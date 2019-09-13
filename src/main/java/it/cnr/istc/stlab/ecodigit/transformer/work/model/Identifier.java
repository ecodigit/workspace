package it.cnr.istc.stlab.ecodigit.transformer.work.model;

public class Identifier {

	private String literalValue;
	private ResourceIdentifierScheme usesIdentifierScheme;

	public Identifier(String literalValue, ResourceIdentifierScheme resourceIdentifierScheme) {
		super();
		this.literalValue = literalValue;
		this.usesIdentifierScheme = resourceIdentifierScheme;
	}

	public String getLiteralValue() {
		return literalValue;
	}

	public void setLiteralValue(String literalValue) {
		this.literalValue = literalValue;
	}

	public ResourceIdentifierScheme getUsesIdentifierScheme() {
		return usesIdentifierScheme;
	}

	public void setUsesIdentifierScheme(ResourceIdentifierScheme usesIdentifierScheme) {
		this.usesIdentifierScheme = usesIdentifierScheme;
	}

}
