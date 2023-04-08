*===============================================================================
/*
En este do-file hice la limpieza de los datos para evaluar el efecto de los 
aumentos del salario mínimo (SM) en 2005 en Argentina. Este código solo sirve 
para ese aumento y tendríamos que modificarlo algo para incluir otros aumentos. 
Hay cosas para mejorar. 

Los datos son de la Muestra Longitudinal Empleo Registrado. 
Los descargas de aquí: https://www.trabajo.gob.ar/estadisticas/oede/mler.asp

Cada observación es un match empleador-empleado.
*/
*===============================================================================

* Aquí definí algunas macros:
global in /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico/In
global out /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico/Out
global dofiles /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico/Dofiles

use "$in/Muestra Longitudinal Empleo Registrado.dta", clear

* Los datos tienen muchísimas variables y ocupa mucha RAM usar todo al mismo tiempo
* por eso hice un keep.

* Las variables como rt200504 son la remuneración percibida en un mes en particular
* el formato es rtAñoMes. 
* El resto de nombres es bastante intiutivo, excepto letra que es el sector 
* económico.  

keep rt200504 rt200505 rt200506 rt200507 rt200508 rt200509 rt200510 rt200511 rt200512 ///
rt200601 rt200602 rt200603 rt200604 rt200605 rt200606 provi fnac_anu sexo pondera letra

* Cree una variable para la edad en 2005. 
gen age05=2005-fnac_anu

* Eliminé a la gente con missing en los controles. De cualquier modo, en las
* regresiones pasaría esto, así que mejor trabajar todo con las mismas obs. 
drop if sexo==0
drop if age05==. | provi==. | letra=="" 

* Eliminé a las observaciones con ingresos missing (empleos inactivos) o 
* con ingresos menores al SM el mes anterior al aumento. 
* 	SUPUESTO 1: los puestos de trabajo con ingresos menores al SM son part-time. 

*	Nota 1:  Las remuneraciones con valor igual a 0 en general corresponden a 
*			 trabajadores que están con licencia.
drop if rt200504<450 | rt200504==.

* Variable para el ingreso centrado en el nuevo SM.
gen z:"Centered wage"=rt200504-630
* Variable de tratamiento: SM antiguo <= Salario antes del aumento < SM nuevo.
gen treated=(rt200504>=450 & rt200504<630)

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
replace emp_1=0 if rt200505==0 |rt200505==.

replace emp_2=0 if rt200505==0 |rt200505==.
replace emp_2=0 if rt200506==0 |rt200506==.

replace emp_3=0 if rt200505==0 |rt200505==.
replace emp_3=0 if rt200506==0 |rt200506==.
replace emp_3=0 if rt200507==0 |rt200507==.

replace emp_4=0 if rt200505==0 |rt200505==.
replace emp_4=0 if rt200506==0 |rt200506==.
replace emp_4=0 if rt200507==0 |rt200507==.
replace emp_4=0 if rt200508==0 |rt200508==.

replace emp_5=0 if rt200505==0 |rt200505==.
replace emp_5=0 if rt200506==0 |rt200506==.
replace emp_5=0 if rt200507==0 |rt200507==.
replace emp_5=0 if rt200508==0 |rt200508==.
replace emp_5=0 if rt200509==0 |rt200509==.


foreach x in 05 06 07 08 09 10 {
replace emp_6=0 if rt2005`x'==0 |rt2005`x'==.
}

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
gen ages=age05*age05
* Crea dummies de provincia
tab provi, gen(province)
* Crea dummies de sector económico. 
tab sector, gen(secto)

* Guarda los datos. 
save "$out/MuestraGratis", replace


cls
