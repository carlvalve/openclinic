package be.openclinic.archiving;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.dcm4che2.data.DicomObject;
import org.dcm4che2.io.DicomInputStream;
import org.dcm4che2.io.DicomOutputStream;

import be.mxs.common.util.system.Debug;

public class Dicom {

	public static DicomObject getDicomObject(String filename){
		return getDicomObject(new File(filename));
	}
	
	public static DicomObject getDicomObject(File file){
		DicomObject dcmObj=null;
		DicomInputStream din = null;
		try {
		    din = new DicomInputStream(file);
		    dcmObj = din.readDicomObject();
		}
		catch (Exception e) {
		    Debug.println(e.getMessage());
		}
		finally {
		    try {
		        din.close();
		    }
		    catch (Exception ignore) {
		    }
		}
	    return dcmObj;
	}
	
	public static void writeDicomObject(DicomObject obj,File file){
		FileOutputStream fos;
		try {
		    fos = new FileOutputStream(file);
		}
		catch (FileNotFoundException e) {
		    e.printStackTrace();
		    return;
		}
		BufferedOutputStream bos = new BufferedOutputStream(fos);
		DicomOutputStream dos = new DicomOutputStream(bos);
		try {
		    dos.writeDicomFile(obj);
		}
		catch (IOException e) {
		    e.printStackTrace();
		    return;
		}
		finally {
		    try {
		        dos.close();
		    }
		    catch (IOException ignore) {
		    }
		}
	}
}
