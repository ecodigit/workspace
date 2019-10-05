package it.cnr.istc.stlab.ecodigit.rdf;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.Option.Builder;
import org.apache.commons.io.FilenameUtils;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.riot.RDFDataMgr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RDFValidator {

	private static Logger logger = LoggerFactory.getLogger(RDFValidator.class);

	public static final String INPUT = "i";
	public static final String INPUT_LONG = "input";

	public static final String PRINT = "p";
	public static final String PRINT_LONG = "print";

	public static void main(String[] args) {

		Options options = new Options();

		{
			//@f:off
			Builder optionBuilder = Option.builder(INPUT);
			Option option = optionBuilder.argName("input")
					.hasArg()
					.required(true)
					.desc("MANDATORY - Absolute path to file or folder to validate.")
					.longOpt(INPUT_LONG)
					.build();
			//@f:on
			options.addOption(option);
		}

		{
			//@f:off
			Builder optionBuilder = Option.builder(PRINT);
			Option option = optionBuilder.argName("print")
					.required(false)
					.desc("Use if you want the RDF file being printed on console.")
					.longOpt(PRINT_LONG)
					.build();
			//@f:on
			options.addOption(option);
		}

		CommandLine commandLine = null;

		CommandLineParser cmdLineParser = new DefaultParser();
		try {
			commandLine = cmdLineParser.parse(options, args);
		} catch (ParseException e) {
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp("process", options);
		}

		if (commandLine != null) {
			try {

				String input = commandLine.getOptionValue(INPUT);
				boolean print = commandLine.hasOption(PRINT);

				validate(input, print);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}

	private static void validate(String inputFilePath, boolean b) {
		
		
		File input_file = new File(inputFilePath);

		List<String> files = new ArrayList<>();

		if (input_file.isDirectory()) {
			logger.info("Processing Folder {}", inputFilePath);
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
			if (b)
				m.write(System.out, "TTL");
		}
	}

}
