
# extract_opakapaka_ss3.r
# Nicholas Ducharme-Barth
# 2026/03/09
#
# Extract data and parameter configurations from SS3 opakapaka
# input files (*.ss_new, ss.par) and package into .rda for opal.
#
# HISTORICAL DATA ONLY: SS3 model spans 1949-2048; we truncate to
# 1949-2023, the last year with observed Comm fleet CPUE and length
# composition data. ResFish survey (fleet 3) runs 2017-2023 within
# this window.
#
# Outputs (matching opal bundled-data conventions):
#   - opaka_data.rda       : list matching wcpo_bet_data structure
#   - opaka_lf.rda         : long-format length composition (data.table)
#   - opaka_parameters.rda : starting parameter list matching wcpo_bet_parameters
#
# SS3 model structure:
#   3 fleets: Comm (catch), Non_comm (catch), ResFish (survey)
#   1 season, 1 area, 1 sex
#   44 ages (SS3 ages 0-43 → opal internal ages 1-44)
#   17 data length bins: 5, 10, 15, ..., 85 cm (5 cm width)
#   Population length bins: 1 cm from 1-94
#   Growth: standard VB → converted to Schnute with A1=1, A2=n_age
#   M = 0.135 (constant across ages)
#   Maturity: length logistic (Mat50=40.7 cm, slope=-2.26)
#   Selectivity: logistic (fleets 1-2), double-normal pattern 24 (fleet 3)
#   CPUE: fleets 1 (1949-2023) and 3 (2017-2023)
#   Length comps: fleets 1 (1949-2023) and 3 (2017-2023)
#
# Growth conversion note:
#   SS3 uses standard VB: L(a) = Linf - (Linf - L0) * exp(-k*a)
#     with L_at_Amin (age 0), L_at_Amax=999 (Linf), k
#   opal uses Schnute parameterization:
#     mu_a = L1 + (L2-L1)*(1-exp(-k*(a-A1)))/(1-exp(-k*(A2-A1)))
#   We set A1=1, A2=n_age, L1=VB(age 0), L2=VB(age n_age-1),
#   where opal internal age i maps to SS3 age (i-1).
#   k is unchanged. The conversion is exact to machine precision.
#
# Copyright (c) 2026 Nicholas Ducharme-Barth
# GPL-3.0

# =============================================================================
# 0. Setup
# =============================================================================

library(data.table)
library(magrittr)

dir_ss3 <- file.path(getwd(), "HRF_SQ_25_yrfwd","1","em")
dir_out <- file.path(getwd(), "opal_data", "opakapaka_ss3")

last_hist_yr <- 2023

# =============================================================================
# 1. Model dimensions
# =============================================================================

data_lines <- readLines(file.path(dir_ss3, "data_echo.ss_new"))

styr    <- 1949
endyr   <- last_hist_yr
n_year  <- endyr - styr + 1   # 75
n_seas  <- 1
n_age   <- 44                 # SS3 ages 0-43 → opal ages 1:44
age_a   <- 1:n_age            # opal convention: internal ages always 1:n_age
n_fleet <- 3

fleet_names <- c("Comm", "Non_comm", "ResFish")
fleet_types <- c(1, 1, 3)
catch_units <- c(1, 1, 1)     # all biomass

# Data length bins
len_bins      <- c(5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85)
n_len         <- length(len_bins)
len_bin_width <- 5
len_bin_start <- 5

# =============================================================================
# 2. Extract catch data
# =============================================================================

catch_start <- grep("^#.*catch_se", data_lines)[1]

catch_rows <- list()
i <- catch_start + 1
while (i <= length(data_lines)) {
  line <- trimws(data_lines[i])
  if (grepl("^#", line) || line == "") { i <- i + 1; next }
  vals <- as.numeric(strsplit(line, "\\s+")[[1]][1:5])
  if (is.na(vals[1]) || vals[1] == -9999) break
  catch_rows[[length(catch_rows) + 1]] <- vals
  i <- i + 1
}

