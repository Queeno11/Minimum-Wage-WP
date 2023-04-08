* Aquí definí algunas macros:
global in /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico/In
global out /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico/Out
global dofiles /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico

********************************************************************************
* Esto limpia los datos para los aumentos del SM de julio de 2003. 
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

run "$dofiles/Generalizada.do"
********************************************************************************
* Esto limpia los datos para los aumentos del SM de ENERO de 2004. 
* Línea de base: diciembre de 2003.
*	SM antiguo (vigente en la línea de base): ARS 300
* Final del periodo. julio de 2004
*	SM final (fijado en enero de 2004): ARS 350 
* Resolución: Dec. 1349/04

* Parametros necesarios: 
global wt0 rt200312				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt200401				// Variable de Salario Nominal 1 mes después
global wt2 rt200402				// Variable de Salario Nominal 2 meses después
global wt3 rt200403				// Variable de Salario Nominal 3 meses después
global wt4 rt200404				// Variable de Salario Nominal 4 meses después
global wt5 rt200405				// Variable de Salario Nominal 5 meses después
global wt6 rt200406				// Variable de Salario Nominal 6 meses después
global SMpre 300				// Salario mínimo vigente antes del aumento
global SMpost 350				// Salario mínimo vigente al final del (de los) aumento(s)
global anio 2004				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

run "$dofiles/Generalizada.do"

* Esto es un pequeño parche, necesario pues hay otro aumento luego en 2004:
save "$out/Aumento_Enero$anio", replace
********************************************************************************
* Esto limpia los datos para los aumentos del SM de Septiembre de 2004. 
* Línea de base: Agosto de 2004.
*	SM antiguo (vigente en la línea de base): ARS 350
* Final del periodo. febrero de 2005
*	SM final (fijado en agosto de 2004): ARS 450 
* Resolución: Res. 2/04 CNEPySMVyM

* Parametros necesarios: 
global wt0 rt200408				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt200409				// Variable de Salario Nominal 1 mes después
global wt2 rt200410				// Variable de Salario Nominal 2 meses después
global wt3 rt200411				// Variable de Salario Nominal 3 meses después
global wt4 rt200412				// Variable de Salario Nominal 4 meses después
global wt5 rt200501				// Variable de Salario Nominal 5 meses después
global wt6 rt200502				// Variable de Salario Nominal 6 meses después
global SMpre 350				// Salario mínimo vigente antes del aumento
global SMpost 450				// Salario mínimo vigente al final del (de los) aumento(s)
global anio 2004				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

run "$dofiles/Generalizada.do"

********************************************************************************
* Esto limpia los datos para los aumentos del SM de Mayo de 2005. 
* Línea de base: Abril de 2005.
*	SM antiguo (vigente en la línea de base): ARS 450
* Final del periodo. febrero de 2005
*	SM final (fijado en julio de 2005): ARS 630 
* Resolución: Res. 2/05 CNEPySMVyM

* Parametros necesarios: 
global wt0 rt200504				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt200505				// Variable de Salario Nominal 1 mes después
global wt2 rt200506				// Variable de Salario Nominal 2 meses después
global wt3 rt200507				// Variable de Salario Nominal 3 meses después
global wt4 rt200508				// Variable de Salario Nominal 4 meses después
global wt5 rt200509				// Variable de Salario Nominal 5 meses después
global wt6 rt200510				// Variable de Salario Nominal 6 meses después
global SMpre 450				// Salario mínimo vigente antes del aumento
global SMpost 630				// Salario mínimo vigente al final del (de los) aumento(s)
global anio 2005				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

run "$dofiles/Generalizada.do"

********************************************************************************
* Esto limpia los datos para los aumentos del SM de agosto de 2006. 
* Línea de base: julio de 2006.
*	SM antiguo (vigente en la línea de base): ARS 630
* Final del periodo. enero de 2007
*	SM final (fijado en diciembre de 2007): ARS 800 
* Resolución: Res. Res. 2/06 CNEPySMVyM

