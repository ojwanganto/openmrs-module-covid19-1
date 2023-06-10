/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.covid19.reporting.data.definition.evaluator.postcovidscreening;

import org.openmrs.annotation.Handler;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSPostCovidActiveSymptomsDataDefinition;
import org.openmrs.module.reporting.data.encounter.EvaluatedEncounterData;
import org.openmrs.module.reporting.data.encounter.definition.EncounterDataDefinition;
import org.openmrs.module.reporting.data.encounter.evaluator.EncounterDataEvaluator;
import org.openmrs.module.reporting.evaluation.EvaluationContext;
import org.openmrs.module.reporting.evaluation.EvaluationException;
import org.openmrs.module.reporting.evaluation.querybuilder.SqlQueryBuilder;
import org.openmrs.module.reporting.evaluation.service.EvaluationService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Map;

/**
 * Evaluates a VisitIdDataDefinition to produce a VisitData
 */
@Handler(supports = PCSPostCovidActiveSymptomsDataDefinition.class, order = 50)
public class PCSPostCovidActiveSymptomsDataEvaluator implements EncounterDataEvaluator {
	
	@Autowired
	private EvaluationService evaluationService;
	
	public EvaluatedEncounterData evaluate(EncounterDataDefinition definition, EvaluationContext context)
	        throws EvaluationException {
		EvaluatedEncounterData c = new EvaluatedEncounterData(definition, context);
		
		String qry = "select encounter_id, \n" + "concat_ws(',',\n"
		        + "if(post_covid_symptom_breathlessness_active = 1065,'Breathlessness',null),\n"
		        + "if(post_covid_symptom_fatigue_active = 1065,'Fatigue',null),\n"
		        + "if(post_covid_symptom_cough_active = 1065,'Cough',null),\n"
		        + "if(post_covid_symptom_memory_loss_active = 1065,'Memory loss',null)\n" + ")\n" + " as symptoms \n"
		        + "from kenyaemr_etl.etl_cca_post_covid_screening ;";
		
		SqlQueryBuilder queryBuilder = new SqlQueryBuilder();
		queryBuilder.append(qry);
		Map<Integer, Object> data = evaluationService.evaluateToMap(queryBuilder, Integer.class, Object.class, context);
		c.setData(data);
		return c;
	}
}
