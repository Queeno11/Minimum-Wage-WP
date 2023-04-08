*===============================================================================
/*
Versión generalizada de la limpieza de datos.
*/
*===============================================================================

use "$in/Muestra Longitudinal Empleo Registrado.dta", clear


* Los datos tienen muchísimas variables y ocupa mucha RAM usar todo al mismo tiempo
* por eso hice un keep.

local an=substr("$anio",-2,2)

keep $wt0 $wt1 $wt2 $wt3 $wt4 $wt5 $wt6 provi fnac_anu sexo pondera letra ///
tr_04`an' ide_trabajador

rename tr_04`an' tam_emp // Variable para el tamaño de empresa

gen anio=$anio 
* Variables de ancho de banda, simétrico y medio arbitrario: 
gen hneg=-SMdist // Candidato a ancho de banda por la izquierda.
gen hpos=SMdist // Candidato a ancho de banda por la derecha.

* Cree una variable para la edad. 
gen age=$anio-fnac_anu

* Eliminé a la gente con missing en los controles. De cualquier modo, en las
* regresiones pasaría esto, así que mejor trabajar todo con las mismas obs. 
drop if sexo==0
drop if age==. | provi==. | letra=="" 

* Eliminé a las observaciones con ingresos missing (empleos inactivos) o 
* con ingresos menores al SM el mes anterior al aumento. 
* 	SUPUESTO 1: los puestos de trabajo con ingresos menores al SM son part-time. 

*	Nota 1:  Las remuneraciones con valor igual a 0 en general corresponden a 
*			 trabajadores que están con licencia.
drop if $wt0<$SMpre | $wt0==.

* Variable para el ingreso centrado en el nuevo SM.
gen z:"Centered wage"=$wt0-$SMpost
* Variable de tratamiento: SM antiguo <= Salario antes del aumento < SM nuevo.
gen treated=($wt0>=$SMpre & $wt0<$SMpost)

/*
 Acá creo unas variables intermedias que toman el valor de 1 si el match sigue
 activo en el mes 1, en el 2, ..., o en el 6 luego del aumento. Todos los 
 matches están activos en t=0. Considero que un match se destruye si el salario 
 se vuelve missing o cero (aunque cero es "licencia" creo que lo más estricto
 es asumir que una licencia también es destrucción, pero no estoy convencido).
 ¿Qué piensas?
 
 Por ejemplo:
 emp_1 toma el valor de 1 si había info de ingresos válida un mes luego del 
 aumento y cero si no había. emp_2 toma el valor de 1 si el empleo tuvo info 
 válida tanto en el primer como en el segundo mes luego del aumento. Y así... 
*/
forvalues j=1/6{
gen emp_`j'=1
}


* Esto hay que mejorarlo:
replace emp_1=0 if $wt1==0 |$wt1==.

replace emp_2=0 if emp_1==0
replace emp_2=0 if $wt2==0 |$wt2==.

replace emp_3=0 if emp_2==0
replace emp_3=0 if $wt3==0 |$wt3==.

replace emp_4=0 if emp_3==0
replace emp_4=0 if $wt4==0 |$wt4==.

replace emp_5=0 if emp_4==0
replace emp_5=0 if $wt5==0 |$wt5==.

replace emp_6=0 if emp_5==0
replace emp_6=0 if $wt6==0 |$wt6==.

*******************
/*
 Aquí ej invierte e_j; de tal manera que ej indica si es que el match se rompió 
 en cualquier punto j meses luego del aumento. Por ejemplo, para j=3, e podría 
 ser igual a 1 si el match se rompió en el mes 1, en el 2 o en el 3 luego del 
 aumento. Es importante hacer esto y no simplemente comparar si la persona seguía
 ahí 3 meses después porque hay gente que se sale y luego regresa. Podríamos 
 tener una especificación alternativa haciendo lo otro. 
*/
forvalues j=1/6 {
gen e`j'=emp_`j'==0 
replace e`j'=. if emp_`j'==.
}


* Las líneas de abajo pueden parecer extrañas pues en un análisis de regresión
* clásico usariamos factor variables tipo i.variable o c.var##c.var. Pero si
* hacemos el RDD no lineal, el comando que lo hace no admite esto así que...
* nada, en caso nos interese hacer eso, se puede. 


* Esto codifica la variable de sector económico. 
encode letra, gen(sector)
* Crea dummies de sexo.
tab sexo, gen(sexb)
* Crea una variable de edad^2.
gen ages=age*age
* Crea dummies de provincia
tab provi, gen(province)
* Crea dummies de sector económico. 
tab sector, gen(secto)

* Guarda los datos. 
save "$out/Aumento_$anio", replace


cls
