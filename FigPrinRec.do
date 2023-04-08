*===============================================================================
/*
En este do-file hice dos cosas. Primero, computé los RDs paramétricos y lineales
para la probabilidad de el aumento del SM destruya un match en algún punto luego 
de 1, 2, ..., o 6 meses. Luego, plotee los betas correspondientes a la dummy 
de ser tratado (tener un salario antes del aumento entre el SM antiguo y el 
nuevo). 

La idea es, calcular las regresiones, almacenar el beta con su error estándar y
luego plotearlo a lo Event Study. Realmente no estimamos un Event Study en 
niguna parte, pero se ve súper elegante presentar los resultados de esa forma. 
*/
*===============================================================================

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

global floro treated z c.z#i.treated i.sexo c.age##c.age i.provi i.sector 

* Hacemos las 6 regresiones:
forvalue j=1/6 {
reg e`j' $floro if z>=-180 & z<=180,robust
extraccion
replace pointest=beta in `j'
replace stderr=se in `j'
}


* Ploteamos y guardamos. 
preserve 
keep pointest-meses
serrbar pointest stderr meses, ///
	 ytitle("Efecto Destructor de Empleos") xtitle("Meses Desde el Aumento") ///
	xlabel(1(1)6, valuelabel) graphregion(color(white)) ylabel(-0.02(0.01).02, valuelabel) ///
	yline(0, lcolor(black))

graph export "$out/FiguraPrincipal2.png", replace
restore 

