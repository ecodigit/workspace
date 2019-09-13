package it.cnr.istc.stlab.ecodigit.transformer;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Arrays;

import it.cnr.istc.stlab.lgu.commons.tables.RowsIterator;
import it.cnr.istc.stlab.lgu.commons.tables.RowsIteratorGoogleSheets;

public class PersonTransformer {
	
	
	
	public static void main(String[] args) throws GeneralSecurityException, IOException {
		RowsIterator ri = new RowsIteratorGoogleSheets("1sFKzCJFOo8Gw3-26Cj8CUr8ZjWN9CO6m1lZMBo-k_Ko", "Risposte del modulo 1");
		
		String[] header = ri.next();
		
		while (ri.hasNext()) {
			String[] strings = (String[]) ri.next();
			System.out.println(Arrays.toString(strings).replaceAll("\n", " "));
		}
	}

}
