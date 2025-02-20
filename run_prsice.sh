mkdir outputs

for file in *.bgen
do
        sampleid=$(basename $file .bgen)
	echo "Started job for "$sampleid
	/home/Softwares/PRSice_linux --a2 A2 --a1 A1 --bar-levels 1 --base tl_prs_col.txt --binary-target F --beta --stat BETA --bp BP --chr CHR --snp SNP --thread 2 --fastscore --no-clump --no-regress --out outputs/${sampleid} --target $sampleid,$sampleid".sample" --type bgen --score sum --keep-ambig && echo $sampleid" completed successfully"
done

tar -zcvf "outputs.tar.gz"  outputs
rm -rf outputs
