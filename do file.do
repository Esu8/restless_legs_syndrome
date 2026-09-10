********************************************************************************
* STATA CODE: Prepare Final Public Dataset - RLS Study
* Only variables significantly associated with RLS in multivariable analysis
* Sample Size: n=422
* Date: [Insert Date]
********************************************************************************

* Set working directory
cd "D:\1research related\1 RLS budget\RLS Data"

* Open the SPSS file
* If you have the SPSS file, use:
usespss using "Analysis begin_1.sav"

* OR if already converted to STATA:
* use "Analysis_begin_1.dta", clear

********************************************************************************
* Step 1: Keep ONLY the 5 significant variables + RLS outcome
********************************************************************************
# import spss Address Educational_status Marital_status Occupation GA Abortion Chronic_disease hemoglobin Anemia Weight Iron_tab No_tab_month Chat chat_for_30_days Alcohol_ever Alcohol_30days Type_Alcohol Caffeine type_caffeine SH_bed bed_room Work_before_bed SH_something_wake_me substance_before_bed stress_and_thinking_on_bed_before Use_bed_for_other_purpose Exercise_before_bed Wake_at_different_time Sleep_at_different_clock Wait_on_bed_more_than_usual Nap_for_2_hr move_to_bed_with_anger Sleep_position usual_timeforbed min_for_sleep usual_timeto_wake hour_slp_night hour_spend_bed difficulty_30_min Wake_in_the_middle_of_night have_you_wake_to_use_toilet Difficulty_of_breathing cough_snoring too_cold feel_too_hot bad_dream feel_pain other_problems have_you_took_medication difficulty_to_stay_awake_in_social_life Lose_of_interest Rate_your_sleep_quality NAP_in_the_day_time min_NAP component_2 Want_to_walk walk_to_aleviate_pain pain_increase_with_rest symptoms_increase_in_the_night Special_1_took_medication Special_2_too_sever_to_alivate Special_3_pain_got_too_sever_to_differentiate_day_and_night fulfill_RLS_symptoms RLS_scale_for_your_legpain how_much_do_you_need_to_walk_for_your_pain how_much_relief_you_got_from_walking RLS_symptoms_effect_onsleep sleepy_due_to_RLS generaly_your_RLS_severity how_frequant_RLS_symptoms for_how_many_hour_your_RLS_wait influence_on_your_daily_life how_sever_is_the_influence_on_ur_feeling how_would_you_rate_last_week_symptoms Can_see_bright_side_of_things Do_things_with_interest I_regret_for_thingsgot_wrong I_feel_stressed_with_noreason V102 things_are_getting_uncontrolled Difficult_to_sleep_bc_I_feel_sad I_felt_sad I_was_cring_bc_sad I_thought_to_hurt_myself VAR00001 have_you_advices_notto_exercise have_you_exercise_before_pregnancy Exercise_in_current_pregnancy walk Dance Cycling Breathing_exercise pelvic_exercise Extremity breathing Anemia_Y_N Gravida_cat age_cat Marrital_cat Comp1A Component_22 Component_2final Comp_33 Component_44 component_4final Component_5sum_b_j component_5final Component_7sum Component_7final PSQI_sum GQOS occup_cat para_cat GA2_cat depression_sum1234 Depression_YN Exercise

keep ///
    Residence          ///
    GA                 ///
    Abortion           ///
    Iron_tab           ///
    Alcohol_30days     ///
    RLS                 ///
    ID                  ///
    *[Add any other essential variables if needed]

********************************************************************************
* Step 2: Rename to Readable Format
********************************************************************************

* Primary Outcome
rename RLS rls_third_trimester  // 1=Yes, 0=No

* Significant Predictors (AOR from your analysis)
rename Residence residence
rename GA gestational_age_cat
rename Abortion abortion_history
rename Iron_tab iron_supplement
rename Alcohol_30days alcohol_during_pregnancy

********************************************************************************
* Step 3: Create/Verify Variable Labels
********************************************************************************

label variable rls_third_trimester "Restless Legs Syndrome in third trimester"
label variable residence "Residence (0=Rural, 1=Urban)"
label variable gestational_age_cat "Gestational age category"
label variable abortion_history "History of abortion (0=No, 1=Yes)"
label variable iron_supplement "Iron supplementation (0=No, 1=Yes)"
label variable alcohol_during_pregnancy "Alcohol consumption during pregnancy (0=No, 1=Yes)"

