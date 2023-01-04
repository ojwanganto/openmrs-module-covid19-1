/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.covid19.util;

import java.util.List;

import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;

public class CovidUtils {
	
	public static Encounter lastEncounter(Patient patient, List<EncounterType> types) {
		List<Encounter> encounters = Context.getEncounterService().getEncounters(patient, null, null, null, null, types,
		    null, null, null, false);
		return encounters.size() > 0 ? encounters.get(encounters.size() - 1) : null;
	}
}
