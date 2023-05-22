
SET @OLD_SQL_MODE=@@SQL_MODE $$
SET SQL_MODE='' $$

--Populate etl covid screening: CCA
DROP PROCEDURE IF EXISTS sp_populate_etl_cca_covid_screening$$
CREATE PROCEDURE sp_populate_etl_cca_covid_screening()
BEGIN
SELECT "Processing CCA covid screening data", CONCAT("Time: ", NOW());
insert into kenyaemr_etl.etl_cca_covid_screening(
uuid,
encounter_id,
visit_id,
patient_id,
location_id,
visit_date,
encounter_provider,
date_created,
onset_symptoms_date,
fever,
cough,
runny_nose,
diarrhoea,
headache,
muscular_pain,
abdominal_pain,
general_weakness,
sore_throat,
breathing_difficulty,
nausea_vomiting,
altered_mental_status,
chest_pain,
joint_pain,
loss_of_taste_smell,
other_symptom,
specify_symptoms,
recent_travel,
contact_with_suspected_or_confirmed_case,
attended_large_gathering,
screening_department,
hiv_status,
in_tb_program,
pregnant,
vaccinated_for_covid,
covid_vaccination_status,
ever_tested_for_covid,
covid_test_date,
eligible_for_covid_test,
consented_for_covid_test,
decline_reason,
voided
)
select
	e.uuid,
	e.encounter_id as encounter_id,
	e.visit_id as visit_id,
	e.patient_id,
	e.location_id,
	date(e.encounter_datetime) as visit_date,
	e.creator as encounter_provider,
	e.date_created as date_created,
  max(if(o.concept_id=1730,date(o.value_datetime),null)) as onset_symptoms_date,
  max(if(o.concept_id=140238,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as fever,
  max(if(o.concept_id=143264,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as cough,
  max(if(o.concept_id=163336,(case o.value_coded when 113224 then "Yes" when 1066 then "No" else "" end),null)) as runny_nose,
  max(if(o.concept_id=142412,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as diarrhoea,
  max(if(o.concept_id=5219,(case o.value_coded when 139084 then "Yes" when 1066 then "No" else "" end),null)) as headache,
  max(if(o.concept_id=160388,(case o.value_coded when 133632 then "Yes" when 1066 then "No" else "" end),null)) as muscular_pain,
  max(if(o.concept_id=1125,(case o.value_coded when 151 then "Yes" when 1066 then "No" else "" end),null)) as abdominal_pain,
  max(if(o.concept_id=122943,(case o.value_coded when 5226 then "Yes" when 1066 then "No" else "" end),null)) as general_weakness,

  max(if(o.concept_id=163741,(case o.value_coded when 158843 then "Yes" when 1066 then "No" else "" end),null)) as sore_throat,
  max(if(o.concept_id=164441,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as breathing_difficulty,
  max(if(o.concept_id=122983,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as nausea_vomiting,

  max(if(o.concept_id=6023,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as altered_mental_status,
  max(if(o.concept_id=1123,(case o.value_coded when 120749 then "Yes" when 1066 then "No" else "" end),null)) as chest_pain,
  max(if(o.concept_id=160687,(case o.value_coded when 80 then "Yes" when 1066 then "No" else "" end),null)) as joint_pain,
  max(if(o.concept_id=1729,(case o.value_coded when 135589 then "Yes" when 1066 then "No" else "" end),null)) as loss_of_taste_smell,

  max(if(o.concept_id=1838,(case o.value_coded when 139548 then "Yes" else "" end),null)) as other_symptom,
	max(if(o.concept_id=160632,o.value_text,null)) as specify_symptoms,
  max(if(o.concept_id=162619,(case o.value_coded when 1065 then "Yes" when 1066 then "No" when 1067 then "Unknown" else "" end),null)) as recent_travel,
	max(if(o.concept_id=162633,(case o.value_coded when 1065 then "Yes" when 1066 then "No" when 1067 then "Unknown" else "" end),null)) as contact_with_suspected_or_confirmed_case,
  max(if(o.concept_id=165163,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as attended_large_gathering,
  max(if(o.concept_id=164918,(case o.value_coded when 1622 then "ANC" when 1623 then "PNC" when 5483 then "FP" when 162049 then "CWC" when 160542 then "OPD" when 162050 then "CCC" when 160541 then "TB" when 160545 then "Community" else "" end),null)) as screening_department,
  max(if(o.concept_id=1169,(case o.value_coded when 703 then "Positive" when 664 then "Negative" else "" end),null)) as hiv_status,
  max(if(o.concept_id=162309,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as in_tb_program,
  max(if(o.concept_id=5272,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as pregnant,

  max(if(o.concept_id=163100,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as vaccinated_for_covid,
  max(if(o.concept_id=164134,(case o.value_coded when 166192 then "Partially vaccinated" when 5585 then "Fully vaccinated" else "" end),null)) as covid_vaccination_status,
  max(if(o.concept_id=165852,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as ever_tested_for_covid,
  max(if(o.concept_id=159948,date(o.value_datetime),null)) as covid_test_date,
  max(if(o.concept_id=165087,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as eligible_for_covid_test,
  max(if(o.concept_id=1710,(case o.value_coded when 1 then "Yes" when 2 then "No" else "" end),null)) as consented_for_covid_test,
  max(if(o.concept_id=161011, o.value_text, null)) as decline_reason,
	e.voided as voided
from encounter e
	inner join person p on p.person_id=e.patient_id and p.voided=0
	inner join
	(
		select form_id from form where
			uuid in('117092aa-5355-11ec-bf63-0242ac130002')
	) f on f.form_id=e.form_id
	left outer join obs o on o.encounter_id=e.encounter_id and o.voided=0
													 and o.concept_id in (159948,1730,1729,140238,122943,143264,163741,163336,164441,142412,122983,5219,6023,160388,
                                                1123,1125,160687,1838,160632,5272,162619,162633,164918,1169,162309,163100,164134,159948,165163,165087,1710,161011)
where e.voided=0
group by e.patient_id, e.encounter_id;

SELECT "Completed processing CCA covid screening data ", CONCAT("Time: ", NOW());
END$$


--Populate etl covid treatment followup: CCA
DROP PROCEDURE IF EXISTS sp_populate_etl_cca_covid_treatment_followup$$
CREATE PROCEDURE sp_populate_etl_cca_covid_treatment_followup()
BEGIN
SELECT "Processing CCA covid treatment followup data", CONCAT("Time: ", NOW());
insert into kenyaemr_etl.etl_cca_covid_treatment_followup(
uuid,
encounter_id,
visit_id,
patient_id,
location_id,
visit_date,
encounter_provider,
date_created,
day_of_followup,
temp,
fever,
cough,
difficulty_breathing,
sore_throat,
sneezing,
headache,
referred_to_hosp,
case_classification,
patient_admitted,
admission_unit,
treatment_received,
voided
)
select
	e.uuid,
	e.encounter_id as encounter_id,
	e.visit_id as visit_id,
	e.patient_id,
	e.location_id,
	date(e.encounter_datetime) as visit_date,
	e.creator as encounter_provider,
	e.date_created as date_created,
	max(if(o.concept_id=165416,o.value_numeric,null)) as day_of_followup,
	max(if(o.concept_id=5088,o.value_numeric,null)) as temp,
	max(if(o.concept_id=140238,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as fever,
	max(if(o.concept_id=143264,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as cough,
	max(if(o.concept_id=164441,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as diffiulty_breathing,
	max(if(o.concept_id=162737,(case o.value_coded when 158843 then "Yes" when 1066 then "No" else "" end),null)) as sore_throat,
  max(if(o.concept_id=163336,(case o.value_coded when 126319 then "Yes" when 1066 then "No" else "" end),null)) as sneezing,
	max(if(o.concept_id=5219,(case o.value_coded when 139084 then "Yes" when 1066 then "No" else "" end),null)) as headache,
	max(if(o.concept_id=1788,(case o.value_coded when 140238 then "Yes" when 1066 then "No" when 1175 then "N/A" else "" end),null)) as referred_to_hosp,
  max(if(o.concept_id=159640,(case o.value_coded when 5006 then "Asymptomatic" when 1498 then "Mild" when 1499 then "Moderate" when 1500 then "Severe" when 164830 then "Critical" else "" end),null)) as case_classification,
	max(if(o.concept_id=162477,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as patient_admitted,
	max(if(o.concept_id=161010,(case o.value_coded when 165994 then "Isolation" when 165995 then "HDU" when 161936 then "ICU" else "" end),null)) as admission_unit,
  group_concat(if(o.concept_id=159369,o.value_coded,null)) as treatment_received,  e.voided as voided
from encounter e
	inner join person p on p.person_id=e.patient_id and p.voided=0
	inner join
	(
		select form_id, uuid,name from form where
			uuid in('33a3aab6-73ae-11ea-bc55-0242ac130003')
	) f on f.form_id=e.form_id
	left outer join obs o on o.encounter_id=e.encounter_id and o.voided=0 and o.concept_id in (165416,5088,140238,143264,164441,162737,163336,5219,1788,159640,162477,161010,159369)
where e.voided=0
group by e.patient_id, e.encounter_id;


SELECT "Completed processing CCA covid treatment followup data ", CONCAT("Time: ", NOW());
END$$


--Populate etl covid ag-rdt test: CCA
DROP PROCEDURE IF EXISTS sp_populate_etl_cca_covid_rdt_test$$
CREATE PROCEDURE sp_populate_etl_cca_covid_rdt_test()
BEGIN
SELECT "Processing CCA covid ag-rdt test data", CONCAT("Time: ", NOW());
insert into kenyaemr_etl.etl_cca_covid_rdt_test(
	uuid,
	encounter_id,
	visit_id,
	patient_id,
	location_id,
	visit_date,
	encounter_provider,
	date_created,
    consented_for_covid_test,
    decline_reason,
	nationality,
	passport_id_number,
	sample_type,
	test_reason,
	ag_rdt_test_done,
	ag_rdt_test_date,
	case_type,
	assay_kit_name,
	ag_rdt_test_type_coded,
	ag_rdt_test_type_other,
	kit_lot_number,
	kit_expiry,
	test_result,
	action_taken,
	voided
)
select
	e.uuid,
	e.encounter_id as encounter_id,
	e.visit_id as visit_id,
	e.patient_id,
	e.location_id,
	date(e.encounter_datetime) as visit_date,
	e.creator as encounter_provider,
	e.date_created as date_created,
    max(if(o.concept_id=1710,(case o.value_coded when 1 then "Yes" when 2 then "No" else "" end),null)) as consented_for_covid_test,
    max(if(o.concept_id=161011, o.value_text, null)) as decline_reason,
	max(if(o.concept_id=165847,cn.name,null)) as nationality,
	max(if(o.concept_id=163084,o.value_text,null)) as passport_id_number,
	max(if(o.concept_id=159959,(case o.value_coded when 163364 then "NP swab" when 163362 then "OP swab" when 162614 then "NP/OP swab" when 1004 then "Sputum" when 1001 then "Serum" else "" end),null)) as sample_type,
	max(if(o.concept_id=164126,(case o.value_coded when 1068 then "Symptomatic" when 165850 then "Contact with confirmed case" when 5619 then "Health care worker" when 162277 then "Prison remand" when 165631 then "High risk client in health facility" when 1143 then "Outbreak investigation" when 5622 then "Other" else "" end),null)) as test_reason,
	max(if(o.concept_id=165852,(case o.value_coded when 1065 then "Yes" when 1066 then "No" else "" end),null)) as ag_rdt_test_done,
	ag_rdt.ag_rdt_test_date,
	ag_rdt.case_type,
	ag_rdt.assay_kit_name,
	ag_rdt.ag_rdt_test_type_coded,
	ag_rdt.ag_rdt_test_type_other,
	ag_rdt.kit_lot_number,
	ag_rdt.kit_expiry,
	ag_rdt.test_result,
	ag_rdt.action_taken,
  e.voided
from encounter e
	inner join person p on p.person_id=e.patient_id and p.voided=0
	inner join form f on f.form_id=e.form_id and f.uuid in ('820cbf10-54cd-11ec-bf63-0242ac130002')
	left outer join obs o on o.encounter_id=e.encounter_id and o.voided=0 and o.concept_id in (1710,161011,165847,163084,159959,164126,165852,5622)
	left join concept_name cn on cn.concept_id = o.value_coded and o.concept_id = 165847 and cn.concept_name_type='FULLY_SPECIFIED'
	left join (
		select
		o.obs_group_id obs_group_id,
		o.encounter_id,
		max(if(o.concept_id = 162078,date(o.value_datetime), null)) as ag_rdt_test_date,
		max(if(o.concept_id = 162084, case o.value_coded when 162080 then "Initial" when 162081 then "Repeat" else "" end, null)) as case_type,
		max(if(o.concept_id = 164963,o.value_text, null)) as assay_kit_name,
		max(if(o.concept_id = 1271,case o.value_coded when 165859 then "Panbio" when 165611 then "Standard" when 5622 then "Other" else "" end, null)) as ag_rdt_test_type_coded,
		max(if(o.concept_id = 165398,o.value_text, null)) as ag_rdt_test_type_other,
		max(if(o.concept_id = 166455, o.value_text, null)) as kit_lot_number,
		max(if(o.concept_id = 162502, date(o.value_datetime), null)) as kit_expiry,
		max(if(o.concept_id = 166638,case o.value_coded when 703 then "Positive" when 664 then "Negative" when 163611 then "Invalid" else "" end, null)) as test_result,
		max(if(o.concept_id = 1272,case o.value_coded when 159494 then "Referred to clinician" when 165093 then "Preventive counseling" else "" end, null)) as action_taken
	from obs o
		inner join person p on p.person_id=o.person_id and p.voided=0
		inner join encounter e on e.encounter_id = o.encounter_id and e.voided=0
		inner join form f on f.form_id=e.form_id and f.uuid in ('820cbf10-54cd-11ec-bf63-0242ac130002')
	where o.voided=0 and o.concept_id in(162078,162084,164963,1271,165398,166455,162502,166638,1272)  and e.voided=0 and o.obs_group_id is not null
	group by o.obs_group_id, o.encounter_id
	) ag_rdt on ag_rdt.encounter_id = e.encounter_id
where e.voided=0
group by e.patient_id, e.encounter_id;


SELECT "Completed processing CCA covid ag-rdt test data ", CONCAT("Time: ", NOW());
END$$

--Populate etl covid clinical review: CCA
DROP PROCEDURE IF EXISTS sp_populate_etl_cca_covid_clinical_review$$
CREATE PROCEDURE sp_populate_etl_cca_covid_clinical_review()
BEGIN
SELECT "Processing CCA covid clinical data", CONCAT("Time: ", NOW());
insert into kenyaemr_etl.etl_cca_covid_clinical_review(
      uuid,
      encounter_id,
      visit_id,
      patient_id ,
      location_id,
      visit_date,
      encounter_provider,
      date_created,
      ag_rdt_test_result,
      case_classification,
      action_taken,
      hospital_referred_to,
      case_id,
      email,
      case_type,
      pcr_sample_collection_date,
      pcr_result_date,
      pcr_result,
      case_classification_after_positive_pcr,
      action_taken_after_pcr_result,
      notes,
      voided
)
select
	e.uuid,
	e.encounter_id as encounter_id,
	e.visit_id as visit_id,
	e.patient_id,
	e.location_id,
	date(e.encounter_datetime) as visit_date,
	e.creator as encounter_provider,
	e.date_created as date_created,
	max(if(o.concept_id=165852,case o.value_coded when 703 then "Positive" when 664 then "Negative" else "" end,null)) as ag_rdt_test_result,
	max(if(o.concept_id=159640 and o.obs_group_id is null,case o.value_coded when 5006 then "Asymptomatic" when 1498 then "Mild" when 1499 then "Moderate" when 1500 then "Severe" when 164830 then "Critical" else "" end,null)) as case_classification,
	max(if(o.concept_id=1272,case o.value_coded when 165901 then "Referred to home based treatment/isolation" when 1654 then "Hospital admission" when 164165 then "Referred to other hospital for treatment" when 165611 then "Referred for PCR" else "" end,null)) as action_taken,
	max(if(o.concept_id=162724,o.value_text,null)) as hospital_referred_to,
	pcr_test.case_id,
	pcr_test.email,
	pcr_test.case_type,
	pcr_test.pcr_sample_collection_date,
	pcr_test.pcr_result_date,
	pcr_test.pcr_result,
	pcr_test.case_classification_after_positive_pcr,
	pcr_test.action_taken_after_pcr_result,
	max(if(o.concept_id=161011,o.value_text,null)) as notes,
  e.voided
from encounter e
	inner join person p on p.person_id=e.patient_id and p.voided=0
	inner join form f on f.form_id=e.form_id and f.uuid = '8fb6dabd-9c14-4d17-baac-97afaf3d203d'
	left outer join obs o on o.encounter_id=e.encounter_id and o.voided=0 and o.concept_id in (165852,159640,1272,162724,161011)
	left join (
		select
		o.obs_group_id obs_group_id,
		o.encounter_id,
		max(if(o.concept_id = 162576,o.value_text, null)) as case_id,
		max(if(o.concept_id = 162725,o.value_text, null)) as email,
		max(if(o.concept_id = 162084, case o.value_coded when 162080 then "Initial" when 162081 then "Repeat" else "" end, null)) as case_type,
		max(if(o.concept_id = 162078,date(o.value_datetime), null)) as pcr_sample_collection_date,
		max(if(o.concept_id = 162079,date(o.value_datetime), null)) as pcr_result_date,
		max(if(o.concept_id = 166638,case o.value_coded when 703 then "Positive" when 664 then "Negative" when 163611 then "Invalid" when 1118 then "Not done" else "" end, null)) as pcr_result,
		max(if(o.concept_id = 159640,case o.value_coded when 5006 then "Asymptomatic" when 1498 then "Mild" when 1499 then "Moderate" when 1500 then "Severe" when 164830 then "Critical" else "" end, null)) as case_classification_after_positive_pcr,
		max(if(o.concept_id = 160721,case o.value_coded when 165901 then "Referred to home based treatment/isolation" when 1654 then "Hospital admission" when 164165 then "Referred to other hospital for treatment" when 165611 then "Referred for PCR" when 165093 then "Preventive counseling" else "" end, null)) as action_taken_after_pcr_result
	from obs o
		inner join person p on p.person_id=o.person_id and p.voided=0
		inner join encounter e on e.encounter_id = o.encounter_id and e.voided=0
		inner join form f on f.form_id=e.form_id and f.uuid = '8fb6dabd-9c14-4d17-baac-97afaf3d203d'
	where o.voided=0 and o.concept_id in(162576,162725,162078,162084,162079,159640,166638,160721)  and e.voided=0 and o.obs_group_id is not null
	group by o.obs_group_id, o.encounter_id
	) pcr_test on pcr_test.encounter_id = e.encounter_id
where e.voided=0
group by e.patient_id, e.encounter_id;


SELECT "Completed processing CCA covid clinical review data ", CONCAT("Time: ", NOW());
END$$

--Populate etl covid treatment enrollment: CCA
DROP PROCEDURE IF EXISTS sp_populate_etl_cca_covid_treatment_enrollment$$
CREATE PROCEDURE sp_populate_etl_cca_covid_treatment_enrollment()
BEGIN
SELECT "Processing CCA covid enrollment data", CONCAT("Time: ", NOW());
insert into kenyaemr_etl.etl_cca_covid_treatment_enrollment(
      uuid,
      encounter_id,
      visit_id,
      patient_id ,
      location_id,
      visit_date,
      encounter_provider,
      date_created,
      passport_id_number,
      case_classification,
      patient_type,
      hospital_referred_from,
      date_tested_covid_positive,
      action_taken,
      admission_date,
      admission_unit,
      voided
)
select
	e.uuid,
	e.encounter_id as encounter_id,
	e.visit_id as visit_id,
	e.patient_id,
	e.location_id,
	date(e.encounter_datetime) as visit_date,
	e.creator as encounter_provider,
	e.date_created as date_created,
	max(if(o.concept_id=163084,o.value_text,null)) as passport_id_number,
	max(if(o.concept_id=159640 and o.obs_group_id is null,case o.value_coded when 5006 then "Asymptomatic" when 1498 then "Mild" when 1499 then "Moderate" when 1500 then "Severe" when 164830 then "Critical" else "" end,null)) as case_classification,
	max(if(o.concept_id=161641,case o.value_coded when 164144 then "New" when 160563 then "Transfer in" else "" end,null)) as patient_type,
	max(if(o.concept_id=161550,o.value_text,null)) as hospital_referred_from,
	max(if(o.concept_id=159948,date(o.value_datetime),null)) as date_tested_covid_positive,
	max(if(o.concept_id = 1272,case o.value_coded when 165901 then "Referred to home based treatment/isolation" when 1654 then "Hospital admission" else "" end, null)) as action_taken,
	max(if(o.concept_id=1640,date(o.value_datetime),null)) as admission_date,
	max(if(o.concept_id = 161010,case o.value_coded when 165994 then "Isolation" when 165995 then "HDU" when 161936 then "ICU" else "" end, null)) as admission_unit,
  	e.voided
from encounter e
	inner join person p on p.person_id=e.patient_id and p.voided=0
	inner join form f on f.form_id=e.form_id and f.uuid = '9a5d57b6-739a-11ea-bc55-0242ac130003'
	left outer join obs o on o.encounter_id=e.encounter_id and o.voided=0 and o.concept_id in (163084,159640,161641,161550,159948,1272,1640,161010)
where e.voided=0
group by e.patient_id, e.encounter_id;


SELECT "Completed processing CCA covid treatment enrollment data ", CONCAT("Time: ", NOW());
END$$


--Populate etl covid treatment enrollment outcome: CCA
DROP PROCEDURE IF EXISTS sp_populate_etl_cca_covid_treatment_enrollment_outcome$$
CREATE PROCEDURE sp_populate_etl_cca_covid_treatment_enrollment_outcome()
BEGIN
SELECT "Processing CCA covid enrollment outcome data", CONCAT("Time: ", NOW());
insert into kenyaemr_etl.etl_cca_covid_treatment_enrollment_outcome(
      uuid,
      encounter_id,
      visit_id,
      patient_id ,
      location_id,
      visit_date,
      encounter_provider,
      date_created,
      outcome,
      facility_transferred,
      facility_referred,
      comment,
      voided
)
select
	e.uuid,
	e.encounter_id as encounter_id,
	e.visit_id as visit_id,
	e.patient_id,
	e.location_id,
	date(e.encounter_datetime) as visit_date,
	e.creator as encounter_provider,
	e.date_created as date_created,
	max(if(o.concept_id=161555,case o.value_coded when 1663 then "Completed isolation" when 164165 then "Referral" when 160034 then "Died" when 160018 then "Never reached" when 159492 then "Transferred to another hospital" else "" end,null)) as outcome,
	max(if(o.concept_id=159495,o.value_text,null)) as facility_transferred,
	max(if(o.concept_id=161562,o.value_text,null)) as facility_referred,
	max(if(o.concept_id = 160632,o.value_text,null)) as comment,
	e.voided
from encounter e
	inner join person p on p.person_id=e.patient_id and p.voided=0
	inner join form f on f.form_id=e.form_id and f.uuid = '9a5d58c4-739a-11ea-bc55-0242ac130003'
	left outer join obs o on o.encounter_id=e.encounter_id and o.voided=0 and o.concept_id in (161555,159495,161562,160632)
where e.voided=0
group by e.patient_id, e.encounter_id;


SELECT "Completed processing CCA covid treatment enrollment outcome data ", CONCAT("Time: ", NOW());
END$$

-- Populate etl ncd initial visit
DROP PROCEDURE IF EXISTS sp_populate_etl_ncd_initial_visit$$
CREATE PROCEDURE sp_populate_etl_ncd_initial_visit()
BEGIN
SELECT "Processing NCD initial visit data", CONCAT("Time: ", NOW());
insert into kenyaemr_etl.etl_ncd_initial_visit(
    uuid,
    encounter_id,
    visit_id,
    patient_id ,
    location_id,
    visit_date,
    encounter_provider,
    date_created,
    diabetic_status,
    diabetes_diagnosis_date,
    diabetes_type,
    hypertension_status,
    hypertension_diagnosis_date,
    hiv_status,
    in_hiv_program,
    other_comorbidity,
    insurance_type,
    patient_is_referred,
    referring_facility_mfl,
    referring_facility_name,
    referring_department,
    weight,
    systolic_pressure,
    diastolic_pressure,
    height,
    temperature,
    pulse_rate,
    respiratory_rate,
    oxygen_saturation,
    muac,
    general_exam_pallor,
    general_exam_jaundice,
    general_exam_cyanosis,
    general_exam_edema,
    general_exam_other,
    cardiovascular_exam_findings,
    cardiovascular_abnormal_notes,
    respiratory_exam_findings,
    respiratory_abnormal_notes,
    abdominal_pelvic_exam_findings,
    abdominal_pelvic_abnormal_notes,
    neurological_exam_findings,
    neurological_abnormal_notes,
    oral_exam_gum_disease,
    oral_exam_lesions,
    mental_health_depression,
    mental_health_sleep_disorder,
    mental_health_substance_abuse,
    foot_exam_calluses,
    foot_exam_ulcers,
    foot_exam_deformity,
    diabetic_foot,
    foot_risk_assessment_loss_of_sensation,
    foot_risk_assessment_absent_pulses,
    foot_risk_assessment_foot_deformity,
    foot_risk_assessment_history_of_ulcer,
    foot_risk_assessment_prior_amputation,
    diabetic_foot_risk_high,
    diabetic_foot_risk_low,
    complication_stroke,
    complication_visual_impairment,
    complication_heart_failure,
    complication_foot_ulcer,
    complication_renal_disease,
    complication_erectile_dysfunction,
    complication_peripheral_neuropathy,
    complication_other,
    dm_ht_education,
    physical_activity,
    self_care_management,
    stress_management,
    nutrition_counseling_education,
    nutrition_assessment,
    meal_planning,
    drug_adherence,
    pregnancy_status,
    drug_allergies,
    next_appointment_date,
    transfer_care_to_another_facility,
    referral_reason,
    voided
)
select
    e.uuid,
    e.encounter_id as encounter_id,
    e.visit_id as visit_id,
    e.patient_id,
    e.location_id,
    date(e.encounter_datetime) as visit_date,
    e.creator as encounter_provider,
    e.date_created as date_created,
    max(if(ncd.groupConcept=140228,ncd.disease_status,null)) as diabetic_status,
    max(if(ncd.groupConcept=140228,ncd.diagnosis_date,null)) as diabetes_diagnosis_date,
    max(if(ncd.groupConcept=140228,ncd.disease_type,null)) as diabetes_type,
    max(if(ncd.groupConcept=117399,ncd.disease_status,null)) as hypertension_status,
    max(if(ncd.groupConcept=117399,ncd.diagnosis_date,null)) as hypertension_diagnosis_date,
    max(if(o.concept_id=1169,o.value_coded,null)) as hiv_status,
    max(if(o.concept_id=159811,o.value_coded,null)) as in_hiv_program,
    max(if(o.concept_id=166104,o.value_text,null)) as other_comorbidity,
    max(if(o.concept_id=159356,o.value_coded,null)) as insurance_type,
    max(if(o.concept_id=1648,o.value_coded,null)) as patient_is_referred,
    max(if(o.concept_id=166637,o.value_text,null)) as referring_facility_mfl,
    max(if(o.concept_id=161550,o.value_text,null)) as referring_facility_name,
    max(if(o.concept_id=159371,o.value_coded,null)) as referring_department,
    max(if(o.concept_id=5089,o.value_numeric,null)) as weight,
    max(if(o.concept_id=5085,o.value_numeric,null)) as systolic_pressure,
    max(if(o.concept_id=5086,o.value_numeric,null)) as diastolic_pressure,
    max(if(o.concept_id=5090,o.value_numeric,null)) as height,
    max(if(o.concept_id=5088,o.value_numeric,null)) as temperature,
    max(if(o.concept_id=5087,o.value_numeric,null)) as pulse_rate,
    max(if(o.concept_id=5242,o.value_numeric,null)) as respiratory_rate,
    max(if(o.concept_id=5092,o.value_numeric,null)) as oxygen_saturation,
    max(if(o.concept_id=1343,o.value_numeric,null)) as muac,
    max(if(o.concept_id=1119 and o.value_coded = 5245,o.value_coded,null)) as general_exam_pallor,
    max(if(o.concept_id=1119 and o.value_coded = 136443,o.value_coded,null)) as general_exam_jaundice,
    max(if(o.concept_id=1119 and o.value_coded = 143050,o.value_coded,null)) as general_exam_cyanosis,
    max(if(o.concept_id=1119 and o.value_coded = 460,o.value_coded,null)) as general_exam_edema,
    max(if(o.concept_id=1119 and o.value_coded = 5622,o.value_coded,null)) as general_exam_other,
    max(if(o.concept_id=1124,o.value_coded,null)) as cardiovascular_exam_findings,
    max(if(o.concept_id=163046,o.value_text,null)) as cardiovascular_abnormal_notes,
    max(if(o.concept_id=1123,o.value_coded,null)) as respiratory_exam_findings,
    max(if(o.concept_id=160689,o.value_text,null)) as respiratory_abnormal_notes,
    max(if(o.concept_id=1125,o.value_coded,null)) as abdominal_pelvic_exam_findings,
    max(if(o.concept_id=160947,o.value_text,null)) as abdominal_pelvic_abnormal_notes,
    max(if(o.concept_id=1129,o.value_coded,null)) as neurological_exam_findings,
    max(if(o.concept_id=163109,o.value_text,null)) as neurological_abnormal_notes,
    max(if(o.concept_id=163308 and o.value_coded=160142,o.value_coded,null)) as oral_exam_gum_disease,
    max(if(o.concept_id=163308 and o.value_coded=152756,o.value_coded,null)) as oral_exam_lesions,
    max(if(o.concept_id=163043 and o.value_coded=119537,o.value_coded,null)) as mental_health_depression,
    max(if(o.concept_id=163043 and o.value_coded=112930,o.value_coded,null)) as mental_health_sleep_disorder,
    max(if(o.concept_id=163043 and o.value_coded=112603,o.value_coded,null)) as mental_health_substance_abuse,
    max(if(o.concept_id=165471 and o.value_coded=155388,o.value_coded,null)) as foot_exam_calluses,
    max(if(o.concept_id=165471 and o.value_coded=163411,o.value_coded,null)) as foot_exam_ulcers,
    max(if(o.concept_id=165471 and o.value_coded=142677,o.value_coded,null)) as foot_exam_deformity,
    max(if(o.concept_id=1284,o.value_coded,null)) as diabetic_foot,
    max(if(o.concept_id=165430 and o.value_coded=5135,o.value_coded,null)) as foot_risk_assessment_loss_of_sensation,
    max(if(o.concept_id=165430 and o.value_coded=150518,o.value_coded,null)) as foot_risk_assessment_absent_pulses,
    max(if(o.concept_id=165430 and o.value_coded=142677,o.value_coded,null)) as foot_risk_assessment_foot_deformity,
    max(if(o.concept_id=165430 and o.value_coded=163411,o.value_coded,null)) as foot_risk_assessment_history_of_ulcer,
    max(if(o.concept_id=165430 and o.value_coded=164009,o.value_coded,null)) as foot_risk_assessment_prior_amputation,
    max(if(o.concept_id=166879 and o.value_coded=166674,o.value_coded,null)) as diabetic_foot_risk_high,
    max(if(o.concept_id=162619 and o.value_coded=166675,o.value_coded,null)) as diabetic_foot_risk_low,
    max(if(o.concept_id=6042 and o.value_coded=111103,o.value_coded,null)) as complication_stroke,
    max(if(o.concept_id=6042 and o.value_coded=159298,o.value_coded,null)) as complication_visual_impairment,
    max(if(o.concept_id=6042 and o.value_coded=139069,o.value_coded,null)) as complication_heart_failure,
    max(if(o.concept_id=6042 and o.value_coded=163411,o.value_coded,null)) as complication_foot_ulcer,
    max(if(o.concept_id=6042 and o.value_coded=6033,o.value_coded,null)) as complication_renal_disease,
    max(if(o.concept_id=6042 and o.value_coded=116123,o.value_coded,null)) as complication_erectile_dysfunction,
    max(if(o.concept_id=6042 and o.value_coded=118983,o.value_coded,null)) as complication_peripheral_neuropathy,
    max(if(o.concept_id=6042 and o.value_coded=5622,o.value_coded,null)) as complication_other,
    max(if(o.concept_id=166937 and o.value_coded=161595,o.value_coded,null)) as dm_ht_education,
    max(if(o.concept_id=166937 and o.value_coded=159364,o.value_coded,null)) as physical_activity,
    max(if(o.concept_id=166937 and o.value_coded=978,o.value_coded,null)) as self_care_management,
    max(if(o.concept_id=166937 and o.value_coded=167323,o.value_coded,null)) as stress_management,
    max(if(o.concept_id=166937 and o.value_coded=161011,o.value_coded,null)) as nutrition_counseling_education,
    max(if(o.concept_id=161011,o.value_text,null)) as nutrition_assessment,
    max(if(o.concept_id=163189,o.value_text,null)) as meal_planning,
    max(if(o.concept_id=164075,o.value_coded,null)) as drug_adherence,
    max(if(o.concept_id=5272,o.value_coded,null)) as pregnancy_status,
    max(if(o.concept_id=162619,o.value_coded,null)) as drug_allergies,
    max(if(o.concept_id=5096,date(o.value_datetime),null)) as next_appointment_date,
    max(if(o.concept_id=1285,o.value_coded,null)) as transfer_care_to_another_facility,
    max(if(o.concept_id=159623,o.value_coded,null)) as referral_reason,
    e.voided
from encounter e
    inner join person p on p.person_id=e.patient_id and p.voided=0
    inner join form f on f.form_id=e.form_id and f.uuid = '102246ff-04ac-4317-b58f-e0d82fd9afd9'
    left outer join obs o on o.encounter_id=e.encounter_id and o.voided=0
      and o.concept_id in (1169,159811,166104,159356,1648,166637,161550,159371,5089,5085,5086,5090,5088,5087,5242,5092,1343,1119,
                           1124,163046,1123,160689,1125,160947,1129,163109,163308,163043,165471,1284,165430,
                           166879,162619,6042,166937,161011,163189,164075,5272,162619,5096,1285,159623)
    left join (
    select
    o.obs_group_id obs_group_id,
    obsGroup.concept_id groupConcept,
    o.encounter_id,
    max(if(o.concept_id = 1687,o.value_coded, null)) as disease_status,
    max(if(o.concept_id = 159948,date(o.value_datetime), null)) as diagnosis_date,
    max(if(o.concept_id = 6042, o.value_coded, null)) as disease_type
    from obs o
    inner join person p on p.person_id=o.person_id and p.voided=0
    inner join encounter e on e.encounter_id = o.encounter_id and e.voided=0
    inner join form f on f.form_id=e.form_id and f.uuid = '102246ff-04ac-4317-b58f-e0d82fd9afd9'
    inner join obs obsGroup on o.obs_group_id = obsGroup.obs_id and obsGroup.concept_id in (117399, 140228)
    where o.voided=0 and o.concept_id in(1687,159948,6042)  and e.voided=0 and o.obs_group_id is not null
    group by o.obs_group_id, o.encounter_id
    ) ncd on ncd.encounter_id = e.encounter_id
where e.voided=0
group by e.patient_id, e.encounter_id;


SELECT "Completed processing NCD initial visit data ", CONCAT("Time: ", NOW());
END$$

-- Populate etl ncd initial visit
DROP PROCEDURE IF EXISTS sp_populate_etl_ncd_followup_visit$$
CREATE PROCEDURE sp_populate_etl_ncd_followup_visit()
BEGIN
    SELECT "Processing NCD followup visit data", CONCAT("Time: ", NOW());
    insert into kenyaemr_etl.etl_ncd_followup_visit(
        uuid,
        encounter_id,
        visit_id,
        patient_id ,
        location_id,
        visit_date,
        encounter_provider,
        date_created,
        diabetic_status,
        diabetes_diagnosis_date,
        diabetes_type,
        hypertension_status,
        hypertension_diagnosis_date,
        hiv_status,
        in_hiv_program,
        other_comorbidity,
        insurance_type,
        patient_is_referred,
        referring_facility_mfl,
        referring_facility_name,
        referring_department,
        weight,
        systolic_pressure,
        diastolic_pressure,
        height,
        temperature,
        pulse_rate,
        respiratory_rate,
        oxygen_saturation,
        muac,
        general_exam_pallor,
        general_exam_jaundice,
        general_exam_cyanosis,
        general_exam_edema,
        general_exam_other,
        cardiovascular_exam_findings,
        cardiovascular_abnormal_notes,
        respiratory_exam_findings,
        respiratory_abnormal_notes,
        abdominal_pelvic_exam_findings,
        abdominal_pelvic_abnormal_notes,
        neurological_exam_findings,
        neurological_abnormal_notes,
        oral_exam_gum_disease,
        oral_exam_lesions,
        mental_health_depression,
        mental_health_sleep_disorder,
        mental_health_substance_abuse,
        foot_exam_calluses,
        foot_exam_ulcers,
        foot_exam_deformity,
        diabetic_foot,
        foot_risk_assessment_loss_of_sensation,
        foot_risk_assessment_absent_pulses,
        foot_risk_assessment_foot_deformity,
        foot_risk_assessment_history_of_ulcer,
        foot_risk_assessment_prior_amputation,
        diabetic_foot_risk_high,
        diabetic_foot_risk_low,
        complication_stroke,
        complication_visual_impairment,
        complication_heart_failure,
        complication_foot_ulcer,
        complication_renal_disease,
        complication_erectile_dysfunction,
        complication_peripheral_neuropathy,
        complication_other,
        dm_ht_education,
        physical_activity,
        self_care_management,
        stress_management,
        nutrition_counseling_education,
        nutrition_assessment,
        meal_planning,
        drug_adherence,
        pregnancy_status,
        drug_allergies,
        next_appointment_date,
        transfer_care_to_another_facility,
        referral_reason,
        voided
    )
    select
        e.uuid,
        e.encounter_id as encounter_id,
        e.visit_id as visit_id,
        e.patient_id,
        e.location_id,
        date(e.encounter_datetime) as visit_date,
        e.creator as encounter_provider,
        e.date_created as date_created,
        max(if(o.concept_id=164181,o.value_coded,null)) as visit_type,
        max(if(o.concept_id=160632,o.value_text,null)) as chief_complaint,
        max(if(o.concept_id=164800,o.value_coded,null)) as tb_screening_outcome,
        max(if(o.concept_id=164800,o.value_coded,null)) as tb_screening_outcome,
        max(if(o.concept_id=152722,o.value_coded,null)) as tobacco_use,
        max(if(o.concept_id=159450,o.value_coded,null)) as drinks_alcohol,
        max(if(o.concept_id=165569,o.value_coded,null)) as adequate_physical_activity,
        max(if(o.concept_id=167392,o.value_coded,null)) as healthy_diet,
        max(if(o.concept_id=1169,o.value_coded,null)) as hiv_status,
        max(if(o.concept_id=159811,o.value_coded,null)) as in_hiv_program,
        max(if(o.concept_id=166104,o.value_text,null)) as other_comorbidity,
        max(if(o.concept_id=159356,o.value_coded,null)) as insurance_type,
        max(if(o.concept_id=1648,o.value_coded,null)) as patient_is_referred,
        max(if(o.concept_id=166637,o.value_text,null)) as referring_facility_mfl,
        max(if(o.concept_id=161550,o.value_text,null)) as referring_facility_name,
        max(if(o.concept_id=159371,o.value_coded,null)) as referring_department,
        max(if(o.concept_id=5089,o.value_numeric,null)) as weight,
        max(if(o.concept_id=5085,o.value_numeric,null)) as systolic_pressure,
        max(if(o.concept_id=5086,o.value_numeric,null)) as diastolic_pressure,
        max(if(o.concept_id=5090,o.value_numeric,null)) as height,
        max(if(o.concept_id=5088,o.value_numeric,null)) as temperature,
        max(if(o.concept_id=5087,o.value_numeric,null)) as pulse_rate,
        max(if(o.concept_id=5242,o.value_numeric,null)) as respiratory_rate,
        max(if(o.concept_id=5092,o.value_numeric,null)) as oxygen_saturation,
        max(if(o.concept_id=1343,o.value_numeric,null)) as muac,
        max(if(o.concept_id=1119 and o.value_coded = 5245,o.value_coded,null)) as general_exam_pallor,
        max(if(o.concept_id=1119 and o.value_coded = 136443,o.value_coded,null)) as general_exam_jaundice,
        max(if(o.concept_id=1119 and o.value_coded = 143050,o.value_coded,null)) as general_exam_cyanosis,
        max(if(o.concept_id=1119 and o.value_coded = 460,o.value_coded,null)) as general_exam_edema,
        max(if(o.concept_id=1119 and o.value_coded = 5622,o.value_coded,null)) as general_exam_other,
        max(if(o.concept_id=1124,o.value_coded,null)) as cardiovascular_exam_findings,
        max(if(o.concept_id=163046,o.value_text,null)) as cardiovascular_abnormal_notes,
        max(if(o.concept_id=1123,o.value_coded,null)) as respiratory_exam_findings,
        max(if(o.concept_id=160689,o.value_text,null)) as respiratory_abnormal_notes,
        max(if(o.concept_id=1125,o.value_coded,null)) as abdominal_pelvic_exam_findings,
        max(if(o.concept_id=160947,o.value_text,null)) as abdominal_pelvic_abnormal_notes,
        max(if(o.concept_id=1129,o.value_coded,null)) as neurological_exam_findings,
        max(if(o.concept_id=163109,o.value_text,null)) as neurological_abnormal_notes,
        max(if(o.concept_id=163308 and o.value_coded=160142,o.value_coded,null)) as oral_exam_gum_disease,
        max(if(o.concept_id=163308 and o.value_coded=152756,o.value_coded,null)) as oral_exam_lesions,
        max(if(o.concept_id=163043 and o.value_coded=119537,o.value_coded,null)) as mental_health_depression,
        max(if(o.concept_id=163043 and o.value_coded=112930,o.value_coded,null)) as mental_health_sleep_disorder,
        max(if(o.concept_id=163043 and o.value_coded=112603,o.value_coded,null)) as mental_health_substance_abuse,
        max(if(o.concept_id=165471 and o.value_coded=155388,o.value_coded,null)) as foot_exam_calluses,
        max(if(o.concept_id=165471 and o.value_coded=163411,o.value_coded,null)) as foot_exam_ulcers,
        max(if(o.concept_id=165471 and o.value_coded=142677,o.value_coded,null)) as foot_exam_deformity,
        max(if(o.concept_id=1284,o.value_coded,null)) as diabetic_foot,
        max(if(o.concept_id=165430 and o.value_coded=5135,o.value_coded,null)) as foot_risk_assessment_loss_of_sensation,
        max(if(o.concept_id=165430 and o.value_coded=150518,o.value_coded,null)) as foot_risk_assessment_absent_pulses,
        max(if(o.concept_id=165430 and o.value_coded=142677,o.value_coded,null)) as foot_risk_assessment_foot_deformity,
        max(if(o.concept_id=165430 and o.value_coded=163411,o.value_coded,null)) as foot_risk_assessment_history_of_ulcer,
        max(if(o.concept_id=165430 and o.value_coded=164009,o.value_coded,null)) as foot_risk_assessment_prior_amputation,
        max(if(o.concept_id=166879 and o.value_coded=166674,o.value_coded,null)) as diabetic_foot_risk_high,
        max(if(o.concept_id=162619 and o.value_coded=166675,o.value_coded,null)) as diabetic_foot_risk_low,
        max(if(o.concept_id=6042 and o.value_coded=111103,o.value_coded,null)) as complication_stroke,
        max(if(o.concept_id=6042 and o.value_coded=159298,o.value_coded,null)) as complication_visual_impairment,
        max(if(o.concept_id=6042 and o.value_coded=139069,o.value_coded,null)) as complication_heart_failure,
        max(if(o.concept_id=6042 and o.value_coded=163411,o.value_coded,null)) as complication_foot_ulcer,
        max(if(o.concept_id=6042 and o.value_coded=6033,o.value_coded,null)) as complication_renal_disease,
        max(if(o.concept_id=6042 and o.value_coded=116123,o.value_coded,null)) as complication_erectile_dysfunction,
        max(if(o.concept_id=6042 and o.value_coded=118983,o.value_coded,null)) as complication_peripheral_neuropathy,
        max(if(o.concept_id=6042 and o.value_coded=5622,o.value_coded,null)) as complication_other,
        max(if(o.concept_id=166937 and o.value_coded=161595,o.value_coded,null)) as dm_ht_education,
        max(if(o.concept_id=166937 and o.value_coded=159364,o.value_coded,null)) as physical_activity,
        max(if(o.concept_id=166937 and o.value_coded=978,o.value_coded,null)) as self_care_management,
        max(if(o.concept_id=166937 and o.value_coded=167323,o.value_coded,null)) as stress_management,
        max(if(o.concept_id=166937 and o.value_coded=161011,o.value_coded,null)) as nutrition_counseling_education,

        max(if(o.concept_id=1379 and o.value_coded=159364,o.value_coded,null)) as lifestyle_mgt_physical_activity,
        max(if(o.concept_id=1379 and o.value_coded=5489,o.value_coded,null)) as lifestyle_mgt_mental_wellbeing,
        max(if(o.concept_id=1379 and o.value_coded=1455,o.value_coded,null)) as lifestyle_mgt_alcohol_tobacco,
        max(if(o.concept_id=1379 and o.value_coded=5486,o.value_coded,null)) as lifestyle_mgt_social_group,
        max(if(o.concept_id=1379 and o.value_coded=1380,o.value_coded,null)) as lifestyle_mgt_nutrition,


        max(if(o.concept_id=161011,o.value_text,null)) as nutrition_assessment,
        max(if(o.concept_id=163189,o.value_text,null)) as meal_planning,
        max(if(o.concept_id=164075,o.value_coded,null)) as drug_adherence,
        max(if(o.concept_id=5272,o.value_coded,null)) as pregnancy_status,
        max(if(o.concept_id=1427,date(o.value_datetime),null)) as lmp_date,
        max(if(o.concept_id=162619,o.value_coded,null)) as drug_allergies,
        max(if(o.concept_id=5096,date(o.value_datetime),null)) as next_appointment_date,
        max(if(o.concept_id=1285,o.value_coded,null)) as transfer_care_to_another_facility,
        max(if(o.concept_id=159623,o.value_coded,null)) as referral_reason,
        e.voided
    from encounter e
             inner join person p on p.person_id=e.patient_id and p.voided=0
             inner join form f on f.form_id=e.form_id and f.uuid = '102246ff-04ac-4317-b58f-e0d82fd9afd9'
             left outer join obs o on o.encounter_id=e.encounter_id and o.voided=0
        and o.concept_id in (1169,159811,166104,159356,1648,166637,161550,159371,5089,5085,5086,5090,5088,5087,5242,5092,1343,1119,
                             1124,163046,1123,160689,1125,160947,1129,163109,163308,163043,165471,1284,165430,
                             166879,162619,6042,166937,161011,163189,164075,5272,162619,5096,1285,159623,164181,
                             160632,164800,167392,165569,159450,152722,1427,1379)
    where e.voided=0
    group by e.patient_id, e.encounter_id;


    SELECT "Completed processing NCD followup visit ", CONCAT("Time: ", NOW());
    END$$
		-- end of dml procedures

		SET sql_mode=@OLD_SQL_MODE $$

-- ------------------------------------------- running all procedures -----------------------------

DROP PROCEDURE IF EXISTS sp_build_cca_covid_tables $$
CREATE PROCEDURE sp_build_cca_covid_tables()
BEGIN
DECLARE populate_script_id INT(11);
SELECT "Beginning first time setup", CONCAT("Time: ", NOW());
INSERT INTO kenyaemr_etl.etl_script_status(script_name, start_time) VALUES('initial_population_of_covid_cca_tables', NOW());
SET populate_script_id = LAST_INSERT_ID();

CALL sp_populate_etl_cca_covid_screening();
CALL sp_populate_etl_cca_covid_treatment_followup();
CALL sp_populate_etl_cca_covid_rdt_test();
CALL sp_populate_etl_cca_covid_treatment_enrollment();
CALL sp_populate_etl_cca_covid_clinical_review();
CALL sp_populate_etl_cca_covid_treatment_enrollment_outcome();

UPDATE kenyaemr_etl.etl_script_status SET stop_time=NOW() where id= populate_script_id;

SELECT "Completed first time setup", CONCAT("Time: ", NOW());
END $$



