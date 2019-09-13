package it.cnr.istc.stlab.ecodigit.transformer.model;

import it.cnr.istc.stlab.ecodigit.transformer.work.model.Agent;

public class Organization extends Agent {

	private String acronym;
	private double lat, _long;

	public String getAcronym() {
		return acronym;
	}

	public void setAcronym(String acronym) {
		this.acronym = acronym;
	}

	public double getLat() {
		return lat;
	}

	public void setLat(double lat) {
		this.lat = lat;
	}

	public double get_long() {
		return _long;
	}

	public void set_long(double _long) {
		this._long = _long;
	}

}
