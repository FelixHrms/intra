log using "C:\\Users\\hermesf\\Projects\\Intragroup\\quarter_end.log", replace text

*** QUARTER END
*** What the quarter end does to the wedge. The euro area entity's leverage
*** ratio is measured on the last day of the quarter, so its balance sheet is
*** dear around the last business day of March, June and September while
*** hedge fund demand for a specific bond is not. Daily wedge over the sample
*** with quarter ends marked, the wedge by business day to the quarter end by
*** year, and the two legs of the wedge relative to ESTR around the quarter
*** end. December excluded, year end is a common shock. Days on which ESTR
*** jumps by more than 10 bp, the effective dates of ECB rate changes, and
*** the two business days after are flagged, since the cleared leg reprices
*** on the day and the internal leg with a lag. They are excluded from the
*** figures and controlled for in the regression. Input is Data\wedge_eur.csv,
*** paper direction only, weighted by matched volume throughout.

clear all

* Import the data
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\wedge_eur.csv", clear

keep if chain_intra_to_ccp > 0
rename chain_intra_to_ccp chain
rename wedge_intra_to_ccp wedge
rename cleared_lending_rate rate_ccp
rename intra_borrowing_rate rate_intra
drop if abs(wedge) > 100

* Date and panel ids
gen date = date(business_date, "YMD")
format date %td
gen year = year(date)
gen quarter = qofd(date)
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin tenor)

* Each leg relative to ESTR, basis points. The wedge is spec_intra - spec_ccp.
gen spec_ccp = (estr - rate_ccp)*100
gen spec_intra = (estr - rate_intra)*100

* ESTR jump days and the two business days after
preserve
keep date estr
duplicates drop
sort date
gen jump = abs(estr - estr[_n-1]) > 0.10 & estr < . & estr[_n-1] < .
gen jump3 = jump == 1 | jump[_n-1] == 1 | jump[_n-2] == 1
keep date jump3
tempfile jumps
save `jumps'
restore
merge m:1 date using `jumps', nogenerate


*** FIGURE 1
*** Daily wedge over the sample, weighted mean across cells, jump days
*** excluded, quarter ends as solid lines and year ends as dashed lines.

preserve
collapse (mean) wedge if jump3 == 0 [aw = chain], by(date)
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
*** day 0 the last business day of March, June and September, days 1 to 10
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
replace k = bday - first_bday + 1 if bday - first_bday <= 9 & inlist(month(dofq(quarter)), 4, 7, 10) & quarter > qofd(mdy(7, 4, 2021))
keep if k >= -19 & k <= 10
gen event = quarter
replace event = quarter - 1 if k > 0


*** FIGURE 2
*** Wedge by business day to the quarter end, ten days either side, weighted
*** mean, jump days excluded, one line per year.

tabstat wedge if k >= -10 & jump3 == 0 [aw = chain], by(k) statistics(mean n)

preserve
collapse (mean) wedge if k >= -10 & jump3 == 0 [aw = chain], by(k year)
twoway (connected wedge k if year == 2021, msize(small)) ///
       (connected wedge k if year == 2022, msize(small)) ///
       (connected wedge k if year == 2023, msize(small)) ///
       (connected wedge k if year == 2024, msize(small)) ///
       (connected wedge k if year == 2025, msize(small)), ///
    xline(0, lcolor(gs10)) yline(0, lcolor(black) lwidth(thin)) ///
    legend(order(1 "2021" 2 "2022" 3 "2023" 4 "2024" 5 "2025") rows(1) position(6)) ///
    ytitle("Wedge, bp") xtitle("Business days to quarter end") ///
    xlabel(-10(2)10) ///
    graphregion(color(white)) plotregion(color(white)) ///
    name(wedge_qe_year, replace)
graph export "C:\\Users\\hermesf\\Projects\\Intragroup\\structured\\wedge_quarter_end_year.png", replace width(1600)
restore


*** FIGURE 3
*** The two legs relative to ESTR by business day to the quarter end, 2021 to
*** 2024 and 2025 separately. If the cleared leg moves on day 0 and the
*** internal leg does not, the quarter end wedge is the turn in the cleared
*** rate that the internal rate does not follow.

preserve
gen late = year == 2025
collapse (mean) spec_ccp spec_intra if k >= -10 & jump3 == 0 [aw = chain], by(k late)
twoway (connected spec_ccp k if late == 0, msize(small)) ///
       (connected spec_intra k if late == 0, msize(small) lpattern(dash)) ///
       (connected spec_ccp k if late == 1, msize(small)) ///
       (connected spec_intra k if late == 1, msize(small) lpattern(dash)), ///
    xline(0, lcolor(gs10)) ///
    legend(order(1 "Cleared leg, 2021 to 2024" 2 "Internal leg, 2021 to 2024" 3 "Cleared leg, 2025" 4 "Internal leg, 2025") rows(2) position(6)) ///
    ytitle("ESTR minus rate, bp") xtitle("Business days to quarter end") ///
    xlabel(-10(2)10) ///
    graphregion(color(white)) plotregion(color(white)) ///
    name(legs_qe, replace)
graph export "C:\\Users\\hermesf\\Projects\\Intragroup\\structured\\legs_quarter_end.png", replace width(1600)
restore


*** REGRESSION
*** Days -4 to +3 within entity-bond-tenor and event, days -19 to -5 as the
*** reference, jump days controlled for, last three days averaged below.
*** Basis points.

foreach j in 4 3 2 1 {
    gen d_m`j' = k == -`j'
}
gen d_0 = k == 0
foreach j in 1 2 3 {
    gen d_p`j' = k == `j'
}

reghdfe wedge d_m4 d_m3 d_m2 d_m1 d_0 d_p1 d_p2 d_p3 jump3 if k <= 3 [aw = chain], absorb(ent_bond event) vce(cluster date)
lincom (d_m2 + d_m1 + d_0)/3


log close
