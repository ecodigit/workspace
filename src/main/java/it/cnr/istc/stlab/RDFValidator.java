package it.cnr.istc.stlab;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FilenameUtils;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.riot.RDFDataMgr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RDFValidator {

	private static Logger logger = LoggerFactory.getLogger(RDFValidator.class);

	public static void main(String[] args) {
		File input_file = new File(args[0]);

		List<String> files = new ArrayList<>();

		if (input_file.isDirectory()) {
			logger.info("Processing Folder {}", args[0]);
			for (File f : input_file.listFiles()) {
				files.add(f.getAbsolutePath());
			}
		} else {
			files.add(input_file.getAbsolutePath());
		}

		for (String f : files) {
			logger.info("Processing {}", FilenameUtils.getName(f));
			Model m = ModelFactory.createDefaultModel();
			RDFDataMgr.read(m, f);
			logger.info("{} valid! Number of triples {}", FilenameUtils.getName(f), m.size());
			m.write(System.out, "TTL");
		}
	}

}
