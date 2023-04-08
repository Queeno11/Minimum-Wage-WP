* Datos para Nico:
clear all
set obs 1000
gen Aumento=""
save "$out/DatosGraph", replace


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
cap drop cotainf
gen cotainf=. 
cap drop cotasup
gen cotasup=. 



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
replace pointest=-beta in `j' 
replace stderr=se in `j'
replace cotainf=pointest-1.96*stderr in `j'
replace cotasup=pointest+1.96*stderr in `j'

}


end

local c=8
foreach anio in 2003 Enero2004 2004 2005 2006 2007 2008 2011 {
use "$out/Aumento_`anio'", clear
* No incluye efecto fijo de persona ni de año:
TablaES
keep pointest-meses
gen Aumento="`anio'"
drop if pointest==.
append using "$out/DatosGraph"

save "$out/DatosGraph", replace
}

 
 
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
keep pointest-meses
gen Aumento="Todos"
drop if pointest==.
append using "$out/DatosGraph"
drop if pointest==.

save "$out/DatosGraph", replace