catch_dt <- as.data.table(do.call(rbind, catch_rows))
setnames(catch_dt, c("year", "seas", "fleet", "catch", "catch_se"))
catch_dt <- catch_dt[year >= styr & year <= endyr]

catch_obs_ysf <- array(0, dim = c(n_year, n_seas, n_fleet))
for (r in seq_len(nrow(catch_dt))) {
  yr_idx <- catch_dt$year[r] - styr + 1
  fl     <- catch_dt$fleet[r]
  catch_obs_ysf[yr_idx, 1, fl] <- catch_dt$catch[r]
}

# =============================================================================
# 3. Extract CPUE data
# =============================================================================

cpue_header <- grep("^#_yr month fleet obs stderr", data_lines)[1]

cpue_rows <- list()
i <- cpue_header + 1
while (i <= length(data_lines)) {
  line <- trimws(data_lines[i])
  if (grepl("^#", line) || line == "") { i <- i + 1; next }
  line_clean <- sub("#.*$", "", line)
  vals <- as.numeric(strsplit(trimws(line_clean), "\\s+")[[1]])
  if (is.na(vals[1]) || vals[1] == -9999) break
  cpue_rows[[length(cpue_rows) + 1]] <- vals[1:5]
  i <- i + 1
}

cpue_dt <- as.data.table(do.call(rbind, cpue_rows))
setnames(cpue_dt, c("year", "month", "fleet", "obs", "se"))
cpue_dt <- cpue_dt[year >= styr & year <= endyr]

cpue_data <- cpue_dt[, .(
  year    = year,
  month   = month,
  ts      = year - styr + 1,
  fishery = fleet,
  metric  = "cpue",
  units   = catch_units[fleet],
  value   = obs,
  se      = se
)] %>% .[,value:= value/mean(value),by = fishery] %>%  # scale to mean 1 for better numerical stability
.[fishery==1,index:=1] %>% .[fishery==3,index:=2]

# =============================================================================
# 4. Extract length composition data
# =============================================================================

lencomp_header <- grep("yr month fleet sex part Nsamp datavector", data_lines)
lencomp_header <- lencomp_header[length(lencomp_header)]

lf_rows <- list()
i <- lencomp_header + 1
while (i <= length(data_lines)) {
  line <- trimws(data_lines[i])
  if (grepl("^#", line) || line == "") { i <- i + 1; next }
  vals <- as.numeric(strsplit(line, "\\s+")[[1]])
  if (is.na(vals[1]) || vals[1] == -9999) break
  lf_rows[[length(lf_rows) + 1]] <- vals
  i <- i + 1
}

lf_mat <- do.call(rbind, lf_rows)
lf_meta <- data.table(
  year  = lf_mat[, 1],
  month = lf_mat[, 2],
  fleet = lf_mat[, 3],
  Nsamp = lf_mat[, 6]
)

lf_props <- lf_mat[, 7:(7 + n_len - 1), drop = FALSE]
colnames(lf_props) <- as.character(len_bins)

lf_wide <- cbind(lf_meta[, .(year, month, fleet, Nsamp)], as.data.table(lf_props))
setnames(lf_wide, "fleet", "fishery")
lf_wide <- lf_wide[year >= styr & year <= endyr]

opaka_lf <- melt(lf_wide,
                 id.vars = c("year", "month", "fishery", "Nsamp"),
                 variable.name = "bin",
                 value.name = "value")
opaka_lf[, bin := as.numeric(as.character(bin))]
opaka_lf[, ts := year - styr + 1]
opaka_lf[, week := 1]
opaka_lf[, value := value * Nsamp]
opaka_lf[, Nsamp := NULL]
opaka_lf <- opaka_lf[, .(year, month, ts, fishery, bin, value, week)]
setorder(opaka_lf, fishery, year, month, bin)

