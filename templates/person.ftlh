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


	<foaf:Person rdf:about="${person.URI}">
		<foaf:givenname>${person.givenName}</foaf:givenname>
		<foaf:family_name>${person.familyName}</foaf:family_name>
		<#if person.img??>
		<foaf:img rdf:resource="${person.img}" />
		</#if>
		<#if person.mbox??>
		<foaf:mbox rdf:resource="mailto:${person.mbox}" />
		</#if>
		<#if person.homepage??>
		<foaf:homepage rdf:resource="${person.homepage}" />
		</#if>
		<#if person.orcid??>
		<foaf:account>
			<foaf:OnlineAccount>
				<foaf:accountServiceHomepage
					rdf:resource="https://orcid.org/" />
				<foaf:accountName>${person.orcid}</foaf:accountName>
			</foaf:OnlineAccount>
		</foaf:account>
		</#if>
		<#if person.description??>
		<l0:description xml:lang="it"><![CDATA[${person.description}]]></l0:description>
		</#if>
		<#list person.made as pub>
		<foaf:made>
			<rdf:Description rdf:about="${pub.URI}">
				<dc:title>${pub.title}</dc:title>
				<#if pub.URL??>
				<fabio:hasURL rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${pub.URL}</fabio:hasURL>
				</#if>				
			</rdf:Description>
		</foaf:made>
		</#list>
		<#list person.memberOf as m>
		 <org:memberOf>
		 	<org:Organization rdf:about="${m.URI}">
		 		<foaf:name><![CDATA[${m.name}]]></foaf:name>
		 	</org:Organization>
	    </org:memberOf>
		</#list>
		
		
		
		<#list person.memberships as m>
		<org:hasMembership>
			<org:Membership>
				<org:role>
		          <org:Role rdf:about="${m.role.uri}">
		            <rdfs:label><![CDATA[${m.role.label}]]></rdfs:label>
		          </org:Role>
		        </org:role>
				<org:organization>
					<org:Organization rdf:about="${m.organization.URI}">
						<foaf:name><![CDATA[${m.organization.name}]]></foaf:name>
						<foaf:acronym>${m.organization.acronym}</foaf:acronym>
						<org:hasSite>
							<org:Site>
								<CLV:hasAddress>
									<CLV:Address>
										<CLV:fullAddress><![CDATA[${m.organization.fulladdress}]]></CLV:fullAddress>
									</CLV:Address>
								</CLV:hasAddress>
								<#if (m.organization.lat != 0) && (m.organization._long != 0) ??>
								<locn:geometry>
									<sf:Point>
										<geo:asWKT rdf:datatype= "http://www.opengis.net/ont/geosparql#wktLiteral">
											<![CDATA[<http://www.opengis.net/def/crs/OGC/1.3/CRS84> POINT(${m.organization._long} ${m.organization.lat})]]>
										</geo:asWKT>
										<geo_wgs84:lat>${m.organization.lat}</geo_wgs84:lat>
										<geo_wgs84:long>${m.organization._long}</geo_wgs84:long>
									</sf:Point>
								</locn:geometry>
								</#if>
							</org:Site>
						</org:hasSite>
					</org:Organization>
				</org:organization>
			</org:Membership>
		</org:hasMembership>
		</#list>
		
	</foaf:Person>
	
	
	
</rdf:RDF>