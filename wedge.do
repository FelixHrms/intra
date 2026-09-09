log using "C:\\Users\\hermesf\\Projects\\Intragroup\\wedge.log", replace text

*** WEDGE
*** Internal price of the chain. The euro area entity lends cash in the CCP,
*** sources the bond, and borrows cash intragroup from the non-euro area
*** entity, passing the bond on. The wedge is the cleared lending rate minus
*** the intragroup borrowing rate, in basis points, positive when the euro
*** area entity keeps a margin. Rows are entity by bond by day by tenor
*** bucket, from wedge.ipynb. Everything is weighted by matched chain volume.

clear all

* Import the data
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\wedge_eur.csv", clear

* The paper's chain direction only
keep if chain_intra_to_ccp > 0
rename chain_intra_to_ccp chain
rename wedge_intra_to_ccp wedge
rename cleared_lending_rate rate_ccp
rename intra_borrowing_rate rate_intra

* Trim. A transfer price more than 100 bp away from the same bond, same day,
* same tenor cleared rate is a reporting error, not a price.
drop if abs(wedge) > 100

* Date and panel ids
gen date = date(business_date, "YMD")
format date %td
gen year = year(date)
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin tenor)


*** SAMPLE

* Entities and groups behind the wedge, per year
preserve
egen tag_entity = tag(year entity_id)
egen tag_group = tag(year group_id)
collapse (sum) entities = tag_entity groups = tag_group (count) cells = wedge (sum) volume = chain, by(year)
list, clean
restore


*** DESCRIPTIVES

* Wedge, overall, by tenor bucket, by year
summarize wedge [aw = chain], detail
bysort tenor: summarize wedge [aw = chain]
tabstat wedge [aw = chain], by(year) statistics(mean p25 p50 p75 n)

* Share of volume where the internal leg is priced at the own cleared rate
gen at_ccp = abs(wedge) < 0.5
summarize at_ccp [aw = chain]


*** PASS-THROUGH
*** Internal rate on the own cleared rate, within entity-bond-tenor and date.
*** A slope of one means the internal leg moves one for one with the cleared
*** leg, so the wedge is a constant spread whatever the specialness. A slope
*** below one means the wedge shrinks when the bond is special, the euro area
*** entity absorbs one minus the slope of every specialness move. The level
*** of the wedge sits in the fixed effects and is given by the descriptives.
*** Rates in percent.

reghdfe rate_intra rate_ccp [aw = chain], absorb(ent_bond date) vce(cluster bond)



*** ===== OVERNIGHT (appended) =====
*** Same code on the overnight sample from the end of wedge.ipynb, trades with
*** contractual_maturity of 0 or 1 only, so both legs are priced on the day
*** and share the tenor. Uses wedge_eur_on.csv.

import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\wedge_eur_on.csv", clear

keep if chain_intra_to_ccp > 0
rename chain_intra_to_ccp chain
rename wedge_intra_to_ccp wedge
rename cleared_lending_rate rate_ccp
rename intra_borrowing_rate rate_intra

drop if abs(wedge) > 100

gen date = date(business_date, "YMD")
format date %td
gen year = year(date)
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin tenor)

preserve
egen tag_entity = tag(year entity_id)
egen tag_group = tag(year group_id)
collapse (sum) entities = tag_entity groups = tag_group (count) cells = wedge (sum) volume = chain, by(year)
list, clean
restore

summarize wedge [aw = chain], detail
tabstat wedge [aw = chain], by(year) statistics(mean p25 p50 p75 n)

gen at_ccp = abs(wedge) < 0.5
summarize at_ccp [aw = chain]

reghdfe rate_intra rate_ccp [aw = chain], absorb(ent_bond date) vce(cluster bond)


log close
