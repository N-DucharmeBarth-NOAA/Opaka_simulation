

# Nicholas Ducharme-Barth
# 2026/03/10
#
# Extract data and parameter configurations from SS3 opakapaka

library(r4ss)
library(data.table)
library(magrittr)
library(tibble)

dir_ss3_em <- file.path(getwd(), "HRF_SQ_25_yrfwd","1","em")
dir_ss3_om <- file.path(getwd(), "HRF_SQ_25_yrfwd","1","om")
dir_out <- file.path(getwd(), "opal_data", "opakapaka_ss3")

last_hist_yr <- 2023

om_results = r4ss::SS_output(dir_ss3_om, printstats = FALSE, verbose = FALSE)
em_results = r4ss::SS_output(dir_ss3_em, printstats = FALSE, verbose = FALSE)

opaka_truth = list(om = list(),em=list())
opaka_truth$om$sprseries = om_results$sprseries[,c("Yr","SSB")]
opaka_truth$em$sprseries = em_results$sprseries[,c("Yr","SSB")]
opaka_truth$om$cpue = om_results$cpue[,c("Yr","Fleet","Fleet_name","Vuln_bio","Obs","Exp","SE")]
opaka_truth$em$cpue = em_results$cpue[,c("Yr","Fleet","Fleet_name","Vuln_bio","Obs","Exp","SE")]

save(opaka_truth, file = file.path(dir_out, "opaka_truth.rda"))

plot(opaka_truth$om$sprseries$Yr, opaka_truth$om$sprseries$SSB, type = "l")
lines(opaka_truth$em$sprseries$Yr, opaka_truth$em$sprseries$SSB, col = "red")