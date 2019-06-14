# Workspace del progetto Ecodigit

Questo repository contiene il workspace del progetto EcoDigit.

### Ontologie

I dati acquisiti e pubblicati da EcoDigit saranno strutturati secondo ontologie raccomandate da enti nazionali (e.g. AgId) e internazionali (e.g. W3C) o riconosciute come standard de-facto (e.g. [OntoPiA](https://github.com/italia/daf-ontologie-vocabolari-controllati/), [FOAF](http://xmlns.com/foaf/spec/), [Dublin Core](http://www.dublincore.org/specifications/dublin-core/dcmi-terms/), [W3C's Organization Ontology](https://www.w3.org/TR/vocab-org/), [Bibliographic Ontology](http://bibliontology.com/) ecc.).
Dove la specificità dei dati da rappresentare non consentirà un riuso complete dei modelli standard, verranno definite delle nuove ontologie che estenderanno le ontologie esistenti dove necessario.

#### Nuove Ontologie
Di seguito la lista delle ontologie definite ex-novo per EcoDigit:

- [Ontologia delle Organizzazioni](https://w3id.org/ecodigit/ontology/organization) 
  - Namespace: `https://w3id.org/ecodigit/ontology/organization/`
  - Obiettivo: L'ontologia ha lo scopo di definire un vocabolario condiviso di termini per la descrizione delle organizzazioni che partecipano al Centro di Eccellenza - DTC Lazio.
  - Estende: [OntoPiA-COV](https://w3id.org/italia/onto/COV), [FOAF](http://xmlns.com/foaf/spec/),[W3C's Organization Ontology](https://www.w3.org/TR/vocab-org/) 

- [Ontologia delle Esperienze e Competenze](https://w3id.org/ecodigit/ontology/eas) 
  - Namespace: `https://w3id.org/ecodigit/ontology/eas/`
  - Obiettivo: L'ontologia ha lo scopo di definire un vocabolario condiviso di termini per la descrizione delle esperienze e competenze di una persona.
  - Estende: [OntoPiA-CPV](https://w3id.org/italia/onto/CPV), OntoPiA-COV](https://w3id.org/italia/onto/COV), [FOAF](http://xmlns.com/foaf/spec/),[BIBO](http://purl.org/ontology/bibo/) 



### Esempi

La directory examples/ contiene degli esempi di file XML-RDF che seguono la struttura dei modelli dati adottati per EcoDigit.
Inoltre è disponibile una [presentazione](https://docs.google.com/presentation/d/1zRPi2FyykDnJ9wsSyAYA-govw6NRrdPUP0X4xvUregk/edit?usp=sharing) che fornisce le indicazioni su produrre i dati compatibili con i modelli adottati per EcoDigit.


### RDFValidator

RDFValidator verifica la correttezza sintattica di un file RDF.
RDFValidator è disponibile tramite pacchetto java (JAR) al seguente [link](https://github.com/ecodigit/workspace/raw/master/bin/rdf_validator-0.0.1.zip).
Di seguito verranno riportate le istruzioni per usare RDFValidator
```
$ wget https://github.com/ecodigit/workspace/raw/master/bin/rdf_validator-0.0.1.zip
$ unzip rdf_validator-0.0.1.zip
$ cd rdf_validator-0.0.1/rdf_validator-0.0.1/
$ java -jar rdf_validator-0.0.1.jar -i <input_file_or_directory>
```
Dove <input_file_or_directory> è il path assoluto verso un file rdf oppure il path assoluto verso una directory contenente file RDF.
