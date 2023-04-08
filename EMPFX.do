* Efectos en Empleo:
cls
use "$out/MLER(ActiveMatches)2", clear
encode letra, gen(sector)

gen rdz=-z
tab sexo, gen(sexb)
gen ages=age05*age05
tab provi, gen(province)
tab sector, gen(secto)


* C&F es casi idéntico a C&F con controles
*preserve
* 1 mes:
* Currie & Fallick Rdd:
reg e1 treated z c.z#i.treated i.sexo c.age05##c.age05 i.provi i.sector,robust
estimates store RDDE1
* Jimenez:
reg e1 treated z c.z#i.treated i.sexo c.age05##c.age05 i.provi i.sector if z>=-180 & z<=180,robust
estimates store Jimenez1

* 6 meses:
* Currie & Fallick Rdd:
reg e6 treated z c.z#i.treated i.sexo c.age05##c.age05 i.provi i.sector, robust
estimates store RDDE6
* Jimenez:
reg e6 treated z c.z#i.treated i.sexo c.age05##c.age05 i.provi i.sector if z>=-180 & z<=180,robust
estimates store Jimenez6


* 12 meses:
* Currie & Fallick Rdd:
reg e12 treated z c.z#i.treated i.sexo c.age05##c.age05 i.provi i.sector,robust
estimates store RDDE12
* Jimenez:
reg e12 treated z c.z#i.treated i.sexo c.age05##c.age05 i.provi i.sector if z>=-180 & z<=180,robust
estimates store Jimenez12

estout RDDE1 Jimenez1 RDDE6 Jimenez6 RDDE12 Jimenez12 using ///
"$out/Table1.csv", cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) stats(N) starlevels(* 0.10 ** 0.05 *** 0.01) keep(treated) replace


preserve
clear all 

import delimited using "$out/Table1.csv", clear
set obs 100 

forvalues j=2/7 {
replace v`j'="" in 2
}

replace v2="Unlimited" in 1
replace v3="Simmetrical" in 1

replace v1="One Month" in 2

foreach x in 3 7 11 {
replace v1="Treatment Effect" in `x'
local ++x
replace v1="" in `x'
local ++x
replace v1="Obs." in `x'

}

replace v1="Six Months" in 6
replace v1="Twelve Months" in 10

foreach x in 2 3{
local linea=7
local y=`x'+2
local z=`x'+4

foreach linea in 7 8 9 {
replace v`x'=v`y'[_n-4] in `linea'
}

foreach linea in 11 12 13 {
replace v`x'=v`z'[_n-8] in `linea'
}
}

keep v1 v2 v3
gen id=_n

save "$out/Table1", replace 
restore 

preserve 

gen robust=""
* Robustez:
rdrobust e1 rdz,  covs(sexb1 age05 ages province1-province24 secto2-secto14)
replace robust="Optimal" in 1
matrix P=e(b)
matrix Nl= e(N_h_l) 
matrix Nr= e(N_h_r) 
scalar nobs= Nl[1,1]+Nr[1,1]
matrix ES=e(V)
scalar point=round(P[1,1],.001)
scalar est=round(sqrt(ES[1,1]),.001)
replace robust=string(point) in 3
replace robust=string(est) in 4
replace robust=string(nobs) in 5

rdrobust e6 rdz,  covs(sexb1 age05 ages province1-province24 secto2-secto14)
matrix P=e(b)
matrix Nl= e(N_h_l) 
matrix Nr= e(N_h_r) 
scalar nobs= Nl[1,1]+Nr[1,1]
matrix ES=e(V)
scalar point=round(P[1,1],.001)
scalar est=round(sqrt(ES[1,1]),.001)
replace robust=string(point) in 7
replace robust=string(est) in 8
replace robust=string(nobs) in 9

rdrobust e12 rdz,  covs(sexb1 age05 ages province1-province24 secto2-secto14)
matrix P=e(b)
matrix Nl= e(N_h_l) 
matrix Nr= e(N_h_r) 
scalar nobs= Nl[1,1]+Nr[1,1]
matrix ES=e(V)
scalar point=round(P[1,1],.001)
scalar est=round(sqrt(ES[1,1]),.001)
replace robust=string(point) in 11
replace robust=string(est) in 12
replace robust=string(nobs) in 13


gen id=_n
gen v1="One Month" in 2
foreach x in 3 7 11 {
replace v1="Treatment Effect" in `x'
local ++x
replace v1="" in `x'
local ++x
replace v1="Obs." in `x'

}
replace v1="Six Months" in 6
replace v1="Twelve Months" in 10

keep id robust 
merge 1:1 id using "$out/Table1"

drop id 
order v1 v2 v3 robust

forvalues q=2/3{
replace v`q'=substr(v`q',1, strpos(v`q', ".") - 1) in 5
replace v`q'=substr(v`q',1, strpos(v`q', ".") - 1) in 9
replace v`q'=substr(v`q',1, strpos(v`q', ".") - 1) in 13

}

save "$out/Table1", replace 
restore