* Parametros necesarios: 
global wt0 rt200607				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt200608				// Variable de Salario Nominal 1 mes después
global wt2 rt200609				// Variable de Salario Nominal 2 meses después
global wt3 rt200610				// Variable de Salario Nominal 3 meses después
global wt4 rt200611				// Variable de Salario Nominal 4 meses después
global wt5 rt200612				// Variable de Salario Nominal 5 meses después
global wt6 rt200701				// Variable de Salario Nominal 6 meses después
global SMpre 630				// Salario mínimo vigente antes del aumento
global SMpost 800				// Salario mínimo vigente al final del (de los) aumento(s)
global anio 2006				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

run "$dofiles/Generalizada.do"
********************************************************************************
* Esto limpia los datos para los aumentos del SM de agosto de 2007. 
* Línea de base: julio de 2007.
*	SM antiguo (vigente en la línea de base): ARS 800
* Final del periodo. enero de 2008
*	SM final (fijado en diciembre de 2007): ARS 980 
* Resolución: Res. 2/07 CNEPySMVyM

* Parametros necesarios: 
global wt0 rt200707				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt200708				// Variable de Salario Nominal 1 mes después
global wt2 rt200709				// Variable de Salario Nominal 2 meses después
global wt3 rt200710				// Variable de Salario Nominal 3 meses después
global wt4 rt200711				// Variable de Salario Nominal 4 meses después
global wt5 rt200712				// Variable de Salario Nominal 5 meses después
global wt6 rt200801				// Variable de Salario Nominal 6 meses después
global SMpre 800				// Salario mínimo vigente antes del aumento
global SMpost 980				// Salario mínimo vigente al final del (de los) aumento(s)
global anio 2007				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

run "$dofiles/Generalizada.do"

********************************************************************************
* Esto limpia los datos para los aumentos del SM de agosto de 2008. 
* Línea de base: julio de 2008.
*	SM antiguo (vigente en la línea de base): ARS 980
* Final del periodo. enero de 2009
*	SM final (fijado en diciembre de 2008): ARS 1240
* Resolución: Res. 3/08 CNEPySMVyM

* Parametros necesarios: 
global wt0 rt200807				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt200808				// Variable de Salario Nominal 1 mes después
global wt2 rt200809				// Variable de Salario Nominal 2 meses después
global wt3 rt200810				// Variable de Salario Nominal 3 meses después
global wt4 rt200811				// Variable de Salario Nominal 4 meses después
global wt5 rt200812				// Variable de Salario Nominal 5 meses después
global wt6 rt200901				// Variable de Salario Nominal 6 meses después
global SMpre 980				// Salario mínimo vigente antes del aumento
global SMpost 1240				// Salario mínimo vigente al final del (de los) aumento(s)
global anio 2008				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

run "$dofiles/Generalizada.do"

********************************************************************************
* Esto limpia los datos para los aumentos del SM de septiembre de 2011. 
* Línea de base: agosto de 2011.
*	SM antiguo (vigente en la línea de base): ARS 1840
* Final del periodo. febrero de 2012
*	SM final (fijado en diciembre de 2011 creo): ARS 2300
* Resolución: Res. 2/11 CNEPySMVyM

* Parametros necesarios: 
global wt0 rt201108				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt201109				// Variable de Salario Nominal 1 mes después
global wt2 rt201110				// Variable de Salario Nominal 2 meses después
global wt3 rt201111				// Variable de Salario Nominal 3 meses después
global wt4 rt201112				// Variable de Salario Nominal 4 meses después
global wt5 rt201201				// Variable de Salario Nominal 5 meses después
global wt6 rt201202				// Variable de Salario Nominal 6 meses después
global SMpre 1840				// Salario mínimo vigente antes del aumento
global SMpost 2300				// Salario mínimo vigente al final del (de los) aumento(s)
global anio 2011				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

run "$dofiles/Generalizada.do"


