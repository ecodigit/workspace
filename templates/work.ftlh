<?xml version="1.0" encoding="utf-8"?>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:bibo="http://purl.org/ontology/bibo/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:org="http://www.w3.org/ns/org#"
	xmlns:CLV="https://w3id.org/italia/onto/CLV/"
	xmlns:fabio="http://purl.org/spar/fabio/"
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:datacite="http://purl.org/spar/datacite/"
	xmlns:literal="http://www.essepuntato.it/2010/06/literalreification/"
	xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/"
	xmlns:schemaorg="https://schema.org/"
	xmlns:frbr="http://purl.org/vocab/frbr/core#"
	xmlns:SM="https://w3id.org/italia/onto/SM/"
	xmlns:locn="https://www.w3.org/ns/locn#"
	xmlns:sf="http://www.opengis.net/ont/sf#"
	xmlns:geo="http://www.opengis.net/ont/geosparql#"
	xmlns:l0="https://w3id.org/italia/onto/l0/"
	xmlns:DUL="http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#"
	xmlns:geo_wgs84="http://www.w3.org/2003/01/geo/wgs84_pos#">


	<rdf:Description rdf:about="${work.URI}">
		<!-- Vista Generica sull'oggetto -->
		<rdf:type>
			<rdf:Description rdf:about="http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#Object">
				<rdfs:label xml:lang="it">Oggetto</rdfs:label>
			</rdf:Description>
		</rdf:type>
		<dc:title><![CDATA[${work.title}]]></dc:title>
		<#if work.identifier??>
		<dc:identifier><![CDATA[${work.identifier}]]></dc:identifier>
		</#if>
		<#if work.isbn??>
		<datacite:hasIdentifier>
			<datacite:ResourceIdentifier>
				<literal:hasLiteralValue><![CDATA[${work.isbn}]]></literal:hasLiteralValue>
				<datacite:usesIdentifierScheme>
					<datacite:ResourceIdentifierScheme rdf:about="http://purl.org/spar/datacite/isbn">
						<fabio:hasURL rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">http://www.isbn-international.org/</fabio:hasURL>
						<rdfs:label>ISBN</rdfs:label>
					</datacite:ResourceIdentifierScheme>
				</datacite:usesIdentifierScheme>
			</datacite:ResourceIdentifier>
		</datacite:hasIdentifier>
		<bibo:isbn>${work.isbn}</bibo:isbn>
		</#if>
		<#if work.publisher??>
				<dcterms:publisher>
					<org:Organization rdf:about="${work.publisher.URI}">
						<foaf:name>${work.publisher.name}</foaf:name>
						<#if work.publisher.fulladdress??>
						<org:hasSite>
							<org:Site>
								<CLV:hasAddress>
									<CLV:Address>
										<CLV:fullAddress><![CDATA[${work.publisher.fulladdress}]]></CLV:fullAddress>
									</CLV:Address>
								</CLV:hasAddress>
								<#if (work.publisher.lat!=0) && (work.publisher._long!=0) ??>
								<locn:geometry>
									<sf:Point>
										<geo:asWKT rdf:datatype= "http://www.opengis.net/ont/geosparql#wktLiteral">
											<![CDATA[<http://www.opengis.net/def/crs/OGC/1.3/CRS84> POINT(${work.publisher._long} ${work.publisher.lat})]]>
										</geo:asWKT>
										<geo_wgs84:lat>${work.publisher.lat}</geo_wgs84:lat>
										<geo_wgs84:long>${work.publisher._long}</geo_wgs84:long>
									</sf:Point>
								</locn:geometry>
								</#if>
							</org:Site>
						</org:hasSite>
						</#if>
				</org:Organization>
			</dcterms:publisher>
		</#if>
		<#if work._abstract??>
		<dc:description><![CDATA[${work._abstract}]]></dc:description>
		<bibo:abstract><![CDATA[${work._abstract}]]></bibo:abstract>
		</#if>
		<#if work.language??>
		<dc:language>${work.language}</dc:language>
		</#if>
		<#if work.year??>
		<dc:date>${work.year}</dc:date>
		</#if>
		<#if work.lat?? && work.lon??>
		<locn:geometry>
			<sf:Point>
				<geo:asWKT rdf:datatype= "http://www.opengis.net/ont/geosparql#wktLiteral">
					<![CDATA[<http://www.opengis.net/def/crs/OGC/1.3/CRS84> POINT(${work.lon} ${work.lat})]]>
				</geo:asWKT>
				<geo_wgs84:lat>${work.lat}</geo_wgs84:lat>
				<geo_wgs84:long>${work.lon}</geo_wgs84:long>
			</sf:Point>
		</locn:geometry>
		</#if>
		<#if work.authorsString??>
		<dc:creator><![CDATA[${work.authorsString}]]></dc:creator>
		</#if>
		<#list work.contributors as contributor>
		<dc:contributor>
			<rdf:Description rdf:about="${contributor.URI}">
				<foaf:name>${contributor.name}</foaf:name>
			</rdf:Description>
		</dc:contributor>
		</#list>
		<#list work.coverages as coverage>
		<dc:coverage>
			<rdf:Description rdf:about="${coverage.uri}">
				<rdfs:label xml:lang="it">${coverage.label}</rdfs:label>
			</rdf:Description>
		</dc:coverage>
		</#list>
		<#list work.subjects as subject>
		<dcterms:subject>
			<rdf:Description rdf:about="${subject.uri}">
				<rdfs:label xml:lang="it">${subject.label}</rdfs:label>
			</rdf:Description>
		</dcterms:subject>
		</#list>
		<#if work.rightsHolder??>
		<dcterms:rightsHolder>
			<org:Organization rdf:about="${work.rightsHolder.URI}">
				<foaf:name>${work.rightsHolder.name}</foaf:name>
			</org:Organization>
		</dcterms:rightsHolder>
		</#if>
		<#list work.relations as relation>
		<dc:relation>
			<rdf:Description rdf:about="${relation.URI}">
				<dc:title>${relation.title}</dc:title>
				<#if relation.URL??>
				<fabio:hasURL rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${relation.URL}</fabio:hasURL>
				</#if>				
			</rdf:Description>
		</dc:relation>
		</#list>
		<#if work.URL??>
		<SM:URL rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${work.URL}</SM:URL>
		</#if>
		<#list work.author as a>
    	<frbr:creator>
			<foaf:Person rdf:about="${a.URI}">
				<foaf:givenname>${a.givenName}</foaf:givenname>
				<foaf:family_name>${a.familyName}</foaf:family_name>
			</foaf:Person>
		</frbr:creator>
  		</#list>
  		<#if work.imgURL??>
  		<SM:hasImage>
			<SM:Image>
				<SM:URL rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${work.imgURL}</SM:URL>
			</SM:Image>
		</SM:hasImage>
  		</#if>
		<!-- Vista particolare per pubblicazioni -->
		<#if work.startPage??>
		<bibo:pageStart>${work.startPage}</bibo:pageStart>
		</#if>
		<#if work.endPage??>
		<bibo:pageEnd>${work.endPage}</bibo:pageEnd>
		</#if>
		<#if work.extent??>
		<dcterms:extent>${work.extent}</dcterms:extent>
		</#if>
		<#list work.identifiers as identifier>
		<datacite:hasIdentifier>
			<datacite:ResourceIdentifier>
				<literal:hasLiteralValue><![CDATA[${identifier.literalValue}]]></literal:hasLiteralValue>
				<datacite:usesIdentifierScheme>
					<datacite:ResourceIdentifierScheme rdf:about="${identifier.usesIdentifierScheme.uri}">
						<fabio:hasURL rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${identifier.usesIdentifierScheme.url}</fabio:hasURL>
						<rdfs:label>${identifier.usesIdentifierScheme.label}</rdfs:label>
					</datacite:ResourceIdentifierScheme>
				</datacite:usesIdentifierScheme>
			</datacite:ResourceIdentifier>
		</datacite:hasIdentifier>
  		</#list>
		<#if work.doi??>
		<bibo:doi><![CDATA[${work.doi}]]></bibo:doi>
		</#if>
		<#list work.types as type>
		<rdf:type>
			<rdf:Description rdf:about="${type.uri}">
				<rdfs:label>${type.label}</rdfs:label>
			</rdf:Description>
		</rdf:type>
		</#list>
		<#list work.keywords as keyword>
		<prism:keyword xml:lang="en">${keyword}</prism:keyword>
		</#list>
		<#if work.isPartOf??>
		<dcterms:isPartOf>
			<rdf:Description rdf:about="${work.isPartOf.URI}">
				<dc:title><![CDATA[${work.isPartOf.title}]]></dc:title>
				<#if work.isPartOf.isbn??>
				<datacite:hasIdentifier>
					<datacite:ResourceIdentifier>
						<literal:hasLiteralValue><![CDATA[${work.isPartOf.isbn}]]></literal:hasLiteralValue>
						<datacite:usesIdentifierScheme>
							<datacite:ResourceIdentifierScheme rdf:about="http://purl.org/spar/datacite/isbn">
								<fabio:hasURL rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">http://www.isbn-international.org/</fabio:hasURL>
								<rdfs:label>ISBN</rdfs:label>
							</datacite:ResourceIdentifierScheme>
						</datacite:usesIdentifierScheme>
					</datacite:ResourceIdentifier>
				</datacite:hasIdentifier>
				<bibo:isbn>${work.isPartOf.isbn}</bibo:isbn>
				<dc:identifier><![CDATA[${work.isPartOf.isbn}]]></dc:identifier>
				</#if>
				<#if work.isPartOf.publisher??>
				<dcterms:publisher>
					<org:Organization rdf:about="${work.isPartOf.publisher.URI}">
						<foaf:name>${work.isPartOf.publisher.name}</foaf:name>
						<#if work.isPartOf.publisher.fulladdress??>
						<org:hasSite>
							<org:Site>
								<CLV:hasAddress>
									<CLV:Address>
										<CLV:fullAddress><![CDATA[${work.isPartOf.publisher.fulladdress}]]></CLV:fullAddress>
								</CLV:Address>
								</CLV:hasAddress>
							</org:Site>
						</org:hasSite>
						</#if>
					</org:Organization>
				</dcterms:publisher>
				</#if>
			</rdf:Description>
		</dcterms:isPartOf>
		</#if>
		<#if  work.author?has_content>
	  	<bibo:authorList>
	  		<rdf:Seq>
	  			<#list work.author as a>
	 				<rdf:li rdf:resource="${a.URI}"/>
				</#list>
	  		</rdf:Seq>
		</bibo:authorList>
		</#if>
	</rdf:Description>



	<#if work.provenance??>
		<!-- Provenance -->
		<prov:Entity rdf:about="${work.URI}">
			<prov:wasGeneratedBy>
				<prov:Activity>
					<rdfs:comment><![CDATA[${work.provenance.activity}]]></rdfs:comment>
					<prov:wasAssociatedWith>
						<rdf:Description rdf:about="${work.provenance.agent.URI}">
							<foaf:name><![CDATA[${work.provenance.agent.name}]]></foaf:name>
							<org:hasSite>
								<org:Site>
									<CLV:hasAddress>
										<CLV:Address>
											<CLV:fullAddress>${work.provenance.agent.fulladdress}</CLV:fullAddress>
										</CLV:Address>
									</CLV:hasAddress>
									<#if (work.provenance.agent.lat != 0) && (work.provenance.agent._long != 0) ??>
								<locn:geometry>
									<sf:Point>
										<geo:asWKT rdf:datatype= "http://www.opengis.net/ont/geosparql#wktLiteral">
											<![CDATA[<http://www.opengis.net/def/crs/OGC/1.3/CRS84> POINT(${work.provenance.agent._long} ${work.provenance.agent.lat})]]>
										</geo:asWKT>
										<geo_wgs84:lat>${work.provenance.agent.lat}</geo_wgs84:lat>
										<geo_wgs84:long>${work.provenance.agent._long}</geo_wgs84:long>
									</sf:Point>
								</locn:geometry>
								</#if>
								</org:Site>
							</org:hasSite>
						</rdf:Description>
					</prov:wasAssociatedWith>
					<#if work.URL??>
						<prov:used rdf:resource="${work.URL}" />
					</#if>
				</prov:Activity>
			</prov:wasGeneratedBy>
		</prov:Entity>
	</#if>
	
	
	<#list work.digitalDocuments as doc>
	<schemaorg:DigitalDocument rdf:about="${doc.uri}">
		<dc:title><![CDATA[${doc.title}]]></dc:title>
		<dc:description><![CDATA[${doc.description}]]></dc:description>
		<schemaorg:inLanguage>${doc.language}</schemaorg:inLanguage>
		<schemaorg:mainEntity rdf:resource="${doc.mainEntity}" />
		<schemaorg:url rdf:resource="${doc.url}" />
	</schemaorg:DigitalDocument>
  	</#list>
	

</rdf:RDF>