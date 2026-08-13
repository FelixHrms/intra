*** USD DESCRIPTIVE EVIDENCE
*** Directly observed hedge fund Treasury financing through UK branches of euro
*** area groups, hedge funds being Cayman-resident investment funds. Daily.
*** One graph for the gross financing over time, one for the net positions.
*** Input is Data\desc_usd.csv from chains.ipynb.

clear all
import delimited "C:\\Users\\hermesf\\Projects\\Intragroup\\Data\\desc_usd.csv", clear

gen date = date(business_date, "YMD")
format date %td
sort date

* Gross financing over time, daily, USD bn
twoway (line hf_gross_bn date, lwidth(thin)), ///
    ytitle("USD bn") xtitle("") ///
    title("UK-branch hedge fund Treasury financing (gross, daily)") ///
    name(vol, replace)


* Net positions, daily. hf_net is the UK branch position vis-a-vis hedge funds,
* intra_net is the offsetting intragroup position. They should mirror around zero.
twoway (line hf_net_bn date, lwidth(thin)) ///
       (line intra_net_bn date, lwidth(thin) lpattern(thin)), ///
    yline(0, lcolor(gs10)) ///
    ytitle("Net cash position, USD bn") xtitle("") ///
    legend(order(1 "Net vs hedge funds" 2 "Net intragroup") rows(1) position(6)) ///
    name(net, replace)
graph export "C:\\Users\\hermesf\\Projects\\Intragroup\\structured\\usd_hf_netpositions.png", replace width(1600)
