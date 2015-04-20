package be.openclinic.archiving;

import java.io.File;
import java.io.IOException;

import org.dcm4che2.data.DicomObject;
import org.dcm4che2.io.DicomInputStream;

public class Dicom {

	public static DicomObject getDicomObject(String filename){
		DicomObject dcmObj=null;
		DicomInputStream din = null;
		try {
			System.out.println("reading "+filename);
			File file = new File(filename);
			System.out.println("1: "+file);
		    din = new DicomInputStream(file);
			System.out.println("2");
		    dcmObj = din.readDicomObject();
			System.out.println("3");
		}
		catch (Exception e) {
			System.out.println("Error 1");
		    e.printStackTrace();
		}
		finally {
		    try {
		        din.close();
		    }
		    catch (Exception ignore) {
				System.out.println("Error 2");
		    }
		}
	    return dcmObj;
	}
	
}
