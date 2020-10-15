package it.cnr.istc.stlab;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.jena.ext.com.google.common.collect.Lists;
import org.apache.jena.rdf.model.Model;
import org.junit.Test;

import freemarker.core.ParseException;
import freemarker.template.MalformedTemplateNameException;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateNotFoundException;
import it.cnr.istc.stlab.ecodigit.transformer.TransformerConfiguration;
import it.cnr.istc.stlab.ecodigit.transformer.URIGenerator;
import it.cnr.istc.stlab.ecodigit.transformer.WorkTransformer;
import it.cnr.istc.stlab.ecodigit.transformer.model.DigitalDocument;
import it.cnr.istc.stlab.ecodigit.transformer.model.Membership;
import it.cnr.istc.stlab.ecodigit.transformer.model.Organization;
import it.cnr.istc.stlab.ecodigit.transformer.model.Person;
import it.cnr.istc.stlab.ecodigit.transformer.model.Role;
import it.cnr.istc.stlab.ecodigit.transformer.work.model.Work;

public class TestPublisher {

	static List<Person> getListOfPersonsFromAuthorList(String list) {
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

	@Test
	public void testTemplateWork() throws TemplateNotFoundException, MalformedTemplateNameException, ParseException,
			IOException, TemplateException {
		Work w = new Work();
		String authorString = "pippis, pippo; paperinis, paperino";
		w.setAuthorsString(authorString);
		w.setTitle("la casa nella prateria");
		w.setYear(2019);
		List<Person> authors = WorkTransformer.getListOfPersonsFromAuthorList(authorString);
		w.setAuthor(authors);
		String work_id = "http://example.org/" + URIGenerator.getIDWork(w);
		w.setURI(work_id);
		w.setIsbn("ISBN-DI-PROVA");
		Organization o = new Organization();
		o.setName("Organizzazione Publisher");
		o.setAcronym("PUB");
		o.setURI("http://example.org/PUB");
		o.setFulladdress("Indirizzo PUB");
		o.setLat(11);
		o.set_long(12);
		w.setPublisher(o);

		List<DigitalDocument> docs = new ArrayList<>();
		DigitalDocument d = new DigitalDocument();

		d.setDescription("Descrizione allegato");
		d.setTitle("Titolo");
		d.setUri("http://example.com/uriDigitalDocument");
		d.setUrl("http://example.com/urlAllegato");
		d.setLanguage("it");
		d.setMainEntity("http://example.com/uriEntity");
		docs.add(d);

		w.setDigitalDocuments(docs);

		Map<String, Object> root = new HashMap<>();
		root.put("work", w);

		Template temp = TransformerConfiguration.getInstance().getFreemarkerCfg().getTemplate("work.ftlh");
		StringWriter sw = new StringWriter();
		temp.process(root, sw);

		Model m = org.apache.jena.rdf.model.ModelFactory.createDefaultModel();
		StringReader sr = new StringReader(sw.getBuffer().toString());
		m.read(sr, null);
		m.write(System.out, "TTL");

	}

	@Test
	public void testTemplatePerson() throws TemplateNotFoundException, MalformedTemplateNameException, ParseException,
			IOException, TemplateException {
		Person p = new Person();

		p.setName("Luigi Asprino");
		p.setFamilyName("Asprino");
		p.set_long(10);
		p.setLat(11);
		p.setDescription("He is a good boy.");
		p.setFulladdress("Via San Martino della Battaglia 24");
		p.setGivenName("Luigi");
		p.setHomepage("http://luigiasprino.it");
		p.setImg("http://luigiasprino.it/img");
		Work w = new Work();
		String authorString = "pippis, pippo; paperinis, paperino";
		w.setAuthorsString(authorString);
		w.setTitle("la casa nella prateria");
		w.setYear(2019);
		String work_id = "http://example.org/" + URIGenerator.getIDWork(w);
		w.setURI(work_id);
		p.setMade(Lists.newArrayList(w));
		p.setMbox("luigi@luigi.it");
		Organization o = new Organization();
		o.setName("Organizzazione Publisher");
		o.setAcronym("PUB");
		o.setURI("http://example.org/PUB");
		o.setFulladdress("Indirizzo PUB");
		o.setLat(10);
		o.set_long(11);
		p.setMemberOf(Lists.newArrayList(o));
		p.setOrcid("0000-00000-0000");
		p.setURI("https://w3id/luigi");
		
		
		Membership mem= new Membership();
		mem.setOrganization(o);
		Role r = new Role();
		r.setLabel("Capo");
		r.setUri("http://example.com/capo");
		mem.setRole(r);
		p.setMemberships(Lists.newArrayList(mem));

		Map<String, Object> root = new HashMap<>();
		root.put("person", p);

		Template temp = TransformerConfiguration.getInstance().getFreemarkerCfg().getTemplate("person.ftlh");
		StringWriter sw = new StringWriter();
		temp.process(root, sw);

		Model m = org.apache.jena.rdf.model.ModelFactory.createDefaultModel();
		StringReader sr = new StringReader(sw.getBuffer().toString());
		m.read(sr, null);
		m.write(System.out, "TTL");

	}

}
