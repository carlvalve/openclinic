package be.openclinic.knowledge;

import java.awt.Color;
import java.awt.Image;
import java.awt.Polygon;
import java.util.Vector;

import ocspring2.OC;

public class Ikirezi {
	
	public static Vector getDiagnoses(Vector signs, String language){
		OC oc = new OC();
		Vector diagnoses = oc.getResponse(signs,language);
		return diagnoses;
	}
	
	public static Vector getDiagnoses(String[] signs, String language){
		OC oc = new OC();
		Vector diagnoses = oc.getResponse(signs,language);
		return diagnoses;
	}
	
}
