#/!bin/bash
#
# Code for mapping targeted sequencing reads to humane genome hg38
# Argument 1: sample name - name of the fastq files before _1.fq.gz or _2.fq.gz
# Requrements: 
#   - Fastq files in subfolder named "fastq"
#   - BWA index path
# Output will be written in a subfoler named "bwa"

d=/nfs/users/nfs_m/mg31/data/inhouse/sruthi/20240429_target   ## local directory
genomefile=/nfs/users/nfs_m/mg31/shared/reference/bwa/hg38    ## bwa index for hg38
name = $1   ## sample name as argument 1

bwadir=$d/bwa
fastqdir=$d/fastq

bamfile=$bwadir'/'$name'.bam'
infs=$fastqdir'/'$name'_1.fq.gz '$fastqdir'/'$name'_2.fq.gz'

source activate test_py3
bwa mem -t 4 -R"@RG\tDT:S\tPG:SCS\tID:$name.1\tSM:$name\tDS:TARGETED_ILLUMINA_SHORT\tPL:ILLUMINA" \
 $genomefile $infs | samtools fixmate -m - -  | samtools sort -o $bamfile -
samtools index $bamfile


