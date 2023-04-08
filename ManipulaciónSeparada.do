foreach anio in 2003 Enero2004 2004 2005 2006 2007 2008 {
use "$out/Aumento_`anio'", clear
* No incluye efecto fijo de persona ni de año:

sum hpos
local h=r(mean)
scalar mh=-`h'

rddensity z, plot  plot_range(-`h' `h') graph_opt(graphregion(color(white)) ///
 xlabel(-`h'(20)`h', labsize(small) angle(45)) xtitle("Running Variable: Centered Baseline Wages") ytitle("Density") legend(off))  ///
hist_range(-`h' `h')  genvars(temp) q(2) 
  // Nuevo
graph export "$out/Manipulacion`anio'.png", replace


}

use "$out/Aumento_2011", clear
sum hpos
local h=r(mean)
scalar mh=-`h'

rddensity z, plot  plot_range(-`h' `h') graph_opt(graphregion(color(white)) ///
 xlabel(-`h'(115)`h', labsize(small) angle(45)) xtitle("Running Variable: Centered Baseline Wages") ytitle("Density") legend(off))  ///
hist_range(-`h' `h')  genvars(temp) q(2)
graph export "$out/Manipulacion2011.png", replace
