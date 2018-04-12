#! /bin/sh
platform=$1
sampledir=/data/tmp/
map1=/source/plink_$platform'_v2.bim'
map2=$sampledir/plink,sample.map
bim2=$sampledir/plink,sample.bim
ped=$sampledir/plink,sample
bed=$sampledir/plink,sample.bed

cd /app/plink_mac
if [ -e $ped.ped ] && [ -e $map2 ]
then
  plink --file $ped --a1-allele $map1 5 2 0 --make-bed --out $ped
  diff -s $sampledir/plink,sample.bim /source/plink_$platform'_v2.bim' >> $sampledir/diff.txt ## check if SNP ID annotations are the same.
  cp $map1 $bim2

  cp /source/plink_$platform'_v2.6.P' $sampledir/plink,sample.6.P.in
  cd $sampledir
  admixture -P $bed 6
fi
