
* Aquí creo un programa pequeño para la extracción. 
capture program drop extraccion

program define extraccion
matrix define B=e(tau_cl)  
scalar beta=B[1,1]
matrix define SE=e(se_tau_cl)
scalar se=SE[1,1]
end


* Programa de generación de gráfico
capture program drop graficoaloES

program define graficoaloES
cls 
* Aquí vamos a almacenar los resultados para correr serrbar luego:
cap drop pointest
gen pointest=. 
cap drop stderr
gen stderr=. 

cap drop meses
gen meses=_n
replace meses=. if meses>6

* Creo unas dummies adicionales.
tab tam_emp, gen(tmemp)

* Este es el vector de X que vamos a usar. No solo los controles, incluye tam-
* bien la dummy de tratamiento.


* Hacemos las 6 regresiones:
forvalue j=1/6 {
* Sin covariables
rdrobust e`j' z, p(1) kernel(uni) // covs(sexb1 age ages province1-province24 secto2-secto14 tmemp1-tmemp3)  
extraccion
* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest=-beta in `j' 
replace stderr=se in `j'
}


* Ploteamos y guardamos. 
preserve 
keep pointest-meses
serrbar pointest stderr meses, ///
	 ytitle("Efecto del Salario Mínimo") xtitle("Meses Desde el Aumento") ///
	xlabel(1(1)6, valuelabel) graphregion(color(white)) ylabel(-.1(0.025).1, valuelabel) ///
	yline(0, lcolor(black)) scale(1.96)

restore 
end


foreach anio in 2003 Enero2004 2004 2005 2006 2007 2008 2011 {
use "$out/Aumento_`anio'", clear
* No incluye efecto fijo de persona ni de año:
graficoaloES
graph export "$out/FP`anio'OpbdwGrado1.png", replace

}
