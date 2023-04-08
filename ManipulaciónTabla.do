capture program drop extracciondens

program define extracciondens
matrix define T=e(T_q)  
scalar t=T[1,1]

matrix define PV=e(pv_q)  
scalar pv=PV[1,1]
end 


foreach anio in 2003 /*Enero2004 2004 2005 2006 2007 2008*/ {
use "$out/Aumento_`anio'", clear

* No incuyo los errores estándar porque hay dos, entonces es raro.
* Pointest aquí es el estadístico T (en el texto estoy poniendo que es esto exactamente).
cap drop pointest
gen pointest=. 
cap drop pval
gen pval=. 

cap drop pointest05
gen pointest05=. 
cap drop pval05
gen pval05=. 


cap drop pointest15
gen pointest15=. 
cap drop pval15
gen pval15=.  


* No incluye efecto fijo de persona ni de año:

* óptimo
sum hpos
local h=r(mean)


rddensity z,  plot_range(-`h' `h') graph_opt(graphregion(color(white)) ///
 xlabel(-`h'(20)`h', labsize(small) angle(45)) xtitle("Salario Centrado") ytitle("Densidad") legend(off))  ///
hist_range(-`h' `h')  genvars(temp) q(2) 

extracciondens

replace pointest=t in 1
replace pval=pv in 1



matrix define Hleft=e(h_l) 
scalar hleft=Hleft[1,1]

matrix define Hright=e(h_t) 
scalar hright=Hright[1,1]

local hl05=0.5*hleft
local hl15=1.5*hleft

local hr05=0.5*hright
local hr15=1.5*hright

* 0.5 Opt
rddensity z, h(`hl05' `hr05') plot_range(-`h' `h') graph_opt(graphregion(color(white)) ///
 xlabel(-`h'(20)`h', labsize(small) angle(45)) xtitle("Salario Centrado") ytitle("Densidad") legend(off))  ///
hist_range(-`h' `h')  genvars(temp) q(2) 

extracciondens

replace pointest05=t in 1
replace pval05=pv in 1

* 0.5 Opt
rddensity z, h(`hl15' `hr15') plot_range(-`h' `h') graph_opt(graphregion(color(white)) ///
 xlabel(-`h'(20)`h', labsize(small) angle(45)) xtitle("Salario Centrado") ytitle("Densidad") legend(off))  ///
hist_range(-`h' `h')  genvars(temp) q(2) 

extracciondens

replace pointest15=t in 1
replace pval15=pv in 1

}
* Esto es una mala idea...

/*
use "$out/Aumento_2011", clear
sum hpos
local h=r(mean)
scalar mh=-`h'

rddensity z, plot  plot_range(-`h' `h') graph_opt(graphregion(color(white)) ///
 xlabel(-`h'(115)`h', labsize(small) angle(45)) xtitle("Salario Centrado") ytitle("Densidad") legend(off))  ///
hist_range(-`h' `h')  genvars(temp) q(2)
graph export "$out/Manipulacion2011.png", replace
