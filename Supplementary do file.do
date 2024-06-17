cd "C:\Users\te21567\OneDrive - Queen Mary, University of London\zother folders\Documents\Project"
//Table 5.1 reg 1a
reg overrun post i.countryid i.typeid gbp completed
  asdoc reg overrun post i.countryid i.typeid gbp completed, save(Table_5.1.doc)
  
//Table 5.2 reg 2a
 reg overrun post uk HSR gbp completed
asdoc reg overrun post uk HSR gbp completed, save(Table_5.2.doc)

//Table 5.3 reg 1a BP test
asdoc reg overrun post i.countryid i.typeid gbp completed, save(Table_5.3.doc)
estat hettest 
//Table 5.4 reg 2a BP test
asdoc reg overrun post uk HSR gbp completed, save(Table_5.4.doc)
estat hettest

//Table 5.5 ttest pre 
label define group 0 "Post-covid" 1 "Pre-covid", modify
label values pre group
asdoc ttest overrun, by(pre), save(Table_5.5.doc)
//Table 5.6 ttest bigshort
label define group 1 "Pre-08" 0 "2008-19", modify
label values bigshort group
asdoc ttest overrun if year<2020, by(bigshort), save(Table_5.6.doc)

//Table 5.7 reg just post 3a
asdoc reg overrun post, save(Table_5.7.doc)

//Table 5.8 reg just post and delay 3b
asdoc reg overrun delay post, save(Table_5.8.doc)

// Table 5.9 reg full model 1b - delay
asdoc reg overrun delay post i.countryid i.typeid gbp completed, save(Table_5.9.doc)
//Table 5.10 reg full model 2b - incl delay
asdoc reg overrun delay post uk HSR gbp completed, save(Table_5.10.doc) 



//Table 5.12 HSR ttest
label define group 1 "HSR" 0 "Other", modify
label values HSR group
asdoc ttest overrun, by(HSR), save(Table_5.12.doc)

//Table 5.14 UK ttest
label define group 1 "UK" 0 "Other", modify
label values uk group
asdoc ttest overrun, by(uk), save(Table_5.14.doc) 

///////////////////////
// Figure 5.1
two (scatter overrun year)(qfit overrun year), xtitle("Year of completion") ytitle("% Change in cost") legend(off)

// Figure 5.2
sort country
by country: egen country_pre= mean(overrun) if post==0
by country: egen country_post= mean(overrun) if post==1
by country: egen preavg =  mean(country_pre)
by country: egen postavg =  mean(country_post)
g ppointchange = (postavg - preavg)
g percentagechange = (postavg - preavg) / preavg

//Project level overruns
two (scatter overrun cases if post==1, mcolor(cranberry) msymbol(t))(lfit overrun cases if post==1)(qfit overrun cases, lpattern(dash)), saving(grplcases, replace) xtitle("") ytitle("Cost overrun (%)") legend(off)
two (scatter overrun deaths if post==1, mcolor(gold) msymbol(t))(lfit overrun deaths if post==1)(qfit overrun deaths, lpattern(dash)), saving(grpldeaths, replace) xtitle("") legend(off)
two (scatter overrun tight if post==1, mcolor(dkgreen) msymbol(t))(lfit overrun tight if post==1)(qfit overrun tight, lpattern(dash)), xtitle("") saving(grpltight, replace) legend(off)

//Country level overruns
//postavg
two (scatter postavg cases if cntn==1, mlabel(country) mcolor(cranberry))(lfit postavg cases if cntn==1)(qfit postavg cases if cntn==1, lpattern(dash)), saving(grcl1cases, replace) xtitle("") ytitle("Average overrun post-covid (%)") legend(off)
two (scatter postavg deaths if cntn==1, mlabel(country) mcolor(gold))(lfit postavg deaths if cntn==1)(qfit postavg deaths if cntn==1, lpattern(dash) mcolor(navy)), saving(grcl1deaths, replace) legend(off) xtitle("")
two (scatter postavg tight if cntn==1, mlabel(country) mcolor(dkgreen))(lfit postavg tight if cntn==1)(qfit postavg tight if cntn==1, lpattern(dash)), saving(grcl1tight, replace) legend(off) xtitle("")

