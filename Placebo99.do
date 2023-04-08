* Aquí creo un programa pequeño para la extracción. 
capture program drop extraccion

program define extraccion
matrix define B=e(tau_cl)  
scalar beta=B[1,1]

matrix define SE=e(se_tau_cl)
scalar se=SE[1,1]

matrix define H=e(h_l)  
scalar bh=H[1,1]

matrix define PV=e(pv_cl)
scalar pvalor=PV[1,1]

matrix define Nleft=e(N_h_l)
matrix define Nright=e(N_h_r)

scalar Num=Nleft[1,1]+Nright[1,1]



end

use "$out/Aumento_1999", clear

* Acá guardamos el estilo Currie & Fallick:
cap drop pointestCF
gen pointestCF=. 
cap drop stderrCF
gen stderrCF=. 
cap drop pvalCF
gen pvalCF=. 
cap drop NobsCF
gen NobsCF=. 

* Acá el estilo Abbate y Jiménez:

cap drop pointestAJ
gen pointestAJ=. 
cap drop stderrAJ
gen stderrAJ=. 
cap drop pvalAJ
gen pvalAJ=. 
cap drop NobsAJ
gen NobsAJ=. 
cap drop powerAJ
gen powerAJ=.

cls 
forvalues j=1/6 {
reg e`j' c.z##i.treated

matrix define RES=r(table)  
scalar beta=RES[1,3]
scalar se=RES[2,3]
scalar pvalor=RES[4,3]
matrix define N=e(N)
scalar Num=N[1,1]




replace pointestCF=beta in `j' 
replace stderrCF=se in `j'
replace pvalCF=pvalor in `j'
replace NobsCF=Num in `j'


rdrobust e`j' z, p(1) kernel(uni) h(`h1')  
extraccion
local h=bh

* El cambio de signo es porque el paquete asume que los de la derecha son los tratados. En nuestro caso es al revés.
replace pointestAJ=-beta in `j' 
replace stderrAJ=se in `j'
replace pvalAJ=pvalor in `j'
replace NobsAJ=Num in `j'

rdpow e`j' z, tau(0.09) h(`h')
scalar powpowpow=r(power_rbc)
replace powerAJ=powpowpow in `j' 


}

* Power is the probability that a test of significance will pick up on an effect that is present

/*
Ex-post (or observational) RD analysis. The researcher already has the final
data for analysis, and the goal is to assess the statistical power underlying the
testing procedures implemented in rdrobust. Specifically, rdpow will estimate the
statistical power of the robust bias-corrected inference methods implemented using
rdrobust for a given hypothesized RD treatment effect (denoted τA below). In this
case, the sample size is fixed, and the goal is to understand the statistical power
that different inference procedures have. For example, the researcher can compare
the statistical power between using local linear and local quadratic methods.
*/


keep pointestCF-powerAJ
drop if pointestCF==.
tostring pointestCF stderrCF pointestAJ stderrAJ powerAJ, replace format(%12.3f) force
 tostring NobsCF NobsAJ, replace format(%12.0fc) force
 
foreach x in stderrCF stderrAJ {
replace `x'="("+`x'+")"
}


foreach v in CF AJ {
replace pointest`v'=pointest`v'+"*" if pval`v'>=0.05 & pval`v'<0.1
replace pointest`v'=pointest`v'+"**" if pval`v'>=0.01 & pval`v'<0.05
replace pointest`v'=pointest`v'+"***" if pval`v'<0.01
drop pval`v'
}

sxpose, clear

gen desc=""
order desc _v*

replace desc="ET: OLS à la CF (1996)" in 1 
replace desc="" in 2 
replace desc="N.Obs" in 3 
replace desc="ET: DRD" in 4 
replace desc="" in 5 
replace desc="N.Obs" in 6 
replace desc="Poder(0.09)" in 7 

export excel "$out/PlaceboCFvsAJ99", sheetmodify 

