use "$out/Aumento_2003", clear
append using "$out/Aumento_Enero2004"
append using "$out/Aumento_2004"
append using "$out/Aumento_2005"
append using "$out/Aumento_2006"
append using "$out/Aumento_2007"
append using "$out/Aumento_2008"
append using "$out/Aumento_2011"


cls 
* Aquí vamos a almacenar los resultados para correr serrbar luego:
cap drop pointest
gen pointest=. 
cap drop stderr
gen stderr=. 

cap drop meses
gen meses=_n
replace meses=. if meses>6

* Aquí creo un programa pequeño para la extracción. 
capture program drop extraccion

program define extraccion
matrix define B=e(tau_cl)  
scalar beta=B[1,1]
matrix define SE=e(se_tau_cl)
scalar se=SE[1,1]
end

* Creo unas dummies adicionales.
tab anio, gen(yr) 
tab tam_emp, gen(tmemp)

* No sé como hacer los efectos fijos de persona. "tab ide_trabajador, gen" no 
* funciona porque ide_trabajador tiene "too many values". ¿Alguna idea?

* Hacemos las 6 regresiones:
forvalue j=1/6 {
* Sin covariables
rdrobust e`j' z, p(1) kernel(uni) // covs(sexb1 age ages province1-province24 secto2-secto14 yr2-yr7 tmemp1-tmemp3)
extraccion
* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest=-beta in `j'
replace stderr=se in `j'
}

* Ploteamos y guardamos. [CHANGED TO 90% CI (7/7/22)]
preserve 
keep pointest-meses
serrbar pointest stderr meses,  lc(black) mvopts(mc(black)) ///
	 ytitle("Treatment Effect: Percentage Point" "Difference in Separation Rates", size(medsmall)) xtitle("Months from Hike") ///
	xlabel(1(1)6, valuelabel) graphregion(color(white)) ylabel(-0.025(0.01).025, valuelabel) ///
	yline(0, lcolor(red) lpat(dash)) scale(1.65)

graph export "$out/FPGenOpbdwGrado1.png", replace
restore 