* Define value labels
label define residence_lbl 0 "Rural" 1 "Urban"
label values residence residence_lbl

label define ga_lbl 1 "28-34 weeks" 2 "34-37 weeks" 3 "≥37 weeks"
label values gestational_age_cat ga_lbl

label define yesno_lbl 0 "No" 1 "Yes"
label values abortion_history yesno_lbl
label values iron_supplement yesno_lbl
label values alcohol_during_pregnancy yesno_lbl
label values rls_third_trimester yesno_lbl

********************************************************************************
* Step 4: Generate Participant ID (Remove original identifiers)
********************************************************************************

* Create anonymous ID
gen participant_id = _n
order participant_id, first

* Drop any original identifying variables (if present)
capture drop ID VAR00001 VAR00002

********************************************************************************
* Step 5: Data Quality Check
********************************************************************************

* Check for missing values
misstable summarize

* Frequency of all variables
tabulate rls_third_trimester
tabulate residence
tabulate gestational_age_cat
tabulate abortion_history
tabulate iron_supplement
tabulate alcohol_during_pregnancy

* Cross-tabulations to verify your results
tabulate rls_third_trimester residence, chi2 row
tabulate rls_third_trimester gestational_age_cat, chi2 row
tabulate rls_third_trimester abortion_history, chi2 row
tabulate rls_third_trimester iron_supplement, chi2 row
tabulate rls_third_trimester alcohol_during_pregnancy, chi2 row

********************************************************************************
* Step 6: Create a Clean Dataset with Only Essential Variables
********************************************************************************

* Keep only the variables we need
keep participant_id residence gestational_age_cat ///
     abortion_history iron_supplement alcohol_during_pregnancy ///
     rls_third_trimester

********************************************************************************
* Step 7: Export to CSV
********************************************************************************

* Export the final dataset
export delimited using "RLS_Study_Public_Final.csv", replace

********************************************************************************
* Step 8: Generate Comprehensive Data Dictionary
********************************************************************************

* Create a data dictionary file
clear
set obs 7

gen variable = ""
replace variable = "participant_id" in 1
replace variable = "residence" in 2
replace variable = "gestational_age_cat" in 3
replace variable = "abortion_history" in 4
replace variable = "iron_supplement" in 5
replace variable = "alcohol_during_pregnancy" in 6
replace variable = "rls_third_trimester" in 7

gen label = ""
replace label = "Unique anonymous participant identifier" in 1
replace label = "Residence (0=Rural, 1=Urban)" in 2
replace label = "Gestational age category (1=28-34wks, 2=34-37wks, 3=37+wks)" in 3
replace label = "History of abortion (0=No, 1=Yes)" in 4
replace label = "Iron supplementation during pregnancy (0=No, 1=Yes)" in 5
replace label = "Alcohol consumption during pregnancy (0=No, 1=Yes)" in 6
replace label = "Restless Legs Syndrome in third trimester (0=No, 1=Yes)" in 7

gen type = ""
replace type = "Numeric (Integer)" in 1
replace type = "Binary (0/1)" in 2
replace type = "Categorical (1/2/3)" in 3
replace type = "Binary (0/1)" in 4
replace type = "Binary (0/1)" in 5
replace type = "Binary (0/1)" in 6
replace type = "Binary (0/1)" in 7

export delimited using "RLS_Study_Data_Dictionary.csv", replace

********************************************************************************
* Step 9: Create a README-compatible summary (for publication)
********************************************************************************

* Generate summary statistics table
tabstat rls_third_trimester residence ///
        gestational_age_cat abortion_history ///
        iron_supplement alcohol_during_pregnancy, ///
        statistics(mean sd min max count) columns(statistics)

********************************************************************************
* Step 10: Save the STATA dataset for future use
********************************************************************************

save "RLS_Study_Final_Dataset.dta", replace

********************************************************************************
* END OF CODE
********************************************************************************




ds

* Create a list of all variables except Age, RBS, Income
local all_vars ""
foreach var of varlist _all {
    if "`var'" != "Age" & "`var'" != "RBS" & "`var'" != "Income" {
        local all_vars "`all_vars' `var'"
    }
}

* Display frequency tables
foreach var in `all_vars' {
    di _newline
    di "================================================="
    di "FREQUENCY TABLE FOR: `var'"
    di "================================================="
    tabulate `var', missing
    di ""
}