
* Aquí creo un programa pequeño para la extracción. 
capture program drop extraccion

program define extraccion
matrix define B=r(table) 
scalar beta=B[1,1]
scalar se=B[2,1]
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


* Este es el vector de X que vamos a usar. No solo los controles, incluye tam-
* bien la dummy de tratamiento.

global floro treated z c.z#i.treated // i.sexo c.age##c.age i.provi i.sector i.tam_emp

* Hacemos las 6 regresiones:
forvalue j=1/6 {
reg e`j' $floro if z>=-150 & z<=150, robust 
extraccion
replace pointest=beta in `j'
replace stderr=se in `j'
}


* Ploteamos y guardamos. 
preserve 
keep pointest-meses
serrbar pointest stderr meses, ///
	 ytitle("Efecto del Salario Mínimo") xtitle("Meses Desde el Aumento") ///
	xlabel(1(1)6, valuelabel) graphregion(color(white)) ylabel(-0.02(0.02).1, valuelabel) ///
	yline(0, lcolor(black))

restore 
end


foreach anio in 2003 Enero2004 2004 2005 2006 2007 2008 2011 {
use "$out/Aumento_`anio'", clear
* No incluye efecto fijo de persona ni de año:
graficoaloES
graph export "$out/FiguraPrincipal`anio'.png", replace

}
