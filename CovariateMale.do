* Buenos Aires.


* Aquí creo un programa pequeño para la extracción. 
capture program drop extraccion

program define extraccion
matrix define B=e(tau_cl)  
scalar beta=B[1,1]

matrix define right=e(ci_r_cl) 
scalar high=right[1,1]
matrix define left=e(ci_l_cl) 
scalar low=left[1,1]

end


* Programa de generación de gráfico
capture program drop Graphloco

program define Graphloco
cls 
* Aquí vamos a almacenar los resultados para hacer la tabla luego:

cap drop pointest
gen pointest=. 
cap drop low95
gen low95=. 
cap drop low90
gen low90=. 
cap drop high95
gen high95=. 
cap drop high90
gen high90=. 
cap drop bdw
gen bdw=. 

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
forvalues h=10(10)600 /* Aca itero sobre bdw no covariates GBA sexb2 fnac_anu empmasde50 primario*/ { 
* Covariables

rdrobust sexb2 z, p(1) kernel(uni) level(90) h(`h')
extraccion

* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace bdw=`h' in `j'
replace low90=-low in `j'
replace high90=-high in `j'

rdrobust sexb2 z, p(1) kernel(uni) h(`h')
extraccion

* IMPORTANTE: 
* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointest=-beta in `j' 
replace low95=-low in `j'
replace high95=-high in `j'


local ++j
}


end

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
Graphloco

gen zeroline = 0
	local color1 maroon
	local color2 0 0 255

		twoway rarea low95 high95 bdw, sort lcolor(`color1'*.20) fcolor(`color1') fintensity(20) || /// 
		rarea low90 high90 bdw,  lcolor(`color1'*.40) fcolor(`color1') fintensity(40) || ///
		line pointest bdw, sort lpattern(l) lcolor(`color1') ||  ///
		lfit zeroline bdw, lcolor(black) ///
		xlabel(,labsize(medium)) ///	
		xscale(r(9 601)) ///
		xlabel(10(50)600, labsize(vsmall) angle(45)) ///
		ylabel(,glcolor(none) labsize(medium)) ///
		legend(off)  ///
		title("") ///
		ytitle(Employee is Male , margin(r=1) size(medium)) xtitle("Bandwidth (ARS)", size(medium)) ///
		graphregion(color(white)) plotregion(style(none)) 
		graph export "$out/MaleVsBandwidth.png", replace 
		

/* 		yscale(r(-0.05 .5)) ///
		ylabel(-.05 0 .15 .25 .35 .5) ///
		*/
		
 
