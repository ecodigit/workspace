<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:SM="https://w3id.org/italia/onto/SM/"
	xmlns:CLV="https://w3id.org/italia/onto/CLV/"
	xmlns:COV="https://w3id.org/italia/onto/COV/"
	xmlns:RO="https://w3id.org/italia/onto/RO/"
	xmlns:l0="https://w3id.org/italia/onto/l0/"
	xmlns:TI="https://w3id.org/italia/onto/TI/"
	xmlns:CPV="https://w3id.org/italia/onto/CPV/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:cerif="http://eurocris.org/ontology/cerif/0.1#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:bibo="http://purl.org/ontology/bibo/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:org="http://www.w3.org/ns/org#"
	xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:cov="https://w3id.org/italia/onto/COV"
	xmlns:project="https://w3id.org/italia/onto/Project/"
	xmlns:language="https://w3id.org/italia/onto/Language/"
	xmlns:schemaorg="https://schema.org/"
	xmlns:ecodigit-org="https://w3id.org/ecodigit/ontology/organization/"
	xmlns:ecodigit-grade="https://w3id.org/ecodigit/ontology/grade/"
	xmlns:ecodigit-eas="https://w3id.org/ecodigit/ontology/eas/"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xsl rdf SM CLV CPV ecodigit-grade TI RO ecodigit-eas project language COV l0 xalan schemaorg ecodigit-org skos rdfs cerif foaf dc bibo dcterms org vcard geo cov">

	<xsl:output method="xml" encoding="utf-8" indent="yes" />

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

	<xsl:variable name="smallcase"
		select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase"
		select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template name="creativeWork">
		<xsl:param name="elem" />

		<ATTACHMENT>

			<xsl:choose>
				<xsl:when
					test="contains(translate($elem/dc:title, $smallcase, $uppercase),'BROCHURE')">
					<TIPO>BROCHURE</TIPO>
				</xsl:when>
				<xsl:when
					test="contains(translate($elem/dc:title, $smallcase, $uppercase),'CV')">
					<TIPO>CV</TIPO>
				</xsl:when>
				<xsl:when
					test="contains(translate($elem/dc:title, $smallcase, $uppercase),'CURRICULUM')">
					<TIPO>CV</TIPO>
				</xsl:when>
				<xsl:when
					test="contains(translate($elem/dc:title, $smallcase, $uppercase),'LOGO')">
					<TIPO>LOGO</TIPO>
				</xsl:when>
				<xsl:when
					test="contains(translate($elem/dc:title, $smallcase, $uppercase),'FOTOMEMBRO')">
					<TIPO>FOTOMEMBRO</TIPO>
				</xsl:when>
				<xsl:otherwise>
					<TIPO>ALTRO</TIPO>
				</xsl:otherwise>
			</xsl:choose>
			<RIFERIMENTO>
				<xsl:value-of select="$elem/@rdf:about" />
			</RIFERIMENTO>
			<TITOLO>
				<xsl:value-of select="normalize-space($elem/dc:title)" />
			</TITOLO>
			<DESCRIZIONE>
				<xsl:value-of
					select="normalize-space($elem/dc:description)" />
			</DESCRIZIONE>
			<URL>
				<xsl:value-of
					select="normalize-space($elem/schemaorg:url/@rdf:resource)" />
			</URL>
		</ATTACHMENT>

	</xsl:template>


	<xsl:template match="//foaf:Person">

		<xsl:variable name="uriPerson" select="@rdf:about" />
		
		<xsl:variable name="idDL">
			<xsl:text>r3_s1-a3-t1_</xsl:text>
			<xsl:value-of select="$uriPerson" />
		</xsl:variable>

		<body>

			<!-- Contenuto tag rdf:about -->
			<ID>
				<xsl:value-of select="$idDL" />
			</ID>
			<URI>
				<xsl:value-of select="$uriPerson" />
			</URI>

			<!-- Nome e Cognome -->

			<xsl:if test="foaf:name">
				<NOME_COGNOME>
					<xsl:value-of select="normalize-space(foaf:name)" />
				</NOME_COGNOME>
			</xsl:if>

			<xsl:if test="foaf:gender">
				<GENERE>
					<xsl:value-of select="normalize-space(foaf:gender)" />
				</GENERE>
			</xsl:if>

			<xsl:if test="foaf:givenname|foaf:family_name">
				<NOME_COGNOME>
					<xsl:value-of
						select="normalize-space(concat(foaf:givenname, ' ', foaf:family_name))" />
				</NOME_COGNOME>
			</xsl:if>


			<!-- Descrizione -->
			<xsl:if test="l0:description">
				<xsl:choose>
					<xsl:when test="l0:description[@xml:lang='en']">
						<DESCRIZIONE_ENG>
							<xsl:value-of
								select="normalize-space(l0:description[@xml:lang='en'])" />
						</DESCRIZIONE_ENG>
					</xsl:when>
					<xsl:otherwise>
						<DESCRIZIONE> 
							<xsl:value-of
								select="normalize-space(l0:description)" />
						</DESCRIZIONE>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>


			<!-- ID_INTERNAZIONALI manca: WoS/Isni -->
			<xsl:if test="foaf:account">
				<ID_INTERNAZIONALI>
					<xsl:for-each select="foaf:account/foaf:OnlineAccount">

						<xsl:choose>
							<xsl:when
								test="contains(foaf:accountServiceHomepage/@rdf:resource,'https://orcid.org/')">
								<BANCADATI>
									<LABEL>Orcid</LABEL>
									<ID>
										<xsl:value-of
											select="normalize-space(foaf:accountName/text())"></xsl:value-of>
									</ID>
									<URL>
										<xsl:value-of
											select="normalize-space(concat('https://orcid.org/', foaf:accountName/text()))" />
									</URL>
								</BANCADATI>
							</xsl:when>
							<xsl:when
								test="contains(foaf:accountServiceHomepage/@rdf:resource,'https://scholar.google.it/')">
								<BANCADATI>
									<LABEL>Google Scholar</LABEL>
									<ID>
										<xsl:value-of
											select="normalize-space(foaf:accountName/text())"></xsl:value-of>
									</ID>
									<URL>
										<xsl:value-of
											select="normalize-space(concat('https://scholar.google.it/citations?user=', foaf:accountName/text()))" />
									</URL>
								</BANCADATI>
							</xsl:when>
							<xsl:when
								test="contains(foaf:accountServiceHomepage/@rdf:resource,'scopus')">
								<BANCADATI>
									<LABEL>Scopus</LABEL>
									<ID>
										<xsl:value-of
											select="normalize-space(foaf:accountName/text())"></xsl:value-of>
									</ID>
									<URL>
										<xsl:value-of
											select="normalize-space(concat('https://www.scopus.com/authid/detail.uri?authorId=', foaf:accountName/text()))" />
									</URL>
								</BANCADATI>
							</xsl:when>

							<xsl:when
								test="contains(foaf:accountServiceHomepage/@rdf:resource,'researchgate')">
								<BANCADATI>
									<LABEL>Research Gate</LABEL>
									<ID>
										<xsl:value-of
											select="normalize-space(foaf:accountName/text())"></xsl:value-of>
									</ID>
									<URL>
										<xsl:value-of
											select="normalize-space(concat('https://www.researchgate.net/profile/', foaf:accountName/text()))" />
									</URL>
								</BANCADATI>
							</xsl:when>

							<xsl:when
								test="contains(foaf:accountServiceHomepage/@rdf:resource,'https://www.linkedin.com')">
								<BANCADATI>
									<LABEL>LinkedIn</LABEL>
									<ID>
										<xsl:value-of
											select="normalize-space(foaf:accountName/text())"></xsl:value-of>
									</ID>
									<URL>
										<xsl:value-of
											select="normalize-space(concat('https://www.linkedin.com/in/', foaf:accountName/text()))" />
									</URL>
								</BANCADATI>
							</xsl:when>


						</xsl:choose>


					</xsl:for-each>
				</ID_INTERNAZIONALI>
			</xsl:if>



			<!-- Ruolo -->

			<xsl:if test="org:hasMembership">
				<RUOLI>
					<xsl:for-each
						select="org:hasMembership/org:Membership">
						<RUOLO>
							<xsl:choose>
								<xsl:when test="org:role/org:Role/l0:name">
									<LABEL>
										<xsl:value-of
											select="normalize-space(org:role/org:Role/l0:name)" />
									</LABEL>
								</xsl:when>
								<xsl:when test="org:role/org:Role/rdfs:label">
									<LABEL>
										<xsl:value-of
											select="normalize-space(org:role/org:Role/rdfs:label)" />
									</LABEL>
								</xsl:when>
							</xsl:choose>
							<URI>
								<xsl:value-of select="org:role/org:Role/@rdf:about" />
							</URI>
							<ORG>
								<LABEL>
									<xsl:value-of
										select="normalize-space(org:organization/org:Organization/foaf:name)" />
								</LABEL>
								<URI>
									<xsl:value-of
										select="org:organization/org:Organization/@rdf:about" />
								</URI>
							</ORG>
						</RUOLO>
					</xsl:for-each>
				</RUOLI>
			</xsl:if>


			<!-- Prodotti -->
			<xsl:if test="foaf:made">
				<PRODOTTI>
					<xsl:for-each select="foaf:made/*">
						<PRODOTTO>

							<xsl:choose>
								<xsl:when test="dc:title">
									<LABEL>
										<xsl:value-of select="normalize-space(dc:title)" />
									</LABEL>
								</xsl:when>
								<xsl:when test="rdfs:label">
									<LABEL>
										<xsl:value-of
											select="normalize-space(rdfs:label)" />
									</LABEL>
								</xsl:when>
							</xsl:choose>


							<URI>
								<xsl:value-of select="@rdf:about" />
							</URI>
							<xsl:for-each select="rdf:type/rdf:Description">
								<xsl:choose>
									<xsl:when
										test="starts-with(@rdf:about, 'https://w3id.org/ecodigit/publication/CNR_DL_TYPE')">
										<TYPE>
											<xsl:value-of
												select="normalize-space(rdfs:label/text())" />
										</TYPE>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
							<YEAR>
								<xsl:value-of select="normalize-space(dc:date)" />
							</YEAR>
						</PRODOTTO>
					</xsl:for-each>
				</PRODOTTI>
			</xsl:if>

			<!-- Progetti -->
			<xsl:if test="project:isParticipantingAgentOfProject">
				<PROGETTI>
					<xsl:for-each
						select="project:isParticipantingAgentOfProject/*">
						<PROGETTO>
							<URI>
								<xsl:value-of select="@rdf:about" />
							</URI>

							<xsl:choose>
								<xsl:when test="project:projectTitle">
									<LABEL>
										<xsl:value-of
											select="normalize-space(project:projectTitle)" />
									</LABEL>
								</xsl:when>
								<xsl:when test="rdfs:label">
									<LABEL>
										<xsl:value-of
											select="normalize-space(rdfs:label)" />
									</LABEL>
								</xsl:when>
							</xsl:choose>


							<xsl:choose>
								<xsl:when
									test="name()='project:ProcurementProject'">
									<TYPE>Progetto di approvigionamento</TYPE>
								</xsl:when>
								<xsl:when
									test="name()='project:PublicInvestmentProject'">
									<TYPE>Progetto d'Investimento Pubblico</TYPE>
								</xsl:when>
								<xsl:when
									test="name()='project:PublicResearchProject'">
									<TYPE>Progetto di Ricerca Pubblica</TYPE>
								</xsl:when>
							</xsl:choose>


							<xsl:if test="TI:startTime">
								<DATE_START>
									<xsl:value-of
										select="normalize-space(TI:startTime)" />
								</DATE_START>
							</xsl:if>

							<xsl:if test="TI:endTime">
								<DATE_END>
									<xsl:value-of select="normalize-space(TI:endTime)" />
								</DATE_END>
							</xsl:if>
						</PROGETTO>
					</xsl:for-each>
				</PROGETTI>
			</xsl:if>

			<!-- Titoli di studio -->
			<xsl:if test="ecodigit-eas:attends">
				<TITOLI_STUDIO>
					<xsl:for-each select="ecodigit-eas:attends">
						<xsl:if
							test="ecodigit-eas:Training/ecodigit-eas:includesAnExamination/ecodigit-eas:FinalExamination/ecodigit-eas:leadsTo/ecodigit-eas:IstitutionalCertification/ecodigit-eas:attests">
							<TITOLO>
								<xsl:variable name="titolo">
									<xsl:copy-of
										select="normalize-space(ecodigit-eas:Training/ecodigit-eas:includesAnExamination/ecodigit-eas:FinalExamination/ecodigit-eas:leadsTo/*/ecodigit-eas:attests/*/rdfs:label[@xml:lang='it'])" />
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="contains($titolo,'Dottorato')">
										<TYPE>Dottorato di Ricerca</TYPE>
									</xsl:when>
									<xsl:when
										test="contains($titolo,'Laurea specialistica')">
										<TYPE>Laurea specialistica</TYPE>
									</xsl:when>
									<xsl:when
										test="contains($titolo,'Laurea di primo livello')">
										<TYPE>Laurea triennale</TYPE>
									</xsl:when>
									<xsl:when
										test="contains($titolo,'Diploma di maturità')">
										<TYPE>Diploma superiore</TYPE>
									</xsl:when>
								</xsl:choose>
								<LABEL>
									<xsl:value-of
										select="normalize-space(ecodigit-eas:Training/ecodigit-eas:includesAnExamination/ecodigit-eas:FinalExamination/ecodigit-eas:leadsTo/*/ecodigit-eas:attests/*/rdfs:label[@xml:lang='it'])" />
								</LABEL>

								<xsl:if
									test="ecodigit-eas:Training/TI:atTime/*/TI:startTime">
									<DATA_INIZIO>
										<xsl:value-of
											select="normalize-space(ecodigit-eas:Training/TI:atTime/*/TI:startTime)" />
									</DATA_INIZIO>
								</xsl:if>

								<xsl:if
									test="ecodigit-eas:Training/TI:atTime/*/TI:endTime">
									<DATA_FINE>
										<xsl:value-of
											select="normalize-space(ecodigit-eas:Training/TI:atTime/*/TI:endTime)" />
									</DATA_FINE>
								</xsl:if>

								<xsl:if
									test="ecodigit-eas:Training/ecodigit-eas:includesAnExamination/ecodigit-eas:FinalExamination/ecodigit-grade:hasGrade/ecodigit-grade:Grade/ecodigit-grade:literalValue">
									<VOTO>
										<xsl:value-of
											select="normalize-space(ecodigit-eas:Training/ecodigit-eas:includesAnExamination/ecodigit-eas:FinalExamination/ecodigit-grade:hasGrade/ecodigit-grade:Grade/ecodigit-grade:literalValue)" />
									</VOTO>
								</xsl:if>
								<xsl:if
									test="ecodigit-eas:Training/ecodigit-eas:includesAnExamination/ecodigit-eas:FinalExamination/ecodigit-grade:hasGrade/ecodigit-grade:Grade/ecodigit-grade:hasGradingScale/ecodigit-grade:GradingScale/ecodigit-grade:hasMaximumGrade/*/ecodigit-grade:literalValue">
									<VOTO_MAX>
										<xsl:value-of
											select="normalize-space(ecodigit-eas:Training/ecodigit-eas:includesAnExamination/ecodigit-eas:FinalExamination/ecodigit-grade:hasGrade/ecodigit-grade:Grade/ecodigit-grade:hasGradingScale/ecodigit-grade:GradingScale/ecodigit-grade:hasMaximumGrade/*/ecodigit-grade:literalValue)" />
									</VOTO_MAX>
								</xsl:if>

								<ORG>

									<xsl:if
										test="ecodigit-eas:Training/ecodigit-eas:providedBy/org:Organization/@rdf:about">
										<URI>
											<xsl:value-of
												select="normalize-space(ecodigit-eas:Training/ecodigit-eas:providedBy/org:Organization/@rdf:about)" />
										</URI>
									</xsl:if>
									<LABEL>
										<xsl:value-of
											select="normalize-space(ecodigit-eas:Training/ecodigit-eas:providedBy/org:Organization/foaf:name)" />
									</LABEL>

									<xsl:if
										test="ecodigit-eas:Training/ecodigit-eas:providedBy/org:Organization/org:hasSite/*/CLV:hasAddress/*/CLV:fullAddress">
										<INDIRIZZO>
											<xsl:value-of
												select="normalize-space(ecodigit-eas:Training/ecodigit-eas:providedBy/org:Organization/org:hasSite/*/CLV:hasAddress/*/CLV:fullAddress)" />
										</INDIRIZZO>
									</xsl:if>
								</ORG>

							</TITOLO>
						</xsl:if>

					</xsl:for-each>
				</TITOLI_STUDIO>
			</xsl:if>

			<!-- Esperienze lavorative -->
			<xsl:if test="COV:holdEmployment">
				<ESPERIENZE_LAVORATIVE>
					<xsl:for-each
						select="COV:holdEmployment/COV:Employment">
						<LAVORO>
							<xsl:if test="RO:withRole/*/l0:name[@xml:lang='it']">
								<RUOLO_ITA>
									<xsl:value-of
										select="normalize-space(RO:withRole/*/l0:name[@xml:lang='it'])" />
								</RUOLO_ITA>
							</xsl:if>
							<xsl:if test="RO:withRole/*/l0:name[@xml:lang='en']">
								<RUOLO_ENG>
									<xsl:value-of
										select="normalize-space(RO:withRole/*/l0:name[@xml:lang='en'])" />
								</RUOLO_ENG>
							</xsl:if>
							<xsl:if
								test="RO:withRole/*/l0:description[@xml:lang='it']/text()">
								<DESCR_ITA>
									<xsl:value-of
										select="normalize-space(RO:withRole/*/l0:description[@xml:lang='it'])" />
								</DESCR_ITA>
							</xsl:if>
							<xsl:if
								test="RO:withRole/*/l0:description[@xml:lang='en']/text()">
								<DESCR_ENG>
									<xsl:value-of
										select="normalize-space(RO:withRole/*/l0:description[@xml:lang='en'])" />
								</DESCR_ENG>
							</xsl:if>
							<xsl:if test="TI:atTime/TI:TimeInterval/TI:startTime">
								<DATA_INIZIO>
									<xsl:value-of
										select="normalize-space(TI:atTime/TI:TimeInterval/TI:startTime)" />
								</DATA_INIZIO>
							</xsl:if>
							<xsl:if test="TI:atTime/TI:TimeInterval/TI:endTime">
								<DATA_FINE>
									<xsl:value-of
										select="normalize-space(TI:atTime/TI:TimeInterval/TI:endTime)" />
								</DATA_FINE>
							</xsl:if>
							<xsl:if test="COV:employmentFor">
								<ORG>
									<xsl:if test="COV:employmentFor/*/@rdf:about">
										<URI>
											<xsl:value-of
												select="COV:employmentFor/*/@rdf:about" />
										</URI>
									</xsl:if>
									<LABEL>
										<xsl:value-of
											select="normalize-space(COV:employmentFor/*/foaf:name)" />
									</LABEL>
									<xsl:if
										test="COV:employmentFor/*/org:hasSite/org:Site/CLV:hasAddress/CLV:Address/CLV:fullAddress">
										<INDIRIZZO>
											<xsl:value-of
												select="normalize-space(COV:employmentFor/*/org:hasSite/org:Site/CLV:hasAddress/CLV:Address/CLV:fullAddress)" />
										</INDIRIZZO>
									</xsl:if>
									<SITO_WEB>
										<xsl:value-of
											select="normalize-space(COV:employmentFor/*/foaf:homepage/@rdf:resource)" />
									</SITO_WEB>
								</ORG>
							</xsl:if>
						</LAVORO>
					</xsl:for-each>
				</ESPERIENZE_LAVORATIVE>
			</xsl:if>


			<!-- Lingue e Certificazioni -->
			<xsl:if
				test="ecodigit-eas:hasExpertise/ecodigit-eas:LanguageSkill">
				<LINGUE>

					<xsl:for-each
						select="ecodigit-eas:hasExpertise/ecodigit-eas:LanguageSkill">
						<LINGUA>
							<LABEL>
								<xsl:value-of
									select="normalize-space(language:hasLanguage/*/rdfs:label/text())" />
							</LABEL>
							<CODE>
								<xsl:value-of
									select="normalize-space(substring-after(language:hasLanguage/*/@rdf:about,'http://publications.europa.eu/resource/authority/language/'))" />
							</CODE>
							<LIVELLI_LINGUA>
								<LIVELLO>
									<TIPO>Livello generale</TIPO>
									<xsl:if
										test="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:Level/l0:name[@xml:lang='it']">
										<VALUE>
											<xsl:value-of
												select="normalize-space(ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:Level/l0:name[@xml:lang='it'])" />
										</VALUE>
									</xsl:if>


									<xsl:if
										test="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:Level/l0:description[@xml:lang='it']">
										<DESCR>
											<xsl:value-of
												select="normalize-space(ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:Level/l0:description[@xml:lang='it'])" />
										</DESCR>
									</xsl:if>



								</LIVELLO>
								<xsl:if
									test="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:LevelInActivity/ecodigit-eas:hasActivity/*/@rdf:about='https://w3id.org/ecodigit/ontology/eas/WrittenProduction'">
									<LIVELLO>
										<TIPO>Produzione scritta</TIPO>
										<xsl:variable name="lev">
											<xsl:copy-of
												select="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:LevelInActivity[ecodigit-eas:hasActivity/*/@rdf:about='https://w3id.org/ecodigit/ontology/eas/WrittenProduction']/ecodigit-eas:hasLevel/ecodigit-eas:Level" />
										</xsl:variable>
										<VALUE>
											<xsl:value-of
												select="normalize-space(xalan:nodeset($lev)/*/l0:name[@xml:lang='it'])" />
										</VALUE>
										<xsl:if
											test="xalan:nodeset($lev)/*/l0:description[@xml:lang='it']/text()">
											<DESCR>
												<xsl:value-of
													select="normalize-space(xalan:nodeset($lev)/*/l0:description[@xml:lang='it'])" />
											</DESCR>
										</xsl:if>


									</LIVELLO>
								</xsl:if>
								<xsl:if
									test="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:LevelInActivity/ecodigit-eas:hasActivity/*/@rdf:about='https://w3id.org/ecodigit/ontology/eas/SpokenProduction'">
									<LIVELLO>
										<xsl:variable name="lev">
											<xsl:copy-of
												select="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:LevelInActivity[ecodigit-eas:hasActivity/*/@rdf:about='https://w3id.org/ecodigit/ontology/eas/SpokenProduction']/ecodigit-eas:hasLevel/ecodigit-eas:Level" />
										</xsl:variable>
										<TIPO>Produzione orale</TIPO>
										<VALUE>
											<xsl:value-of
												select="normalize-space(xalan:nodeset($lev)/*/l0:name[@xml:lang='it'])" />
										</VALUE>
										<xsl:if
											test="xalan:nodeset($lev)/*/l0:description[@xml:lang='it']/text()">
											<DESCR>
												<xsl:value-of
													select="normalize-space(xalan:nodeset($lev)/*/l0:description[@xml:lang='it'])" />
											</DESCR>
										</xsl:if>
									</LIVELLO>
								</xsl:if>
								<xsl:if
									test="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:LevelInActivity/ecodigit-eas:hasActivity/*/@rdf:about='https://w3id.org/ecodigit/ontology/eas/ReadingComprehension'">
									<LIVELLO>
										<xsl:variable name="lev">
											<xsl:copy-of
												select="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:LevelInActivity[ecodigit-eas:hasActivity/*/@rdf:about='https://w3id.org/ecodigit/ontology/eas/ReadingComprehension']/ecodigit-eas:hasLevel/ecodigit-eas:Level" />
										</xsl:variable>
										<TIPO>Comprensione scritta</TIPO>
										<VALUE>
											<xsl:value-of
												select="normalize-space(xalan:nodeset($lev)/*/l0:name[@xml:lang='it'])" />
										</VALUE>
										<xsl:if
											test="xalan:nodeset($lev)/*/l0:description[@xml:lang='it']/text()">
											<DESCR>
												<xsl:value-of
													select="normalize-space(xalan:nodeset($lev)/*/l0:description[@xml:lang='it'])" />
											</DESCR>
										</xsl:if>
									</LIVELLO>
								</xsl:if>
								<xsl:if
									test="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:LevelInActivity/ecodigit-eas:hasActivity/*/@rdf:about='https://w3id.org/ecodigit/ontology/eas/ListeningComprehension'">
									<LIVELLO>
										<xsl:variable name="lev">
											<xsl:copy-of
												select="ecodigit-eas:hasCertification/ecodigit-eas:SelfCertification/ecodigit-eas:attests/ecodigit-eas:LevelInActivity[ecodigit-eas:hasActivity/*/@rdf:about='https://w3id.org/ecodigit/ontology/eas/ListeningComprehension']/ecodigit-eas:hasLevel/ecodigit-eas:Level" />
										</xsl:variable>
										<TIPO>Comprensione orale</TIPO>
										<VALUE>
											<xsl:value-of
												select="normalize-space(xalan:nodeset($lev)/*/l0:name[@xml:lang='it'])" />
										</VALUE>
										<xsl:if
											test="xalan:nodeset($lev)/*/l0:description[@xml:lang='it']/text()">
											<DESCR>
												<xsl:value-of
													select="normalize-space(xalan:nodeset($lev)/*/l0:description[@xml:lang='it'])" />
											</DESCR>
										</xsl:if>
									</LIVELLO>
								</xsl:if>
							</LIVELLI_LINGUA>


							<xsl:if
								test="ecodigit-eas:hasCertification/ecodigit-eas:IstitutionalCertification">
								<CERTIFICAZIONI>
									<xsl:for-each
										select="ecodigit-eas:hasCertification/ecodigit-eas:IstitutionalCertification">
										<CERTIFICAZIONE>
											<LABEL>
												<xsl:value-of
													select="normalize-space(rdfs:label[@xml:lang='it'])" />
											</LABEL>
											<xsl:if test="ecodigit-eas:issueDate">
												<DATA>
													<xsl:value-of
														select="normalize-space(ecodigit-eas:issueDate)" />
												</DATA>
											</xsl:if>
											<xsl:if
												test="ecodigit-grade:hasGrade/ecodigit-grade:Grade/ecodigit-grade:literalValue/text()">
												<VOTO>
													<xsl:value-of
														select="normalize-space(ecodigit-grade:hasGrade/ecodigit-grade:Grade/ecodigit-grade:literalValue)" />
												</VOTO>
											</xsl:if>
										</CERTIFICAZIONE>
									</xsl:for-each>
								</CERTIFICAZIONI>
							</xsl:if>

						</LINGUA>

					</xsl:for-each>


				</LINGUE>
			</xsl:if>

			<!-- Skills -->
			<xsl:if test="ecodigit-eas:hasExpertise">
				<SKILLS>
					<xsl:for-each
						select="ecodigit-eas:hasExpertise/ecodigit-eas:ExpertiseAndSkill">
						<SKILL>
							<xsl:if test="@rdf:about">
								<URI>
									<xsl:value-of select="@rdf:about" />
								</URI>
							</xsl:if>
							<SKILL>
								<xsl:value-of select="normalize-space(rdfs:label)" />
							</SKILL>
						</SKILL>
					</xsl:for-each>
				</SKILLS>
			</xsl:if>

			<xsl:if test="foaf:mbox/@rdf:resource">
				<EMAIL>
					<xsl:value-of
						select="normalize-space(substring-after(foaf:mbox/@rdf:resource,'mailto:'))" />
				</EMAIL>
			</xsl:if>

			<TIPOLOGIA>PERSONA</TIPOLOGIA>

			<xsl:if test="foaf:homepage/@rdf:resource">
				<SITO_WEB>
					<xsl:value-of select="foaf:homepage/@rdf:resource"></xsl:value-of>
				</SITO_WEB>
			</xsl:if>

			<xsl:if test="foaf:phone">
				<TELEFONO>
					<xsl:value-of select="normalize-space(foaf:phone)" />
				</TELEFONO>
			</xsl:if>


			<xsl:if
				test="SM:hasContactPoint/SM:ContactPoint/SM:hasTelephone/SM:Telephone[SM:hasTelephoneType[@rdf:resource='https://w3id.org/italia/controlled-vocabulary/classifications-for-public-services/channel/033']]/SM:telephoneNumber">
				<FAX>
					<xsl:value-of
						select="normalize-space(SM:hasContactPoint/SM:ContactPoint/SM:hasTelephone/SM:Telephone[SM:hasTelephoneType[@rdf:resource='https://w3id.org/italia/controlled-vocabulary/classifications-for-public-services/channel/033']]/SM:telephoneNumber)" />
				</FAX>
			</xsl:if>


			<xsl:if
				test="org:hasMembership/*/org:organization/org:Organization/org:hasSite/org:Site">
				<GEO>
					<xsl:for-each
						select="org:hasMembership/*/org:organization/org:Organization/org:hasSite/org:Site">
						<!-- INDIRIZZO -->
						<item>
							<xsl:attribute name="id">1</xsl:attribute>
							<xsl:attribute name="type">person</xsl:attribute>
							<xsl:value-of
								select="normalize-space(CLV:hasAddress/CLV:Address/CLV:fullAddress)" />
						</item>
					</xsl:for-each>
				</GEO>
			</xsl:if>


			<xsl:if
				test="//schemaorg:CreativeWork[schemaorg:mainEntity/@rdf:resource=$uriPerson]|//schemaorg:DigitalDocument|//foaf:img">
				<ATTACHMENTS>
				
					<xsl:if test="//foaf:img">
						<ATTACHMENT>
							<TIPO>FOTOMEMBRO</TIPO>
							<TITOLO>
								<xsl:text>Foto </xsl:text><xsl:value-of select="normalize-space(//foaf:name)" />
							</TITOLO>
							<URL>
								<xsl:value-of
									select="normalize-space(//foaf:img/@rdf:resource)" />
							</URL>
						</ATTACHMENT>
					</xsl:if>
				
					<xsl:for-each
						select="//schemaorg:CreativeWork[schemaorg:mainEntity/@rdf:resource=$uriPerson]|//schemaorg:DigitalDocument">

						<xsl:call-template name="creativeWork">
							<xsl:with-param name="elem" select="." />
						</xsl:call-template>

					</xsl:for-each>					
					
				</ATTACHMENTS>
			</xsl:if>



			<xsl:if
				test="org:memberOf/org:Organization">

				<SUPER_ORGANIZATIONS>
					<xsl:for-each
						select="org:memberOf/org:Organization">
						<SUPER_ORGANIZATION>
							<LABEL>
								<xsl:value-of select="normalize-space(foaf:name)" />
							</LABEL>
							<URI>
								<xsl:value-of select="@rdf:about" />
							</URI>
						</SUPER_ORGANIZATION>
					</xsl:for-each>
				</SUPER_ORGANIZATIONS>

			</xsl:if>






		</body>


	</xsl:template>

	<xsl:template match="*/text()" />

</xsl:stylesheet>