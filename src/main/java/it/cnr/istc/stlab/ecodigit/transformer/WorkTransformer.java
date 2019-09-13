package it.cnr.istc.stlab.ecodigit.transformer;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.jena.rdf.model.Model;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.github.jsonldjava.shaded.com.google.common.collect.Lists;

import freemarker.template.Template;
import freemarker.template.TemplateException;
import it.cnr.istc.stlab.ecodigit.transformer.model.Klass;
import it.cnr.istc.stlab.ecodigit.transformer.model.Organization;
import it.cnr.istc.stlab.ecodigit.transformer.model.Person;
import it.cnr.istc.stlab.ecodigit.transformer.model.Resource;
import it.cnr.istc.stlab.ecodigit.transformer.work.model.Agent;
import it.cnr.istc.stlab.ecodigit.transformer.work.model.Identifier;
import it.cnr.istc.stlab.ecodigit.transformer.work.model.ResourceIdentifierScheme;
import it.cnr.istc.stlab.ecodigit.transformer.work.model.Work;
import it.cnr.istc.stlab.ecodigit.transformer.work.model.Work.Field;
import it.cnr.istc.stlab.lgu.commons.entitylinking.Geonames;
import it.cnr.istc.stlab.lgu.commons.tables.RowsIterator;
import it.cnr.istc.stlab.lgu.commons.tables.RowsIteratorGoogleSheets;
import it.cnr.istc.stlab.lgu.commons.tables.XLS;

public class WorkTransformer {

	private static Logger logger = LoggerFactory.getLogger(WorkTransformer.class);

	private static List<Person> getListOfPersonsFromAuthorList(String list) {
		List<Person> result = new ArrayList<>();

		for (String persona : list.split(";")) {
			String[] split_persona = persona.split(",");
			String nome = null;
			if (split_persona.length > 1)
				nome = split_persona[1].replaceAll(" ", "");
			String cognome = split_persona[0].replaceAll(" ", "");
			Person p = new Person();
			p.setGivenName(nome);
			p.setFamilyName(cognome);
			p.setURI(URIGenerator.getURIPerson(nome, cognome));
			result.add(p);
		}

		return result;
	}

