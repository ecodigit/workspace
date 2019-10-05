package it.cnr.istc.stlab.ecodigit.rdf;

import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.Map;

import it.cnr.istc.stlab.lgu.commons.rdf.RDFMergeUtils;

public class Merge {

	public static void main(String[] args) throws FileNotFoundException {
		Map<String, String> nsPrefixes = new HashMap<>();
		nsPrefixes.put("e-org", "https://w3id.org/ecodigit/organization/");
		nsPrefixes.put("e-res", "https://w3id.org/ecodigit/resource/");
		nsPrefixes.put("e-obj", "https://w3id.org/ecodigit/obj/");
		nsPrefixes.put("gn", "http://sws.geonames.org/");
		nsPrefixes.put("e-per", "https://w3id.org/ecodigit/person/");
		RDFMergeUtils.mergeFolders(nsPrefixes, new String[] { "/Users/lgu/Desktop/ecodigit/FormObjects",
				"/Users/lgu/Desktop/ecodigit/CulturalObject_t/transform", "/Users/lgu/Desktop/ecodigit/Pubblicazioni" },
				"/Users/lgu/Desktop/a.ttl", "TTL");
	}

}
