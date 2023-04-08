* Salario MÃ­nio, 96-2015: Covertura MLER
* Solo hay IPC hasta 2013.
global in "C:\Users\Nico\Documents\Maestría\Economia de la Distribución\Monografía Distribución\Data"
global out "C:\Users\Nico\Documents\Maestría\Economia de la Distribución\Monografía Distribución\Data\data_out"
* Esto tambiÃ©n puede funcionar https://datos.bancomundial.org/indicator/PA.NUS.PPPC.RF?end=2020&start=1990&view=chart
* No recuerdo de donde sacamos esto jaja.

import excel "$in/GDP Arg (World Bank).xls", sheet("Arg") clear firstrow

gen GDP_base2002=GDPcurrentUS/GDPcurrentUS[3]*100
* Paso a bn
gen GDPcurrentUS_bn = GDPcurrentUS / 1000000000 

destring IndicatorName, gen(tiempo)
drop if tiempo > 2012

twoway (line GDPcurrentUS_bn tiempo, lcolor(black) ylabel(0(100)650, nogrid)), ///
xlabel(2000(1)2012, valuelabel labsize(small) angle(45)) graphregion(color(white)) ///
xtitle("") ytitle("") ///
xline(2003.45, lpattern(dash) lcolor(black))

graph export "$out/GPD_current.png", replace  

twoway (line GDP_base2002 tiempo, lcolor(black) ylabel(0(100)650, nogrid)), ///
xlabel(2000(1)2012, valuelabel angle(45)) graphregion(color(white)) ///
xtitle("") ytitle("") ///
xline(2003.45, lpattern(dash) lcolor(black))

graph export "$out/GPD_base2002.png", replace  

