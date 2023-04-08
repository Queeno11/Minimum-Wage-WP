* ESTE DO-FILE HACE LA TABLA CON LOS RESULTADOS PRINCIPALES CON ANCHO DE BANDA 
* ÓPTIMO PARA POLINOMIOS DE GRADO 1 Y 2.


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

cap drop pointest1
gen pointest1=. 
cap drop stderr1
gen stderr1=. 
cap drop pval1
gen pval1=. 
cap drop Nobs1
gen Nobs1=. 

cap drop pointest2
gen pointest2=. 
cap drop stderr2
gen stderr2=. 
cap drop pval2
gen pval2=. 
cap drop Nobs2
gen Nobs2=. 

cap drop meses
gen meses=_n
replace meses=. if meses>6



* Hacemos las 6 regresiones:
forvalue j=1/6 {
* Bandwidth óptimo: sin covariables
rdrobust e`j' z, p(1) kernel(uni) // covs(sexb1 age ages province1-province24 secto2-secto14 tmemp1-tmemp3)  
extraccion


* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest1=-beta in `j' 
replace stderr1=se in `j'
replace pval1=pvalor in `j'
replace Nobs1=Num in `j'


* 1/2 Bandwidth óptimo: sin covariables

rdrobust e`j' z, p(2) kernel(uni) // covs(sexb1 age ages province1-province24 secto2-secto14 tmemp1-tmemp3)  
extraccion
* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest2=-beta in `j' 
replace stderr2=se in `j'
replace pval2=pvalor in `j'
replace Nobs2=Num in `j'


}


end

local c=8
foreach anio in 2003 Enero2004 2004 2005 2006 2007 2008 2011 {
use "$out/Aumento_`anio'", clear
* No incluye efecto fijo de persona ni de año:
TablaES

preserve 
keep pointest1-Nobs2
drop if pointest1==.
tostring pointest1 stderr1 pointest2 stderr2, replace format(%12.3f) force
 tostring Nobs1 Nobs2, replace format(%12.0fc) force
 
foreach x in stderr1 stderr2 {
replace `x'="("+`x'+")"
}


foreach v in 1 2 {
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
forvalues j=7/12 {
gen _var`j'=""

local k=`j'-6
replace _var`j'=_var`k'[_n+3] in 1
replace _var`j'=_var`k'[_n+3] in 2
replace _var`j'=_var`k'[_n+3] in 3
}

drop if _n>3

export excel "$out/ResultadosLinealvsCuad", sheetmodify cell(A`c')
restore

local c=`c'+4

}

 putexcel set "$out/ResultadosLinealvsCuad.xls", modify
 
 putexcel A1 = "Aumento/Grado del Polinomio"
 putexcel B1 = "Lineal"
 putexcel H1 = "Cuadrático"
 
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
keep pointest1-Nobs2
drop if pointest1==.
tostring pointest1 stderr1 pointest2 stderr2 , replace format(%12.3f) force
 tostring Nobs1 Nobs2, replace format(%12.0fc) force
 
foreach x in stderr1 stderr2 {
replace `x'="("+`x'+")"
}


foreach v in 1 2 {
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
forvalues j=7/12 {

gen _var`j'=""

local k=`j'-6
replace _var`j'=_var`k'[_n+3] in 1
replace _var`j'=_var`k'[_n+3] in 2
replace _var`j'=_var`k'[_n+3] in 3

}
drop if _n>3

export excel "$out/ResultadosLinealvsCuad", sheetmodify cell(A4)
restore


* MDE 

preserve 
count if abs(z)<=100.589
keep if abs(z)<=100.589
gen T=z<0
bys T: sum e6
restore

 
