// -------------------------------------------------------------------------- //
// Setting up environment: data path, etc.
// -------------------------------------------------------------------------- //

clear all

global project_dir "/wid-world"

// Directory of Dropbox-saved country data
global updates 		"/W2ID-Country-Updates"

global forbes_data 	"$updates/Forbes/2022"
global historical 	"$updates/Historical_series/2022_December"

// Directory of the data availability quality index
global quality_file "$updates/AvailableData-World/Transparency_index_2022_update.xlsx"


// Directory with the output
global output_dir "$project_dir/output"
cap mkdir "$output_dir"

// Directory of the DO files
global do_dir "$project_dir/stata-do"

// Directory of the ADO files
global ado_dir "$project_dir/stata-ado"
sysdir set PERSONAL "$ado_dir" // Add to the ADO path

// Location of R executable
global Rpath "/usr/bin/R"

// External data sources
global input_data_dir "$project_dir/data-input"

// Location of the codes dictionnary file
global codes_dictionary "$input_data_dir/Codes_Dictionnary_WID.xlsx"

global wtid_data         "$input_data_dir/wtid-data"
global un_data           "$input_data_dir/un-data"
global oecd_data         "$input_data_dir/oecd-data"
global wb_data           "$input_data_dir/wb-data"
global imf_data          "$input_data_dir/imf-data"
global gfd_data          "$input_data_dir/gfd-data"
global fw_data           "$input_data_dir/fw-data"
global std_data          "$input_data_dir/std-codes"
global maddison_data     "$input_data_dir/maddison-data"
global eastern_bloc_data "$input_data_dir/eastern-bloc-data"
global eurostat_data     "$input_data_dir/eurostat-data"
global argentina_data    "$input_data_dir/argentina-data"
global east_germany_data "$input_data_dir/east-germany-data"
global zucman_data       "$input_data_dir/missing-wealth"
global france_data       "$input_data_dir/france-data"
global us_data           "$input_data_dir/us-data"
global us_states_data    "$input_data_dir/us-states-data"
global china_pyz_data    "$input_data_dir/china-pyz-data"

// Files to helps matching countries & currencies between the different sources
global country_codes  "$input_data_dir/country-codes"
global currency_codes "$input_data_dir/currency-codes"

// Directory with intermediairy data files (not synced to GitHub)
global work_data "$project_dir/work-data"
cap mkdir "$work_data"



// Old version directory to compare with udpated database
// global olddate 21_May_2019_09_27_03
// global oldoutput_dir "$output_dir/$olddate"

// Store date and time in a global macro to timestamp the output
local c_date = c(current_date)
local c_time = c(current_time)
local c_time_date = "`c_date'"+"_" +"`c_time'"
local time_string = subinstr("`c_time_date'", ":", "_", .)
local time_string = subinstr("`time_string'", " ", "_", .)
global time "`time_string'"

// Store current and past years and to update WEO source and commands
global year 2022 
global pastyear 2021 // this year matches commands in gdp-vs-nni,
					 // import-exchange-rates, aggregate-regions, impute-cfc,
					 // and other do-files
global pastpastyear 2020 
global pastpastpastyear 2019 // only for WPP, needs to be changed every 2 years 
						 // (changes made April 2021)

// Global years for updating Forbes data
global forbes_year 2021
global forbes_upd_year 2022						 
						 
// Global macros to switch on/off some parts of the code (1=on, 0=off)
global plot_missing_nfi    0
global plot_nfi_countries  0
global plot_imputation_cfc 0
global export_with_labels  0

// World summary table in market exchange rate (1) or PPP (0)
global world_summary_market 1

