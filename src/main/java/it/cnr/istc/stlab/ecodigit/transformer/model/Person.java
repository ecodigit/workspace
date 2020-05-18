package it.cnr.istc.stlab.ecodigit.transformer.model;

import java.util.List;

import it.cnr.istc.stlab.ecodigit.transformer.work.model.Agent;
import it.cnr.istc.stlab.ecodigit.transformer.work.model.Work;

public class Person extends Agent {

	public enum Field {
		GIVEN_NAME, FAMILY_NAME, IMG, MBOX, HOMEPAGE, ORCID, DESCRIPTION, PUBLICATIONS, AFFILIATION_NAME,
		AFFILIATION_ACRONYM, AFFILIATION_ADDRESS
	}

	private String givenName, familyName, img, mbox, homepage, orcid, description;
	private List<Work> made;
	private List<Organization> memberOf;
	private List<Membership> memberships;

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

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public String getMbox() {
		return mbox;
	}

	public void setMbox(String mbox) {
		this.mbox = mbox;
	}

	public String getHomepage() {
		return homepage;
	}

	public void setHomepage(String homepage) {
		this.homepage = homepage;
	}

	public String getOrcid() {
		return orcid;
	}

	public void setOrcid(String orcid) {
		this.orcid = orcid;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public List<Work> getMade() {
		return made;
	}

	public void setMade(List<Work> made) {
		this.made = made;
	}

	public List<Organization> getMemberOf() {
		return memberOf;
	}

	public void setMemberOf(List<Organization> memberOf) {
		this.memberOf = memberOf;
	}

	public List<Membership> getMemberships() {
		return memberships;
	}

	public void setMemberships(List<Membership> memberships) {
		this.memberships = memberships;
	}

}
