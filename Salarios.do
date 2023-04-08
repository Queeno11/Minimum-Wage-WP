 use "/Users/user1/Desktop/UNLP/Distribución/Monografía/VersionconNico/In/Muestra Longitudinal Empleo Registrado.dta", clear
 
 drop r32-rt200212  drop rt2013* rt2014* rt2015* 
 
 collapse (rawsum) rt2003@ rt2004@ rt2005@ rt2006@ rt2007@ rt2008@ rt2009@ /// 
 rt2010@ rt2011@ rt2012@ (firstnm) , by (ide_trabajador)
 
 reshape long rt2003@ rt2004@ rt2005@ rt2006@ rt2007@ rt2008@ rt2009@ /// 
 rt2010@ rt2011@ rt2012@, i(ide_trabajador) j(mes) 


