log using "C:\\Users\\hermesf\\Projects\\Intragroup\\wedge.log", replace text

*** WEDGE
*** Internal price of the chain for euro area subsidiaries of foreign groups.
*** Rows are subsidiary by bond by day by tenor bucket, from wedge.ipynb.
*** wedge_intra_to_ccp is the cleared lending rate minus the intragroup
*** borrowing rate (bond goes out to the affiliate), wedge_ccp_to_intra is the
*** intragroup lending rate minus the cleared borrowing rate (bond comes in).
*** Both in basis points, positive when the subsidiary keeps a margin.

clear all

* Import the data
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\wedge_eur.csv", clear

* Date and panel ids
gen date = date(business_date, "YMD")
format date %td
gen year = year(date)
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin tenor)


*** SAMPLE

* Entities and groups behind the wedge, per year
preserve
egen tag_entity = tag(year entity_id) if wedge_intra_to_ccp < . | wedge_ccp_to_intra < .
egen tag_group = tag(year group_id) if wedge_intra_to_ccp < . | wedge_ccp_to_intra < .
collapse (sum) entities = tag_entity groups = tag_group (count) cells_in = wedge_intra_to_ccp cells_out = wedge_ccp_to_intra, by(year)
list, clean
restore

* Groups running a chain in the same bond-day
tab n_groups if wedge_intra_to_ccp < .


*** DESCRIPTIVES

* Wedge by direction, unweighted and weighted by matched volume
summarize wedge_intra_to_ccp wedge_ccp_to_intra carry, detail
summarize wedge_intra_to_ccp [aw = chain_intra_to_ccp], detail
summarize wedge_ccp_to_intra [aw = chain_ccp_to_intra], detail

* By tenor bucket and by year
bysort tenor: summarize wedge_intra_to_ccp wedge_ccp_to_intra
tabstat wedge_intra_to_ccp wedge_ccp_to_intra, by(year) statistics(mean p50 n)

* Pricing convention of the internal leg. Share of cells within half a basis
* point of the own cleared rate, of the market cleared rate, and of ESTR.
gen at_own_in = abs(wedge_intra_to_ccp) < 0.5 if chain_intra_to_ccp > 0
gen at_market_in = abs(intra_borrowing_rate - market_rate)*100 < 0.5 if chain_intra_to_ccp > 0 & market_rate < .
gen at_estr_in = abs(intra_borrowing_rate - estr)*100 < 0.5 if chain_intra_to_ccp > 0 & estr < .
gen at_own_out = abs(wedge_ccp_to_intra) < 0.5 if chain_ccp_to_intra > 0
gen at_market_out = abs(intra_lending_rate - market_rate)*100 < 0.5 if chain_ccp_to_intra > 0 & market_rate < .
gen at_estr_out = abs(intra_lending_rate - estr)*100 < 0.5 if chain_ccp_to_intra > 0 & estr < .
summarize at_own_in at_market_in at_estr_in at_own_out at_market_out at_estr_out

* Haircut and maturity on the two legs of each direction
summarize cleared_lending_haircut intra_borrowing_haircut cleared_lending_maturity intra_borrowing_maturity if chain_intra_to_ccp > 0
summarize cleared_borrowing_haircut intra_lending_haircut cleared_borrowing_maturity intra_lending_maturity if chain_ccp_to_intra > 0


*** PASS-THROUGH
*** Internal rate on the external rate, within entity-bond-tenor and date.
*** A slope of one means the internal leg tracks the external leg, below one
*** means the subsidiary keeps part of the movement. Rates in percent.

reghdfe intra_borrowing_rate cleared_lending_rate if chain_intra_to_ccp > 0, absorb(ent_bond date) vce(cluster bond)
reghdfe intra_borrowing_rate market_rate if chain_intra_to_ccp > 0, absorb(ent_bond date) vce(cluster bond)
reghdfe intra_lending_rate cleared_borrowing_rate if chain_ccp_to_intra > 0, absorb(ent_bond date) vce(cluster bond)
reghdfe intra_lending_rate market_rate if chain_ccp_to_intra > 0, absorb(ent_bond date) vce(cluster bond)


*** WEDGE AND SPECIALNESS
*** Does the margin widen when the bond is special. Both in basis points.

reghdfe wedge_intra_to_ccp special, absorb(ent_bond date) vce(cluster bond)
reghdfe wedge_ccp_to_intra special, absorb(ent_bond date) vce(cluster bond)


*** COVERAGE
*** Chain volume with a rate in this file against the matched chain volume of
*** the pricing table, which uses all trades, at the bond-day level.

preserve
collapse (sum) chain_rated = chain_intra_to_ccp, by(business_date security_isin)
tempfile rated
save `rated'
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\intra_cleared_matched.csv", clear
merge 1:1 business_date security_isin using `rated', keep(match) nogenerate
collapse (sum) chain_rated intra_m
gen coverage = chain_rated / intra_m
list, clean
restore


log close
