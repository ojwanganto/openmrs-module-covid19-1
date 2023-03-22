/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.covid19.calculation.library.covid;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.api.EncounterService;
import org.openmrs.api.FormService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.calculation.patient.PatientCalculationContext;
import org.openmrs.calculation.result.CalculationResultMap;
import org.openmrs.module.covid19.metadata.CovidMetadata;
import org.openmrs.module.kenyacore.calculation.AbstractPatientCalculation;
import org.openmrs.module.kenyacore.calculation.BooleanResult;
import org.openmrs.module.kenyacore.calculation.PatientFlagCalculation;
import org.openmrs.module.kenyaemr.util.EmrUtils;

import java.util.Collection;
import java.util.Map;

/**
 * Calculates a patient's eligibility for NCD followup
 */
public class ShowNCDFollowupFormCalculation extends AbstractPatientCalculation implements PatientFlagCalculation {
	
	/**
	 * @see org.openmrs.calculation.patient.PatientCalculation#evaluate(Collection, Map,
	 *      PatientCalculationContext)
	 * @should calculate eligibility
	 */
	protected static final Log log = LogFactory.getLog(NotVaccinatedCalculation.class);
	
	@Override
	public CalculationResultMap evaluate(Collection<Integer> cohort, Map<String, Object> parameterValues,
	        PatientCalculationContext context) {
		
		EncounterService encounterService = Context.getEncounterService();
		FormService formService = Context.getFormService();
		PatientService patientService = Context.getPatientService();
		
		CalculationResultMap ret = new CalculationResultMap();
		for (Integer ptId : cohort) {
			Patient patient = patientService.getPatient(ptId);
			boolean showNcdFollowupForm = false;
			Encounter hasNcdInitialEnc = EmrUtils.lastEncounter(patient, encounterService
			        .getEncounterTypeByUuid(CovidMetadata._EncounterType.DIABETES_HYPERTENSION_TREATMENT_INITIAL_ENCOUNTER),
			    formService.getFormByUuid(CovidMetadata._Form.DIABETES_HYPERTENSION_TREATMENT_INITIAL_ENCOUNTER));
			
			if (hasNcdInitialEnc != null) {
				showNcdFollowupForm = true;
			}
			
			ret.put(ptId, new BooleanResult(showNcdFollowupForm, this));
		}
		return ret;
	}
	
	@Override
	public String getFlagMessage() {
		return "NCD patient";
	}
}
