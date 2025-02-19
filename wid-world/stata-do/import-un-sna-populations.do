import delimited "$un_data/populations/sna/unsd_snaAma-$pastyear.csv", ///
	clear delimiter(",") encoding("utf8")
cap rename countryarea countryorarea
cap drop unit

// Identify countries ------------------------------------------------------- //

// Drop regions
replace countryorarea = "Côte d'Ivoire"    if (countryorarea=="C�te d'Ivoire")
replace countryorarea = "Curaçao"          if (countryorarea=="Cura�ao")
replace countryorarea = "Swaziland"      if (countryorarea == "Kingdom of Eswatini")
replace countryorarea = "Czech Republic" if (countryorarea == "Czechia")
replace countryorarea = "China, People's Republic of" if (countryorarea == "China (mainland)")

countrycode countryorarea, generate(iso) from("un sna main")
drop countryorarea

// Deal with former economies
drop if (iso == "SD-FORMER") & (year >= 2008)
drop if (iso == "SD") & (year < 2008)
replace iso = "SD" if iso == "SD-FORMER"

drop if (iso == "ET-FORMER") & (year >= 1993)
drop if (iso == "ET") & (year < 1993)
replace iso = "ET" if (iso == "ET-FORMER")
drop if (iso == "ER") & (year < 1993)

generate sex = "both"
generate age = "all"

rename population value

drop if value == "..."
destring value, replace

label data "Generated by import-un-sna-populations.do"
save "$work_data/un-sna-population.dta", replace
