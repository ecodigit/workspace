package it.cnr.istc.stlab.ecodigit.transformer.model;

import it.cnr.istc.stlab.ecodigit.transformer.work.model.Agent;

public class Person extends Agent {

	private String givenName, familyName, img, mbox, homepage, orcid, description;

	public String getGivenName() {
		return givenName;
	}

	public void setGivenName(String givenName) {
		this.givenName = givenName;
	}

	public String getFamilyName() {
		return familyName;
	}

	public void setFamilyName(String familyName) {
		this.familyName = familyName;
	}

}