# =============================================================================
# 5. Extract biological parameters from control.ss_new
# =============================================================================

ctl_lines <- readLines(file.path(dir_ss3, "control.ss_new"))

get_init <- function(pattern) {
  pline <- grep(pattern, ctl_lines, value = TRUE, fixed = TRUE)[1]
  as.numeric(strsplit(trimws(pline), "\\s+")[[1]][3])
}

# --- Natural mortality ---
M_val <- get_init("NatM_uniform_Fem_GP_1")
M     <- rep(M_val, n_age)

# --- SS3 growth parameters (standard VB) ---
L_at_Amin <- get_init("L_at_Amin_Fem_GP_1")   # L at SS3 age 0
L_at_Amax <- get_init("L_at_Amax_Fem_GP_1")   # Linf (since Growth_Age_for_L2 = 999)
k_ss3     <- get_init("VonBert_K_Fem_GP_1")
CV_young  <- get_init("CV_young_Fem_GP_1")
CV_old    <- get_init("CV_old_Fem_GP_1")

# --- Convert to Schnute parameterization: A1=1, A2=n_age ---
# opal internal age i maps to SS3 age (i-1)
# L1 = VB(SS3 age 0) = L_at_Amin → assigned to opal age 1
# L2 = VB(SS3 age n_age-1) → assigned to opal age n_age
#
# Standard VB: L(a) = Linf - (Linf - L0) * exp(-k * a)
A1 <- 1L
A2 <- n_age  # 44
L1 <- L_at_Amin  # VB at SS3 age 0 = opal age 1
L2 <- L_at_Amax - (L_at_Amax - L_at_Amin) * exp(-k_ss3 * (n_age - 1))  # VB at SS3 age 43

cat(sprintf("Growth conversion: SS3 VB (L0=%.1f, Linf=%.1f, k=%.3f)\n", L_at_Amin, L_at_Amax, k_ss3))
cat(sprintf("  → Schnute (A1=%d, A2=%d, L1=%.4f, L2=%.4f, k=%.3f)\n", A1, A2, L1, L2, k_ss3))

# --- Weight-length ---
lw_a <- get_init("Wtlen_1_Fem_GP_1")
lw_b <- get_init("Wtlen_2_Fem_GP_1")

# --- Maturity (length logistic) ---
mat50     <- get_init("Mat50%_Fem_GP_1")
mat_slope <- get_init("Mat_slope_Fem_GP_1")

len_mid         <- len_bins + len_bin_width / 2
maturity_at_len <- 1 / (1 + exp(mat_slope * (len_mid - mat50)))

# --- Fecundity: eggs = Wt * (a + b*Wt); a=1, b=0 → eggs = weight ---
fec_a <- get_init("Eggs/kg_inter_Fem_GP_1")
fec_b <- get_init("Eggs/kg_slope_wt_Fem_GP_1")

wt_at_len        <- lw_a * len_mid^lw_b
fecundity_at_len <- wt_at_len * (fec_a + fec_b * wt_at_len)

# --- Stock-recruitment ---
SR_lnR0   <- as.numeric(strsplit(trimws(grep("SR_LN\\(R0\\)", ctl_lines, value = TRUE)[1]), "\\s+")[[1]][3])
SR_steep   <- get_init("SR_BH_steep")
SR_sigmaR  <- get_init("SR_sigmaR")

# --- Catchability ---
Q_lines <- grep("LnQ_base_", ctl_lines, value = TRUE)
Q_vals  <- sapply(Q_lines, function(x) as.numeric(strsplit(trimws(x), "\\s+")[[1]][3]))
names(Q_vals) <- sub(".*#\\s*", "", Q_lines)

# --- Selectivity ---
sel_type_f <- c(1, 1, 24)

# =============================================================================
# 6. Extract estimated parameters from ss.par
# =============================================================================

par_lines <- readLines(file.path(dir_ss3, "ss.par"))

