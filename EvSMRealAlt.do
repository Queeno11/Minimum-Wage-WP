* Salario Mínio, 96-2015: Covertura MLER
* Solo hay IPC hasta 2013.

* Esto también puede funcionar https://datos.bancomundial.org/indicator/PA.NUS.PPPC.RF?end=2020&start=1990&view=chart
* No recuerdo de donde sacamos esto jaja.
import delimited "$in/indice-salario-minimo-vital-movil-valores-mensuales-pesos-corrientes-desde-1988.csv", clear 

keep if _n>372 & _n<613
gen mes=_n
local iter=1
while `iter'<19 {
replace mes=mes-12 if mes>12
local ++iter
}

gen año=substr(indice_tiempo,1,4) 


/*
preserve 

import excel "$in/sh_ipc_2008.xls", sheet("Serie Histórica") cellrange(A5:AV996) firstrow clear
keep if año>"1995" & año<"2016"
rename Nivelgeneral IPC
keep año mes IPC
save "$out/IPC_96-15", replace
restore
*/

preserve 
import excel "$in/ITCRMSerie.xls", sheet("ITCRM y bilaterales prom. mens.") cellrange(A2:B194) firstrow clear
gen año=year(Período)
gen mes=month(Período)
keep if año>1995 & año<2016
tostring año, replace
keep año mes ITCRM
save "$out/ITCRM_96-15", replace
restore


merge 1:1 año mes using "$out/ITCRM_96-15"
drop if año=="1996"
*100
gen SM_real=(salario_minimo_vital_movil_mensu/ITCRM)

egen tiempo=group(indice_tiempo)

* Esto se ve horrible, pensemos como visualizarlo bien:
line SM_real tiempo 
gen lsal=ln(SM_real)
line lsal tiempo 

sum SM_real if _n==1

local baseline=r(mean)
gen SM_reali=SM_real/`baseline'*100

* Va de  71.56233 a  496.5002
la def tiempo 1 "1997" 13 "1998"25 "1999"37 "2000"49 "2001" ///
 61 "2002" 73 "2003" 85 "2004" 97 "2005" 109 "2006" ///
121 "2007"133 "2008"145 "2009"157 "2010"169 "2011" 181 "2012" 193 "2013" ///
205 "2014" 217 "2015"

la values tiempo tiempo

preserve
drop if tiempo>193
line SM_reali tiempo, ylabel(0(200)1200, nogrid) yscale(r(0 1200)) ///
xlabel(1(12)193, valuelabel labsize(vsmall) angle(45)) xscale(r(0 193)) graphregion(color(white)) ///
legend(label(1 "Salario Mínimo")) xtitle("") ytitle("") ///
xline(78, lpattern(dash) lcolor(black)) lcolor(black)

  graph export "$out/SMRealIndexEnero1996Alternativo.png", replace  


restore