//ppointchange
preserve
collapse ppointchange percentagechange cases deaths tight, by(country)
two (scatter ppointchange cases, mlabel(country) mcolor(cranberry))(lfit ppointchange cases)(qfit ppointchange cases, lpattern(dash)), saving(grcl2cases, replace) ytitle("Pstcovchng in avg overrun (%pts)", size(small)) legend(off) xtitle("")
two (scatter ppointchange deaths, mlabel(country) mcolor(gold))(lfit ppointchange deaths)(qfit ppointchange deaths, lpattern(dash)), saving(grcl2deaths, replace) legend(off) xtitle("")
two (scatter ppointchange tight, mlabel(country) mcolor(dkgreen))(lfit ppointchange tight)(qfit ppointchange tight, lpattern(dash)), saving(grcl2tight, replace) legend(off) xtitle("")
 restore
 
 //percentagechange
 preserve
collapse ppointchange percentagechange cases deaths tight, by(country)
two (scatter percentagechange cases, mlabel(country) mcolor(cranberry))(lfit percentagechange cases)(qfit percentagechange cases, lpattern(dash)), saving(grcl3cases, replace) xtitle("COVID19 cases per 100,000 population") ytitle("Pstcovchng in avg overrun (%chng)", size(small)) legend(off)
two (scatter percentagechange deaths, mlabel(country) mcolor(gold))(lfit percentagechange deaths)(qfit percentagechange deaths, lpattern(dash)), saving(grcl3deaths, replace) xtitle("COVID19 deaths per 100,000 population") legend(off)
two (scatter percentagechange tight, mlabel(country) mcolor(dkgreen))(lfit percentagechange tight)(qfit percentagechange tight, lpattern(dash)), saving(grcl3tight, replace) xtitle("COVID19 stringency index 0-100") legend(off)
 restore
 
 //combination
 
   gr combine grplcases.gph grpldeaths.gph grpltight.gph grcl1cases.gph grcl1deaths.gph grcl1tight.gph grcl2cases.gph grcl2deaths.gph grcl2tight.gph grcl3cases.gph grcl3deaths.gph grcl3tight.gph, rows(4) imargin(tiny) 
   
   
 ///////////////
 // Figure 5.3
 sort country
by country: egen country_pred= mean(delay) if post==0
by country: egen country_postd= mean(delay) if post==1
by country: egen preavgd =  mean(country_pred)
by country: egen postavgd =  mean(country_postd)
g ppointchanged = (postavgd - preavgd)
g percentagechanged = (postavgd - preavgd) / preavgd

//Project level delays
two (scatter delay cases if post==1, mcolor(cranberry) msymbol(t))(lfit delay cases if post==1)(qfit delay cases, lpattern(dash)), saving(delplcases, replace) xtitle("") ytitle("Schedule delay (months)") legend(off)
two (scatter delay deaths if post==1, mcolor(gold) msymbol(t))(lfit delay deaths if post==1)(qfit delay deaths, lpattern(dash)), saving(delpldeaths, replace) xtitle("") legend(off)
two (scatter delay tight if post==1, mcolor(dkgreen) msymbol(t))(lfit delay tight if post==1)(qfit delay tight, lpattern(dash)), xtitle("") saving(delpltight, replace) legend(off)

//Country level delays
//postavgd

two (scatter postavgd cases if cntn==1, mlabel(country) mcolor(cranberry))(lfit postavgd cases if cntn==1)(qfit postavgd cases if cntn==1, lpattern(dash)), saving(delcl1cases, replace) xtitle("") ytitle("Average delay post-covid (months)") legend(off)
two (scatter postavgd deaths if cntn==1, mlabel(country) mcolor(gold))(lfit postavgd deaths if cntn==1)(qfit postavgd deaths if cntn==1, lpattern(dash) mcolor(navy)), saving(delcl1deaths, replace) legend(off) xtitle("")
two (scatter postavgd tight if cntn==1, mlabel(country) mcolor(dkgreen))(lfit postavgd tight if cntn==1)(qfit postavgd tight if cntn==1, lpattern(dash)), saving(delcl1tight, replace) legend(off) xtitle("")

