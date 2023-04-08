
use "$out/DatosGraph.dta", clear

reshape wide pointest stderr cotainf cotasup, i(meses) j(Aumento) string

local new = _N + 1
set obs `new'

foreach var of varlist _all {
replace `var'= 0 if `var'==.
}
sort meses

/*
capture graph drop mygraph
twoway  (line pointest2003 meses, lpattern("_")) ///
		(line pointest2004 meses, lpattern("_")) ///
		(line pointest2005 meses, lpattern("_")) ///
		(line pointest2006 meses, lpattern("_")) ///
		(line pointest2007 meses, lpattern("_")) ///
		(line pointest2008 meses, lpattern(1) lwidth(medthick)) ///
		(line pointest2011 meses, lpattern("_")) ///
	    (line pointestEnero2004 meses, lpattern(1) lwidth(medthick) lcolor(gold))  ///
		(line pointestTodos meses, lpattern("_") lwidth(medthick) lcolor("black")), ///
		legend(label(1 "Jul. 2003") label(2 "Sep. 2004") label(3 "May. 2005") ///
		label(4 "Aug. 2006") label(5 "Aug. 2007") label(6 "Aug. 2008") ///
		label(7 "Sep. 2011") label(8 "Jan. 2004") label(9 "All") order(1 8 2 3 4 5 6 7 9) rows(3)) ///
		graphregion(color(white)) xtitle(Months Since the Hike) ytitle(Treatment Effect) name(mygraph) ///
		 ylabel(-.1(0.05).1, valuelabel) 
graph display mygraph, ysize(3) xsize(4)

graph export "$out/PathofBeta.pdf", replace
*/

capture graph drop mygraph
twoway  (connected pointest2003 meses, lpattern("_") msym(V)) ///
		(connected pointest2004 meses, lpattern("_") msym(i)) ///
		(connected pointest2005 meses, lpattern("_") msym(X)) ///
		(connected pointest2006 meses, lpattern("_") msym(|)) ///
		(connected pointest2007 meses, lpattern("_") msym(Sh)) ///
		(connected pointest2008 meses, lpattern(1) lwidth(medthick) msym(O)) ///
		(connected pointest2011 meses, lpattern("_") msym(A)) ///
	    (connected pointestEnero2004 meses, lpattern(1) lwidth(medthick) lcolor(gold) msym(D) mcolor(gold))  ///
		(connected pointestTodos meses, lpattern("_") lwidth(medthick) lcolor("black") mcolor(black) msym(Oh)), ///
		legend(label(1 "Jul. 2003") label(2 "Sep. 2004") label(3 "May. 2005") ///
		label(4 "Aug. 2006") label(5 "Aug. 2007") label(6 "Aug. 2008") ///
		label(7 "Sep. 2011") label(8 "Jan. 2004") label(9 "Pool") order(1 8 2 3 4 5 6 7 9) rows(3)) ///
		graphregion(color(white)) xtitle(Months from Hike) ytitle("Treatment Effect: Percentage Point" "Difference in Separation Rates", size(medsmall)) name(mygraph) ///
		 ylabel(-.1(0.05).1, valuelabel) 
graph display mygraph, ysize(3) xsize(4)

graph export "$out/PathofBeta.pdf", replace
