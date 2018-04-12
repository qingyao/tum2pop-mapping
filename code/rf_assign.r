rf_assign <- function(platform,file_format){
  # args = commandArgs(trailingOnly = TRUE)
  # platform = args[1]
  targetdir = '/data'
  dir.create(file.path(targetdir,'results'),showWarnings=F)

  library(randomForest)
  pop <- read.table('/source/2492pop.tsv',stringsAsFactors = F)
  reference <- read.table(sprintf('/source/plink_%s_v2.6.Q',platform))
  reference$pop <- factor(pop$V1)
  rf <- randomForest(pop ~ ., data = reference,ntree=50,proximity=T)
  study <- read.table(file.path(targetdir,'tmp','plink,sample.6.Q'))
  result <- predict(rf, newdata = study)
  prob <- matrix(predict(rf, newdata = study,type = "prob"),ncol=5,byrow=F)
  prob <- as.data.frame(prob)
  colnames(prob)[1:5] <- names(predict(rf, newdata = study,type = "vote")[1,])

  marg <- apply(prob,1,function(x) {
    od <- order(x,decreasing = T)
    x[od[1]] - x[od[2]]
  })
  prob$result <- as.character(result)
  prob$score <- marg

  sampleID <- read.table(file.path(targetdir,'tmp','plink,sample.fam'),stringsAsFactors = F)[,1]
  prob <- cbind(ID = sampleID,prob)
  if (file_format %in% c("CONT", "BOTH")){
    write.table(prob,file.path(targetdir,'results','cont.tsv'),append = F,sep = '\t',quote = F,row.names = F)
  }

  if (file_format %in% c("FRAC", "BOTH")){
    write.table(study,file.path(targetdir,'results','frac.tsv'),append = F,sep = '\t',quote = F,row.names = F)
  }
}
