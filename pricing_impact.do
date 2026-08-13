log using "C:\\Users\\hermesf\\Projects\\Intragroup\\pricing_impact.log", replace text

*** PRICING IMPACT
*** Chain activity and specialness in the EUR cleared segment.
*** Produces the six columns of the market-impact table.

clear all

* Import the data
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\intra_cleared.csv", clear

* Date and panel ids
gen date = date(business_date, "YMD")
format date %td
encode security_isin, gen(isin_id)

* Bond-by-month id for the saturated specification
gen month = mofd(date)
egen isin_month = group(isin_id month)

* (1) Chain only
reghdfe special intra_vol, absorb(isin_id date) vce(cluster isin_id)
summarize special if e(sample)

* (2) Hedge fund only
reghdfe special hf_vol, absorb(isin_id date) vce(cluster isin_id)

* (3) Chain and hedge fund
reghdfe special intra_vol hf_vol, absorb(isin_id date) vce(cluster isin_id)

* (4) Add the unlinked intragroup placebo
reghdfe special intra_vol intra_vol_unlinked hf_vol, absorb(isin_id date) vce(cluster isin_id)

* (5) Add the bank benchmark, a generic cleared-activity control
reghdfe special intra_vol intra_vol_unlinked hf_vol bank_bench, absorb(isin_id date) vce(cluster isin_id)

* (6) Same specification with bond-by-month and date fixed effects
reghdfe special intra_vol intra_vol_unlinked hf_vol bank_bench, absorb(isin_month date) vce(cluster isin_id)

* Does the chain price more per billion than generic cleared demand?
test intra_vol = bank_bench


*** ===== CLEARED-MATCHED SPECIFICATION (appended) =====
* Chain and HF regressors are the cleared-matched gross volumes from Section 4.1
* (Chain^in and its direct analog), so the construction runs through to pricing.
* intra_m is the matched chain volume, hf_m the matched direct HF volume,
* unlinked_m the intragroup residual. bank_bench is unchanged. Uses
* intra_cleared_matched.csv from market_impact.ipynb.

import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\intra_cleared_matched.csv", clear
gen date = date(business_date, "YMD")
format date %td
encode security_isin, gen(isin_id)
gen month = mofd(date)
egen isin_month = group(isin_id month)

reghdfe special intra_m, absorb(isin_id date) vce(cluster isin_id date)

reghdfe special hf_m, absorb(isin_id date) vce(cluster isin_id date)

reghdfe special intra_m hf_m, absorb(isin_id date) vce(cluster isin_id date)

reghdfe special intra_m unlinked_m hf_m, absorb(isin_id date) vce(cluster isin_id date)

reghdfe special intra_m unlinked_m hf_m bank_bench, absorb(isin_id date) vce(cluster isin_id date)

reghdfe special intra_m unlinked_m hf_m bank_bench, absorb(isin_month date) vce(cluster isin_id date)


log close


