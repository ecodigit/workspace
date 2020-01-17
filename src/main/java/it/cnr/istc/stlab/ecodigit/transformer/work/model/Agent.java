package it.cnr.istc.stlab.ecodigit.transformer.work.model;

public class Agent {

	private String URI, name, fulladdress;
	private double lat, _long;

	public String getURI() {
		return URI;
	}

	public void setURI(String uRI) {
		URI = uRI;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getFulladdress() {
		return fulladdress;
	}

	public void setFulladdress(String fulladdress) {
		this.fulladdress = fulladdress;
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