get_par <- function(tag) {
  idx <- grep(tag, par_lines, fixed = TRUE)
  as.numeric(trimws(par_lines[idx + 1]))
}

# Selectivity parameters
sel_parm_vals <- sapply(1:10, function(j) get_par(paste0("# selparm[", j, "]:")))

par_sel <- matrix(0, nrow = n_fleet, ncol = 6)
par_sel[1, 1:2] <- sel_parm_vals[1:2]   # Comm: logistic
par_sel[2, 1:2] <- sel_parm_vals[3:4]   # Non_comm: logistic (fixed)
par_sel[3, 1:6] <- sel_parm_vals[5:10]  # ResFish: double-normal

# Recruitment deviations (historical only)
recdev_early <- as.numeric(strsplit(trimws(
  par_lines[grep("recdev_early:", par_lines, fixed = TRUE) + 1]
), "\\s+")[[1]])

recdev2 <- as.numeric(strsplit(trimws(
  par_lines[grep("recdev2:", par_lines, fixed = TRUE) + 1]
), "\\s+")[[1]])

early_yrs <- 1906:(1906 + length(recdev_early) - 1)
main_yrs  <- 1928:(1928 + length(recdev2) - 1)

all_dev_yrs <- c(early_yrs, main_yrs)
all_devs    <- c(recdev_early, recdev2)

dev_idx <- which(all_dev_yrs >= styr & all_dev_yrs <= endyr)
rdev_y  <- all_devs[dev_idx]

# =============================================================================
# 7. Assemble opaka_data (matching wcpo_bet_data structure)
# =============================================================================

opaka_data <- list(
  # Dimensions
  age_a        = age_a,         # 1:44 (opal convention)
  n_age        = n_age,         # 44
  n_season     = n_seas,        # 1
  n_fishery    = n_fleet,       # 3
  n_year       = n_year,        # 75
  first_yr     = 1L,
  last_yr      = n_year,
  years        = seq_len(n_year),

  # Length structure
  len_bin_start = len_bin_start,   # 5
  len_bin_width = len_bin_width,   # 5
  n_len         = n_len,           # 17

  # Catch
  first_yr_catch = 1L,
  catch_units_f  = catch_units,
  catch_obs_ysf  = catch_obs_ysf,

  # CPUE
  cpue_switch = 1L,
  cpue_data   = cpue_data,

  # Biology
  lw_a      = lw_a,
  lw_b      = lw_b,
  maturity  = maturity_at_len,     # n_len vector
  fecundity = fecundity_at_len,    # n_len vector
  M         = M,                   # n_age vector (constant)

  # Growth reference ages (Schnute parameterization)
  A1 = A1,   # 1
  A2 = A2,   # 44 (= n_age)

  # Selectivity
  sel_type_f = sel_type_f,

  # Priors (placeholder)
  priors = list(
    log_B0     = list(type = "normal", par1 = 0, par2 = 0.2, index = 1),
    log_cpue_q = list(type = "normal", par1 = 0, par2 = 0.2, index = 2),
    par_sel    = list(type = "normal", par1 = 0, par2 = 0.2, index = 3),
    log_L1     = list(type = "normal", par1 = 0, par2 = 0.2, index = 4),
    log_L2     = list(type = "normal", par1 = 0, par2 = 0.2, index = 5),
    log_k      = list(type = "normal", par1 = 0, par2 = 0.2, index = 6),
    log_CV1    = list(type = "normal", par1 = 0, par2 = 0.2, index = 7),
    log_CV2    = list(type = "normal", par1 = 0, par2 = 0.2, index = 8)
  )
)

# =============================================================================
# 8. Assemble opaka_parameters (matching wcpo_bet_parameters structure)
# =============================================================================

