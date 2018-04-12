#!/usr/bin/env Rscript
library("optparse")

outputfile = 'Rout.log'
errorfile = 'Rerr.log'

option_list = list(
  make_option(c("-i", "--input"), type="character", default=NULL,
              help="input as B allele frequency file format (BAF), or genotype calling format (GC)", metavar="character"),
	make_option(c("-o", "--out"), type="character", default='CONT',
              help="output file type (CONT, FRAC or BOTH), default is CONT", metavar="character"),
  make_option(c("-p", "--platform"), type="character", default=NULL,
              help="SNP array platform", metavar="character")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

if (any(is.null(opt$input),is.null(opt$platform))){
  print_help(opt_parser)
  stop("Input type and platform must be supplied. See help.", call.=FALSE)
}

accepted_platforms <- c('Mapping10K_Xba142','Mapping50K_Hind240','Mapping50K_Xba240',
                              'Mapping250K_Nsp','Mapping250K_Sty','CytoScan750K_Array',
                              'GenomeWideSNP_5','GenomeWideSNP_6','CytoScanHD_Array')

input_type = opt$input
platform = opt$platform
file_format = opt$out

if (!platform %in% accepted_platforms) stop('Platform not supported. See README.md for supported platforms.', call.=FALSE)

source('createPedMapFile.r')
print(createPedMapFile(platform,input_type))

system2("sh", c("match_admix.sh", platform),stdout = outputfile, stderr = errorfile)

source('rf_assign.r')
rf_assign(platform,file_format)
