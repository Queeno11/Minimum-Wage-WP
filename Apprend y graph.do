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
matrix define B=r(table) 
scalar beta=B[1,1]
scalar se=B[2,1]
end

* Este es el vector de X que vamos a usar. No solo los controles, incluye tam-
* bien la dummy de tratamiento.

global floro treated z c.z#i.treated // i.sexo c.age##c.age i.provi i.sector i.anio i.tam_emp

* Hacemos las 6 regresiones:
forvalue j=1/6 {
* Con este bandwidth se parece mucho más a lo no-paramétrico que con [hneg, hpos]
reg e`j' $floro if z>=-150 & z<=150, robust //a(ide_trabajador)
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

graph export "$out/FiguraPrincipalGen.png", replace
restore 
