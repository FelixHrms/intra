clear all

* 1. Import the data
import delimited "C:\Users\hermesf\Projects\Intragroup\Data\breakdown_USD.csv", clear

* 2. Parse the date
gen bdate = date(business_date, "YMD")
format bdate %tdCCYY-NN-DD
drop business_date
rename bdate business_date

* 3. Reshape wide so each residence group becomes its own variable
encode residence_group, gen(rg)
keep business_date rg net
reshape wide net, i(business_date) j(rg)

rename net1 net_ea
rename net2 net_other
rename net3 net_uk
rename net4 net_us

* 4. Split each series into positive and negative parts
foreach v in ea other uk us {
    gen pos_`v' = max(net_`v', 0)
    gen neg_`v' = min(net_`v', 0)
}

* 5. Build cumulative levels. The stacking order from the
*    zero line outward is EA, UK, US, Other.
gen pos0 = 0
gen pos1 = pos0 + pos_ea
gen pos2 = pos1 + pos_uk
gen pos3 = pos2 + pos_us
gen pos4 = pos3 + pos_other

gen neg0 = 0
gen neg1 = neg0 + neg_ea
gen neg2 = neg1 + neg_uk
gen neg3 = neg2 + neg_us
gen neg4 = neg3 + neg_other

* 6. Sort for clean area rendering
sort business_date

* 7. Plot. Each rarea fills between two cumulative levels,
*    which produces a stacked area on each side of zero.
twoway ///
    (rarea pos0 pos1 business_date, color(navy)   lwidth(none)) ///
    (rarea pos1 pos2 business_date, color(orange) lwidth(none)) ///
    (rarea pos2 pos3 business_date, color(green)  lwidth(none)) ///
    (rarea pos3 pos4 business_date, color(gs10)   lwidth(none)) ///
    (rarea neg0 neg1 business_date, color(navy)   lwidth(none)) ///
    (rarea neg1 neg2 business_date, color(orange) lwidth(none)) ///
    (rarea neg2 neg3 business_date, color(green)  lwidth(none)) ///
    (rarea neg3 neg4 business_date, color(gs10)   lwidth(none)) ///
    , ///
    legend(order(1 "Euro Area" 2 "UK" 3 "US" 4 "Other") ///
           rows(1) position(12) ring(1) region(lstyle(none))) ///
    ytitle("Volume in billion dollars") ///
    xtitle("") ///
    xlabel(, format(%tdCCYY-NN-DD) angle(45) labsize(small)) ///
    yline(0, lcolor(black) lwidth(thin)) ///
    graphregion(color(white)) plotregion(color(white)) ///
    ylabel(-150(50)150, grid)
	
	
	
	
	
	
clear all

* 1. Import the data
import delimited "C:\Users\hermesf\Projects\Intragroup\Data\breakdown_EUR.csv", clear

* 2. Parse the date
gen bdate = date(business_date, "YMD")
format bdate %tdCCYY-NN-DD
drop business_date
rename bdate business_date

* 3. Reshape wide so each residence group becomes its own variable
encode residence_group, gen(rg)
keep business_date rg net
reshape wide net, i(business_date) j(rg)

rename net1 net_ea
rename net2 net_other
rename net3 net_uk
rename net4 net_us

* 4. Split each series into positive and negative parts
foreach v in ea other uk us {
    gen pos_`v' = max(net_`v', 0)
    gen neg_`v' = min(net_`v', 0)
}

* 5. Build cumulative levels. The stacking order from the
*    zero line outward is EA, UK, US, Other.
gen pos0 = 0
gen pos1 = pos0 + pos_ea
gen pos2 = pos1 + pos_uk
gen pos3 = pos2 + pos_us
gen pos4 = pos3 + pos_other

gen neg0 = 0
gen neg1 = neg0 + neg_ea
gen neg2 = neg1 + neg_uk
gen neg3 = neg2 + neg_us
gen neg4 = neg3 + neg_other

* 6. Sort for clean area rendering
sort business_date

* 7. Plot. Each rarea fills between two cumulative levels,
*    which produces a stacked area on each side of zero.
twoway ///
    (rarea pos0 pos1 business_date, color(navy)   lwidth(none)) ///
    (rarea pos1 pos2 business_date, color(orange) lwidth(none)) ///
    (rarea pos2 pos3 business_date, color(green)  lwidth(none)) ///
    (rarea pos3 pos4 business_date, color(gs10)   lwidth(none)) ///
    (rarea neg0 neg1 business_date, color(navy)   lwidth(none)) ///
    (rarea neg1 neg2 business_date, color(orange) lwidth(none)) ///
    (rarea neg2 neg3 business_date, color(green)  lwidth(none)) ///
    (rarea neg3 neg4 business_date, color(gs10)   lwidth(none)) ///
    , ///
    legend(order(1 "Euro Area" 2 "UK" 3 "US" 4 "Other") ///
           rows(1) position(12) ring(1) region(lstyle(none))) ///
    ytitle("Volume in billion dollars") ///
    xtitle("") ///
    xlabel(, format(%tdCCYY-NN-DD) angle(45) labsize(small)) ///
    yline(0, lcolor(black) lwidth(thin)) ///
    graphregion(color(white)) plotregion(color(white)) ///
    ylabel(-150(50)150, grid)