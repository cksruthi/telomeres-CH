#!/nfs/users/nfs_m/mg31/anaconda3/bin/python
#
# Code for converting Samtools mpileup output into a summary table containing mutations and VAFs
# Argument 1: File name of Samtools mpileup outout, in the subfolder named "pileup"
# Output: Summary table in the "pileup" folder

import sys, os

batch=sys.argv[1]

d="/nfs/users/nfs_m/mg31/data/inhouse/sruthi/20240429_target"
od=d+"/pileup"
indir=d+"/pileup"
os.makedirs(od,exist_ok=True)

set={'A','T','C','G','a','t','c','g'}

def process(ss,fw):
 samp=ss[0]
 pos=ss[1]
 chr=ss[2]
 loc=ss[3]
 ref=ss[4]
 cov=int(ss[5])
 seq=ss[6]
 dd={}
 i=0
 while i<len(seq):
  c=seq[i]
  if c == '+' or c == '-':
   nn=0
   while True:
    nstr=seq[i+1+nn]
    if nstr.isdigit():
     nn=nn+1
    else:
     break
   try:
    n=int(seq[i+1:i+1+nn])
   except:
    i=i+1
    continue
   ins=seq[i+1+nn:i+1+nn+n]
   insu=c+ins.upper()
   if insu not in dd:
    dd[insu]=0
   dd[insu] = dd[insu]+1
   i=i+nn+n
  elif c == '^':
   i=i+1
  else:
   if c in set:
    cu=c.upper()
    if cu not in dd:
     dd[cu]=0
    dd[cu] = dd[cu]+1
  i=i+1
 for k in dd:
  vaf=dd[k]/cov
  fw.write(samp+"\t"+pos+"\t"+chr+"\t"+loc+"\t"+ref+"\t"+k+"\t"+str(cov)+"\t"+str(dd[k])+"\t"+str(vaf)+"\n")


fr=open(indir+"/"+batch,'r')
fw=open(od+"/summary_"+batch,"w")
for l in fr:
 l=l.rstrip()
 ss=l.split("\t")
 process(ss,fw)
fr.close()
fw.close()

