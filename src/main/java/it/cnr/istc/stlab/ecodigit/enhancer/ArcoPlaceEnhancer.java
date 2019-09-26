package it.cnr.istc.stlab.ecodigit.enhancer;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;

import org.apache.jena.query.QueryExecution;
import org.apache.jena.query.QueryExecutionFactory;
import org.apache.jena.query.QuerySolution;
import org.apache.jena.query.ResultSet;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.riot.Lang;
import org.apache.jena.riot.RDFDataMgr;
import org.apache.jena.vocabulary.RDF;

import it.cnr.istc.stlab.lgu.commons.entitylinking.Geonames;
import it.cnr.istc.stlab.lgu.commons.files.FileUtils;

public class ArcoPlaceEnhancer {

//	private static Logger logger = LoggerFactory.getLogger(ArcoPlaceEnhancer.class);

	private static void addGeoNames(String folder) {

		String q = "SELECT ?a ?l {" + "?c <https://w3id.org/arco/ontology/location/hasCulturalPropertyAddress> ?ad . "
				+ "?ad <https://w3id.org/italia/onto/CLV/hasCity> ?a . "
				+ "?a <https://w3id.org/italia/onto/l0/name> ?l ." + "}";

		String q2 = "PREFIX gn: <http://www.geonames.org/ontology#> "
				+ "PREFIX wgs84: <http://www.w3.org/2003/01/geo/wgs84_pos#> " + "SELECT ?lat ?lon {"
				+ "?f a gn:Feature . " + "?f wgs84:lat ?lat . " + "?f wgs84:long ?lon . " + "}";

		for (String f : FileUtils.getFilesUnderTreeRec(folder)) {
			Model m = ModelFactory.createDefaultModel();
			System.out.print("Processing file " + f + " ");
			try {
				RDFDataMgr.read(m, f);
				QueryExecution qexec = QueryExecutionFactory.create(q, m);
				ResultSet rs = qexec.execSelect();
				while (rs.hasNext()) {
					QuerySolution qs = (QuerySolution) rs.next();
					String l = qs.getLiteral("l").toString();
					String a = qs.getResource("a").getURI();
					if (l != null) {
						String[] la = l.split(",");
						if (la.length > 0) {
							String gn = Geonames.getGeoNamesRDF(la[la.length - 1]);
							if (gn != null) {
								System.out.print("Found GeoNames");
								Model gn_model = ModelFactory.createDefaultModel();
								RDFDataMgr.read(gn_model, new ByteArrayInputStream(gn.getBytes()), Lang.RDFXML);
								QueryExecution qexecGn = QueryExecutionFactory.create(q2, gn_model);
								ResultSet rsGn = qexecGn.execSelect();
								if (rsGn.hasNext()) {
									QuerySolution qsGn = (QuerySolution) rsGn.next();
									String lat = qsGn.getLiteral("lat").toString();
									String lon = qsGn.getLiteral("lon").toString();
									m.add(getGeometry(a, lat, lon));
									m.write(new FileOutputStream(new File(f)));
									System.out.print(" model written!");
								}
							}
						}
					}

				}

			} catch (Exception e) {
				e.getMessage();
			}
			System.out.println();
		}

	}

	private static Model getGeometry(String r, String lat, String lon) {
		Model m = ModelFactory.createDefaultModel();
		String pointUri = r + "/geometry";
		m.add(m.getResource(r), m.createProperty("https://www.w3.org/ns/locn#geometry"), m.createResource(pointUri));
		m.add(m.createResource(pointUri), RDF.type, m.createResource("http://www.opengis.net/ont/sf#Point"));
		m.add(m.createResource(pointUri), m.getProperty("http://www.opengis.net/ont/geosparql#asWKT"),
				m.createTypedLiteral(
						"<![CDATA[<http://www.opengis.net/def/crs/OGC/1.3/CRS84> POINT(" + lon + " " + lat + ")]]>",
						"http://www.opengis.net/ont/geosparql#wktLiteral"));
		m.add(m.createResource(pointUri), m.createProperty("http://www.w3.org/2003/01/geo/wgs84_pos#lat"), lat);
		m.add(m.createResource(pointUri), m.createProperty("http://www.w3.org/2003/01/geo/wgs84_pos#long"), lon);

		return m;
	}

	public static void main(String[] args) {
		addGeoNames("/Users/lgu/Desktop/ecodigit/CulturalObject");
	}

}