//delay change in months
preserve
collapse ppointchanged percentagechanged cases deaths tight, by(country)
two (scatter ppointchanged cases, mlabel(country) mcolor(cranberry))(lfit ppointchanged cases)(qfit ppointchanged cases, lpattern(dash)), saving(delcl2cases, replace) ytitle("Pstcovchng in avg delay (months)", size(small)) legend(off) xtitle("")
two (scatter ppointchanged deaths, mlabel(country) mcolor(gold))(lfit ppointchanged deaths)(qfit ppointchanged deaths, lpattern(dash)), saving(delcl2deaths, replace) legend(off) xtitle("")
two (scatter ppointchanged tight, mlabel(country) mcolor(dkgreen))(lfit ppointchanged tight)(qfit ppointchanged tight, lpattern(dash)), saving(delcl2tight, replace) legend(off) xtitle("")
 restore
 
 //percentagechange in delay
 preserve
collapse ppointchanged percentagechanged cases deaths tight, by(country)
two (scatter percentagechanged cases, mlabel(country) mcolor(cranberry))(lfit percentagechanged cases)(qfit percentagechanged cases, lpattern(dash)), saving(delcl3cases, replace) xtitle("COVID19 cases per 100,000 population") ytitle("Pstcovchng in avg overrun (%chng)", size(small)) legend(off)
two (scatter percentagechanged deaths, mlabel(country) mcolor(gold))(lfit percentagechanged deaths)(qfit percentagechanged deaths, lpattern(dash)), saving(delcl3deaths, replace) xtitle("COVID19 deaths per 100,000 population") legend(off)
two (scatter percentagechanged tight, mlabel(country) mcolor(dkgreen))(lfit percentagechanged tight)(qfit percentagechanged tight, lpattern(dash)), saving(delcl3tight, replace) xtitle("COVID19 stringency index 0-100") legend(off)
 restore
 
 //combination
 
   gr combine delplcases.gph delpldeaths.gph delpltight.gph delcl1cases.gph delcl1deaths.gph delcl1tight.gph delcl2cases.gph delcl2deaths.gph delcl2tight.gph delcl3cases.gph delcl3deaths.gph delcl3tight.gph, rows(4) imargin(tiny)
   
//////////////////
//Figure 5.4
twoway  (scatter overrun delay if group == "Post-Int", mcolor(gs0)   msymbol(s)) ///
		(scatter overrun delay if group == "Pre-Int" , mcolor(gs10)  msymbol(s)) ///
		(scatter overrun delay if group == "Post-UK" , mcolor(gs0)   msymbol(o)) ///
		(scatter overrun delay if group == "Pre-UK"  , mcolor(gs10)  msymbol(o)) ///
		(lfit overrun delay, lpattern(dash) lcolor(black)), ///
			legend(label(1 "Post-Int") label(2 "Pre-Int") label(3 "Post-UK") label(4 "Pre-uk")) ///
			text(.9465876 54  "HS2 Phase 2 (pre cancellation)"		, placement(ne) size(vsmall)) ///
			text(.5221    48  "HS2 Phase 1"							, placement(ne) size(vsmall)) ///
			text(.2966044 41  "Crossrail"							, placement(ne) size(vsmall)) ///
			text(.4130435 156 "Basque Y"							, placement(nw) size(vsmall)) ///
			text(.56840394 48 "Channel Tunnel Rail Link (CTRL/HS1)" , placement(nw) size(vsmall)) ///
			xtitle("Delay (months)", size(small)) ytitle("% Change in cost", size(small))
 
 