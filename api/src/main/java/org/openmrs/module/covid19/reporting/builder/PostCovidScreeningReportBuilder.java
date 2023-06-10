/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.covid19.reporting.builder;

import org.openmrs.PersonAttributeType;
import org.openmrs.module.covid19.reporting.cohort.definition.PostCovidScreeningCohortDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSCompleteVaccinationDosesDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSConsentForFollowupDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSCovidTestResultDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSCovidVaccinationStatusDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSCurrentHealthStatusDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSNextAppointmentDateDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSPostCovidImprovedSymptomsDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSPostCovidSymptomsDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSPostCovidUnchangedSymptomsDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSPostCovidWorsenedSymptomsDataDefinition;
import org.openmrs.module.covid19.reporting.data.definition.postcovidscreening.PCSPreCovidSymptomsDataDefinition;
import org.openmrs.module.kenyacore.report.ReportDescriptor;
import org.openmrs.module.kenyacore.report.ReportUtils;
import org.openmrs.module.kenyacore.report.builder.AbstractReportBuilder;
import org.openmrs.module.kenyacore.report.builder.Builds;
import org.openmrs.module.kenyaemr.metadata.CommonMetadata;
import org.openmrs.module.metadatadeploy.MetadataUtils;
import org.openmrs.module.reporting.common.SortCriteria;
import org.openmrs.module.reporting.data.DataDefinition;
import org.openmrs.module.reporting.data.converter.BirthdateConverter;
import org.openmrs.module.reporting.data.converter.DataConverter;
import org.openmrs.module.reporting.data.converter.ObjectFormatter;
import org.openmrs.module.reporting.data.patient.definition.PatientIdDataDefinition;
import org.openmrs.module.reporting.data.person.definition.AgeDataDefinition;
import org.openmrs.module.reporting.data.person.definition.BirthdateDataDefinition;
import org.openmrs.module.reporting.data.person.definition.ConvertedPersonDataDefinition;
import org.openmrs.module.reporting.data.person.definition.GenderDataDefinition;
import org.openmrs.module.reporting.data.person.definition.PersonAttributeDataDefinition;
import org.openmrs.module.reporting.data.person.definition.PreferredNameDataDefinition;
import org.openmrs.module.reporting.dataset.definition.DataSetDefinition;
import org.openmrs.module.reporting.dataset.definition.EncounterDataSetDefinition;
import org.openmrs.module.reporting.evaluation.parameter.Mapped;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.report.definition.ReportDefinition;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Component
@Builds({ "kenyaemr.post.covid.screening.report" })
public class PostCovidScreeningReportBuilder extends AbstractReportBuilder {
	
	public static final String DATE_FORMAT = "dd/MM/yyyy";
	
	String paramMapping = "startDate=${startDate},endDate=${endDate}";
	
	@Override
	protected List<Parameter> getParameters(ReportDescriptor reportDescriptor) {
		return Arrays.asList(new Parameter("startDate", "Start Date", Date.class), new Parameter("endDate", "End Date",
		        Date.class), new Parameter("dateBasedReporting", "", String.class));
	}
	
	@Override
	protected List<Mapped<DataSetDefinition>> buildDataSets(ReportDescriptor reportDescriptor,
	        ReportDefinition reportDefinition) {
		return Arrays.asList(ReportUtils.map(reportColumns(), "startDate=${startDate},endDate=${endDate}"));
	}
	
	/**
	 * Columns for the report
	 * 
	 * @return
	 */
	protected DataSetDefinition reportColumns() {
		EncounterDataSetDefinition dsd = new EncounterDataSetDefinition();
		dsd.setName("postCovidScreeningRegister");
		dsd.setDescription("Visit information");
		dsd.addSortCriteria("Visit Date", SortCriteria.SortDirection.ASC);
		dsd.addParameter(new Parameter("startDate", "Start Date", Date.class));
		dsd.addParameter(new Parameter("endDate", "End Date", Date.class));
		
		String paramMapping = "startDate=${startDate},endDate=${endDate}";
		
		DataConverter nameFormatter = new ObjectFormatter("{familyName}, {givenName} {middleName}");
		DataDefinition nameDef = new ConvertedPersonDataDefinition("name", new PreferredNameDataDefinition(), nameFormatter);
		PersonAttributeType phoneNumber = MetadataUtils.existing(PersonAttributeType.class,
		    CommonMetadata._PersonAttributeType.TELEPHONE_CONTACT);
		
		dsd.addColumn("Name", nameDef, "");
		dsd.addColumn("id", new PatientIdDataDefinition(), "");
		dsd.addColumn("Date of Birth", new BirthdateDataDefinition(), "", new BirthdateConverter(DATE_FORMAT));
		dsd.addColumn("Age", new AgeDataDefinition(), "");
		dsd.addColumn("Sex", new GenderDataDefinition(), "");
		dsd.addColumn("Telephone No", new PersonAttributeDataDefinition(phoneNumber), "");
		dsd.addColumn("Vaccination", new PCSCovidVaccinationStatusDataDefinition(), "");
		dsd.addColumn("Complete doses", new PCSCompleteVaccinationDosesDataDefinition(), "");
		dsd.addColumn("COVID-19 test result", new PCSCovidTestResultDataDefinition(), "");
		dsd.addColumn("Current health status", new PCSCurrentHealthStatusDataDefinition(), "");
		dsd.addColumn("Pre-covid symptoms", new PCSPreCovidSymptomsDataDefinition(), "");
		dsd.addColumn("Post-covid symptoms", new PCSPostCovidSymptomsDataDefinition(), "");
		dsd.addColumn("Post-covid improved symptoms", new PCSPostCovidImprovedSymptomsDataDefinition(), "");
		dsd.addColumn("Post-covid unchanged symptoms", new PCSPostCovidUnchangedSymptomsDataDefinition(), "");
		dsd.addColumn("Post-covid worsened symptoms", new PCSPostCovidWorsenedSymptomsDataDefinition(), "");
		dsd.addColumn("Attending clinic", new PCSNextAppointmentDateDataDefinition(), "");
		dsd.addColumn("Consent for followup", new PCSConsentForFollowupDataDefinition(), "");
		dsd.addColumn("Next appointment Date", new PCSNextAppointmentDateDataDefinition(), "");
		
		PostCovidScreeningCohortDefinition cd = new PostCovidScreeningCohortDefinition();
		cd.addParameter(new Parameter("startDate", "Start Date", Date.class));
		cd.addParameter(new Parameter("endDate", "End Date", Date.class));
		
		dsd.addRowFilter(cd, paramMapping);
		return dsd;
		
	}
}
