log using "C:\\Users\\hermesf\\Projects\\Intragroup\\quarter_end.log", replace text

*** QUARTER END
*** What the quarter end does to the wedge. The euro area entity's leverage
*** ratio is measured on the last day of the quarter, so its balance sheet is
*** dear around the last business day of March, June and September while
*** hedge fund demand for a specific bond is not. First the daily wedge over
*** the sample with quarter ends marked, then the wedge by business day to
*** the quarter end, days -19 to -5 as reference, December excluded since
*** year end is a common shock. Input is Data\wedge_eur.csv, paper direction
*** only, weighted by matched volume throughout.

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


*** FIGURE 1
*** Daily wedge over the sample, weighted mean across cells, quarter ends as
*** solid lines and year ends as dashed lines.

preserve
collapse (mean) wedge [aw = chain], by(date)
gen quarter = qofd(date)
bysort quarter: egen last_q = max(date)
gen qe = date == last_q & day(date) >= 28
levelsof date if qe == 1 & month(date) != 12, local(qedates)
levelsof date if qe == 1 & month(date) == 12, local(yedates)
twoway (line wedge date, lwidth(thin)), ///
    xline(`qedates', lcolor(gs10) lwidth(thin)) ///
    xline(`yedates', lcolor(gs10) lwidth(thin) lpattern(dash)) ///
    yline(0, lcolor(black) lwidth(thin)) ///
    ytitle("Wedge, bp") xtitle("") ///
    xlabel(, format(%tdCCYY-NN-DD) angle(45) labsize(small)) ///
    graphregion(color(white)) plotregion(color(white)) ///
    name(wedge_daily, replace)
graph export "C:\\Users\\hermesf\\Projects\\Intragroup\\structured\\wedge_daily.png", replace width(1600)
restore


*** EVENT WINDOW
*** Business day index from the dates in the data, days to the quarter end,
*** day 0 the last business day of March, June and September, days 1 to 3
*** the first business days of the next quarter.

preserve
keep date
duplicates drop
sort date
gen bday = _n
tempfile bdays
save `bdays'
restore
merge m:1 date using `bdays', nogenerate

bysort quarter: egen last_q = max(date)
bysort quarter: egen qe_bday = max(cond(date == last_q & day(date) >= 28 & month(date) != 12, bday, .))
bysort quarter: egen first_bday = min(bday)
gen k = bday - qe_bday
replace k = bday - first_bday + 1 if bday - first_bday <= 2 & inlist(month(dofq(quarter)), 4, 7, 10) & quarter > qofd(mdy(7, 4, 2021))
keep if k >= -19 & k <= 3
gen event = quarter
replace event = quarter - 1 if k > 0


*** FIGURE 2
*** Wedge by business day to the quarter end, weighted mean.

tabstat wedge [aw = chain], by(k) statistics(mean n)

preserve
collapse (mean) wedge [aw = chain], by(k)
twoway (connected wedge k, msize(small)), ///
    xline(0, lcolor(gs10)) yline(0, lcolor(black) lwidth(thin)) ///
    ytitle("Wedge, bp") xtitle("Business days to quarter end") ///
    xlabel(-19(2)3) ///
    graphregion(color(white)) plotregion(color(white)) ///
    name(wedge_qe, replace)
graph export "C:\\Users\\hermesf\\Projects\\Intragroup\\structured\\wedge_quarter_end.png", replace width(1600)
restore


*** REGRESSION
*** Same profile within entity-bond-tenor and event, days -19 to -5 as the
*** reference, last three days averaged below. Basis points.

foreach j in 4 3 2 1 {
    gen d_m`j' = k == -`j'
}
gen d_0 = k == 0
foreach j in 1 2 3 {
    gen d_p`j' = k == `j'
}

reghdfe wedge d_m4 d_m3 d_m2 d_m1 d_0 d_p1 d_p2 d_p3 [aw = chain], absorb(ent_bond event) vce(cluster date)
lincom (d_m2 + d_m1 + d_0)/3


log close
