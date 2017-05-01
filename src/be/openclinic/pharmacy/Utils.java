package be.openclinic.pharmacy;

import java.io.BufferedReader;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.RxNormInteraction;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.system.Translate;
import be.openclinic.knowledge.ATCClass;
import be.openclinic.medical.Prescription;

public class Utils {

	public static String getRxNormCode(String sKey){
		String sRxNormCode = "";
		try{
			HttpClient client = new HttpClient();
			//First retrieve all rxcui for the term
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormCode","http://rxnav.nlm.nih.gov/REST/approximateTerm");
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			NameValuePair nvp1= new NameValuePair("term",sKey);
			NameValuePair nvp2= new NameValuePair("option","1");
			method.setQueryString(new NameValuePair[]{nvp1,nvp2});
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
			SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("rxnormdata")){
				Element approximateGroup=root.element("approximateGroup");
				Iterator candidates = approximateGroup.elementIterator("candidate");
				if(candidates.hasNext()){
					Element candidate = (Element)candidates.next();
					if(candidate.elementText("rxcui")!=null){
						String rxcui=candidate.elementText("rxcui");
						url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormProperties","http://rxnav.nlm.nih.gov/REST/rxcui/"+rxcui+"/properties");
						method = new GetMethod(url);
						method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
						statusCode = client.executeMethod(method);
						br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
						reader=new SAXReader(false);
						document=reader.read(br);
						root = document.getRootElement();
						if(root.getName().equalsIgnoreCase("rxnormdata")){
							Element properties = root.element("properties");
							if(properties!=null && properties.element("name")!=null){
								sRxNormCode=rxcui+";"+Integer.parseInt(candidate.elementText("score"))+";"+properties.elementText("name");
							}
						}
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return sRxNormCode;
	}
	
	public static String getRxNormCodeForATC(String sKey){
		String sRxNormCode = "";
		try{
			HttpClient client = new HttpClient();
			//First retrieve all rxcui for the term
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormCodeForATC","http://rxnav.nlm.nih.gov/REST/rxcui");
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			NameValuePair nvp1= new NameValuePair("idtype","ATC");
			NameValuePair nvp2= new NameValuePair("id",sKey);
			method.setQueryString(new NameValuePair[]{nvp1,nvp2});
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
			SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("rxnormdata")){
				Element idGroup=root.element("idGroup");
				if(idGroup!=null && idGroup.element("rxnormId")!=null){
					sRxNormCode=idGroup.element("rxnormId").getText();
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return sRxNormCode;
	}
	
	public static SortedSet getRxNormCodes(String sKey){
		TreeSet codes = new TreeSet();
		try{
			HttpClient client = new HttpClient();
			//First retrieve all rxcui for the term
			Hashtable rxcuis = new Hashtable();
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormCode","http://rxnav.nlm.nih.gov/REST/approximateTerm");
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			NameValuePair nvp1= new NameValuePair("term",sKey);
			method.setQueryString(new NameValuePair[]{nvp1});
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
			SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("rxnormdata")){
				Element approximateGroup=root.element("approximateGroup");
				Iterator candidates = approximateGroup.elementIterator("candidate");
				while(candidates.hasNext()){
					Element candidate = (Element)candidates.next();
					if(candidate.elementText("rxcui")!=null && rxcuis.get(candidate.element("rxcui"))==null){
						rxcuis.put(candidate.elementText("rxcui"),Integer.parseInt(candidate.elementText("score")));
					}
				}
			}
			
			//For all rxcuis, find the RxNorm name
			Enumeration e = rxcuis.keys();
			while(e.hasMoreElements()){
				String rxcui=(String)e.nextElement();
				url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormProperties","http://rxnav.nlm.nih.gov/REST/rxcui/"+rxcui+"/properties");
				method = new GetMethod(url);
				method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
				statusCode = client.executeMethod(method);
				br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
				reader=new SAXReader(false);
				document=reader.read(br);
				root = document.getRootElement();
				if(root.getName().equalsIgnoreCase("rxnormdata")){
					Element properties = root.element("properties");
					if(properties!=null && properties.element("name")!=null){
						String score="000"+(100-(Integer)rxcuis.get(rxcui));
						codes.add(score.substring(score.length()-3,score.length())+";"+properties.elementText("name")+";"+rxcui);
					}
				}
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return codes;
	}

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
	
	public static SortedMap extractATCCodes(String drugs){
		return extractATCCodes(drugs, MedwanQuery.getInstance().getConfigString("defaultLanguage","fr"));
	}
	
	public static SortedMap extractFullATCCodes(String drugs){
		return extractFullATCCodes(drugs, MedwanQuery.getInstance().getConfigString("defaultLanguage","fr"));
	}
	
	public static SortedMap extractATCCodes(String drugs,String language){
		SortedMap atccodes=new TreeMap();
		Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		PreparedStatement ps=null;
		ResultSet rs=null;
		try{
			String[] s = normalizeATCString(drugs).split(" ");
			for(int n=0;n<s.length;n++){
				s[n]+="e";
				int q=0;
				boolean bFound=false;
				while(!bFound && q<3 && s[n].trim().length()>MedwanQuery.getInstance().getConfigInt("lowerPharmaceuticalTokenLengthLimit",4)){
					q++;
					//Zoek de bijhorende atccode voor deze term
					ps=conn.prepareStatement("select * from oc_drugthesaurus where oc_drugthesaurus_normalizeddrugname=?");
					ps.setString(1,s[n]);
					rs=ps.executeQuery();
					if(rs.next()){
						ATCClass atc = ATCClass.get(rs.getString("oc_drugthesaurus_code"));
						if(atc!=null){
							atccodes.put(atc.getCode()+";"+s[n],atc.getLabel(language));
							bFound=true;
						}
					}
					rs.close();
					ps.close();
					s[n]=s[n].substring(0,s[n].length()-1);
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return atccodes;
	}
	
	public static SortedMap extractFullATCCodes(String drugs,String language){
		SortedMap atccodes=new TreeMap();
		Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		PreparedStatement ps=null;
		ResultSet rs=null;
		try{
			String[] s = normalizeATCString(drugs).split(" ");
			for(int n=0;n<s.length;n++){
				s[n]+="e";
				int q=0;
				boolean bFound=false;
				while(!bFound && q<3 && s[n].trim().length()>MedwanQuery.getInstance().getConfigInt("lowerPharmaceuticalTokenLengthLimit",4)){
					q++;
					//Zoek de bijhorende atccode voor deze term
					ps=conn.prepareStatement("select * from oc_drugthesaurus where oc_drugthesaurus_normalizeddrugname=?");
					ps.setString(1,s[n]);
					rs=ps.executeQuery();
					if(rs.next()){
						ATCClass atc = ATCClass.get(rs.getString("oc_drugthesaurus_code"));
						if(atc!=null){
							atccodes.put(atc.getCode()+";"+s[n],atc.getFullLabel(language));
							bFound=true;
						}
					}
					rs.close();
					ps.close();
					s[n]=s[n].substring(0,s[n].length()-1);
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return atccodes;
	}
	
	public static String normalizeATCString(String s){
		s=ScreenHelper.checkString(s).toLowerCase();
		s=s.replaceAll("0", "");
		s=s.replaceAll("1", "");
		s=s.replaceAll("2", "");
		s=s.replaceAll("3", "");
		s=s.replaceAll("4", "");
		s=s.replaceAll("5", "");
		s=s.replaceAll("6", "");
		s=s.replaceAll("7", "");
		s=s.replaceAll("8", "");
		s=s.replaceAll("9", "");
		s=s.replaceAll("é", "e");
		s=s.replaceAll("è", "e");
		s=s.replaceAll("ê", "e");
		s=s.replaceAll("ë", "e");
		s=s.replaceAll("à", "a");
		s=s.replaceAll("â", "a");
		s=s.replaceAll("û", "u");
		s=s.replaceAll("ü", "u");
		s=s.replaceAll("ç", "c");
		s=s.replaceAll("\\(", " ");
		s=s.replaceAll("\\)", " ");
		s=s.replaceAll("\\[", " ");
		s=s.replaceAll("\\]", " ");
		s=s.replaceAll("/", " ");
		s=s.replaceAll("\\+", " ");
		s=s.replaceAll("\\.", " ");
		s=s.replaceAll(",", " ");
		s=s.replaceAll(";", " ");
		s=s.replaceAll("'", "");
		s=s.replaceAll("y", "i");
		s=s.replaceAll("ph", "f");
		s=s.replaceAll("ck", "k");
		s=s.replaceAll("qu", "k");
		s=s.replaceAll("q", "k");
		s=s.replaceAll("ks", "x");
		s=s.replaceAll("k", "c");
		s=s.replaceAll("th", "t");
		s=s.replaceAll("-", " ");
		s=s.replaceAll("\r", "");
		s=s.replaceAll("\n", " ");
		return s;
	}

}
