* Placebos:
* Aquí definí algunas macros:
global in /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico/In
global out /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico/Out
global dofiles /Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico

********************************************************************************
* Esto limpia los datos para un aumento ficticio en Agosto de 1996-2000. 
* Línea de base: julio de 1996-2000.
*	SM antiguo (vigente en la línea de base): ARS 200
* Final del periodo. enero de 1997-2001
*	SM final (falso): ARS 280 
* Resolución: ES UN PLACEBO

forvalues placebo=1996/2000 { 
* Parametros necesarios: 
global wt0 rt`placebo'07				// Variable de Salario Nominal en linea de base (t0)
global wt1 rt`placebo'08				// Variable de Salario Nominal 1 mes después
global wt2 rt`placebo'09				// Variable de Salario Nominal 2 meses después
global wt3 rt`placebo'10				// Variable de Salario Nominal 3 meses después
global wt4 rt`placebo'11				// Variable de Salario Nominal 4 meses después
global wt5 rt`placebo'12				// Variable de Salario Nominal 5 meses después
global wt6 rt`placebo'01				// Variable de Salario Nominal 6 meses después
global SMpre 200				// Salario mínimo vigente antes del aumento
global SMpost 300				// Salario mínimo vigente al final del (de los) aumento(s)
global anio `placebo'				// Año del aumento

* Diferencia entre ambos salarios, útil para ancho de banda preliminar.
scalar SMdist=$SMpost-$SMpre	

run "$dofiles/Generalizada.do"
}
