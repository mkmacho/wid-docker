// Calculate Top10/Bottom50 ratio for all available income concepts

use "$work_data/World-and-regional-aggregates-output.dta", clear
keep if substr(widcode, 1, 1) == "a"
keep if (p == "p90p100" | p == "p0p50")

// Split widcode
generate onelet  = substr(widcode, 1, 1)
generate vartype = substr(widcode, 2, .)

greshape wide value, i(iso year widcode currency onelet vartype) j(p) string
generate value = valuep90p100/valuep0p50

drop if missing(value)
drop valuep90p100 valuep0p50
replace widcode = "r" + vartype
drop onelet vartype
generate p = "p0p100"

tempfile ratio
save `ratio'

// save
use "$work_data/World-and-regional-aggregates-output.dta", clear
append using "`ratio'"

compress
label data "Generated by calculate-top10bot50-ratio.do"
save "$work_data/calculate-top10bot50-ratio.dta", replace
