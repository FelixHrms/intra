log using "C:\\Users\\hermesf\\Projects\\Intragroup\\passthrough.log", replace text
*** PASS-THROUGH REGRESSIONS
*** Within-entity, within-security co-movement of the intragroup leg and the
*** matched external leg. Shows the intermediating entity passes flow through
*** rather than holding it. EUR is the intragroup-to-CCP leg for euro area
*** subsidiaries of foreign groups. USD is the hedge-fund-to-intragroup leg for
*** UK branches of euro area groups. Entity-by-security and date fixed effects,
*** so identification is time variation within a given entity and bond.
*** Standard errors clustered by bond.

clear all

*** EUR, intragroup volume on cleared (CCP) volume
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\pt_eur.csv", clear
gen date = date(business_date, "YMD")
format date %td
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin)

* gross volume co-movement
reghdfe intra_vol cleared_vol, absorb(ent_bond date) vce(cluster bond)

* net positions, a slope near minus one means the entity offsets its external position
reghdfe intra_net cleared_net, absorb(ent_bond date) vce(cluster bond)


*** USD, intragroup volume on hedge fund volume
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\pt_usd.csv", clear
gen date = date(business_date, "YMD")
format date %td
encode security_isin, gen(bond)
egen ent_bond = group(entity_id security_isin)

reghdfe intra_vol hf_vol, absorb(ent_bond date) vce(cluster bond)

reghdfe intra_net if_net, absorb(ent_bond date) vce(cluster bond)


log close