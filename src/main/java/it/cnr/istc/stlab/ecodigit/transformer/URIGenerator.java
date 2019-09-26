package it.cnr.istc.stlab.ecodigit.transformer;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import it.cnr.istc.stlab.ecodigit.transformer.work.model.Work;

public class URIGenerator {

	public static final String BASE = "https://w3id.org/ecodigit/";

	public static String getURIWork(String lastNameFirstAuthor, int year, String firstTokenTitle) {
		return BASE + "work/" + lastNameFirstAuthor + year + firstTokenTitle;
	}

	public static String getIDWork(Work w) {
		if (w.getAuthor().size() > 0) {
			return w.getAuthor().iterator().next().getFamilyName() + w.getYear() + w.getTitle().split(" ")[0];
		}
		return w.getTitle().replaceAll("\\s", "_");
	}

	public static String getURIWork(String title) {
		return BASE + "work/" + title.replaceAll("\\s", "_");
	}

	public static String getURIPerson(String firstName, String lastName) {
		if (firstName != null && lastName != null)
			return BASE + "person/" + firstName.toLowerCase() + "." + lastName.toLowerCase();
		else
			return BASE + "person/" + lastName.toLowerCase();
	}

	public static String getURIFromString(String s) throws UnsupportedEncodingException {
		return BASE + "resource/" + URLEncoder.encode(s.replaceAll("\\s", "_"), "UTF-8");
	}

	public static String getURIOrganization(String name) {
		return BASE + "organization/" + name.replaceAll("\\s", "_");
	}

	public static String getIDFromString(String s) throws UnsupportedEncodingException {
		return URLEncoder.encode(s.replaceAll("\\s", "_"), StandardCharsets.UTF_8.toString());
	}

}
