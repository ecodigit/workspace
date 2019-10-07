package it.cnr.istc.stlab.ecodigit.transformer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TrasformerUtils {

	private static Logger logger = LoggerFactory.getLogger(TrasformerUtils.class);

	static String getStringField(String[] row, Integer col) {
		try {
			String result = row[col];
			if (result.length() == 0) {
				return null;
			}
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return null;
	}

	static Integer indexOf(String[] arr, String string) {
		for (int i = 0; i < arr.length; i++) {
			if (arr[i].equals(string)) {
				return i;
			}
		}
		return null;
	}

}
