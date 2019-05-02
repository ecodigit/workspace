# Workspace del progetto Ecodigit

Questo repository contiene il workspace del progetto EcoDigit.

### Esempi

La directory examples/ contiene degli esempi di file XML-RDF che seguono la struttura dei modelli dati adottati per EcoDigit.
Inoltre è disponibile una [presentazione](https://docs.google.com/presentation/d/1zRPi2FyykDnJ9wsSyAYA-govw6NRrdPUP0X4xvUregk/edit?usp=sharing) che fornisce le indicazioni su produrre i dati compatibili con i modelli adottati per EcoDigit.


### RDFValidator

RDFValidator verifica la correttezza sintattica di un file RDF.
RDFValidator è disponibile tramite pacchetto java (JAR) al seguente [link](https://github.com/ecodigit/workspace/raw/master/bin/rdf_validator-0.0.1.zip).
Di seguito verranno riportate le istruzioni per usare RDFValidator
```
wget https://github.com/ecodigit/workspace/raw/master/bin/rdf_validator-0.0.1.zip
unzip rdf_validator-0.0.1.zip
cd rdf_validator-0.0.1/rdf_validator-0.0.1/
java -jar rdf_validator-0.0.1.jar -i <input_file_or_directory>
```
Dove <input_file_or_directory> è il path assoluto verso un file rdf oppure il path assoluto verso una directory contenente file RDF.
