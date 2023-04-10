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
import org.openmrs.api.context.Context;
import org.openmrs.calculation.patient.PatientCalculationContext;
import org.openmrs.calculation.result.CalculationResultMap;
import org.openmrs.module.covid19.ModuleConstants;
import org.openmrs.module.covid19.metadata.CovidMetadata;
import org.openmrs.module.covid19.util.CovidUtils;
import org.openmrs.module.kenyacore.calculation.AbstractPatientCalculation;
import org.openmrs.module.kenyacore.calculation.BooleanResult;
import org.openmrs.module.kenyacore.calculation.Filters;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.Map;
import java.util.Set;

/**
 * Evaluates clients who have been screened for COVID-19 during a visit
 */
public class ScreenedForCovidTestCalculation extends AbstractPatientCalculation {
	
	/**
	 * @see org.openmrs.calculation.patient.PatientCalculation#evaluate(Collection, Map,
	 *      PatientCalculationContext)
	 * @should calculate eligibility
	 */
	protected static final Log log = LogFactory.getLog(NotVaccinatedCalculation.class);
	
	@Override
	public CalculationResultMap evaluate(Collection<Integer> cohort, Map<String, Object> parameterValues,
	        PatientCalculationContext context) {
		
		Set<Integer> alive = Filters.alive(cohort, context);
		CalculationResultMap ret = new CalculationResultMap();
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		
		for (int ptId : cohort) {
			boolean eligible = false;
			// Check clients with covid encounters
			Encounter lastCovidEncounter = CovidUtils.lastEncounter(Context.getPatientService().getPatient(ptId), Arrays
			        .asList(ModuleConstants.covidScreeningEncType, ModuleConstants.covidTestingEncType,
			            ModuleConstants.covidClinicalReviewEncType, ModuleConstants.covidEnrollmentEncType)); //last covid 19 encounter
			
			if (alive.contains(ptId) && lastCovidEncounter != null) {
				if (lastCovidEncounter.getEncounterType().getUuid().equals(CovidMetadata._EncounterType.COVID_SCREENING)) {
					String dateToday = dateFormat.format(new Date());
					String encounterDate = dateFormat.format(lastCovidEncounter.getEncounterDatetime());
					eligible = dateToday.equals(encounterDate);
				}
			}
			
			ret.put(ptId, new BooleanResult(eligible, this));
		}
		return ret;
	}
	
}
