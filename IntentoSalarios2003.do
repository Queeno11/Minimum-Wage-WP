use "$in/Muestra Longitudinal Empleo Registrado.dta", clear


keep rt2003* provi fnac_anu sexo pondera letra ///
tr_0403 ide_trabajador relacion

 sort ide_trabajador
 
/*
 Estas líneas crean una variable de ingresos. Sirven para identificar al trabajo
 "principal" (el de mayores ingresos) cuando un individuo resgistró más de un 
 trabajo al mismo tiempo. Por ejemplo, la persona 10008740 en agosto de 2003.
 El resultado es la secuencia de variables wAño_Mes que captura los ingresos
 en la ocupación principal. 
*/
 foreach m in 01 02 03 04 05 06 07 08 09 10 11 12 {
 bys ide_trabajador: egen w2003`m'=max(rt2003`m')
 }

/* 
 Ahora, debemos crear variables para el sector económico (letra), la provincia
 (provi) donde se realizó la ocupación principal y el código de relación. 
 El sexo y el año de nacimiento son time-invariant así que no les hice nada. 
*/

* ide_trabajador==10008740

 foreach m in 01 02 03 04 05 06 07 08 09 10 11 12 {
 * Sector Económico
 gen letra`m'= letra if w2003`m'==float(rt2003`m')
 replace  letra`m'="" if rt2003`m'==.
 * Provincia
 gen provi`m'= provi if w2003`m'==float(rt2003`m')
 replace  provi`m'=. if rt2003`m'==.
 * Código de Relación
  gen relacion`m'= relacion if w2003`m'==float(rt2003`m')
 replace  relacion`m'=. if rt2003`m'==.
 }


 collapse (max) sexo fnac_anu w200301-w200312 provi* relacion* ///
 (first) letra* , by(ide_trabajador) 
 
 * PENDIENTES (en cualquier orden): 

 * 1) reshape, hacer lo mismo con el resto de años y append. 
 
 * 2) hacer algo con las obs con ingresos poco creibles (<100 pesos por ejemplo).
 
 * 3) poner value labels a las variables. 
 
 * 4) ¿qué hacemos con los missings? a 0? O nos preocupamos por la distribución 
 * de ingresos laborales.
 
 * 5) hacer el merge con la serie de salarios mínimos. 
 
 * 6) poner los montos en términos reales de alguna forma...
