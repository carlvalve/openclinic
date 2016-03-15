package be.mxs.common.util.io;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import be.mxs.common.util.db.MedwanQuery;
import net.admin.AdminPerson;

public class ExportNHIFEClaims {

	public static String sub(String s,int length){
		if(s==null){
			s="";
		}
		if(s.length()>length){
			return s.substring(0,length);
		}
		else{
			return s;
		}
	}
	public static void main(String[] args) throws ClassNotFoundException, SQLException, ParseException {
		// TODO Auto-generated method stub
		long day=24*3600*1000;
		// This will load the MySQL driver, each DB has its own driver
	    System.out.println("driver OpenClinic="+args[0]);
	    System.out.println("url OpenClinic="+args[1]);
	    System.out.println("driver EClaims="+args[2]);
	    System.out.println("url EClaims="+args[3]);
	    Class.forName(args[0]);			
	    Connection conn =  DriverManager.getConnection(args[1]);
	    Connection conn2 =  DriverManager.getConnection(args[1]);
	    Class.forName(args[2]);			
	    Connection nhifconn =  DriverManager.getConnection(args[3]);
	    //Eerst moeten we de afgesloten NHIF facturen opzoeken
	    String sSql="select * from oc_config where oc_key='MFP'";
	    PreparedStatement ps = conn.prepareStatement(sSql);
	    ResultSet rs = ps.executeQuery();
	    String sNHIF="";
	    if(rs.next()){
	    	sNHIF=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
	    sSql="select * from oc_config where oc_key='concatSign'";
	    ps = conn.prepareStatement(sSql);
	    rs = ps.executeQuery();
	    String sConcatSign="||";
	    if(rs.next()){
	    	sConcatSign=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
	    sSql="select * from oc_config where oc_key='NHIFFacilityCode'";
	    ps = conn.prepareStatement(sSql);
	    rs = ps.executeQuery();
	    String sNHIFFacilityCode="03993";
	    if(rs.next()){
	    	sNHIFFacilityCode=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
	    sSql="select * from oc_config where oc_key='NHIFUserName'";
	    ps = conn.prepareStatement(sSql);
	    rs = ps.executeQuery();
	    String sNHIFUserName="donarth";
	    if(rs.next()){
	    	sNHIFUserName=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
    	if(sNHIF.length()>0){
    		System.out.println("NHIF UID = "+sNHIF);
    		rs.close();
    		ps.close();
    		//We exporteren automatisch voor de vorige maand, tenzij een specifieke periode wordt opgegeven
    		int activeyear = Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()));
    		int activemonth = Integer.parseInt(new SimpleDateFormat("MM").format(new java.util.Date()));
    		if(args.length>4 && args[4].split("/").length>1){
    			activemonth= Integer.parseInt(args[4].split("/")[0]);
    			activeyear= Integer.parseInt(args[4].split("/")[1]);
    			if(activemonth==12){
    				activemonth=1;
    				activeyear+=1;
    			}
    			else{
    				activemonth+=1;
    			}
    		}
    		java.util.Date dBegin = null, dEnd = null;
    		if(activemonth==1){
        		dBegin = new SimpleDateFormat("dd/MM/yyyy").parse("01/12/"+(activeyear-1));
        		dEnd = new SimpleDateFormat("dd/MM/yyyy").parse("01/01/"+activeyear);
    		}
    		else {
        		dBegin = new SimpleDateFormat("dd/MM/yyyy").parse("01/"+(activemonth-1)+"/"+activeyear);
        		dEnd = new SimpleDateFormat("dd/MM/yyyy").parse("01/"+(activemonth)+"/"+activeyear);
    		}
    		System.out.println("Investigating period "+new SimpleDateFormat("dd/MM/yyyy").format(dBegin)+" - "+new SimpleDateFormat("dd/MM/yyyy").format(dEnd));
    		//Search for all closed patient invoices for this insurer in the specified period
    		if(sConcatSign.equalsIgnoreCase("||")){
	    		sSql="select distinct b.*,OC_INSURANCE_NR from oc_debets a, oc_patientinvoices b, oc_insurances c where"
	    				+ " oc_debet_patientinvoiceuid='1.'||oc_patientinvoice_objectid and"
	    				+ " oc_patientinvoice_date>=? and"
	    				+ " oc_patientinvoice_date<? and"
	    				+ " oc_insurance_objectid=replace(oc_debet_insuranceuid,'1.','') and"
	    				+ " length(oc_patientinvoice_comment)>0 and"
	    				+ " oc_insurance_insuraruid=? order by oc_patientinvoice_objectid";
    		}
    		else{
	    		sSql="select distinct b.*,OC_INSURANCE_NR from oc_debets a, oc_patientinvoices b, oc_insurances c where"
	    				+ " oc_debet_patientinvoiceuid='1.'+convert(varchar,oc_patientinvoice_objectid) and"
	    				+ " oc_patientinvoice_date>=? and"
	    				+ " oc_patientinvoice_date<? and"
	    				+ " oc_insurance_objectid=replace(oc_debet_insuranceuid,'1.','') and"
	    				+ " len(oc_patientinvoice_comment)>0 and"
	    				+ " oc_insurance_insuraruid=? order by oc_patientinvoice_objectid";
    		}
    		ps = conn2.prepareStatement(sSql);
    		ps.setDate(1, new java.sql.Date(dBegin.getTime()));
    		ps.setDate(2, new java.sql.Date(dEnd.getTime()));
    		ps.setString(3, sNHIF);
    		rs=ps.executeQuery();
    		int lines=0;
    		while(rs.next()){
    			lines++;
    			int nInvoiceObjectId=rs.getInt("oc_patientinvoice_objectid");
    			if(lines % 20 ==0){
    				conn.close();
    				conn =  DriverManager.getConnection(args[1]);    				
    				nhifconn.close();
    				nhifconn =  DriverManager.getConnection(args[3]);
    			}
    			System.out.println("========================================================");
    			System.out.println("Found invoice "+nInvoiceObjectId+" on "+rs.getDate("oc_patientinvoice_date"));
    			System.out.println("========================================================");
    			//Eerst controleren we of er voor de specifieke periode wel degelijk een ClaimRegistration werd opgemaakt
    			String sClaimNo="CCBRT/NHIF/"+new SimpleDateFormat("MMM/yyyy").format(dBegin).toUpperCase();
    			sSql="select * from ClaimRegistration where ClaimNo=?";
    			PreparedStatement ps2 = nhifconn.prepareStatement(sSql);
    			ps2.setString(1, sub(sClaimNo,50));
    			ResultSet rs2=ps2.executeQuery();
    			if(!rs2.next()){
    				System.out.println("Creating ClaimRegistration N°"+sClaimNo);
    				rs2.close();
    				ps2.close();
    				sSql="insert into ClaimRegistration(ClaimNo,FacilityCode,ClaimMonth,ClaimYear,RemoteClaimNo,ReceivedDate,TreatmentDateFrom,TreatmentDateTo,FoliosSubmitted,AmountClaimed,AmountPaid,Status,Remarks,createdby,datecreated,lastmodifiedby,lastmodified)"
    						+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    				ps2=nhifconn.prepareStatement(sSql);
    				ps2.setString(1, sClaimNo);
    				ps2.setString(2, sNHIFFacilityCode);
    				ps2.setInt(3,Integer.parseInt(new SimpleDateFormat("MM").format(dBegin)));
    				ps2.setInt(4,Integer.parseInt(new SimpleDateFormat("yyyy").format(dBegin)));
    				ps2.setString(5, "");
    				ps2.setDate(6, null);
    				ps2.setDate(7,new java.sql.Date(dBegin.getTime()));
    				ps2.setDate(8,new java.sql.Date(dEnd.getTime()-day));
    				ps2.setInt(9, 0);
    				ps2.setDouble(10, 0);
    				ps2.setDouble(11, 0);
    				ps2.setString(12, "Open");
    				ps2.setString(13, "");
    				ps2.setString(14, sNHIFUserName);
    				ps2.setDate(15, new java.sql.Date(new java.util.Date().getTime()));
    				ps2.setString(16, sNHIFUserName);
    				ps2.setDate(17, new java.sql.Date(new java.util.Date().getTime()));
    				ps2.execute();
    			}
    			rs2.close();
    			ps2.close();
    			String sFolioId="";
    			java.util.Date dInvoice	= rs.getDate("OC_PATIENTINVOICE_DATE");

    			//Nu gaan we controleren of voor deze factuur reeds een folio bestaat, 
    			//indien neen, creëer een nieuw folio obv het serial number
    			String sSerialNo = rs.getString("OC_PATIENTINVOICE_COMMENT");
    			sSql="select * from Folios where ClaimNo=? and SerialNo=?";
    			ps2=nhifconn.prepareStatement(sSql);
    			ps2.setString(1, sub(sClaimNo,50));
    			ps2.setString(2, sub(sSerialNo,50));
    			rs2=ps2.executeQuery();
    			if(rs2.next()){
    				sFolioId=rs2.getString("FolioID");
    				System.out.println("Found existing Folio with ID "+sFolioId);
    			}
    			else {
    				//We creëren een nieuw Folio want het bestaat nog niet;
    				//We zoeken eerst het hoogste bestaande FolioNo op voor deze ClaimNo
    				rs2.close();
    				ps2.close();
    				//Now let's find the patient data
    				PreparedStatement ps3 = conn.prepareStatement("select * from adminview where personid=?");
    				int nPatientId=rs.getInt("OC_PATIENTINVOICE_PATIENTUID");
    				ps3.setInt(1, nPatientId);
    				ResultSet rs3 = ps3.executeQuery();
    				if(rs3.next()){
	    				int nFolioNo=1;
	    				sSql="select max(FolioNo) maxno from Folios where ClaimNo=?";
	    				ps2=nhifconn.prepareStatement(sSql);
	    				ps2.setString(1, sClaimNo);
	    				rs2=ps2.executeQuery();
	    				if(rs2.next()){
	    					Integer i = rs2.getInt("maxno");
	    					if(i!=null){
	    						nFolioNo=i+1;
	    					}
	    				}
	    				rs2.close();
	    				ps2.close();
	    				sSql="insert into Folios(folioid,claimno,foliono,serialno,cardno,firstname,lastname,gender"
	    						+ ",age,attendancedate,patientfileno,authorizationno,servicetypeid,"
	    						+ "sourcefacilitycode,sourcedocumentno,letterrefno,patienttypecode,dateadmitted,"
	    						+ "datedischarged,createdby,datecreated,lastmodified,lastmodifiedby)"
	    						+ "values(newid(),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	    				ps2=nhifconn.prepareStatement(sSql);
	    				ps2.setString(1, sub(sClaimNo,50));
	    				ps2.setInt(2,nFolioNo);
	    				ps2.setString(3, sub(sSerialNo,50));
	    				ps2.setString(4, sub(rs.getString("OC_INSURANCE_NR"),20));
	    				ps2.setString(5, sub(rs3.getString("firstname"),50));
	    				ps2.setString(6, sub(rs3.getString("lastname"),50));
	    				String sGender=rs3.getString("gender");
	    				ps2.setString(7, sGender!=null && sGender.equalsIgnoreCase("M")?"Male":"Female");
	    				String sInvoiceUid="1."+rs.getString("oc_patientinvoice_objectid");
	    				java.util.Date dBirth = rs3.getDate("dateofbirth");
	    				ps2.setDouble(8, dBirth==null?-1:getNrYears(dBirth, dInvoice));
	    				ps2.setDate(9, new java.sql.Date(dInvoice.getTime()));
	    				ps2.setString(10,nPatientId+"");
	    				ps2.setString(11,sub(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"),20));
	    				ps2.setInt(12,1);
	    				ps2.setString(13,null);
	    				ps2.setString(14,null);
	    				String sModifiers = rs.getString("OC_PATIENTINVOICE_MODIFIERS");
	    				ps2.setString(15,sModifiers.split(";")[0]);
	    				rs3.close();
	    				ps3.close();
	    				String sStatus="OUT";
	    				java.util.Date dAdmitted=null,dDischarged=null;
	    				ps3=conn.prepareStatement("select * from oc_debets,oc_encounters where oc_debet_patientinvoiceuid=? and oc_encounter_objectid=replace(oc_debet_encounteruid,'1.','')");
	    				ps3.setString(1, sInvoiceUid);
	    				rs3=ps3.executeQuery();
	    				if(rs3.next()){
	    					String s = rs3.getString("oc_encounter_type");
	    					if(s!=null && s.equalsIgnoreCase("admission")){
	    						sStatus="IN";
		    					dAdmitted=rs3.getDate("oc_encounter_begindate");
		    					dDischarged=rs3.getDate("oc_encounter_enddate");
	    					}
	    				}
	    				ps2.setString(16, sStatus);
	    				ps2.setDate(17, dAdmitted==null?null:new java.sql.Date(dAdmitted.getTime()));
	    				ps2.setDate(18, dDischarged==null?null:new java.sql.Date(dDischarged.getTime()));
	    				ps2.setString(19, sNHIFUserName);
	    				ps2.setDate(20, new java.sql.Date(dInvoice.getTime()));
	    				ps2.setDate(21, new java.sql.Date(new java.util.Date().getTime()));
	    				ps2.setString(22, sNHIFUserName);
	    				ps2.execute();
    				}
    				rs3.close();
    				ps3.close();
    				rs2.close();
    				ps2.close();
        			sSql="select * from Folios where ClaimNo=? and SerialNo=?";
        			ps2=nhifconn.prepareStatement(sSql);
        			ps2.setString(1, sClaimNo);
        			ps2.setString(2, sSerialNo);
        			rs2=ps2.executeQuery();
        			if(rs2.next()){
        				sFolioId=rs2.getString("FolioID");
        				System.out.println("Created new Folio with ID "+sFolioId);
        			}
    			}
    			rs2.close();
    			ps2.close();
    			//Nu zouden we een folio moeten hebben waar we de folioitems (prestaties) kunnen aan toevoegen
    			if(sFolioId.length()>0){
    				//Eerst zoeken we alle prestaties op die aan de actieve factuur verbonden zijn
    				PreparedStatement ps3=conn.prepareStatement("select * from oc_debets,oc_prestations where oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','') and oc_debet_patientinvoiceuid=? and oc_debet_credited=0");
    				ps3.setString(1, "1."+nInvoiceObjectId);
    				ResultSet rs3=ps3.executeQuery();
    				while(rs3.next()){
    					String sDebetUid="OpenClinic invoice ID: "+nInvoiceObjectId+" Health service ID: "+rs3.getInt("oc_debet_objectid");
    					String sDebetInternalCode=rs3.getString("oc_prestation_code");
    					//Hier beslissen welke code wordt gebruikt: interne code of NHIF code
    					//interne code = OC_PRESTATION_CODE
    					//NHIF code = OC_PRESTATION_NOMENCLATURE
    					String sDebetCode=rs3.getString("oc_prestation_nomenclature");
    					if(sDebetCode!=null && sDebetCode.length()>0){
	    					try{
	    						sDebetCode=Integer.parseInt(sDebetCode)+"";
	    					}
	    					catch(Exception e){
	    						e.printStackTrace();
	    					}
	    					int nQuantity=rs3.getInt("OC_DEBET_QUANTITY");
	    					if(nQuantity>0){
		    					//Eerst kijken we of dit item nog niet is toegevoegd geworden
		    					sSql="select * from FolioItems where FolioID=? and OtherDetails=?";
		    					ps2=nhifconn.prepareStatement(sSql);
		    					ps2.setString(1, sFolioId);
		    					ps2.setString(2, sDebetUid);
		    					rs2=ps2.executeQuery();
		    					if(rs2.next()){
		    						System.out.println("Folio item "+rs2.getString("FolioItemID")+" already exists for debet "+sDebetUid);
		    					}
		    					else {
		    						System.out.println("Insert new Folio item for debet "+sDebetUid);
		    						int nItemTypeId=-1;
		    						double nUnitPrice=0;
		    						rs2.close();
		    						ps2.close();
		    						sSql="select * from PackageItems where ItemCode=?";
		    						ps2=nhifconn.prepareStatement(sSql);
		    						ps2.setString(1, sDebetCode);
		    						rs2=ps2.executeQuery();
		    						if(rs2.next()){
		    							nItemTypeId=rs2.getInt("ItemTypeId");
		    							nUnitPrice=rs2.getDouble("UnitPrice");
		    						}
		    						if(nItemTypeId>-1){
		        						rs2.close();
		        						ps2.close();
				    					sSql="insert into FolioItems(FolioItemID,FolioID,ItemTypeID,ItemCode,OtherDetails,ItemQuantity,"
				    							+ "UnitPrice,AmountClaimed,CreatedBy,datecreated,lastmodifiedby,lastmodified)"
				    							+ " values(newid(),?,?,?,?,?,?,?,?,?,?,?)";
				    					ps2=nhifconn.prepareStatement(sSql);
				    					ps2.setString(1, sFolioId);
				    					ps2.setInt(2,nItemTypeId);
				    					ps2.setString(3, sDebetCode);
				    					ps2.setString(4, sDebetUid);
				    					ps2.setInt(5,nQuantity);
				    					ps2.setDouble(6, nUnitPrice);
				    					ps2.setDouble(7,nQuantity*nUnitPrice);
				    					ps2.setString(8, sNHIFUserName);
				    					ps2.setDate(9, new java.sql.Date(dInvoice.getTime()));
				    					ps2.setString(10, sNHIFUserName);
				    					ps2.setDate(11, new java.sql.Date(new java.util.Date().getTime()));
				    					ps2.execute();
		    						}
		    						else{
		    							System.out.println("Health service code "+sDebetCode+" has no mapping on NHIF code table");
		        						sSql="delete from unknownhealthservicecodes where code=? and type='wrong-nhif'";
		        						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
		        						ps4.setString(1, sDebetInternalCode);
		        						ps4.execute();
		        						ps4.close();
		        						sSql="insert into unknownhealthservicecodes(code,type) values(?,'wrong-nhif')";
		        						ps4=nhifconn.prepareStatement(sSql);
		        						ps4.setString(1, sDebetInternalCode);
		        						ps4.execute();
		        						ps4.close();
		    						}
		    					}
		    					rs2.close();
		    					ps2.close();
	    					}
    					}
    					else {
    						System.out.println("NHIF code has not been specified for debet code "+sDebetInternalCode);
    						sSql="delete from unknownhealthservicecodes where code=? and type='no-nhif'";
    						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1, sDebetInternalCode);
    						ps4.execute();
    						ps4.close();
    						sSql="insert into unknownhealthservicecodes(code,type) values(?,'no-nhif')";
    						ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1, sDebetInternalCode);
    						ps4.execute();
    						ps4.close();
    					}
    				}
    				rs3.close();
    				ps3.close();
    				//Nu gaan we alle ziektecodes opzoeken die aan de encounters van deze factuur verbonden zijn
    				//De codes moeten geconverteerd worden en daarna toegevoegd aan e-Claims
    				ps3=conn.prepareStatement("select distinct oc_diagnosis_code from oc_debets,oc_diagnoses,oc_encounters a,oc_encounters b"+
    										" where oc_debet_patientinvoiceuid=? and"+ 
    										" a.OC_ENCOUNTER_OBJECTID=REPLACE(oc_debet_encounteruid,'1.','') and"+
    										" b.OC_ENCOUNTER_PATIENTUID=a.OC_ENCOUNTER_PATIENTUID and"+
    										" OC_DIAGNOSIS_ENCOUNTERUID='1.'+CONVERT(varchar,b.oc_encounter_objectid) and"+
    										" DATEDIFF(day,a.oc_encounter_begindate,b.oc_encounter_begindate)=0 and oc_diagnosis_codetype='icd10'");
    				ps3.setString(1, "1."+nInvoiceObjectId);
    				rs3=ps3.executeQuery();
    				boolean bFoundUnmapped=false;
    				while(rs3.next()){
    					//We zoeken nu de mapping op naar de diagnoses in NHIF, indien niet gevonden gebruiken we 0
    					ps2=conn.prepareStatement("select * from icd10_to_nhif where icd10 like ?");
    					String sIcd10=rs3.getString("oc_diagnosis_code");
						System.out.println("Adding ICD10 code "+sIcd10);
    					ps2.setString(1, sIcd10+"%");
    					rs2=ps2.executeQuery();
    					int n=0;
    					if(rs2.next()){
    						n++;
    						String sNHIFcode = rs2.getInt("NHIF")+"";
    						//Eerst controleren of deze diagnose niet reeds werd toegevoegd
    						sSql="select * from FolioDiseases where FolioID=? and DiseaseCode=?";
    						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1,sFolioId);
    						ps4.setString(2, sNHIFcode);
    						ResultSet rs4=ps4.executeQuery();
    						if(rs4.next()){
    							System.out.println("Disease Folio ID "+rs4.getString("FolioID")+" is already mapped to disease code "+sNHIFcode);
    						}
    						else{
    							System.out.println("Creating Disease Folio ID for disease code "+sNHIFcode);
    							rs4.close();
    							ps4.close();
    							sSql="insert into FolioDiseases(FolioDiseaseID,DiseaseCode,FolioID,Remarks,"
    									+ "CreatedBy,DateCreated,LastModifiedBy,LastModified)"
    									+ " values(newid(),?,?,?,?,?,?,?)";
    							ps4=nhifconn.prepareStatement(sSql);
    							ps4.setString(1,sNHIFcode);
    							ps4.setString(2, sFolioId);
    							ps4.setString(3, "ICD10: "+sIcd10);
    							ps4.setString(4, sNHIFUserName);
    							ps4.setDate(5, new java.sql.Date(dInvoice.getTime()));
    							ps4.setString(6, sNHIFUserName);
    							ps4.setDate(7, new java.sql.Date(new java.util.Date().getTime()));
    							ps4.execute();
    						}
    						rs4.close();
    						ps4.close();
    					}
    					else{
    						if(sIcd10.split("\\.").length>1){
    							sIcd10=sIcd10.split("\\.")[0];
    							System.out.println("Not found, trying ICD10 code "+sIcd10);
    							rs2.close();
    							ps2.close();
    	    					ps2=conn.prepareStatement("select * from icd10_to_nhif where icd10 like ?");
    	    					ps2.setString(1, sIcd10+"%");
    	    					rs2=ps2.executeQuery();
    	    					if(rs2.next()){
    	    						n++;
    	    						String sNHIFcode = rs2.getInt("NHIF")+"";
    	    						//Eerst controleren of deze diagnose niet reeds werd toegevoegd
    	    						sSql="select * from FolioDiseases where FolioID=? and DiseaseCode=?";
    	    						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
    	    						ps4.setString(1,sFolioId);
    	    						ps4.setString(2, sNHIFcode);
    	    						ResultSet rs4=ps4.executeQuery();
    	    						if(rs4.next()){
    	    							System.out.println("Disease Folio ID "+rs4.getString("FolioID")+" is already mapped to disease code "+sNHIFcode);
    	    						}
    	    						else{
    	    							System.out.println("Creating Disease Folio ID for disease code "+sNHIFcode);
    	    							rs4.close();
    	    							ps4.close();
    	    							sSql="insert into FolioDiseases(FolioDiseaseID,DiseaseCode,FolioID,Remarks,"
    	    									+ "CreatedBy,DateCreated,LastModifiedBy,LastModified)"
    	    									+ " values(newid(),?,?,?,?,?,?,?)";
    	    							ps4=nhifconn.prepareStatement(sSql);
    	    							ps4.setString(1,sNHIFcode);
    	    							ps4.setString(2, sFolioId);
    	    							ps4.setString(3, "ICD10: "+sIcd10);
    	    							ps4.setString(4, sNHIFUserName);
    	    							ps4.setDate(5, new java.sql.Date(dInvoice.getTime()));
    	    							ps4.setString(6, sNHIFUserName);
    	    							ps4.setDate(7, new java.sql.Date(new java.util.Date().getTime()));
    	    							ps4.execute();
    	    						}
    	    						rs4.close();
    	    						ps4.close();
    	    					}
    						}
    					}
						rs2.close();
						ps2.close();
    					if(n==0){
    						System.out.println("No Mapping exists for ICD10 code "+sIcd10);
    						sSql="delete from unknowndiagnoses where icd10=?";
    						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1, sIcd10);
    						ps4.execute();
    						ps4.close();
    						sSql="insert into unknowndiagnoses(icd10) values(?)";
    						ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1, sIcd10);
    						ps4.execute();
    						ps4.close();
    					}
    				}
    				rs3.close();
    				ps3.close();
    			}
    			else{
    				System.out.println("ERROR: folio does not exist for Claim n°"+sClaimNo+" and Serial N°"+sSerialNo);
    			}
    		}
    		rs.close();
    		ps.close();
    	}
    	else {
    		System.out.println("NHIF UID MISSING!");
    	}
	    conn.close();
	    nhifconn.close();
	}
	
    public static float getNrYears(java.util.Date startDate, java.util.Date endDate){
        if(startDate == null || endDate == null){
            return 0;
        }
        
        Calendar start = new GregorianCalendar();
        Calendar end = new GregorianCalendar();
        start.setTime(startDate);
        end.setTime(endDate);
        long millis = end.getTimeInMillis() - start.getTimeInMillis();
        long days = millis / (1000 * 60 * 60 * 24)+1;

        // +1 to make the end inclusive
        // Count number of february 29's between cal1 and cal2
        int startyear = start.get(Calendar.YEAR);
        int endyear = end.get(Calendar.YEAR);
        if(start.get(Calendar.MONTH) > Calendar.FEBRUARY){
            startyear++;
        }
        if(end.get(Calendar.MONTH) < Calendar.FEBRUARY || (end.get(Calendar.MONTH) == Calendar.FEBRUARY && end.get(Calendar.DAY_OF_MONTH) < 29)){
            endyear--;
        }
        int feb29s = 0;
        for (int i = startyear; i <= endyear; i++){
            if((i % 4 == 0) && (i % 100!=0) || (i % 400 == 0)){
                feb29s++;
            }
        }
        
        return (float) (days - feb29s) / 365;
    }

}
