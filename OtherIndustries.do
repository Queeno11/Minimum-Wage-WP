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

cap drop pointest05
gen pointest05=. 
cap drop stderr05
gen stderr05=. 
cap drop pval05
gen pval05=. 
cap drop Nobs05
gen Nobs05=. 

cap drop pointest15
gen pointest15=. 
cap drop stderr15
gen stderr15=.
cap drop pval15
gen pval15=.  
cap drop Nobs15
gen Nobs15=. 

cap drop meses
gen meses=_n
replace meses=. if meses>6



* Hacemos las 6 regresiones:
forvalue j=1/6 {
* Bandwidth óptimo: sin covariables
rdrobust e`j' z, p(1) kernel(uni) // covs(sexb1 age ages province1-province24 secto2-secto14 tmemp1-tmemp3)  
extraccion
local h1=0.5*bh
local h2=1.5*bh

* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest=-beta in `j' 
replace stderr=se in `j'
replace pval=pvalor in `j'
replace Nobs=Num in `j'


* 1/2 Bandwidth óptimo: sin covariables

rdrobust e`j' z, p(1) kernel(uni) h(`h1') // covs(sexb1 age ages province1-province24 secto2-secto14 tmemp1-tmemp3)  
extraccion
* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest05=-beta in `j' 
replace stderr05=se in `j'
replace pval05=pvalor in `j'
replace Nobs05=Num in `j'



* 1.5 Bandwidth óptimo: sin covariables
rdrobust e`j' z, p(1) kernel(uni) h(`h2') // covs(sexb1 age ages province1-province24 secto2-secto14 tmemp1-tmemp3)  
extraccion
* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest15=-beta in `j' 
replace stderr15=se in `j'
replace pval15=pvalor in `j'
replace Nobs15=Num in `j'


}


end

local c=8
foreach anio in 2003 Enero2004 2004 2005 2006 2007 2008 2011 {
use "$out/Aumento_`anio'", clear
gen otros=(secto7==1|secto8==1|secto9==1|secto10==1|secto11==1|secto12==1|secto13==1|secto14==1)
replace otros=. if letra==""

keep if otros==1
* No incluye efecto fijo de persona ni de año:
TablaES

preserve 
keep pointest-Nobs15
drop if pointest==.
tostring pointest stderr pointest05 stderr05 pointest15 stderr15, replace format(%12.3f) force
 tostring Nobs Nobs05 Nobs15, replace format(%12.0fc) force
 
foreach x in stderr stderr05 stderr15 {
replace `x'="("+`x'+")"
}

replace pointest=pointest+"*" if pval>=0.05 & pval<0.1
replace pointest=pointest+"**" if pval>=0.01 & pval<0.05
replace pointest=pointest+"***" if pval<0.01
drop pval

foreach v in 05 15 {
replace pointest`v'=pointest`v'+"*" if pval`v'>=0.05 & pval`v'<0.1
replace pointest`v'=pointest`v'+"**" if pval`v'>=0.01 & pval`v'<0.05
replace pointest`v'=pointest`v'+"***" if pval`v'<0.01
drop pval`v'
}

* El orden es optimo, 0.5 y 1.5.
sxpose, clear
gen expres="Efecto del Tratamiento" in 1
replace expres="Error Estándar" in 2
replace expres="N. Obs" in 3
order expres _v*
forvalues j=7/18 {

gen _var`j'=""

if `j' <13 {
local k=`j'-6
replace _var`j'=_var`k'[_n+3] in 1
replace _var`j'=_var`k'[_n+3] in 2
replace _var`j'=_var`k'[_n+3] in 3
}
else if `j' >=13 & `j'<19 {
local k=`j'-12
replace _var`j'=_var`k'[_n+6] in 1
replace _var`j'=_var`k'[_n+6] in 2
replace _var`j'=_var`k'[_n+6] in 3
}
}
drop if _n>3

export excel "$out/ResultadosLocalLinearOtros", sheetmodify cell(A`c')
restore

local c=`c'+4

}

 putexcel set "$out/ResultadosLocalLinearOtros.xls", modify
 
 putexcel A1 = "Aumento/Ancho de Banda"
 putexcel B1 = "Óptimo"
 putexcel H1 = "0.5 X Óptimo"
 putexcel N1 = "1.5 X Óptimo"
 
 putexcel B2 = "1 mes"
 putexcel C2 = "2 meses"
 putexcel D2 = "3 meses"
 putexcel E2 = "4 meses"
 putexcel F2 = "5 meses"
 putexcel G2 = "6 meses"
 
 putexcel H2 = "1 mes"
 putexcel I2 = "2 meses"
 putexcel J2 = "3 meses"
 putexcel K2 = "4 meses"
 putexcel L2 = "5 meses"
 putexcel M2 = "6 meses"
 
 putexcel N2 = "1 mes"
 putexcel O2 = "2 meses"
 putexcel P2 = "3 meses"
 putexcel Q2 = "4 meses"
 putexcel R2 = "5 meses"
 putexcel S2 = "6 meses"
 
 
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

gen otros=(secto7==1|secto8==1|secto9==1|secto10==1|secto11==1|secto12==1|secto13==1|secto14==1)
replace otros=. if letra==""

keep if otros==1

cls 
* No incluye efecto fijo de persona ni de año:
TablaES

preserve 
keep pointest-Nobs15
drop if pointest==.
tostring pointest stderr pointest05 stderr05 pointest15 stderr15, replace format(%12.3f) force
 tostring Nobs Nobs05 Nobs15, replace format(%12.0fc) force
 
foreach x in stderr stderr05 stderr15 {
replace `x'="("+`x'+")"
}

replace pointest=pointest+"*" if pval>=0.05 & pval<0.1
replace pointest=pointest+"**" if pval>=0.01 & pval<0.05
replace pointest=pointest+"***" if pval<0.01
drop pval

foreach v in 05 15 {
replace pointest`v'=pointest`v'+"*" if pval`v'>=0.05 & pval`v'<0.1
replace pointest`v'=pointest`v'+"**" if pval`v'>=0.01 & pval`v'<0.05
replace pointest`v'=pointest`v'+"***" if pval`v'<0.01
drop pval`v'
}

* El orden es optimo, 0.5 y 1.5.
sxpose, clear
gen expres="Efecto del Tratamiento" in 1
replace expres="Error Estándar" in 2
replace expres="N. Obs" in 3
order expres _v*
forvalues j=7/18 {

gen _var`j'=""

if `j' <13 {
local k=`j'-6
replace _var`j'=_var`k'[_n+3] in 1
replace _var`j'=_var`k'[_n+3] in 2
replace _var`j'=_var`k'[_n+3] in 3
}
else if `j' >=13 & `j'<19 {
local k=`j'-12
replace _var`j'=_var`k'[_n+6] in 1
replace _var`j'=_var`k'[_n+6] in 2
replace _var`j'=_var`k'[_n+6] in 3
}
}
drop if _n>3

export excel "$out/ResultadosLocalLinearOtros", sheetmodify cell(A4)
restore


 
