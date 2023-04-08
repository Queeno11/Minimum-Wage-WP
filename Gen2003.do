*===============================================================================
/*
Intento de generalizar la limpieza de datos.
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

* Esto limpia los datos para los aumentos del SM de 2003. 
* Línea de base: junio de 2003.
*	SM antiguo (vigente en la línea de base): ARS 200
* Final del periodo. diciembre de 2003
*	SM final (fijado en diciembre 2003): ARS 300 
* Resolución: Dec. 388/2003 Art. 3.º

* Parametros necesarios: 
global wt0 rt200306				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt200307				// Variable de Salario Nominal 1 mes después
global wt2 rt200308				// Variable de Salario Nominal 2 meses después
global wt3 rt200309				// Variable de Salario Nominal 3 meses después
global wt4 rt200310				// Variable de Salario Nominal 4 meses después
global wt5 rt200311				// Variable de Salario Nominal 5 meses después
global wt6 rt200312				// Variable de Salario Nominal 6 meses después
global SMpre 200				// Salario mínimo vigente antes del aumento
global SMpost 300				// Salario mínimo vigente al final del (de los) aumento(s)
global anio 2003				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

* Los datos tienen muchísimas variables y ocupa mucha RAM usar todo al mismo tiempo
* por eso hice un keep.

* Las variables como rt200504 son la remuneración percibida en un mes en particular
* el formato es rtAñoMes. 
* El resto de nombres es bastante intiutivo, excepto letra que es el sector 
* económico.  

keep $wt0 $wt1 $wt2 $wt3 $wt4 $wt5 $wt6 provi fnac_anu sexo pondera letra ide_trabajador

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

replace emp_5=0 if emp_4
replace emp_5=0 if $wt5==0 |$wt5==.

replace emp_6=0 if emp_5
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
