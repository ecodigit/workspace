package it.cnr.istc.stlab.ecodigit.transformer;

import java.io.File;
import java.io.FileWriter;
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

import org.apache.jena.ext.com.google.common.collect.Lists;
import org.apache.jena.rdf.model.Model;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import freemarker.template.Template;
import it.cnr.istc.stlab.ecodigit.transformer.model.Organization;
import it.cnr.istc.stlab.ecodigit.transformer.model.Person;
import it.cnr.istc.stlab.ecodigit.transformer.work.model.Work;
import it.cnr.istc.stlab.lgu.commons.tables.RowsIterator;
import it.cnr.istc.stlab.lgu.commons.tables.RowsIteratorGoogleSheets;
import it.cnr.istc.stlab.lgu.commons.tables.XLS;

public class PersonTransformer {

	private static Logger logger = LoggerFactory.getLogger(WorkTransformer.class);

	public Person transformPersonFromForm(String[] row, Map<Person.Field, Integer> bind, String publicationsFolder)
			throws Exception {

		Person p = new Person();

		p.setGivenName(row[bind.get(Person.Field.GIVEN_NAME)]);
		p.setFamilyName(row[bind.get(Person.Field.FAMILY_NAME)]);
		p.setImg(TrasformerUtils.getStringField(row, bind.get(Person.Field.IMG)));
		p.setHomepage(TrasformerUtils.getStringField(row, bind.get(Person.Field.HOMEPAGE)));
		p.setOrcid(TrasformerUtils.getStringField(row, bind.get(Person.Field.ORCID)));
		p.setDescription(TrasformerUtils.getStringField(row, bind.get(Person.Field.DESCRIPTION)));

		String r = TrasformerUtils.getStringField(row, bind.get(Person.Field.PUBLICATIONS));
		List<Work> relations = new ArrayList<>();
		if (r != null) {
			try {
				transformPublications(r, publicationsFolder, relations);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		p.setMade(relations);

		String aff_name = TrasformerUtils.getStringField(row, bind.get(Person.Field.AFFILIATION_NAME));
		String aff_acr = TrasformerUtils.getStringField(row, bind.get(Person.Field.AFFILIATION_ACRONYM));
		String aff_add = TrasformerUtils.getStringField(row, bind.get(Person.Field.AFFILIATION_ADDRESS));

		if (aff_name != null && aff_acr != null) {
			Organization org = new Organization();
			org.setName(aff_name);
			org.setAcronym(aff_acr);
			org.setURI(URIGenerator.getURIOrganization(aff_acr));
			org.setFulladdress(aff_add);
			p.setMembership(Lists.newArrayList(org));
		}

		return p;

	}

	private static void transformPublications(String r, String publicationsFolder, List<Work> relations)
			throws Exception {
		String id = r.replace("https://drive.google.com/open?id=", "");
		String downloadURL = "https://drive.google.com/uc?id=" + id + "&export=download";
		InputStream in = new URL(downloadURL).openStream();
		Files.copy(in, Paths.get(id), StandardCopyOption.REPLACE_EXISTING);

		XLS xls = new XLS(id);
		List<String[]> rows = xls.getRowsOfSheet(0);
		Map<Work.Field, Integer> binding = WorkTransformer.getIRISBinding(rows.get(0));

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
			}

			if (!completed && new File(publicationsFolder + "/" + work_id + ".rdf.xml").exists()) {
				Files.delete(Paths.get(publicationsFolder + "/" + work_id + ".rdf.xml"));
			}

		}
	}

	private static Map<Person.Field, Integer> getPersonFormBinding(String[] header) {

		Map<Person.Field, Integer> bind = new HashMap<>();

		bind.put(Person.Field.GIVEN_NAME, 4);
		bind.put(Person.Field.FAMILY_NAME, 5);
		bind.put(Person.Field.IMG, TrasformerUtils.indexOf(header, "Link a immagine profilo"));
		bind.put(Person.Field.HOMEPAGE, TrasformerUtils.indexOf(header, "Sito web personale"));
		bind.put(Person.Field.ORCID, TrasformerUtils.indexOf(header, "ORCID"));
		bind.put(Person.Field.DESCRIPTION, TrasformerUtils.indexOf(header, "Short Bio"));
		bind.put(Person.Field.PUBLICATIONS, TrasformerUtils.indexOf(header, "Pubblicazioni"));
		bind.put(Person.Field.AFFILIATION_NAME, TrasformerUtils.indexOf(header, "Nome Organizzazione 1"));
		bind.put(Person.Field.AFFILIATION_ACRONYM, TrasformerUtils.indexOf(header, "Acronimo Organizzazione 1"));
		bind.put(Person.Field.AFFILIATION_ADDRESS, TrasformerUtils.indexOf(header, "Indirizzo Organizzazione 1"));

		return bind;

	}

	private static void transformFromFormPerson(String sheet_id, String outFolder, String publicationsFolder)
			throws Exception {

		new File(outFolder).mkdirs();

		RowsIterator rit = new RowsIteratorGoogleSheets(sheet_id, "Risposte del modulo 1");

		String[] header = rit.next();
		Map<Person.Field, Integer> binding = getPersonFormBinding(header);

		PersonTransformer pt = new PersonTransformer();

		int i = 1;
		while (rit.hasNext()) {
			logger.info("Processing row {}", i++);

			String[] row = (String[]) rit.next();

			Person p = pt.transformPersonFromForm(row, binding, publicationsFolder);
			p.setURI(URIGenerator.getURIPerson(p));

			Map<String, Object> root = new HashMap<>();
			root.put("person", p);

			Template temp = TransformerConfiguration.getInstance().getFreemarkerCfg().getTemplate("person.ftlh");
			FileWriter out = new FileWriter(
					new File(outFolder + "/" + p.getGivenName() + "_" + p.getFamilyName() + ".rdf.xml"));
			StringWriter sw = new StringWriter();
			temp.process(root, out);
			temp.process(root, sw);

			Model m = org.apache.jena.rdf.model.ModelFactory.createDefaultModel();
			StringReader sr = new StringReader(sw.getBuffer().toString());
			m.read(sr, null);
			logger.info("RDF valido");
			logger.info("Numero di Triple {}", m.size());

		}
	}

	public static void main(String[] args) throws Exception {

		transformFromFormPerson("1sFKzCJFOo8Gw3-26Cj8CUr8ZjWN9CO6m1lZMBo-k_Ko", "/Users/lgu/Desktop/ecodigit/Persons",
				"/Users/lgu/Desktop/ecodigit/Pubblicazioni");

	}

}
