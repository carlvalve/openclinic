package be.openclinic.pharmacy;

import java.io.BufferedReader;
import java.io.StringReader;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.medical.Prescription;

public class Utils {

	public static SortedMap getDrugDrugInteractions(String rxcuis){
		SortedMap interactions= new TreeMap();
		try{
			HttpClient client = new HttpClient();
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormInteraction","http://rxnav.nlm.nih.gov/REST/interaction/list.xml?rxcuis="+rxcuis);
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
			SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("interactiondata")){
				Element interactionTypeGroup=root.element("fullInteractionTypeGroup");
				if(interactionTypeGroup!=null){
					Iterator interactionTypes=interactionTypeGroup.elementIterator("fullInteractionType");
					while(interactionTypes.hasNext()){
						Element interactionType=(Element)interactionTypes.next();
						Iterator interactionPairs = interactionType.elementIterator("interactionPair");
						while(interactionPairs.hasNext()){
							Element interactionPair=(Element)interactionPairs.next();
							String drugcodes="";
							String druginteractions="";
							Iterator interactionConcepts=interactionPair.elementIterator("interactionConcept");
							while(interactionConcepts.hasNext()){
								Element interactionConcept = (Element)interactionConcepts.next();
								if(interactionConcept.element("sourceConceptItem")!=null){
									Element sourceConceptItem=interactionConcept.element("sourceConceptItem");
									drugcodes+=sourceConceptItem.elementText("id")+";";
									if(druginteractions.length()>0){
										druginteractions+=" + ";
									}
									druginteractions+=sourceConceptItem.elementText("name");
								}
							}
							interactions.put(drugcodes,druginteractions+";"+interactionPair.elementText("description"));
						}
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return interactions;
	}
	
	public static boolean hasDrugDrugInteractions(String rxcuis){
		try{
			HttpClient client = new HttpClient();
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormInteraction","http://rxnav.nlm.nih.gov/REST/interaction/list.xml?rxcuis="+rxcuis);
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
			SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("interactiondata")){
				Element interactionTypeGroup=root.element("fullInteractionTypeGroup");
				if(interactionTypeGroup!=null){
					Iterator interactionTypes=interactionTypeGroup.elementIterator("fullInteractionType");
					while(interactionTypes.hasNext()){
						Element interactionType=(Element)interactionTypes.next();
						Iterator interactionPairs = interactionType.elementIterator("interactionPair");
						while(interactionPairs.hasNext()){
							return true;
						}
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return false;
	}
	
	public static boolean patientHasDrugDrugInteractions(String personid){
		String rxcuis="";
		//Find rxcuis from active patientmedication
		Vector activePrescriptions = Prescription.getActivePrescriptions(personid);
		for(int n=0;n<activePrescriptions.size();n++){
			Prescription prescription=(Prescription)activePrescriptions.elementAt(n);
			Product product = prescription.getProduct();
			if(product!=null && product.getRxnormcode()!=null && product.getRxnormcode().length()>0){
				rxcuis+=product.getRxnormcode()+"+";
			}
		}
		try{
			HttpClient client = new HttpClient();
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormInteraction","http://rxnav.nlm.nih.gov/REST/interaction/list.xml?rxcuis="+rxcuis);
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
			SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("interactiondata")){
				Element interactionTypeGroup=root.element("fullInteractionTypeGroup");
				if(interactionTypeGroup!=null){
					Iterator interactionTypes=interactionTypeGroup.elementIterator("fullInteractionType");
					while(interactionTypes.hasNext()){
						Element interactionType=(Element)interactionTypes.next();
						Iterator interactionPairs = interactionType.elementIterator("interactionPair");
						while(interactionPairs.hasNext()){
							return true;
						}
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return false;
	}
	
	public static SortedMap getPatientDrugDrugInteractions(String personid){
		String rxcuis="";
		//Find rxcuis from active patientmedication
		Vector activePrescriptions = Prescription.getActivePrescriptions(personid);
		for(int n=0;n<activePrescriptions.size();n++){
			Prescription prescription=(Prescription)activePrescriptions.elementAt(n);
			Product product = prescription.getProduct();
			if(product!=null && product.getRxnormcode()!=null && product.getRxnormcode().length()>0){
				rxcuis+=product.getRxnormcode()+"+";
			}
		}
		SortedMap interactions= new TreeMap();
		try{
			HttpClient client = new HttpClient();
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormInteraction","http://rxnav.nlm.nih.gov/REST/interaction/list.xml?rxcuis="+rxcuis);
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
			SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("interactiondata")){
				Element interactionTypeGroup=root.element("fullInteractionTypeGroup");
				if(interactionTypeGroup!=null){
					Iterator interactionTypes=interactionTypeGroup.elementIterator("fullInteractionType");
					while(interactionTypes.hasNext()){
						Element interactionType=(Element)interactionTypes.next();
						Iterator interactionPairs = interactionType.elementIterator("interactionPair");
						while(interactionPairs.hasNext()){
							Element interactionPair=(Element)interactionPairs.next();
							String drugcodes="";
							String druginteractions="";
							Iterator interactionConcepts=interactionPair.elementIterator("interactionConcept");
							while(interactionConcepts.hasNext()){
								Element interactionConcept = (Element)interactionConcepts.next();
								if(interactionConcept.element("sourceConceptItem")!=null){
									Element sourceConceptItem=interactionConcept.element("sourceConceptItem");
									drugcodes+=sourceConceptItem.elementText("id")+";";
									if(druginteractions.length()>0){
										druginteractions+=" + ";
									}
									druginteractions+=sourceConceptItem.elementText("name");
								}
							}
							interactions.put(drugcodes,druginteractions+";"+interactionPair.elementText("description"));
						}
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return interactions;
	}
}