// List of core countries
global corecountries `" "AD"	"AE"	"AF"	"AG"	"AI"	"AL"	"AM"	"AO"	"AR"	"AT"	"AU"	"AW"	"AZ"	"BA"	"BB"	"BD"	"BE"	"BF"	"BG"	"BH"	"BI"	"BJ"	"BM"	"BN"	"BO"	"BR"	"BS"	"BT"	"BQ"	"BW"	"BY"	"BZ"	"CA"	"CD"	"CF"	"CG"	"CH"	"CI"	"CL"	"CM"	"CN"	"CO"	"CR"	"CU"	"CV"	"CW"	"CY"	"CZ"	"DE"	"DJ"	"DK"	"DM"	"DO"	"DZ"	"EC"	"EE"	"EG"	"ER"	"ES"	"ET"	"FI"	"FJ"	"FM"	"FR"	"GA"	"GB"	"GD"	"GE"	"GG"	"GH"	"GI"	"GL"	"GM"	"GN"	"GQ"	"GR"	"GT"	"GW"	"GY"	"HK"	"HN"	"HR"	"HT"	"HU"	"ID"	"IE"	"IL"	"IM"	"IN"	"IQ"	"IR"	"IS"	"IT"	"JE"	"JM"	"JO"	"JP"	"KE"	"KG"	"KH"	"KI"	"KM"	"KN"	"KP"	"KR"	"KS"	"KW"	"KY"	"KZ"	"LA"	"LB"	"LC"	"LI"	"LK"	"LR"	"LS"	"LT"	"LU"	"LV"	"LY"	"MA"	"MC"	"MD"	"ME"	"MG"	"MH"	"MK"	"ML"	"MM"	"MN"	"MO"	"MR"	"MS"	"MT"	"MU"	"MV"	"MW"	"MX"	"MY"	"MZ"	"NA"	"NC"	"NE"	"NG"	"NI"	"NL"	"NO"	"NP"	"NR"	"NZ"	"OM"	"PA"	"PE"	"PF"	"PG"	"PH"	"PK"	"PL"	"PR"	"PS"	"PT"	"PW"	"PY"	"QA"	"RO"	"RS"	"RU"	"RW"	"SA"	"SB"	"SC"	"SD"	"SE"	"SG"	"SI"	"SK"	"SL"	"SM"	"SN"	"SO"	"SR"	"SS"	"ST"	"SV"	"SX"	"SY"	"SZ"	"TC"	"TD"	"TG"	"TH"	"TJ"	"TL"	"TM"	"TN"	"TO"	"TR"	"TT"	"TV""'
global corecountries  `" $corecountries "TW"	"TZ"	"UA"	"UG"	"US"	"UY" 	"UZ"	"VC"	"VE"	"VG"	"VN"	"VU"	"WS"	"YE"	"ZA"	"ZM"	"ZW""'
dis $corecountries



// -------------------------------------------------------------------------- //
// Graphical theme
// -------------------------------------------------------------------------- //

// set scheme s2color
// grstyle init
// grstyle color background white
// grstyle anglestyle vertical_tick horizontal
// grstyle yesno draw_major_hgrid yes
// grstyle yesno grid_draw_min yes
// grstyle yesno grid_draw_max yes
// grstyle color grid                   gs13
// grstyle color major_grid             gs13
// grstyle color minor_grid             gs13
// grstyle linewidth major_grid thin
//
// grstyle linewidth foreground   vvthin
// grstyle linewidth background   vvthin
// grstyle linewidth grid         vvthin
// grstyle linewidth major_grid   vvthin
// grstyle linewidth minor_grid   vvthin
// grstyle linewidth tick         vvthin
// grstyle linewidth minortick    vvthin
//
// grstyle yesno extend_grid_low        yes
// grstyle yesno extend_grid_high       yes
// grstyle yesno extend_minorgrid_low   yes
// grstyle yesno extend_minorgrid_high  yes
// grstyle yesno extend_majorgrid_low   yes
// grstyle yesno extend_majorgrid_high  yes
//
// grstyle clockdir legend_position     6
// grstyle gsize legend_key_xsize       8
// grstyle color legend_line            background
// grstyle yesno legend_force_draw      yes
//
// grstyle margin axis_title          medsmall
