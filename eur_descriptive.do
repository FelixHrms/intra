*** EUR DESCRIPTIVE EVIDENCE
*** Euro area subsidiaries of foreign groups on the intragroup-to-CCP leg.
*** Net cleared (CCP) position vs net intragroup position, daily, EUR bn.
*** They should mirror around zero if the subsidiary sources in cleared and
*** passes the bond out through intragroup. Input is Data\desc_eur.csv from
*** chains.ipynb.

clear all
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\desc_eur.csv", clear

gen date = date(business_date, "YMD")
format date %td
sort date

* Gross cleared activity over time, daily, EUR bn
twoway (line cleared_gross_bn date, lwidth(thin)), ///
    ytitle("EUR bn") xtitle("") ///
    title("Euro area subs cleared activity (gross, daily)") ///
    name(eur_vol, replace)


* Net positions, daily. cleared_net is the sub's position in the cleared segment,
* intra_net is the offsetting intragroup position. They should mirror around zero.
twoway (line cleared_net_bn date, lwidth(thin)) ///
       (line intra_net_bn date, lwidth(thin) lpattern(thin)), ///
    yline(0, lcolor(gs10)) ///
    ytitle("Net cash position, EUR bn") xtitle("") ///
    legend(order(1 "Net cleared (CCP)" 2 "Net intragroup") rows(1) position(6))  ///
    name(eur_net, replace)
graph export "C:\\Users\\hermesf\\Projects\\Intragroup\\structured\\eur_net_positions.png", replace width(1600)
