log using "C:\\Users\\hermesf\\Projects\\Intragroup\\quarter_end.log", replace text

*** QUARTER END
*** Supply shifter. The euro area entity's leverage ratio is measured on the
*** last day of the quarter, so its balance sheet is dear around the last
*** business day of March, June and September while hedge fund demand for a
*** specific bond is not. Event window in business days around the quarter
*** end. Day 0 is the last business day, negative days before, days 1 to 3
*** the first business days of the next quarter, days -19 to -5 are the
*** reference. December is excluded, year end is a common shock. Price is
*** the wedge, quantity is the entity's chain volume across bonds relative
*** to its own reference window. Input is Data\wedge_eur.csv, paper
*** direction only.

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
gen quarter = qofd(date)
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin tenor)

* Business day index from the dates in the data
preserve
keep date
duplicates drop
sort date
gen bday = _n
tempfile bdays
save `bdays'
restore
merge m:1 date using `bdays', nogenerate

* Days to the quarter end and the event each day belongs to
bysort quarter: egen last_q = max(date)
bysort quarter: egen qe_bday = max(cond(date == last_q & day(date) >= 28 & month(date) != 12, bday, .))
bysort quarter: egen first_bday = min(bday)
gen k = bday - qe_bday
replace k = bday - first_bday + 1 if bday - first_bday <= 2 & inlist(month(dofq(quarter)), 4, 7, 10) & quarter > qofd(mdy(7, 4, 2021))
keep if k >= -19 & k <= 3
gen event = quarter
replace event = quarter - 1 if k > 0

* Event dummies, reference is days -19 to -5
foreach j in 4 3 2 1 {
    gen d_m`j' = k == -`j'
}
gen d_0 = k == 0
foreach j in 1 2 3 {
    gen d_p`j' = k == `j'
}

* Date table for the quantity panel
preserve
keep date k event d_*
duplicates drop
tempfile dk
save `dk'
restore


*** PRICE
*** Wedge by day to the quarter end, within entity-bond-tenor and event,
*** weighted by matched volume. Basis points. Last three days averaged below.

reghdfe wedge d_m4 d_m3 d_m2 d_m1 d_0 d_p1 d_p2 d_p3 [aw = chain], absorb(ent_bond event) vce(cluster date)
lincom (d_m2 + d_m1 + d_0)/3


*** QUANTITY
*** Daily chain volume of the euro area entity summed across bonds, zeros
*** filled, divided by the entity's own mean over the reference days of the
*** event, weighted by that mean so the estimate is the response of the
*** aggregate crossing. Coefficients are fractions of normal volume.

preserve
collapse (sum) chain, by(entity_id date)
fillin entity_id date
replace chain = 0 if _fillin
bysort entity_id: egen first = min(cond(chain > 0, date, .))
bysort entity_id: egen final = max(cond(chain > 0, date, .))
keep if date >= first & date <= final
merge m:1 date using `dk', nogenerate
bysort entity_id event: egen base = mean(cond(k <= -5, chain, .))
gen chain_n = chain / base
egen ent_event = group(entity_id event)

reghdfe chain_n d_m4 d_m3 d_m2 d_m1 d_0 d_p1 d_p2 d_p3 [aw = base], absorb(ent_event) vce(cluster date)
lincom (d_m2 + d_m1 + d_0)/3
restore



log close
