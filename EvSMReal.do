* Salario MÃ­nio, 96-2015: Covertura MLER
* Solo hay IPC hasta 2013.
global in "C:\Users\Nico\Documents\Maestría\Economia de la Distribución\Monografía Distribución\Data"
global out "C:\Users\Nico\Documents\Maestría\Economia de la Distribución\Monografía Distribución\Data\data_out"
* Esto tambiÃ©n puede funcionar https://datos.bancomundial.org/indicator/PA.NUS.PPPC.RF?end=2020&start=1990&view=chart
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

preserve 

import excel "$in/sh_ipc_2008.xls", sheet("Serie Histórica") cellrange(A5:AV996) firstrow clear
rename ao año
keep if año>"1995" & año<"2016"
rename Nivelgeneral IPC
keep año mes IPC
save "$out/IPC_96-15", replace
restore

merge 1:1 año mes using  "$out/IPC_96-15"
clonevar IPC_limpio=IPC
replace IPC_limpio=subinstr(IPC,",",".",.)
replace IPC_limpio=trim(IPC_limpio)
destring IPC_limpio, replace
gen SM_real=(salario_minimo_vital_movil_mensu*100/IPC_limpio)

egen tiempo=group(indice_tiempo)

* Esto se ve horrible, pensemos como visualizarlo bien:
line SM_real tiempo 
gen lsal=ln(SM_real)
line lsal tiempo 

sum SM_real if _n==1
stop
local baseline=r(mean)
gen SM_reali=SM_real/`baseline'*100

* Va de  71.56233 a  496.5002
la def tiempo 1 "1996"13 "1997"25 "1998"37 "1999"49 "2000" ///
 61 "2001" 73 "2002" 85 "2003" 97 "2004" 109 "2005" ///
121 "2006"133 "2007"145 "2008"157 "2009"169 "2010" 181 "2011"193 "2012" ///
205 "2013" 217 "2014"

la values tiempo tiempo

preserve
drop if tiempo>193
line SM_reali tiempo, ylabel(0(100)420, nogrid) yscale(r(0 420)) ///
xlabel(1(12)193, valuelabel labsize(vsmall) angle(45)) xscale(r(0 193)) graphregion(color(white)) ///
legend(label(1 "Salario MÃ­nimo")) xtitle("") ytitle("") ///
xline(90, lpattern(dash) lcolor(black)) lcolor(black)

  graph export "$out/SMRealIndexEnero1996.png", replace  


restore


