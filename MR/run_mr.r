library(TwoSampleMR)

ch_all<-c("all", "asxl1",  "dnmt3a", "tet2", "except_splicing",  "mpn", "ppm1d", "splicing", "short_telomere","long_telomere","Y_loss","X_loss","autosomal")  

exp <- read_exposure_data(
  "../../../inputs/tl_flip.txt",
  sep = "\t",
  beta_col = "BETA",
  snp_col = "SNP",
  se_col = "se",
  effect_allele_col = "A1",
  other_allele_col = "A2",
  pval_col = "P",
  eaf_col = "eaf",
  samplesize_col = "n"
)

#Replace ch with dnmt3a/tet2/large/small


for (ch in ch_all){
out <- read_outcome_data(
  filename = paste0(ch,"_nowbc_flip_final_r1_singlegene.txt"),
  snps = exp$SNP,
  sep = "\t",
  snp_col = "SNP",
  beta_col = "BETA",
  se_col = "SE",
  eaf_col = "A1FREQ",
  effect_allele_col = "ALLELE1",
  other_allele_col = "ALLELE0",
  pval_col = "PVALUE",
)

dat <- harmonise_data(exp, out,action=1)

res <- generate_odds_ratios(mr(dat,method_list = c("mr_wald_ratio","mr_egger_regression","mr_weighted_median","mr_ivw","mr_simple_mode","mr_weighted_mode","mr_ivw_mre","mr_ivw_fe")))
print(res)


if (ch == "all"){
res_all<-cbind("CH_type"=ch,res)
}
else{
res_all<-rbind(res_all,cbind("CH_type"=ch,res))
}
}



write.table(res_all, file = "tl_as_exp_ch_r1.txt", row.names = F, quote = F, sep = "\t")
