log using "C:\\Users\\hermesf\\Projects\\Intragroup\\quarter_end.log", replace text

*** QUARTER END
*** Supply shifter. The euro area entity's leverage ratio is measured on the
*** last day of the quarter, so its balance sheet is dear on the last business
*** day of the quarter while hedge fund demand for a specific bond is not.
*** Price and quantity of the crossing on that day, year end separately, other
*** month ends as a placebo. Generic cleared activity in the same bonds is the
*** benchmark. Input is Data\wedge_eur.csv from wedge.ipynb, paper direction
*** only, and Data\intra_cleared_matched.csv from market_impact.ipynb.

clear all

* Import the data
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\wedge_eur.csv", clear

keep if chain_intra_to_ccp > 0
rename chain_intra_to_ccp chain
rename wedge_intra_to_ccp wedge
drop if abs(wedge) > 100

* Date and panel ids
gen date = date(business_date, "YMD")
format date %td
gen month = mofd(date)
gen quarter = qofd(date)
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin tenor)

* Last business day of the quarter, year end separately, other month ends as placebo
bysort quarter: egen last_q = max(date)
bysort month: egen last_m = max(date)
gen qe = date == last_q & day(date) >= 28 & month(date) != 12
gen ye = date == last_q & day(date) >= 28 & month(date) == 12
gen me = date == last_m & day(date) >= 28 & qe == 0 & ye == 0


*** PRICE
*** Wedge on the last day of the quarter, within entity-bond-tenor and month,
*** weighted by matched volume. Basis points.

reghdfe wedge qe ye me [aw = chain], absorb(ent_bond month) vce(cluster date)


*** QUANTITY
*** Daily chain volume of the euro area entity summed across bonds, zeros
*** filled in between its first and last active day. Billions, then logs.

preserve
collapse (sum) chain, by(entity_id date)
fillin entity_id date
replace chain = 0 if _fillin
bysort entity_id: egen first = min(cond(chain > 0, date, .))
bysort entity_id: egen final = max(cond(chain > 0, date, .))
keep if date >= first & date <= final
gen month = mofd(date)
gen quarter = qofd(date)
bysort quarter: egen last_q = max(date)
bysort month: egen last_m = max(date)
gen qe = date == last_q & day(date) >= 28 & month(date) != 12
gen ye = date == last_q & day(date) >= 28 & month(date) == 12
gen me = date == last_m & day(date) >= 28 & qe == 0 & ye == 0
encode entity_id, gen(ent)
gen lchain = log(chain)

summarize chain
reghdfe chain qe ye me, absorb(ent month) vce(cluster date)
reghdfe lchain qe ye me, absorb(ent month) vce(cluster date)
restore


*** BENCHMARK
*** Bond-day level, all bonds active in the cleared market. bank_bench is
*** cleared volume of banks with no chain or hedge fund activity in the bond
*** that day, intra_m is the matched chain volume of the pricing table.
*** Billions. Means reported to scale the coefficients.

preserve
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\intra_cleared_matched.csv", clear
gen date = date(business_date, "YMD")
format date %td
gen month = mofd(date)
gen quarter = qofd(date)
encode security_isin, gen(bond)
bysort quarter: egen last_q = max(date)
bysort month: egen last_m = max(date)
gen qe = date == last_q & day(date) >= 28 & month(date) != 12
gen ye = date == last_q & day(date) >= 28 & month(date) == 12
gen me = date == last_m & day(date) >= 28 & qe == 0 & ye == 0

summarize bank_bench intra_m
reghdfe bank_bench qe ye me, absorb(bond month) vce(cluster date)
reghdfe intra_m qe ye me, absorb(bond month) vce(cluster date)
restore



*** ===== OVERNIGHT (appended) =====
*** Same price and quantity blocks on the overnight sample, wedge_eur_on.csv,
*** where the trades on the last day of the quarter are the ones priced over
*** the quarter end.

import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\wedge_eur_on.csv", clear

keep if chain_intra_to_ccp > 0
rename chain_intra_to_ccp chain
rename wedge_intra_to_ccp wedge
drop if abs(wedge) > 100

gen date = date(business_date, "YMD")
format date %td
gen month = mofd(date)
gen quarter = qofd(date)
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin tenor)

bysort quarter: egen last_q = max(date)
bysort month: egen last_m = max(date)
gen qe = date == last_q & day(date) >= 28 & month(date) != 12
gen ye = date == last_q & day(date) >= 28 & month(date) == 12
gen me = date == last_m & day(date) >= 28 & qe == 0 & ye == 0

reghdfe wedge qe ye me [aw = chain], absorb(ent_bond month) vce(cluster date)

preserve
collapse (sum) chain, by(entity_id date)
fillin entity_id date
replace chain = 0 if _fillin
bysort entity_id: egen first = min(cond(chain > 0, date, .))
bysort entity_id: egen final = max(cond(chain > 0, date, .))
keep if date >= first & date <= final
gen month = mofd(date)
gen quarter = qofd(date)
bysort quarter: egen last_q = max(date)
bysort month: egen last_m = max(date)
gen qe = date == last_q & day(date) >= 28 & month(date) != 12
gen ye = date == last_q & day(date) >= 28 & month(date) == 12
gen me = date == last_m & day(date) >= 28 & qe == 0 & ye == 0
encode entity_id, gen(ent)
gen lchain = log(chain)

summarize chain
reghdfe chain qe ye me, absorb(ent month) vce(cluster date)
reghdfe lchain qe ye me, absorb(ent month) vce(cluster date)
restore


log close
