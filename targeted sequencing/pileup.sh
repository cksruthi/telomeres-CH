#!/bin/bash
# Code for running Samtools mpileup
# 
#
#


d=/nfs/users/nfs_m/mg31/data/inhouse/sruthi/20240429_target   ## local directory
sumcode=$d/code/summary.py    # path to summary.py


batchf=$1
metaf=$d/meta/ngs_coordinates.txt
odir=$d/pileup
mkdir -p $odir


outf=$odir/$batchf
rm $outf
while read -r line; do
 samp=$(basename $line | rev | cut -f2- -d'.' | rev)
 while read -r metline; do
  loc=$(echo $metline | cut -f4 -d$' ')
  gene=$(echo $metline | cut -f1 -d$' ')
  samtools mpileup -A -f /nfs/users/nfs_m/mg31/shared/reference/fa/hg38.fa -r $loc $line | \
    awk -v a=$samp -v b=$gene '{print a"\t"b"\t"$0}' >> $outf
 done < $metaf
done < $batchf

$sumcode $batchf

