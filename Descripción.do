* Descriptivos: 

use "$out/Aumento_2003", clear
append using "$out/Aumento_Enero2004"
append using "$out/Aumento_2004"
append using "$out/Aumento_2005"
append using "$out/Aumento_2006"
append using "$out/Aumento_2007"
append using "$out/Aumento_2008"
append using "$out/Aumento_2011"

gen empmasde50=(tam_emp==1 | tam_emp==2)
replace empmasde50=. if tam_emp==.

gen primario=(secto1==1|secto2==1|secto3==1)
replace primario=. if letra==""

gen GBA=(province1==1|province2==1|province3==1)
replace GBA=. if provi==.

preserve
replace sexo=sexo-1 // % de Hombres
gen uno=1

collapse sexo fnac_anu empmasde50 primario GBA e1 e3 e6 treated (rawsum) uno

gen Marcador=. 
gen Marcador2=.

order sexo fnac_anu empmasde50 primario GBA Marcador e1 e3 e6 Marcador2 treated uno 

foreach v in sexo empmasde50 primario GBA e1 e3 e6 treated {
replace `v'=`v'*100 
}
xpose, clear
gen v0="Hombres (%)" in 1
replace v0="Año de Nacimiento" in 2
replace v0="Empresa Grande" in 3
replace v0="Sector Primario" in 4
replace v0="GBA" in 5

replace v0="Empleos destruidos (%)" in 6
replace v0="1 meses" in 7
replace v0="3 meses" in 8
replace v0="6 meses" in 9
replace v0="Tratados (%)" in 11
replace v0="Obs." in 12
order v0 v1

tostring v1, force format(%20.2f) replace
rename v1 todos
gen id=_n
save "$out/Tabla1a", replace
restore

preserve
replace sexo=sexo-1 // % de Hombres
gen uno=1

collapse sexo fnac_anu empmasde50 primario GBA  e1 e3 e6 (rawsum) uno, by(treated)

gen Marcador=. 
gen Marcador2=.

order sexo fnac_anu empmasde50 primario GBA  Marcador e1 e3 e6 Marcador2 treated uno 

foreach v in sexo empmasde50 primario GBA e1 e3 e6 {
replace `v'=`v'*100 
}
xpose, clear
rename (v1 v2) (untreated treated)
gen v0="Hombres (%)" in 1
replace v0="Año de Nacimiento" in 2
replace v0="Empresa Grande" in 3
replace v0="Sector Primario" in 4
replace v0="GBA" in 5

replace v0="Empleos destruidos (%)" in 6
replace v0="1 meses" in 7
replace v0="3 meses" in 8
replace v0="6 meses" in 9
replace v0="Tratados (%)" in 11
replace v0="Obs." in 12
order v0 treated untreated


tostring treated untreated, force format(%20.2f) replace
gen id=_n

save "$out/Tabla1b", replace
restore

preserve
replace sexo=sexo-1 // % de Hombres
gen uno=1

keep if treated==0 & z<=0.25*hpos
collapse sexo fnac_anu empmasde50 primario GBA e1 e3 e6 treated (rawsum) uno

gen Marcador=. 
gen Marcador2=.

order sexo fnac_anu empmasde50 primario GBA Marcador e1 e3 e6 Marcador2 treated uno 

foreach v in sexo empmasde50 primario GBA e1 e3 e6 treated {
replace `v'=`v'*100 
}
xpose, clear
gen v0="Hombres (%)" in 1
replace v0="Año de Nacimiento" in 2
replace v0="Empresa Grande" in 3
replace v0="Sector Primario" in 4
replace v0="GBA" in 5

replace v0="Empleos destruidos (%)" in 6
replace v0="1 meses" in 7
replace v0="3 meses" in 8
replace v0="6 meses" in 9
replace v0="Tratados (%)" in 11
replace v0="Obs." in 12
order v0 v1

tostring v1, force format(%20.2f) replace
rename v1 bdwidthtreated
gen id=_n

save "$out/Tabla1c", replace
restore

preserve
use "$out/Tabla1a", clear
merge 1:1 id using "$out/Tabla1b", nogen
merge 1:1 id using "$out/Tabla1c", nogen

drop id

order v0 todos treated bd* untreated
save "$out/Tabla1", replace

erase "$out/Tabla1a.dta"
erase "$out/Tabla1b.dta"
erase "$out/Tabla1c.dta"

restore
