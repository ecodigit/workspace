package it.cnr.istc.stlab.ecodigit.transformer.work.model;

import java.util.ArrayList;
import java.util.List;

import it.cnr.istc.stlab.ecodigit.transformer.model.Klass;
import it.cnr.istc.stlab.ecodigit.transformer.model.Organization;
import it.cnr.istc.stlab.ecodigit.transformer.model.Person;
import it.cnr.istc.stlab.ecodigit.transformer.model.Provenance;
import it.cnr.istc.stlab.ecodigit.transformer.model.Resource;

public class Work {

	public enum Field {
		TITLE, LIST_OF_AUTHORS, YEAR, FIRST_PAGE, LAST_PAGE, URL, LANGUAGE, DOI, TYPE, ISBN_COLLECTION,
		PUBLISHER_COLLECTION, PUBLISHER_PLACE_COLLECTION, TITLE_COLLECTION, ABSTRACT, IMGURL, COVERAGE,
		RIGHTS_HOLDER_NAME, RIGHTS_HOLDER_ACRONYM, RELATION, AREA_SETTORE_DISCIPLINARE, DISCIPLINA, SETTORE_AFFINE,
		TEMATICA, LAT,LON
	}

	private String URI, title, language, URL, doi, _abstract, isbn, identifier, authorsString, imgURL, lat, lon;
	private Integer startPage, endPage, extent, year;
	private List<Identifier> identifiers = new ArrayList<>();
	private List<String> keywords = new ArrayList<>();
	private List<Klass> types = new ArrayList<>();
	private Work isPartOf;
	private List<Person> editor = new ArrayList<>();
	private List<Person> author = new ArrayList<>();
	private Agent publisher;
	private List<Agent> contributors = new ArrayList<>();
	private Provenance provenance;
	private List<Resource> coverages = new ArrayList<>();
	private List<Resource> subjects = new ArrayList<>();
	private Organization rightsHolder;
	private List<Work> relations = new ArrayList<>();

	public String getURI() {
		return URI;
	}

	public void setURI(String uRI) {
		URI = uRI;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public String getURL() {
		return URL;
	}

	public void setURL(String uRL) {
		URL = uRL;
	}

	public String getDoi() {
		return doi;
	}

	public void setDoi(String doi) {
		this.doi = doi;
	}

	public String get_abstract() {
		return _abstract;
	}

	public void set_abstract(String _abstract) {
		this._abstract = _abstract;
	}

	public String getIsbn() {
		return isbn;
	}

	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public Integer getStartPage() {
		return startPage;
	}

	public void setStartPage(Integer startPage) {
		this.startPage = startPage;
	}

	public Integer getEndPage() {
		return endPage;
	}

	public void setEndPage(Integer endPage) {
		this.endPage = endPage;
	}

	public Integer getExtent() {
		return extent;
	}

	public void setExtent(Integer extent) {
		this.extent = extent;
	}

	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public List<Identifier> getIdentifiers() {
		return identifiers;
	}

	public void setIdentifiers(List<Identifier> identifiers) {
		this.identifiers = identifiers;
	}

	public List<String> getKeywords() {
		return keywords;
	}

	public void setKeywords(List<String> keywords) {
		this.keywords = keywords;
	}

	public List<Klass> getTypes() {
		return types;
	}

	public void setTypes(List<Klass> types) {
		this.types = types;
	}

	public List<Person> getEditor() {
		return editor;
	}

	public void setEditor(List<Person> editor) {
		this.editor = editor;
	}

	public List<Person> getAuthor() {
		return author;
	}

	public void setAuthor(List<Person> author) {
		this.author = author;
	}

	public Work getIsPartOf() {
		return isPartOf;
	}

	public void setIsPartOf(Work isPartOf) {
		this.isPartOf = isPartOf;
	}

	public Agent getPublisher() {
		return publisher;
	}

	public void setPublisher(Agent organization) {
		this.publisher = organization;
	}

	public String getAuthorsString() {
		return authorsString;
	}

	public void setAuthorsString(String authorsString) {
		this.authorsString = authorsString;
	}

	public Provenance getProvenance() {
		return provenance;
	}

	public void setProvenance(Provenance provenance) {
		this.provenance = provenance;
	}

	public List<Agent> getContributors() {
		return contributors;
	}

	public void setContributors(List<Agent> contributors) {
		this.contributors = contributors;
	}

	public List<Resource> getCoverages() {
		return coverages;
	}

	public void setCoverages(List<Resource> coverages) {
		this.coverages = coverages;
	}

	public List<Resource> getSubjects() {
		return subjects;
	}

	public void setSubjects(List<Resource> subjects) {
		this.subjects = subjects;
	}

	public Organization getRightsHolder() {
		return rightsHolder;
	}

	public void setRightsHolder(Organization rightsHolder) {
		this.rightsHolder = rightsHolder;
	}

	public List<Work> getRelations() {
		return relations;
	}

	public void setRelations(List<Work> relations) {
		this.relations = relations;
	}

	public String getImgURL() {
		return imgURL;
	}

	public void setImgURL(String imgURL) {
		this.imgURL = imgURL;
	}

	public String getLat() {
		return lat;
	}

	public void setLat(String lat) {
		this.lat = lat;
	}

	public String getLon() {
		return lon;
	}

	public void setLon(String lon) {
		this.lon = lon;
	}
	
	

}