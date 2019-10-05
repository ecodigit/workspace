<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:bibo="http://purl.org/ontology/bibo/"
	xmlns:CLV="https://w3id.org/italia/onto/CLV/"
	xmlns:COV="https://w3id.org/italia/onto/COV/"
	xmlns:datacite="http://purl.org/spar/datacite/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:DUL="http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#"
	xmlns:ecodigit-org="https://w3id.org/ecodigit/ontology/organization/"
	xmlns:fabio="http://purl.org/spar/fabio/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:frbr="http://purl.org/vocab/frbr/core#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:l0="https://w3id.org/italia/onto/l0/"
	xmlns:literal="http://www.essepuntato.it/2010/06/literalreification/"
	xmlns:org="http://www.w3.org/ns/org#"
	xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/"
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:schemaorg="https://schema.org/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:SM="https://w3id.org/italia/onto/SM/"
	xmlns:wgs84="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:locn="https://www.w3.org/ns/locn#"
	xmlns:a-loc="https://w3id.org/arco/ontology/location/"
	xmlns:sf="http://www.opengis.net/ont/sf#"
	xmlns:a-res-city="https://w3id.org/arco/resource/City/"
	xmlns:a-cat="https://w3id.org/arco/ontology/catalogue/"
	xmlns:pss="https://w3id.org/pss/"
	xmlns:gs="http://www.opengis.net/ont/geosparql#"
	xmlns:arco="https://w3id.org/arco/ontology/arco/"
	xmlns:a-res-add="https://w3id.org/arco/resource/Address/"
	xmlns:xalan="http://xml.apache.org/xalan">

	<xsl:output method="xml" encoding="utf-8" indent="yes" />
	<!-- <xsl:include href="lib/utils.xsl" /> -->

	<xsl:key name="about" match="*" use="@rdf:about" />

	<xsl:template name="resolveRif">
		<xsl:param name="elem" />
		<xsl:choose>
			<xsl:when test="$elem/@rdf:resource">
				<xsl:copy-of select="key('about',$elem/@rdf:resource)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$elem/*" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template
		match="//rdf:Description[rdf:type[*[@rdf:about='https://w3id.org/pss/CrawledResource']]]|pss:CrawledResource">

		<xsl:variable name="uriObject" select="@rdf:about" />

		<rdf:RDF>
			<rdf:Description rdf:about="{$uriObject}">

				<rdf:type>
					<rdf:Description
						rdf:about="http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#Object">
						<rdfs:label xml:lang="it">Oggetto</rdfs:label>
					</rdf:Description>
				</rdf:type>


				<xsl:if test="rdfs:label">
					<dc:title>
						<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
						<xsl:value-of
							select="normalize-space(rdfs:label/text())" />
						<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
					</dc:title>
				</xsl:if>


				<xsl:if
					test="a-cat:isDescribedByCatalogueRecord/*/a-cat:systemRecordCode">
					<dc:identifier>
						<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
						<xsl:value-of
							select="normalize-space(a-cat:isDescribedByCatalogueRecord/*/a-cat:systemRecordCode/text())" />
						<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
					</dc:identifier>

					<SM:URL
						rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
						<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
						<xsl:value-of
							select="normalize-space(concat('http://www.catalogo.beniculturali.it/sigecSSU_FE/schedaCompleta.action?keycode=', a-cat:isDescribedByCatalogueRecord/*/a-cat:systemRecordCode/text()))" />
						<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
					</SM:URL>


				</xsl:if>

				<xsl:if test="arco:description">
					<dc:description xml:lang="it">
						<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
						<xsl:value-of
							select="normalize-space(arco:description/text())" />
						<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
					</dc:description>
				</xsl:if>

				<dcterms:subject>
					<rdf:Description
						rdf:about="http://dbpedia.org/resource/Cultural_heritage">
						<rdfs:label xml:lang="en">Cultural Heritage</rdfs:label>
						<rdfs:label xml:lang="it">Patrimonio Culturale</rdfs:label>
					</rdf:Description>
				</dcterms:subject>

				<dcterms:subject>
					<rdf:Description
						rdf:about="https://w3id.org/ecodigit/resource/Scienze_dell%27antichit%C3%A0%2C_filologico-letterarie_e_storico-artistiche">
						<rdfs:label xml:lang="it"><![CDATA[Scienze dell'antichità, filologico-letterarie e storico-artistiche]]></rdfs:label>
					</rdf:Description>
				</dcterms:subject>

				<dcterms:subject>
					<rdf:Description
						rdf:about="https://w3id.org/ecodigit/resource/Beni_Culturali">
						<rdfs:label xml:lang="it"><![CDATA[Beni Culturali]]></rdfs:label>
					</rdf:Description>
				</dcterms:subject>

				<dcterms:subject>
					<rdf:Description
						rdf:about="https://w3id.org/ecodigit/resource/Turismo">
						<rdfs:label xml:lang="it"><![CDATA[Turismo]]></rdfs:label>
					</rdf:Description>
				</dcterms:subject>

				<dcterms:subject>
					<rdf:Description
						rdf:about="https://w3id.org/ecodigit/resource/Scheda_informativa">
						<rdfs:label xml:lang="it"><![CDATA[Scheda informativa]]></rdfs:label>
					</rdf:Description>
				</dcterms:subject>

				<dcterms:rightsHolder>
					<org:Organization
						rdf:about="https://w3id.org/ecodigit/organization/mibact">
						<foaf:name><![CDATA[Ministero dei Beni e delle attività Culturali e del Turismo]]></foaf:name>
					</org:Organization>
				</dcterms:rightsHolder>

				<dc:relation>
					<rdf:Description
						rdf:about="https://w3id.org/ecodigit/publication/Carriero2019">
						<dc:title><![CDATA[ArCo: the Italian Cultural Heritage Knowledge Graph]]></dc:title>
						<fabio:hasURL
							rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI"><![CDATA[https://arxiv.org/abs/1905.02840]]></fabio:hasURL>
					</rdf:Description>
				</dc:relation>

				<xsl:choose>
					<xsl:when
						test="a-loc:hasTimeIndexedTypedLocation/*/a-loc:atSite/*/locn:geometry">
						<locn:geometry>
							<sf:Point>
								<geo:asWKT
									rdf:datatype="http://www.opengis.net/ont/geosparql#wktLiteral">
									<xsl:text disable-output-escaping="yes">&lt;![CDATA[ &lt;http://www.opengis.net/def/crs/OGC/1.3/CRS84&gt; </xsl:text>
									<xsl:value-of
										select="normalize-space(concat('POINT(', a-loc:hasTimeIndexedTypedLocation/*/a-loc:atSite/*/locn:geometry/*/wgs84:long,',',a-loc:hasTimeIndexedTypedLocation/*/a-loc:atSite/*/locn:geometry/*/wgs84:lat,')'))" />
									<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
								</geo:asWKT>

								<wgs84:lat>
									<xsl:value-of
										select="normalize-space(a-loc:hasTimeIndexedTypedLocation/*/a-loc:atSite/*/locn:geometry/*/wgs84:lat)" />
								</wgs84:lat>
								<wgs84:long>
									<xsl:value-of
										select="normalize-space(a-loc:hasTimeIndexedTypedLocation/*/a-loc:atSite/*/locn:geometry/*/wgs84:long)" />
								</wgs84:long>
							</sf:Point>
						</locn:geometry>
					</xsl:when>
					<xsl:otherwise>

						<xsl:if
							test="a-loc:hasCulturalPropertyAddress/*/CLV:hasCity/*/locn:geometry">
							<locn:geometry>
								<sf:Point>
									<geo:asWKT
										rdf:datatype="http://www.opengis.net/ont/geosparql#wktLiteral">
										<xsl:text disable-output-escaping="yes">&lt;![CDATA[ &lt;http://www.opengis.net/def/crs/OGC/1.3/CRS84&gt; </xsl:text>
										<xsl:value-of
											select="normalize-space(concat('POINT(', a-loc:hasCulturalPropertyAddress/*/CLV:hasCity/*/locn:geometry/*/wgs84:long,',',a-loc:hasCulturalPropertyAddress/*/CLV:hasCity/*/locn:geometry/*/wgs84:lat,')'))" />
										<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
									</geo:asWKT>

									<wgs84:lat>
										<xsl:value-of
											select="normalize-space(a-loc:hasCulturalPropertyAddress/*/CLV:hasCity/*/locn:geometry/*/wgs84:lat)" />
									</wgs84:lat>
									<wgs84:long>
										<xsl:value-of
											select="normalize-space(a-loc:hasCulturalPropertyAddress/*/CLV:hasCity/*/locn:geometry/*/wgs84:long)" />
									</wgs84:long>
								</sf:Point>
							</locn:geometry>
						</xsl:if>

					</xsl:otherwise>
				</xsl:choose>
			</rdf:Description>


			<!-- Provenance -->
			<prov:Entity rdf:about="{$uriObject}">
				<prov:wasGeneratedBy>
					<prov:Activity>
						<rdfs:comment><![CDATA[Integrazione con il sistema ArCo]]></rdfs:comment>
						<prov:wasAssociatedWith>
							<rdf:Description
								rdf:about="https://w3id.org/italia/data/organization/support-unit/cnr-Z6HZEH/stlab">
								<foaf:name><![CDATA[Istituto di Scienze e Tecnologie della Cognizione del CNR - Semantic Technology Lab (STLab)]]></foaf:name>
							</rdf:Description>
						</prov:wasAssociatedWith>
						<prov:used rdf:resource="https://w3id.org/arco" />
						<prov:startedAtTime
							rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2019-09-27T03:40:00Z</prov:startedAtTime>
						<prov:endedAtTime
							rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2019-09-27T03:40:00Z</prov:endedAtTime>
					</prov:Activity>
				</prov:wasGeneratedBy>
			</prov:Entity>


			<xsl:if
				test="a-cat:isDescribedByCatalogueRecord/*/a-cat:systemRecordCode">


				<schemaorg:DigitalDocument
					rdf:about="{normalize-space(concat('https://w3id.org/ecodigit/document/', a-cat:isDescribedByCatalogueRecord/*/a-cat:systemRecordCode/text()))}">
					<dc:title>
						<xsl:value-of
							select="normalize-space(concat('Scheda catalografica ', a-cat:isDescribedByCatalogueRecord/*/a-cat:systemRecordCode/text()))" />
					</dc:title>
					<dc:description>
						<xsl:value-of
							select="normalize-space(concat('Scheda catalografica ', a-cat:isDescribedByCatalogueRecord/*/a-cat:systemRecordCode/text()))" />
					</dc:description>
					<schemaorg:inLanguage>it</schemaorg:inLanguage>
					<schemaorg:mainEntity
						rdf:resource="{$uriObject}" />
					<schemaorg:url
						rdf:resource="{normalize-space(concat('http://www.catalogo.beniculturali.it/sigecSSU_FE/schedaCompleta.action?keycode=', a-cat:isDescribedByCatalogueRecord/*/a-cat:systemRecordCode/text()))}" />
				</schemaorg:DigitalDocument>


			</xsl:if>





		</rdf:RDF>

	</xsl:template>

	<xsl:template match="*/text()" />

</xsl:stylesheet>