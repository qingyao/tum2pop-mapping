# args = commandArgs(trailingOnly = TRUE)
# platform <- args[1]
# file_format <- args[2]
createPedMapFile <- function(platform,file_format){

  targetdir <- '/data'
  input_files <- list.files(targetdir)
  input_files <- input_files[!input_files %in% c('tmp','results')]

  options(stringsAsFactors = F)

  dir.create(file.path(targetdir, '/tmp'), showWarnings = FALSE)
  bim <- read.table(sprintf('/source/plink_%s_v2.bim',platform),header=F,stringsAsFactors = F)
  anno <- read.table(sprintf('/source/%s_anno.tsv',platform),header=T,stringsAsFactors = F)
  bim$chr_pos <- paste(bim[,1],bim[,4],sep = '_')
  anno$chr_pos <- paste(anno[,2],anno[,3],sep = '_')

  ### create ped file
  pedfile <-file.path(targetdir, 'tmp', 'plink,sample.ped')
  sink(file = pedfile)

  for (f in input_files){
    sample_name <- unlist(strsplit(f,split = '.tsv',fixed = T))[1]
    fracb <- read.table(file.path(targetdir,f),header = T,stringsAsFactors = F)
    fracb$chr_pos <- paste(fracb[,2],fracb[,3],sep = '_')

    if (sum(!bim$chr_pos %in% fracb$chr_pos) > 0) {
      warning(sprintf('For %s: fracB file incomplete.',sample_name))
      next
    }
    idx <-  match(bim$chr_pos, fracb$chr_pos)
    fracb <- fracb[idx,]
    val <- fracb[,4]

    if (file_format == "GC") {
      map<- c('AA' = 0 , 'AB' = 0.5, 'BB' = 1)
      val <- map[val]
    }

    oneliner <- unlist(sapply(1:nrow(fracb),function(x){

        if (val[x] <0.15){
          rep(anno$Allele.A[x],2)
        } else if (val[x] >= 0.15 & val[x] <= 0.85) { ## 0.15 and 0.85 originally
          c(anno$Allele.A[x],anno$Allele.B[x])
        }else if (val[x] > 0.85){
          rep(anno$Allele.B[x],2)
        }else{
          rep(0,2)
        }

    }))
    oneliner <- as.vector(oneliner)

    cat(sample_name,sample_name,rep("0",3), "-9",oneliner,"\n",sep=" ")
  }
  sink()

  ### create map file
  mapfile <-file.path(targetdir, 'tmp', 'plink,sample.map')
  writedata <- cbind(anno[,c(2,1)],rep(0,length(idx)),anno[,3])
  write.table(writedata,mapfile,quote = F,row.names = F,col.names = F,sep='\t')
}
