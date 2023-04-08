use "$out/Aumento_2003", clear
append using "$out/Aumento_Enero2004"
append using "$out/Aumento_2004"
append using "$out/Aumento_2005"
append using "$out/Aumento_2006"
append using "$out/Aumento_2007"
append using "$out/Aumento_2008"
append using "$out/Aumento_2011"

preserve

local h 10 // Acá le pones el bandwidth que quieras
local binsize 1 // Acá va la "longitud" de cada bin"
local y e6 // Acá va el nombre de la variable dependiente

* Nos quedamos solo con las obs cercanas al umbral.

keep if z>=-`h' & z<=`h' 



*Bins: Esta secuencia agrega las observaciones en bins.
cap drop bins
generate bins=.

forvalues j=-`h'(`binsize')`h' { 
replace bins=`j' if z>=`j'-`binsize' & z<`j'
}

* Creamos pesos de tal manera que cada bin esté ponderado por el número de 
* observaciones que lo compone.
bys bins: egen weight=count(`y') 

* Hace el dibujito y lo guarda. 
collapse `y' z weight treated , by (bins)
twoway (scatter `y' z [w=weight] if treated==1, msymbol(O) mcolor(maroon)) ///
 (scatter `y' z [w=weight] if treated==0, msymbol(circle_hollow) mcolor(navy)) ///
 (lfit `y' z [w=weight] if treated==1, lcolor(maroon) /*ciplot(rline)*/) ///
 (lfit `y' z [w=weight] if treated==0, lcolor(navy) lpattern(dash) /*ciplot(rline)*/ ), ///
 xline(0, lpattern(dash) lcolor(gs7)) graphregion(color(white)) xtitle(Running Variable: Centered Baseline Wages) ytitle (Probability of Separation) legend(off)
graph export "$out/GraficoClasicoEN.png", replace
restore 
