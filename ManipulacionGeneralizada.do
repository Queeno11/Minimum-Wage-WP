use "$out/Aumento_2003", clear
append using "$out/Aumento_Enero2004"
append using "$out/Aumento_2004"
append using "$out/Aumento_2005"
append using "$out/Aumento_2006"
append using "$out/Aumento_2007"
append using "$out/Aumento_2008"
append using "$out/Aumento_2011"



rddensity z, plot  plot_range(-460 460) graph_opt(graphregion(color(white)) ///
xlabel(-460(115)460, labsize(small) angle(45)) xtitle("Running Variable: Centered Baseline Wages") ytitle("Density") legend(off))  ///
hist_range(-460 460) q(2) 

graph export "$out/ManipulacionTotal.png", replace
