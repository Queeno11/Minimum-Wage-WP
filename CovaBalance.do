* ESTE DO-FILE HACE LA TABLA CON LOS RESULTADOS PRINCIPALES CON ANCHO DE BANDA 
* ÓPTIMO Y TAMBIÉN CON 0.5*ÓPTIMO y 1.5*ÓPTIMO


* Aquí creo un programa pequeño para la extracción. 
capture program drop extraccion

program define extraccion
matrix define B=e(tau_cl)  
scalar beta=B[1,1]

matrix define SE=e(se_tau_cl)
scalar se=SE[1,1]

matrix define H=e(h_l)  
scalar bh=H[1,1]

matrix define PV=e(pv_cl)
scalar pvalor=PV[1,1]

matrix define Nleft=e(N_h_l)
matrix define Nright=e(N_h_r)

scalar Num=Nleft[1,1]+Nright[1,1]



end


* Programa de generación de gráfico
capture program drop TablaES

program define TablaES
cls 
* Aquí vamos a almacenar los resultados para hacer la tabla luego:

cap drop pointest
gen pointest=. 
cap drop stderr
gen stderr=. 
cap drop pval
gen pval=. 
cap drop Nobs
gen Nobs=. 


cap drop meses
gen meses=_n
replace meses=. if meses>6

gen empmasde50=(tam_emp==1 | tam_emp==2)
replace empmasde50=. if tam_emp==.

* Hacemos las regresiones para estas covariables:
* Capital Federal, Hombre, Empresa con más de 50 trabajadores, sector agrario
gen primario=(secto1==1|secto2==1|secto3==1)
replace primario=. if letra==""

gen GBA=(province1==1|province2==1|province3==1)
replace GBA=. if provi==.
local j=1
foreach y in GBA sexb2 fnac_anu empmasde50 primario { 
* Bandwidth óptimo: sin covariables
rdrobust `y' z, p(1) kernel(uni) 
extraccion

* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest=-beta in `j' 
replace stderr=se in `j'
replace pval=pvalor in `j'
replace Nobs=Num in `j'

local ++j
}


end

local c=8
foreach anio in 2003 Enero2004 2004 2005 2006 2007 2008 2011 {
use "$out/Aumento_`anio'", clear
* No incluye efecto fijo de persona ni de año:
TablaES

preserve 
keep pointest-Nobs
drop if pointest==.
tostring pointest stderr, replace format(%12.3f) force
 tostring Nobs , replace format(%12.0fc) force
 
foreach x in stderr {
replace `x'="("+`x'+")"
}

replace pointest=pointest+"*" if pval>=0.05 & pval<0.1
replace pointest=pointest+"**" if pval>=0.01 & pval<0.05
replace pointest=pointest+"***" if pval<0.01
drop pval


sxpose, clear
gen expres="Efecto del Tratamiento" in 1
replace expres="Error Estándar" in 2
replace expres="N. Obs" in 3
order expres _v*

drop if _n>3

export excel "$out/CovBalance", sheetmodify cell(A`c')
restore

local c=`c'+4

}

 putexcel set "$out/CovBalance.xls", modify
 
 putexcel A1 = "Aumento/Covariable"

 putexcel B2 = "Capital Federal"
 putexcel C2 = "Hombre"
 putexcel D2 = "Año de Nacimiento"
 putexcel E2 = "Empresa Grande"
 putexcel F2 = "Sector Agro"
 

 
 
 putexcel A3 = "Todos", bold
 putexcel A7 = "Julio de 2003", bold
 putexcel A11 = "Enero de 2004", bold
 putexcel A15 = "Septiembre de 2004", bold
 putexcel A19 = "Mayo de 2005", bold
 putexcel A23 = "Agosto de 2006", bold
 putexcel A27 = "Agosto de 2007", bold
 putexcel A31 = "Agosto de 2008", bold
 putexcel A35 = "Septiembre de 2011", bold
 
 * Todos

use "$out/Aumento_2003", clear
append using "$out/Aumento_Enero2004"
append using "$out/Aumento_2004"
append using "$out/Aumento_2005"
append using "$out/Aumento_2006"
append using "$out/Aumento_2007"
append using "$out/Aumento_2008"
append using "$out/Aumento_2011"

cls 
* No incluye efecto fijo de persona ni de año:
TablaES

preserve 
keep pointest-Nobs
drop if pointest==.
tostring pointest stderr, replace format(%12.3f) force
 tostring Nobs, replace format(%12.0fc) force
 
foreach x in stderr {
replace `x'="("+`x'+")"
}

replace pointest=pointest+"*" if pval>=0.05 & pval<0.1
replace pointest=pointest+"**" if pval>=0.01 & pval<0.05
replace pointest=pointest+"***" if pval<0.01
drop pval


* El orden es optimo, 0.5 y 1.5.
sxpose, clear
gen expres="Efecto del Tratamiento" in 1
replace expres="Error Estándar" in 2
replace expres="N. Obs" in 3
order expres _v*

drop if _n>3

export excel "$out/CovBalance", sheetmodify cell(A4)
restore


 
