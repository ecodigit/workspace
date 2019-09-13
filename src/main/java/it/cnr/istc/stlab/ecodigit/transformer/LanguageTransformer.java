package it.cnr.istc.stlab.ecodigit.transformer;

import java.util.HashMap;
import java.util.Map;

public class LanguageTransformer {

	private static LanguageTransformer instance;
	private Map<String, String> langCodeTransformer = new HashMap<>();

	private LanguageTransformer() {
		langCodeTransformer.put("ita", "it");
		langCodeTransformer.put("eng", "en");
	}

	public static LanguageTransformer getInstance() {
		if (instance == null) {
			instance = new LanguageTransformer();
		}
		return instance;
	}

	public String transform(String code) {
		return langCodeTransformer.get(code);
	}

}