opaka_parameters <- list(
  # Stock parameters
  log_B0         = SR_lnR0,           # 5.656 (SS3's LN(R0))
  log_h          = log(SR_steep),      # log(0.76)
  log_sigma_r    = log(SR_sigmaR),     # log(0.52)

  # Observation model
  log_cpue_q     = as.numeric(Q_vals), # [-3.773, -6.253]
  cpue_creep     = 0,
  log_cpue_tau   = -Inf,
  log_cpue_omega = 0,

  # Recruitment deviations
  rdev_y         = rdev_y,             # 75 values (1949-2023)

  # Selectivity
  par_sel        = par_sel,            # [3 × 6] matrix

  # Growth (Schnute parameterization, log-scale)
  log_L1         = log(L1),            # log(6.0)
  log_L2         = log(L2),            # log(67.498)
  log_k          = log(k_ss3),         # log(0.242)
  log_CV1        = log(CV_young),      # log(0.085)
  log_CV2        = log(CV_old)         # log(0.085)
)

# =============================================================================
# 9. Save
# =============================================================================

save(opaka_data, file = file.path(dir_out, "opaka_data.rda"))
save(opaka_lf,   file = file.path(dir_out, "opaka_lf.rda"))
save(opaka_parameters, file = file.path(dir_out, "opaka_parameters.rda"))

# =============================================================================
# 10. Summary
# =============================================================================

cat("\n=== Extraction complete (historical only: 1949-2023) ===\n\n")

cat("opaka_data.rda:\n")
cat(sprintf("  Dimensions: %d years × %d ages × %d fleets × %d length bins\n",
            n_year, n_age, n_fleet, n_len))
cat(sprintf("  age_a: %d:%d (opal internal), maps to SS3 ages %d-%d\n",
            min(age_a), max(age_a), 0, n_age - 1))
cat(sprintf("  Growth ref ages: A1=%d (L1=%.2f cm), A2=%d (L2=%.2f cm), k=%.3f\n",
            A1, L1, A2, L2, k_ss3))
cat(sprintf("  M = %.3f (constant)\n", M_val))
cat(sprintf("  LW: a=%.2e, b=%.2f\n", lw_a, lw_b))
cat(sprintf("  Maturity: logistic, Mat50=%.1f cm, slope=%.2f\n", mat50, mat_slope))
cat(sprintf("  Catch: %d non-zero entries (fleets 1-2)\n", sum(catch_obs_ysf > 0)))
cat(sprintf("  CPUE: %d obs (fleet 1: %d, fleet 3: %d)\n",
            nrow(cpue_data),
            cpue_data[fishery == 1, .N],
            cpue_data[fishery == 3, .N]))
cat(sprintf("  Selectivity types: %s\n", paste(sel_type_f, collapse = ", ")))

cat("\nopaka_lf.rda:\n")
cat(sprintf("  %d rows (fleet 1: %d obs, fleet 3: %d obs)\n",
            nrow(opaka_lf),
            opaka_lf[, uniqueN(paste(year, month)), by = fishery][fishery == 1, V1],
            opaka_lf[, uniqueN(paste(year, month)), by = fishery][fishery == 3, V1]))

cat("\nopaka_parameters.rda:\n")
cat(sprintf("  SR: ln(R0)=%.3f, h=%.2f, sigmaR=%.2f\n", SR_lnR0, SR_steep, SR_sigmaR))
cat(sprintf("  Growth: log_L1=%.4f, log_L2=%.4f, log_k=%.4f\n",
            log(L1), log(L2), log(k_ss3)))
cat(sprintf("  CV: log_CV1=%.4f, log_CV2=%.4f (constant CV=%.3f)\n",
            log(CV_young), log(CV_old), CV_young))
cat(sprintf("  Q: %s\n", paste(sprintf("%.3f", Q_vals), collapse = ", ")))
cat(sprintf("  Rec devs: %d values (%d-%d)\n", length(rdev_y), styr, endyr))
cat(sprintf("  Selectivity: %d fleets × %d params\n", nrow(par_sel), ncol(par_sel)))