	private static String getStringField(String[] row, Integer col) {
		try {
			String result = row[col];
			if (result.length() == 0) {
				return null;
			}
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return null;
	}

	private static Integer getIntegerField(String[] row, int col) {
		try {
			String result = row[col];
			if (result.length() == 0)
				return null;
			return (int) Double.parseDouble(result);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return null;
	}

	public Work transformIRISRow(String[] row, Map<Work.Field, Integer> bind) throws IOException, TemplateException {

		Work w = new Work();

		String authors = getStringField(row, bind.get(Field.LIST_OF_AUTHORS));
		w.setAuthorsString(authors);

		String title = getStringField(row, bind.get(Field.TITLE));
		w.setTitle(title);

		String language = getStringField(row, bind.get(Field.LANGUAGE));
		w.setLanguage(language);

		String URL = getStringField(row, bind.get(Field.URL));
		w.setURL(URL);

		String doi = getStringField(row, bind.get(Field.DOI));
		if (doi != null) {
			w.setDoi(doi);
			w.setIdentifier(doi);
			Identifier doi_identifier = new Identifier(doi, new ResourceIdentifierScheme(
					"http://purl.org/spar/datacite/doi", "Digital Object Identier", "http://www.doi.org/"));
			w.setIdentifiers(Lists.newArrayList(doi_identifier));
		}

		Integer year = getIntegerField(row, bind.get(Field.YEAR));
		w.setYear(year);

		String firstWord = title.split(" ")[0];
		String cognomePrimoAutore = authors.split(",")[0].replaceAll(" ", "");
		w.setURI(URIGenerator.getURIWork(cognomePrimoAutore, year, firstWord));

		List<Person> listOfAuthors = getListOfPersonsFromAuthorList(authors);
		w.setAuthor(listOfAuthors);

		Integer firstPage = getIntegerField(row, bind.get(Field.FIRST_PAGE));
		w.setStartPage(firstPage);

		Integer lastPage = getIntegerField(row, bind.get(Field.LAST_PAGE));
		w.setEndPage(lastPage);

		if (lastPage != null && firstPage != null) {
			w.setExtent(lastPage - firstPage + 1);
		}

		String type = getStringField(row, bind.get(Field.TYPE));
		String uriType = URIGenerator.getURIFromString(type);
		w.setTypes(Lists.newArrayList(new Klass(uriType, type)));

		String titleCollection = getStringField(row, bind.get(Field.TITLE_COLLECTION));
		String isbnCollection = getStringField(row, bind.get(Field.ISBN_COLLECTION));
		String publisherCollection = getStringField(row, bind.get(Field.PUBLISHER_COLLECTION));
		String publisherPlace = getStringField(row, bind.get(Field.PUBLISHER_PLACE_COLLECTION));
		if (titleCollection != null) {
			String uriCollection = URIGenerator.getURIWork(titleCollection);
			Work collection = new Work();
			collection.setTitle(titleCollection);
			collection.setURI(uriCollection);
			collection.setIsbn(isbnCollection);
			Agent org = new Agent();
			org.setName(publisherCollection);
			org.setFulladdress(publisherPlace);
			org.setURI(URIGenerator.getURIOrganization(publisherCollection));
			collection.setPublisher(org);
			w.setIsPartOf(collection);
		}

		String _abstract = getStringField(row, bind.get(Field.ABSTRACT));
		w.set_abstract(_abstract);

		return w;
	}

	public Work transformObjectFromForm(String[] row, Map<Work.Field, Integer> bind, String publicationsFolder)
			throws Exception {

		Work w = new Work();

		String authors = getStringField(row, bind.get(Field.LIST_OF_AUTHORS));
		w.setAuthorsString(authors);

		String title = getStringField(row, bind.get(Field.TITLE));
		w.setTitle(title);

		Integer year = getIntegerField(row, bind.get(Field.YEAR));
		w.setYear(year);

		w.setURI(URIGenerator.getURIFromString(title));

		String language = getStringField(row, bind.get(Field.LANGUAGE));
		if (language != null && (language.contains("Italiano") || language.contains("it"))) {
			w.setLanguage("it");
		} else if (language != null && (language.contains("Italiano") || language.contains("en"))) {
			w.setLanguage("en");
		}

		String type = getStringField(row, bind.get(Field.TYPE));
		String uriType = URIGenerator.getURIFromString(type);
		w.setTypes(Lists.newArrayList(new Klass(uriType, type)));

		String URL = getStringField(row, bind.get(Field.URL));
		w.setURL(URL);

		String imgURL = getStringField(row, bind.get(Field.IMGURL));
		w.setImgURL(imgURL);

		String coverageString = getStringField(row, bind.get(Field.COVERAGE));
		String[] coverages = coverageString.split(",");
		List<Resource> coveragesList = new ArrayList<>();
		for (int i = 0; i < coverages.length; i++) {
			coverages[i] = coverages[i].trim();
			List<String> geonames = Geonames.getGeoNames(coverages[i]);
			if (geonames.isEmpty()) {
				geonames.addAll(Geonames.getGeoNames(coverages[i], null));
			}

			for (String gn : geonames) {
				Resource r = new Resource();
				r.setUri(gn);
				r.setLabel(coverages[i]);
				coveragesList.add(r);
			}
		}
		w.setCoverages(coveragesList);

		if (authors != null) {
			List<Person> listOfAuthors = getListOfPersonsFromAuthorList(authors);
			w.setAuthor(listOfAuthors);
		}

		String rightsHolderString = getStringField(row, bind.get(Field.RIGHTS_HOLDER_NAME));
		String rightsHolderAcronymString = getStringField(row, bind.get(Field.RIGHTS_HOLDER_ACRONYM));
		if (rightsHolderString != null) {
			if (rightsHolderAcronymString != null) {
				String uriRightsHolder = URIGenerator.getURIOrganization(rightsHolderAcronymString);
				Organization o = new Organization();
				o.setURI(uriRightsHolder);
				o.setAcronym(rightsHolderAcronymString);
				o.setName(rightsHolderString);
				w.setRightsHolder(o);
			} else {
				String uriRightsHolder = URIGenerator
						.getURIOrganization(URIGenerator.getIDFromString(rightsHolderString));
				Organization o = new Organization();
				o.setURI(uriRightsHolder);
				o.setAcronym(rightsHolderAcronymString);
				o.setName(rightsHolderString);
				w.setRightsHolder(o);
			}
		}

		String r = getStringField(row, bind.get(Field.RELATION));
		List<Work> relations = new ArrayList<>();
		if (r != null) {
			System.out.println(r);

			String id = r.replace("https://drive.google.com/open?id=", "");
			String downloadURL = "https://drive.google.com/uc?id=" + id + "&export=download";
			InputStream in = new URL(downloadURL).openStream();
			Files.copy(in, Paths.get(id), StandardCopyOption.REPLACE_EXISTING);

			XLS xls = new XLS(id);
			List<String[]> rows = xls.getRowsOfSheet(0);
			Map<Work.Field, Integer> binding = getIRISBinding(rows.get(0));

			WorkTransformer wt = new WorkTransformer();
			for (int i = 1; i < rows.size(); i++) {
				String[] currentrow = rows.get(i);
				String work_id = "asd";
				boolean completed = false;
				try {
					logger.info("Processing row {} {}", i, Arrays.toString(currentrow));

					Work work = wt.transformIRISRow(currentrow, binding);
					work_id = URIGenerator.getIDWork(work);

					Map<String, Object> root = new HashMap<>();
					root.put("work", work);

					Template temp = TransformerConfiguration.getInstance().getFreemarkerCfg().getTemplate("work.ftlh");
					FileWriter out = new FileWriter(new File(publicationsFolder + "/" + work_id + ".rdf.xml"));
					StringWriter sw = new StringWriter();
					temp.process(root, out);
					temp.process(root, sw);

					Model m = org.apache.jena.rdf.model.ModelFactory.createDefaultModel();
					StringReader sr = new StringReader(sw.getBuffer().toString());
					m.read(sr, null);
					completed = true;

					relations.add(work);

				} catch (Exception e) {
					logger.error(e.getMessage());
//					e.printStackTrace();
				}

				if (!completed && new File(publicationsFolder + "/" + work_id + ".rdf.xml").exists()) {
					Files.delete(Paths.get(publicationsFolder + "/" + work_id + ".rdf.xml"));
				}

			}

		}
		w.setRelations(relations);

		// Subjects
		String area = getStringField(row, bind.get(Field.AREA_SETTORE_DISCIPLINARE));
		List<Resource> subjectList = new ArrayList<>();
		String[] subjects;
		if (area != null) {
			subjects = area.split(", (?=[A-Z])");
			for (String subject : subjects) {
				Resource subjectResource = new Resource();
				subjectResource.setUri(URIGenerator.getURIFromString(subject));
				subjectResource.setLabel(subject);
				subjectList.add(subjectResource);
			}
		}

		String disciplina = getStringField(row, bind.get(Field.DISCIPLINA));
		if (disciplina != null) {
			subjects = disciplina.split(", (?=[A-Z])");
			for (String subject : subjects) {
				Resource subjectResource = new Resource();
				subjectResource.setUri(URIGenerator.getURIFromString(subject));
				subjectResource.setLabel(subject);
				subjectList.add(subjectResource);
			}
		}

		String settoreAffine = getStringField(row, bind.get(Field.SETTORE_AFFINE));
		if (settoreAffine != null) {
			subjects = settoreAffine.split(", (?=[A-Z])");
			for (String subject : subjects) {
				Resource subjectResource = new Resource();
				subjectResource.setUri(URIGenerator.getURIFromString(subject));
				subjectResource.setLabel(subject);
				subjectList.add(subjectResource);
			}
		}

		String tematica = getStringField(row, bind.get(Field.TEMATICA));
		if (tematica != null) {
			subjects = tematica.split(", (?=[A-Z])");
			for (String subject : subjects) {
				Resource subjectResource = new Resource();
				subjectResource.setUri(URIGenerator.getURIFromString(subject));
				subjectResource.setLabel(subject);
				subjectList.add(subjectResource);
			}
		}
		w.setSubjects(subjectList);

		return w;
	}

	private static Integer indexOf(String[] arr, String string) {
		for (int i = 0; i < arr.length; i++) {
			if (arr[i].equals(string)) {
				return i;
			}
		}
		return null;
	}

	private static Map<Work.Field, Integer> getObjectFormBinding(String[] header) {

		Map<Work.Field, Integer> bind = new HashMap<>();

		bind.put(Work.Field.TITLE, 4);
		bind.put(Work.Field.LIST_OF_AUTHORS, indexOf(header, "Lista Autori"));
		bind.put(Work.Field.YEAR, indexOf(header, "Anno Creazione"));
		bind.put(Work.Field.ABSTRACT, indexOf(header, "Descrizione"));
		bind.put(Work.Field.TYPE, indexOf(header, "Tipologia"));
		bind.put(Work.Field.URL, indexOf(header, "Link"));
		bind.put(Work.Field.IMGURL, indexOf(header, "Immagine"));
		bind.put(Work.Field.LANGUAGE, indexOf(header, "Lingua"));
		bind.put(Work.Field.COVERAGE, indexOf(header, "Copertura"));
		bind.put(Work.Field.LIST_OF_AUTHORS, indexOf(header, "Lista Autori"));
		bind.put(Work.Field.RIGHTS_HOLDER_NAME,
				indexOf(header, "Nome organizzazione detentore dei diritti sull'oggetto"));
		bind.put(Work.Field.RIGHTS_HOLDER_ACRONYM,
				indexOf(header, "Acronimo organizzazione detentore dei diritti sull'oggetto"));
		bind.put(Work.Field.RELATION, indexOf(header, "Pubblicazioni relative all'oggetto"));
		bind.put(Work.Field.AREA_SETTORE_DISCIPLINARE, indexOf(header, "Area del settore disciplinare"));
		bind.put(Work.Field.DISCIPLINA, indexOf(header, "Disciplina"));
		bind.put(Work.Field.AREA_SETTORE_DISCIPLINARE, indexOf(header, "Settore Affine"));
		bind.put(Work.Field.AREA_SETTORE_DISCIPLINARE, indexOf(header, "Tematica"));

		return bind;

	}

	public static Map<Work.Field, Integer> getIRISBinding(String[] header) {

		Map<Work.Field, Integer> bind = new HashMap<>();
		bind.put(Work.Field.LIST_OF_AUTHORS, indexOf(header, "dc.description.allpeople"));
		bind.put(Work.Field.TITLE, indexOf(header, "dc.title"));
		bind.put(Work.Field.YEAR, indexOf(header, "dc.date.issued"));
		bind.put(Work.Field.FIRST_PAGE, indexOf(header, "dc.relation.firstpage"));
		bind.put(Work.Field.LAST_PAGE, indexOf(header, "dc.relation.lastpage"));
		bind.put(Work.Field.LANGUAGE, indexOf(header, "dc.language.iso"));
		bind.put(Work.Field.URL, indexOf(header, "dc.identifier.url"));
		bind.put(Work.Field.DOI, indexOf(header, "dc.identifier.doi"));
		bind.put(Work.Field.TYPE, indexOf(header, "dc.type.full"));
		bind.put(Work.Field.ISBN_COLLECTION, indexOf(header, "dc.identifier.isbn"));
		bind.put(Work.Field.PUBLISHER_COLLECTION, indexOf(header, "dc.publisher.name"));
		bind.put(Work.Field.PUBLISHER_PLACE_COLLECTION, indexOf(header, "dc.publisher.place"));
		bind.put(Work.Field.TITLE_COLLECTION, indexOf(header, "dc.relation.ispartofbook"));
		bind.put(Work.Field.ABSTRACT, indexOf(header, "dc.description.abstract"));

		return bind;

	}

	private static void transformPublications(String xslFilePath, String outFolder) throws Exception {
		XLS xls = new XLS(xslFilePath);
		new File(outFolder).mkdirs();

		List<String[]> rows = xls.getRowsOfSheet(0);
		Map<Work.Field, Integer> binding = getIRISBinding(rows.get(0));

		WorkTransformer wt = new WorkTransformer();
		for (int i = 1; i < rows.size(); i++) {
			String[] row = rows.get(i);

			logger.info("Processing row {}", i);

			Work w = wt.transformIRISRow(row, binding);
			String id = URIGenerator.getURIWork(w.getTitle());

			Map<String, Object> root = new HashMap<>();
			root.put("work", w);

			Template temp = TransformerConfiguration.getInstance().getFreemarkerCfg().getTemplate("work.ftlh");
			FileWriter out = new FileWriter(new File(outFolder + "/" + id + ".rdf.xml"));
			StringWriter sw = new StringWriter();
			temp.process(root, out);
			temp.process(root, sw);

			Model m = org.apache.jena.rdf.model.ModelFactory.createDefaultModel();
			StringReader sr = new StringReader(sw.getBuffer().toString());
			m.read(sr, null);
			System.out.println();
			logger.info("RDF valido");
			logger.info("Numero di Triple {}", m.size());
		}
	}

	private static void transformFromFormObject(String sheet_id, String outFolder, String publicationsFolder)
			throws Exception {

		new File(outFolder).mkdirs();

		RowsIterator rit = new RowsIteratorGoogleSheets(sheet_id, "Risposte del modulo 1");

		String[] header = rit.next();
		Map<Work.Field, Integer> binding = getObjectFormBinding(header);

		WorkTransformer wt = new WorkTransformer();

		int i = 1;
		while (rit.hasNext()) {
			logger.info("Processing row {}", i++);

			String[] row = (String[]) rit.next();

			Work w = wt.transformObjectFromForm(row, binding, publicationsFolder);

			String id = URIGenerator.getIDFromString(w.getTitle() + "_" + row[0]);

			System.out.println(w.getURI());

			Map<String, Object> root = new HashMap<>();
			root.put("work", w);

			Template temp = TransformerConfiguration.getInstance().getFreemarkerCfg().getTemplate("work.ftlh");
			FileWriter out = new FileWriter(new File(outFolder + "/" + id + ".rdf.xml"));
			StringWriter sw = new StringWriter();
			temp.process(root, out);
			temp.process(root, sw);

			Model m = org.apache.jena.rdf.model.ModelFactory.createDefaultModel();
			StringReader sr = new StringReader(sw.getBuffer().toString());
			m.read(sr, null);
			System.out.println();
			logger.info("RDF valido");
			logger.info("Numero di Triple {}", m.size());

		}
	}

	public static void main(String[] args) throws Exception {

		boolean pub = false, formObject = true;

		if (pub)
			transformPublications("/Users/lgu/Desktop/ecodigit/pub.xlsx", "/Users/lgu/Desktop/ecodigit/Pubblicazioni");

		if (formObject)
			transformFromFormObject("1zy_98Jz2AvCEg_r4MyZnMt2QHJnTo0X_2mLLaVeIZ90",
					"/Users/lgu/Desktop/ecodigit/FormObjects", "/Users/lgu/Desktop/ecodigit/Pubblicazioni");

		// controllo validità dati

	}

}
