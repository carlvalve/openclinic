package ocdhis2;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import javax.xml.bind.JAXBException;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class DHIS2Exporter {
	private Date begin=null;
	private Date end=null;
	private Document dhis2document=null;
	private Hashtable departmentmaps=loadDepartmentMaps();
	private String exportFormat;
	private StringBuffer html;
	String language="en";
	
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getExportFormat() {
		return exportFormat;
	}
	public void setExportFormat(String exportFormat) {
		this.exportFormat = exportFormat;
	}
	public StringBuffer getHtml() {
		return html;
	}
	public void setHtml(StringBuffer html) {
		this.html = html;
	}
	public Date getBegin() {
		return begin;
	}
	public void setBegin(Date begin) {
		this.begin = begin;
	}
	public Date getEnd() {
		return end;
	}
	public void setEnd(Date end) {
		this.end = end;
	}
	public Document getDhis2document() {
		return dhis2document;
	}
	public void setDhis2document(Document dhis2document) {
		this.dhis2document = dhis2document;
	}
	
	public boolean setDhis2document(String documentname) {
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(documentname));
			setDhis2document(document);
		} catch (DocumentException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	private Hashtable loadDepartmentMaps(){
		Hashtable h = new Hashtable();
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select serviceid,inscode from services");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String serviceid = ScreenHelper.checkString(rs.getString("serviceid")).toLowerCase();
				String inscode = ScreenHelper.checkString(rs.getString("inscode")).toLowerCase();
				if(serviceid.length()>0 && inscode.length()>0){
					h.put(serviceid, inscode);
				}
			}
			rs.close();
			ps.close();
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
		return h;
	}
	
	public boolean export(String exportFormat){
		this.exportFormat=exportFormat;
		html=new StringBuffer();
		if(begin==null){
			System.out.println("DHIS2 export error: begin of period is missing");
			return false;
		}
		else if(end==null){
			System.out.println("DHIS2 export error: end of period is missing");
			return false;
		}
		else if(dhis2document==null){
			System.out.println("DHIS2 export error: DHIS2 configuration file is missing");
			return false;
		}
		Element root = dhis2document.getRootElement();
		//Step 1: make a list of all dataset types that are needed
		HashSet datasetTypes = new HashSet();
		Iterator iDatasets = root.elementIterator("dataset");
		while(iDatasets.hasNext()){
			Element dataset = (Element)iDatasets.next();
			datasetTypes.add(dataset.attributeValue("type").toLowerCase());
		}
		//Step 2: iterate through all dataset types and export all datasets for each type
		Iterator iDatasetTypes = datasetTypes.iterator();
		while(iDatasetTypes.hasNext()){
			Vector items = new Vector();
			String datasetType = (String)iDatasetTypes.next();
			System.out.println("Exporting dataset type "+datasetType);
			if(datasetType.equalsIgnoreCase("diagnosis")){
				items=loadDiagnoses();
			}
			iDatasets = root.elementIterator("dataset");
			while(iDatasets.hasNext()){
				Element dataset = (Element)iDatasets.next();
				if(dataset.attributeValue("type").equalsIgnoreCase(datasetType)){
					System.out.println("Exporting dataset "+dataset.attributeValue("uid"));
					exportDataset(dataset,items);
				}
			}
		}
		return true;
	}
	
	private void exportDataset(Element dataset,Vector items){
		Element attributeOptionCombo = dataset.element("attributeOptionCombo");
		String department=null;
		if(attributeOptionCombo!=null){
			Vector selectedItems = new Vector();
			String attributeOptionComboType=attributeOptionCombo.attributeValue("type");
			//Iterator through all attributeOptionCombo values
			Iterator iattributeOptionComboValues = attributeOptionCombo.elementIterator();
			while(iattributeOptionComboValues.hasNext()){
				selectedItems = new Vector();
				Element attributeOptionComboValue=(Element)iattributeOptionComboValues.next();
				//For the time being, o,ly department exists as attributeOptionComboType
				if(attributeOptionComboType.equalsIgnoreCase("department")){
					department=attributeOptionComboValue.attributeValue("value");
					System.out.println("Exporting attributeOptionType "+attributeOptionCombo.attributeValue("type")+" - "+department);
				}
				for(int n=0;n<items.size();n++){
					String item = (String)items.elementAt(n);
					//Check if the serviceid associated to the diagnosis is mapped onto the dhis2 department code
					if(department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[6])))){
						selectedItems.add(item);
					}
				}
				if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
					exportDiagnosisDataset(selectedItems,dataset,attributeOptionComboValue.attributeValue("uid"));
				}
			}
		}
		else{
			if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
				exportDiagnosisDataset(items,dataset,"");
			}
		}
	}
	
	private void exportDiagnosisDataset(Vector items,Element dataset, String attributeOptionComboUid){
		String gender=null;
		int minAge=-1;
		int maxAge=-1;
		//This is where we create the DataValueSet
        DataValueSet dataValueSet = new DataValueSet();
        dataValueSet.setDataSet(dataset.attributeValue("uid"));
        dataValueSet.setOrgUnit(MedwanQuery.getInstance().getConfigString("dhis2_orgunit",""));
        dataValueSet.setPeriod(new SimpleDateFormat("yyyyMM").format(begin));
        dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(end));
        dataValueSet.setAttributeOptionCombo(attributeOptionComboUid);

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
					minAge=Integer.parseInt(categoryOptionComboValue.attributeValue("min"));
					maxAge=Integer.parseInt(categoryOptionComboValue.attributeValue("max"));
					System.out.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
					gender=categoryOptionComboValue.attributeValue("value");
					System.out.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
					minAge=Integer.parseInt(categoryOptionComboValue.attributeValue("min"));
					maxAge=Integer.parseInt(categoryOptionComboValue.attributeValue("max"));
					gender=categoryOptionComboValue.attributeValue("gender");
					System.out.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
				}
				for(int n=0;n<items.size();n++){
					String item = (String)items.elementAt(n);
					//Check if the serviceid associated to the diagnosis is mapped onto the dhis2 department code
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2])){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						long year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2]) && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						long year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
				}
				exportDiagnosisDatasetSeries(selectedItems,dataset,attributeOptionComboUid,categoryOptionComboValue.attributeValue("uid"),dataValueSet);
			}
		}
		else{
			exportDiagnosisDatasetSeries(items,dataset,attributeOptionComboUid,"",dataValueSet);
		}
		if(MedwanQuery.getInstance().getConfigInt("sendEmptyDHIS2DataSets",0)==1 || dataValueSet.getDataValues().size()>0){
			try {
				System.out.println(dataValueSet.toXMLString());
			} catch (JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//Send message to DHIS2 server
			if(exportFormat.equalsIgnoreCase("dhis2server")){
				DHIS2Helper.sendToServer(dataValueSet);
			}
			else if(exportFormat.equalsIgnoreCase("html")){
				html.append(DHIS2Helper.toHtml(dataValueSet,"diagnosis",language));
				html.append("<p/>");
			}
		}
	}
	
	private void exportDiagnosisDatasetSeries(Vector items,Element dataset,String attributeOptionComboUid,String categoryOptionUid, DataValueSet dataValueSet){
		//Set diagnosis specific attributes
		//We already have the attributeOptionCombo uid and categoryOptionCombo uid
		//We only have to calculate the values now, based on the extra attributes
		//Now we must also match the code of each diagnosis on a dataelement code from the dataset
		Hashtable targetcodes = new Hashtable();
		Hashtable uidcounters = new Hashtable();
		Hashtable uidmaps = new Hashtable();
		Iterator i = dataset.element("dataelements").elementIterator("dataelement");
		while(i.hasNext()){
			Element dataelement = (Element)i.next();
			targetcodes.put(dataelement.attributeValue("code").toLowerCase(), dataelement.attributeValue("uid"));
			uidmaps.put(dataelement.attributeValue("uid"), dataelement.attributeValue("code"));
			if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1){
				uidcounters.put(dataelement.attributeValue("uid"), 0);
			}
		}
		boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
		boolean bNewcase = ScreenHelper.checkString(dataset.attributeValue("newcase")).equalsIgnoreCase("true");
		String sTransaction = ScreenHelper.checkString(dataset.attributeValue("transaction"));
		String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));
		//We must calculate the total diagnosis weights of all encounters
		Hashtable encounterbod = new Hashtable();
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			if(!bMortality || item.split(";")[8].startsWith("dead")){
				if(!bNewcase || item.split(";")[9].equalsIgnoreCase("1")){
					if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[11]).equalsIgnoreCase(sEncounterType)){
						if(sTransaction.length()==0 || MedwanQuery.getInstance().getTransactionType(ScreenHelper.checkString(item.split(";")[12])).equalsIgnoreCase(sTransaction)){
							if(encounterbod.get(item.split(";")[1])==null){
								encounterbod.put(item.split(";")[1], Integer.parseInt(item.split(";")[10]));
							}
							else{
								encounterbod.put(item.split(";")[1],((Integer)encounterbod.get(item.split(";")[1]))+Integer.parseInt(item.split(";")[10]));
							}
						}
					}
				}
			}
		}
		String classification = ScreenHelper.checkString(dataset.attributeValue("classification")).toLowerCase();
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			if(classification==null || classification.equalsIgnoreCase(item.split(";")[4])){
				if(!bMortality || item.split(";")[8].startsWith("dead")){
					if(!bNewcase || item.split(";")[9].equalsIgnoreCase("1")){
						if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[11]).equalsIgnoreCase(sEncounterType)){
							if(sTransaction.length()==0 || MedwanQuery.getInstance().getTransactionType(ScreenHelper.checkString(item.split(";")[12])).equalsIgnoreCase(sTransaction)){
								//First find a matching targetcode
								String code = item.split(";")[5].toLowerCase();
								String match=null;
								while(code.length()>0){
									match = (String)targetcodes.get(code);
									if(match!=null || code.length()==1){
										break;
									}
									code=code.substring(0,code.length()-1);	
								}
								if(match==null){
									match=(String)targetcodes.get("other");
								}
								if(match!=null){
									double value=1;
									if(bMortality){
										//******************************************
										//Mortality is distributed over all diagnoses according to their weight
										//******************************************
										double diagnosisweight=Double.parseDouble(item.split(";")[10]);
										double encounterweight=new Double((Integer)encounterbod.get(item.split(";")[1]));
										value=diagnosisweight/encounterweight;
									}
									if(uidcounters.get(match)==null){
										uidcounters.put(match, value);
									}
									else{
										uidcounters.put(match,(Double)uidcounters.get(match)+value);
									}
								}
							}
						}
					}
				}
			}
		}
		i = uidcounters.keySet().iterator();
		while(i.hasNext()){
			String uid=(String)i.next();
	        dataValueSet.getDataValues().add(new DataValue(uid,categoryOptionUid,new Double(Math.ceil((Double)uidcounters.get(uid))).intValue()+"",""));
		}
	}
	
	private Vector loadDiagnoses(){
		Vector items = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sSql = 	"select personid,oc_diagnosis_encounteruid,gender,dateofbirth,oc_diagnosis_codetype,oc_diagnosis_code,oc_diagnosis_serviceuid,oc_diagnosis_flags,oc_encounter_outcome,oc_diagnosis_nc,oc_diagnosis_gravity,oc_encounter_type,oc_diagnosis_referenceuid"
							+ " from adminview a,oc_encounters b,oc_diagnoses c"
							+ " where"
							+ " a.personid=b.oc_encounter_patientuid and"
							+ " b.oc_encounter_objectid=replace(c.oc_diagnosis_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " (oc_encounter_enddate>=? and oc_encounter_enddate<?)";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				int gravity = Integer.parseInt(rs.getString("oc_diagnosis_gravity"));
				if(gravity==0){
					gravity=1;
				}
				String item = rs.getString("personid")+";"
						+rs.getString("oc_diagnosis_encounteruid")+";"
						+rs.getString("gender")+";"
						+ScreenHelper.formatDate(rs.getDate("dateofbirth"))+";"
						+rs.getString("oc_diagnosis_codetype")+";"+
						rs.getString("oc_diagnosis_code")+";"
						+rs.getString("oc_diagnosis_serviceuid").toLowerCase()+";"
						+rs.getString("oc_diagnosis_flags")+";"
						+rs.getString("oc_encounter_outcome")+";"
						+rs.getString("oc_diagnosis_nc")+";"
						+gravity+";"
						+rs.getString("oc_encounter_type")+";"
						+rs.getString("oc_diagnosis_referenceuid")+";";
				System.out.println(item);
				items.add(item);
			}
			rs.close();
			ps.close();
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
		return items;
	}
}
