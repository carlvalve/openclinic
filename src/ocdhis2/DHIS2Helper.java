package ocdhis2;

import java.io.File;
import java.net.SocketTimeoutException;
import java.util.Iterator;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.ws.rs.core.Response;
import javax.xml.bind.JAXBException;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class DHIS2Helper {
	public static void sendToServer(DataValueSet dataValueSet){
		String DHIS2_SERVER_URI = MedwanQuery.getInstance().getConfigString("dhis2_server_uri","https://dhis.snis.bi");
		String DHIS2_SERVER_BASE_API = MedwanQuery.getInstance().getConfigString("dhis2_server_api","/api");
		String DHIS2_SERVER_PORT = MedwanQuery.getInstance().getConfigString("dhis2_server_port","443");
		String OC_DHIS2_USER_NAME = MedwanQuery.getInstance().getConfigString("dhis2_server_username","fverbeke");
		String OC_DHIS2_USER_PWD = MedwanQuery.getInstance().getConfigString("dhis2_server_pwd","FVerbeke2015");
        DHIS2Server server = new DHIS2Server(DHIS2_SERVER_URI, DHIS2_SERVER_BASE_API, DHIS2_SERVER_PORT);
        server.setUserName(OC_DHIS2_USER_NAME);
        server.setUserPassword(OC_DHIS2_USER_PWD);
        
        try {
            System.out.println("Sending dataValueSet to DHIS2 server " + DHIS2_SERVER_URI);
            Response postResponse = server.sendToServer(dataValueSet);
            System.out.println("Status: " + postResponse.getStatus());
            System.out.println("Content: " + postResponse.getStatusInfo().getReasonPhrase());
            
            if(postResponse.hasEntity())
            {
                ImportSummary importSummary = postResponse.readEntity(ImportSummary.class);
                // elements of importSummary can also be read individually, and put on a feedback page for example
                // a feedback should be given especially if conflicts are reported
                System.out.println("Import summary: ");
                System.out.println(importSummary);
            }
            
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
	}
	
	public static StringBuffer toHtml(DataValueSet dataValueSet,String type,String language){
		StringBuffer html = new StringBuffer();
		if(type.equalsIgnoreCase("diagnosis")){
			try {
				Document document = DocumentHelper.parseText(dataValueSet.toXMLString());
				Element root = document.getRootElement();
				List cols=getDataSetColumns(root.attributeValue("dataSet"));
				int columns = 0;
				if(cols!=null){
					columns = cols.size();
				}
				//Print titel en dienst
				html.append("<table><tr class='admin'><td colspan='"+(1+columns)+"'>"+getDataSetTitle(root.attributeValue("dataSet"))+"</td></tr>");
				//Plaats de kolomtitels
				html.append("<tr class='admin'><td>"+getAttributeOptionComboName(root.attributeValue("dataSet"),root.attributeValue("attributeOptionCombo"))+"</td>");
				Iterator ic = cols.iterator();
				while(ic.hasNext()){
					Element column = (Element)ic.next();
					html.append("<td><center>"+column.attributeValue("name")+"</center></td>");
				}
				html.append("</tr>");
				//Verzamel alle datasets
				SortedMap results = new TreeMap();
				Iterator iCols=root.elementIterator("dataValue");
				while(iCols.hasNext()){
					Element r = (Element)iCols.next();
					results.put(getDataElementName(root.attributeValue("dataSet"), r.attributeValue("dataElement"), language)+";"+r.attributeValue("dataElement")+";"+r.attributeValue("categoryOptionCombo"), r.attributeValue("value"));
				}
				String activeDataElement = "";
				iCols = results.keySet().iterator();
				while(iCols.hasNext()){
					String key = (String)iCols.next();
					if(!activeDataElement.equalsIgnoreCase(key.split(";")[1])){
						//Print dataElement name
						html.append("<tr><td class='admin'>"+key.split(";")[0]+"</td>");
						//Vul nu in met de colommen
						Iterator ico = cols.iterator();
						while(ico.hasNext()){
							Element column = (Element)ico.next();
							String val = (String)results.get(key.split(";")[0]+";"+key.split(";")[1]+";"+column.attributeValue("uid"));
							html.append("<td class='admin2'><center><b>"+(val==null?"":val)+"</b></center></td>");
						}
						html.append("</tr>");
						activeDataElement=key.split(";")[1];
					}
				}
				html.append("</table>");
			} catch (DocumentException | JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return html;
	}
	
	public static String getDataSetTitle(String uid){
		String dhis2document=MedwanQuery.getInstance().getConfigString("dhis2document","c:/projects/openclinicnew/web/_common/xml/dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.attributeValue("uid").equals(uid)){
					return ScreenHelper.checkString(dataset.attributeValue("name"));
				}
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static String getDataElementName(String datasetuid, String uid,String language){
		String dhis2document=MedwanQuery.getInstance().getConfigString("dhis2document","c:/projects/openclinicnew/web/_common/xml/dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.attributeValue("uid").equals(datasetuid)){
					//This is the right dataset
					Iterator dataElements = dataset.element("dataelements").elementIterator("dataelement");
					while(dataElements.hasNext()){
						Element dataElement = (Element)dataElements.next();
						if(dataElement.attributeValue("uid").equals(uid)){
							return dataElement.attributeValue("code")+" - "+MedwanQuery.getInstance().getCodeTran("icd10", dataElement.attributeValue("code"), language);
						}
					}
				}
			} 
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static String getAttributeOptionComboName(String datasetuid, String uid){
		String dhis2document=MedwanQuery.getInstance().getConfigString("dhis2document","c:/projects/openclinicnew/web/_common/xml/dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.attributeValue("uid").equals(datasetuid)){
					//This is the right dataset
					Element attributeOptionCombo = dataset.element("attributeOptionCombo");
					if(attributeOptionCombo!=null){
						Iterator options = attributeOptionCombo.elementIterator("option");
						while(options.hasNext()){
							Element option = (Element)options.next();
							if(option.attributeValue("uid").equals(uid)){
								return option.attributeValue("name");
							}
						}
					}
				}
			} 
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static List getDataSetColumns(String uid){
		String dhis2document=MedwanQuery.getInstance().getConfigString("dhis2document","c:/projects/openclinicnew/web/_common/xml/dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.attributeValue("uid").equals(uid)){
					Element combo = dataset.element("categoryOptionCombo");
					List j = combo.elements("option");
					return j;
				}
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return null;
	}
}
