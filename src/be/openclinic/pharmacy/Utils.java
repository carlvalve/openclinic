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
import be.mxs.common.util.system.RxNormInteraction;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.system.Translate;
import be.openclinic.medical.Prescription;

public class Utils {

	public static SortedMap getDrugDrugInteractions(String rxcuis, String language){
		language=language.toLowerCase();
		SortedMap interactions= new TreeMap();
		if(!language.equalsIgnoreCase("en")){
			String s = RxNormInteraction.getInteraction(language+"."+rxcuis);
			if(s!=null){
				return ScreenHelper.string2SortedMap(s);
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
										druginteractions+=Translate.translate("en", language,sourceConceptItem.elementText("name"),sourceConceptItem.elementText("name"));
									}
								}
								interactions.put(drugcodes,druginteractions+";"+Translate.translate("en",language,interactionPair.elementText("description"),interactionPair.elementText("description")));
							}
						}
					}
				}
			}
			catch(Exception e){
				e.printStackTrace();
			}
			RxNormInteraction.deleteInteractions(language+"."+rxcuis);
			RxNormInteraction.storeInteraction(language+"."+rxcuis, ScreenHelper.sortedMap2String(interactions));
			return interactions;
		}
		else {
			return getDrugDrugInteractions(rxcuis);
		}
	}
	
	public static SortedMap getDrugDrugInteractions(String rxcuis){
		SortedMap interactions= new TreeMap();
		String s = RxNormInteraction.getInteraction(rxcuis);
		if(s!=null){
			return ScreenHelper.string2SortedMap(s);
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
		RxNormInteraction.deleteInteractions(rxcuis);
		RxNormInteraction.storeInteraction(rxcuis, ScreenHelper.sortedMap2String(interactions));
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
		Vector activePrescriptions = Prescription.findActive(personid,"","","","","","OC_PRESCR_BEGIN","DESC");
		for(int n=0;n<activePrescriptions.size();n++){
			Prescription prescription=(Prescription)activePrescriptions.elementAt(n);
			Product product = prescription.getProduct();
			if(product!=null && product.getRxnormcode()!=null && product.getRxnormcode().length()>0){
				rxcuis+=product.getRxnormcode().replaceAll(";", "+")+"+";
			}
		}
		return getDrugDrugInteractions(rxcuis);
	}
	
	public static SortedMap getPatientDrugDrugInteractions(String personid,String language){
		language=language.toLowerCase();
		String rxcuis="";
		//Find rxcuis from active patientmedication
		Vector activePrescriptions = Prescription.findActive(personid,"","","","","","OC_PRESCR_BEGIN","DESC");
		for(int n=0;n<activePrescriptions.size();n++){
			Prescription prescription=(Prescription)activePrescriptions.elementAt(n);
			Product product = prescription.getProduct();
			if(product!=null && product.getRxnormcode()!=null && product.getRxnormcode().length()>0){
				rxcuis+=product.getRxnormcode().replaceAll(";", "+")+"+";
			}
		}
		return getDrugDrugInteractions(rxcuis, language);
	}
}
