<%@page import="be.openclinic.finance.*,
				be.openclinic.medical.*,
                be.openclinic.statistics.CsvStats,
                be.mxs.common.util.system.HTMLEntities,
                be.mxs.common.util.db.MedwanQuery,
                java.text.SimpleDateFormat,
                java.util.Date"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	boolean hasPBFTransaction(String encounteruid,String userid){
		boolean bHasTransactions = false;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from transactions t, items i where t.serverid=i.serverid and t.transactionid=i.transactionid and "+
					" i.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and i.value='"+encounteruid+"' and t.userId="+userid+" and t.transactionType NOT IN ('be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_LAB_REQUEST','be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2')");
			ResultSet rs = ps.executeQuery();
			bHasTransactions=rs.next();
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return bHasTransactions;
	}
%>
                
<%
	boolean done=false;
	String label = "labelfr";
	if(sWebLanguage.equalsIgnoreCase("e")||sWebLanguage.equalsIgnoreCase("en")){
		label = "labelen";		
	}

	String sQueryType  = checkString(request.getParameter("query")),
	       sTableType  = checkString(request.getParameter("tabletype")),
	       sTargetLang = checkString(request.getParameter("targetlanguage"));
	
	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n************************** util/csvStats.jsp **************************");
		Debug.println("label      : "+label);
		Debug.println("sQueryType : "+sQueryType);
		Debug.println("sTableType : "+sTableType+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	
    String query = null;
	
	//*** 1 - SERVICE ****************************************************
    if("service.list".equalsIgnoreCase(sQueryType)){
        query = "select upper(OC_LABEL_ID) as CODE, OC_LABEL_VALUE as NAME, b.serviceparentid as PARENT"+
                " from OC_LABELS a, ServicesAddressView b"+
                "  where OC_LABEL_ID = b.serviceid"+
                "   and OC_LABEL_TYPE = 'service'"+
                "   and OC_LABEL_LANGUAGE = '"+sWebLanguage+"'"+
                " order by upper(OC_LABEL_ID)";
    }
	//*** 2 - PATIENTS ***************************************************
    else if("patients.list".equalsIgnoreCase(sQueryType)){
        query = "select a.personid, immatnew as patientid, lastname, firstname, dateofbirth,"+
                "  (select max(district) from privateview where personid=a.personid) as location1,"+
                "  (select max(oc_label_value) from oc_labels,privateview where oc_label_type='province' and oc_label_id=province and personid=a.personid and oc_label_language='"+sWebLanguage+"') as location2"+
                " from adminview a";
    }
	//*** 2.a - Vida ***************************************************
    else if("vida".equalsIgnoreCase(sQueryType)){
        Hashtable vaccins = new Hashtable();
        Hashtable comments = new Hashtable();
        Hashtable polios = new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
        PreparedStatement ps = conn.prepareStatement("select * from OC_VACCINATIONS where OC_VACCINATION_DATE<>'' order by OC_VACCINATION_UPDATETIME");
        ResultSet rs = ps.executeQuery();  
        String date,type;
        while(rs.next()){
        	date = checkString(rs.getString("OC_VACCINATION_DATE"));
        	type=rs.getString("OC_VACCINATION_TYPE");
        	if(type.startsWith("vita100")){
        		type="vita100";
        	}
        	else if(type.startsWith("vita200.1")){
        		type="vita200.1";
        	}
        	else if(type.startsWith("vita200.2")){
        		type="vita200.2";
        	}
        	else if(type.startsWith("alben200")){
        		type="alben200";
        	}
        	else if(type.startsWith("alben400")){
        		type="alben400";
        	}
        	if(date.length()>0){
        		String uid=rs.getString("OC_VACCINATION_PATIENTUID")+"."+type;
        		vaccins.put(uid,date);
        		String comment=checkString(rs.getString("OC_VACCINATION_OBSERVATION"));
        		if(comment.length()>0){
        			comments.put(uid,getTranNoLink("malivaccinationobservations",comment.split(";")[0],sWebLanguage)+(comment.split(";").length<2?"":": "+comment.split(";")[1]));
        		}
        		String polio=checkString(rs.getString("OC_VACCINATION_MODIFIER"));
        		if(polio.length()>0){
        			polios.put(uid,getTranNoLink("malivaccinationmodifiers",polio.split(";")[0],sWebLanguage));
        		}
        	}
        }
		rs.close();
		ps.close();
        query = "select b.cell as NoCons,a.comment3 as NoChefID1, b.city as SOUQRTIE, b.quarter as QUARTIER, (select max(firstname) from adminview where personid=a.comment3) as PRCHEF_1, (select max(lastname) from adminview where personid=a.comment3) as NMCHEF_1,"+
                "  a.comment5 as RELACHEF,a.personid as NoIndiv, firstname as PrIndiv2, lastname as NmIndiv2,datediff(now(),a.dateofbirth)/365 as Age, gender as SEXE, comment2 as STATMAT,a.dateofbirth as DATENAIS"+
                " from adminview a, privateview b where a.personid=b.personid and exists (select * from oc_vaccinations where OC_VACCINATION_PATIENTUID=a.personid and OC_VACCINATION_DATE<>'') order by a.comment3,a.searchname";
		StringBuffer sResult=new StringBuffer().append("NoCons;NoChefID1;SOUQRTIE;QUARTIER;PRCHEF_1;NMCHEF_1;RELACHEF;NoIndiv;PrIndiv2;NmIndiv2;Age;SEXE;STATMAT;DATENAIS;BCG;OBS_BCG;POLIO0;OBS_POLIO0;PV_POLIO0;POLIO1;OBS_POLIO1;PV_POLIO1;PENTA1;OBS_PENTA1;PNEUMO1;OBS_PNEUMO1;ROTA1;OBS_ROTA1;POLIO2;OBS_POLIO2;PV_POLIO2;PENTA2;OBS_PENTA2;PNEUMO2;OBS_PNEUMO2;ROTA2;OBS_ROTA2;POLIO3;OBS_POLIO3;PV_POLIO3;PENTA3;OBS_PENTA3;PNEUMO3;OBS_PNEUMO3;ROTA3;OBS_ROTA3;ROUGEOLE;OBS_ROUGEOLE;FIEVREJAUNE;OBS_FIEVREJAUNE;MENIGITEA;OBS_MENINGITEA;VAT1;OBS_VAT1;VAT2;OBS_VAT2;VATR1;OBS_VATR1;VATR2;OBS_VATR2;VATR3;OBS_VATR3;VITA100;OBS_VITA100;VITA200.1;OBS_VITA200.1;ALBEN200;OBS_ALBEN200;VITA200.2;OBS_VITA200.2;ALBEN400;OBS_ALBEN400\r\n");
        ps=conn.prepareStatement(query);
        rs=ps.executeQuery();
        SimpleDateFormat myformat= new SimpleDateFormat("dd/MM/yyyy");
        String sAge,personid;
        java.util.Date birth, minimumdate=new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900");
        int age;
        while(rs.next()){
			personid=checkString(rs.getString("NoIndiv"));
			birth=rs.getDate("DATENAIS");
			if(birth!=null && birth.before(minimumdate)){
				birth=null;
			}
			age=rs.getInt("Age");
			sAge=age+"";
			if(age>150 || age<0){
				sAge="";
			}
        	sResult.append(checkString(rs.getString("NoCons"))+";"+checkString(rs.getString("NoChefID1"))+";"+checkString(rs.getString("SOUQRTIE"))+";"+checkString(rs.getString("QUARTIER"))+";"+checkString(rs.getString("PRCHEF_1"))+";"+checkString(rs.getString("NMCHEF_1"))+";"+getTranNoLink("relationship",checkString(rs.getString("RELACHEF")),sWebLanguage)+";"+personid+";"+checkString(rs.getString("PrIndiv2"))+";"+checkString(rs.getString("NmIndiv2"))+";"
        	+sAge+";"+checkString(rs.getString("SEXE"))+";"+getTranNoLink("civil.status",checkString(rs.getString("STATMAT")),sWebLanguage)+";"+ScreenHelper.formatDate(birth,myformat));
			sResult.append(";"+checkString((String)vaccins.get(personid+".bcg")));
			sResult.append(";"+checkString((String)comments.get(personid+".bcg")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio0")));
			sResult.append(";"+checkString((String)comments.get(personid+".polio0")));
			sResult.append(";"+checkString((String)polios.get(personid+".polio0")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio1")));
			sResult.append(";"+checkString((String)comments.get(personid+".polio1")));
			sResult.append(";"+checkString((String)polios.get(personid+".polio1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta1")));
			sResult.append(";"+checkString((String)comments.get(personid+".penta1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo1")));
			sResult.append(";"+checkString((String)comments.get(personid+".pneumo1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota1")));
			sResult.append(";"+checkString((String)comments.get(personid+".rota1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio2")));
			sResult.append(";"+checkString((String)comments.get(personid+".polio2")));
			sResult.append(";"+checkString((String)polios.get(personid+".polio2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta2")));
			sResult.append(";"+checkString((String)comments.get(personid+".penta2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo2")));
			sResult.append(";"+checkString((String)comments.get(personid+".pneumo2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota2")));
			sResult.append(";"+checkString((String)comments.get(personid+".rota2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio3")));
			sResult.append(";"+checkString((String)comments.get(personid+".polio3")));
			sResult.append(";"+checkString((String)polios.get(personid+".polio3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta3")));
			sResult.append(";"+checkString((String)comments.get(personid+".penta3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo3")));
			sResult.append(";"+checkString((String)comments.get(personid+".pneumo3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota3")));
			sResult.append(";"+checkString((String)comments.get(personid+".rota3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".measles")));
			sResult.append(";"+checkString((String)comments.get(personid+".measles")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".yellowfever")));
			sResult.append(";"+checkString((String)comments.get(personid+".yellowfever")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".meningitisa")));
			sResult.append(";"+checkString((String)comments.get(personid+".meningitisa")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vat1")));
			sResult.append(";"+checkString((String)comments.get(personid+".vat1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vat2")));
			sResult.append(";"+checkString((String)comments.get(personid+".vat2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr1")));
			sResult.append(";"+checkString((String)comments.get(personid+".vatr1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr2")));
			sResult.append(";"+checkString((String)comments.get(personid+".vatr2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr3")));
			sResult.append(";"+checkString((String)comments.get(personid+".vatr3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita100")));
			sResult.append(";"+checkString((String)comments.get(personid+".vita100")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita200.1")));
			sResult.append(";"+checkString((String)comments.get(personid+".vita200.1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".alben200")));
			sResult.append(";"+checkString((String)comments.get(personid+".alben200")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita200.2")));
			sResult.append(";"+checkString((String)comments.get(personid+".vita200.2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".alben400")));
			sResult.append(";"+checkString((String)comments.get(personid+".alben400")));
        	sResult.append("\r\n");        	
        }
        rs.close();
        ps.close();
        conn.close();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();

    	byte[] b = sResult.toString().getBytes();
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 2.b - Banconi ***************************************************
    else if("banconi".equalsIgnoreCase(sQueryType)){
        Hashtable vaccins = new Hashtable();
        Hashtable comments = new Hashtable();
        Hashtable polios = new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
        PreparedStatement ps = conn.prepareStatement("select * from OC_VACCINATIONS order by OC_VACCINATION_UPDATETIME");
        ResultSet rs = ps.executeQuery();  
        String date,type;
        while(rs.next()){
        	date = checkString(rs.getString("OC_VACCINATION_DATE"));
        	type=rs.getString("OC_VACCINATION_TYPE");
        	if(type.startsWith("vita100")){
        		type="vita100";
        	}
        	else if(type.startsWith("vita200.1")){
        		type="vita200.1";
        	}
        	else if(type.startsWith("vita200.2")){
        		type="vita200.2";
        	}
        	else if(type.startsWith("alben200")){
        		type="alben200";
        	}
        	else if(type.startsWith("alben400")){
        		type="alben400";
        	}
        	if(date.length()>0){
        		String uid=rs.getString("OC_VACCINATION_PATIENTUID")+"."+type;
        		vaccins.put(uid,date);
        		String comment=checkString(rs.getString("OC_VACCINATION_OBSERVATION"));
        		if(comment.length()>0){
        			comments.put(uid,getTranNoLink("malivaccinationobservations",comment.split(";")[0],sWebLanguage)+(comment.split(";").length<2?"":": "+comment.split(";")[1]));
        		}
        		String polio=checkString(rs.getString("OC_VACCINATION_MODIFIER"));
        		if(polio.length()>0){
        			polios.put(uid,getTranNoLink("malivaccinationmodifiers",polio.split(";")[0],sWebLanguage));
        		}
        	}
        }
		rs.close();
		ps.close();
        query = "select b.cell as NoCons,a.comment3 as NoChefID1, b.city as SOUQRTIE, (select max(firstname) from adminview where personid=a.comment3) as PRCHEF_1, (select max(lastname) from adminview where personid=a.comment3) as NMCHEF_1,"+
                "  a.personid as NoIndiv, firstname as PrIndiv2, substring(firstname,1,1)"+MedwanQuery.getInstance().concatSign()+"substring(lastname,1,1) as ININDIV_2,lastname as NmIndiv2,a.comment5 as RELACHEF,datediff(now(),a.dateofbirth)/365 as AGEAN, gender as SEXE, comment2 as STATMAT,a.dateofbirth as DATENAIS,a.comment4 as STATUT_2,a.updatetime as Date_Suivi_19,a.comment as Commentaire"+
                " from adminview a, privateview b where a.personid=b.personid order by a.comment3,a.searchname";
        conn = MedwanQuery.getInstance().getOpenclinicConnection();
        ps = conn.prepareStatement("select OC_ENCOUNTER_PATIENTUID,OC_ENCOUNTER_ENDDATE from OC_ENCOUNTERS where OC_ENCOUNTER_OUTCOME like 'dead%'");
        rs = ps.executeQuery();
        Hashtable deaths =new Hashtable();
        while(rs.next()){
        	deaths.put(rs.getString("OC_ENCOUNTER_PATIENTUID"),rs.getDate("OC_ENCOUNTER_ENDDATE"));
        }
        rs.close();
        ps.close();
		StringBuffer sResult=new StringBuffer().append("NoCons;NoChefID1;SOUQRTIE;PRCHEF_1;NMCHEF_1;NoIndiv;PrIndiv2;ININDIV_2;NmIndiv2;RELACHEF;AGEAN;SEXE;STATMAT;DATENAIS;STATUT_2;Date_Suivi_19;Commentaire;Nouv_DCD;BCG;POLIO0;POLIO1;PENTA1;PNEUMO1;ROTA1;POLIO2;PENTA2;PNEUMO2;ROTA2;POLIO3;PENTA3;PNEUMO3;ROTA3;ROUGEOLE;FIEVREJAUNE;MENIGITEA;VAT1;VAT2;VATR1;VATR2;VATR3;VITA100;VITA200.1;ALBEN200;VITA200.2;ALBEN400\r\n");

        ps=conn.prepareStatement(query);
        rs=ps.executeQuery();
        SimpleDateFormat myformat= new SimpleDateFormat("dd/MM/yyyy");
        String sAge,personid;
        java.util.Date birth, minimumdate=new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900");
        int age;
        while(rs.next()){
			personid=checkString(rs.getString("NoIndiv"));
			birth=rs.getDate("DATENAIS");
			if(birth!=null && birth.before(minimumdate)){
				birth=null;
			}
			age=rs.getInt("AGEAN");
			sAge=age+"";
			if(age>150 || age<0){
				sAge="";
			}
        	sResult.append(checkString(rs.getString("NoCons"))+";"+checkString(rs.getString("NoChefID1"))+";"+checkString(rs.getString("SOUQRTIE"))+";"+checkString(rs.getString("PRCHEF_1"))+";"+checkString(rs.getString("NMCHEF_1"))+";"+personid+";"+checkString(rs.getString("PrIndiv2"))+";"+rs.getString("ININDIV_2")+";"+checkString(rs.getString("NmIndiv2"))+";"+getTranNoLink("relationship",checkString(rs.getString("RELACHEF")),sWebLanguage)+";"
        	+sAge+";"+checkString(rs.getString("SEXE"))+";"+getTranNoLink("civil.status",checkString(rs.getString("STATMAT")),sWebLanguage)+";"+ScreenHelper.formatDate(birth,myformat)+";"+checkString(rs.getString("STATUT_2"))+";"+ScreenHelper.formatDate(rs.getDate("Date_Suivi_19"),myformat)+";"+checkString(rs.getString("Commentaire"))+";"+ScreenHelper.formatDate((java.sql.Date)deaths.get(personid),myformat));        	
			sResult.append(";"+checkString((String)vaccins.get(personid+".bcg")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio0")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".measles")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".yellowfever")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".meningitisa")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vat1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vat2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita100")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita200.1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".alben200")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita200.2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".alben400")));
        	sResult.append("\r\n");        	
        }
        rs.close();
        ps.close();
        conn.close();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();

    	byte[] b = sResult.toString().getBytes();
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 3 - LABELS *****************************************************
    else if("labels.list".equalsIgnoreCase(sQueryType)){
    	if(ScreenHelper.checkString(sTableType).equalsIgnoreCase("singlelanguage")){
    		if(request.getParameter("language")!=null){
    			query = "select oc_label_type as TYPE,oc_label_id as ID,oc_label_language as LANGUAGE,oc_label_value as LABEL"+
    		            " from oc_labels"+
    					"  where oc_label_language='"+request.getParameter("language")+"'"+
    		            " order by oc_label_type,oc_label_id";
    			Debug.println(query);
    		}
    	}
    	else if(ScreenHelper.checkString(sTableType).equalsIgnoreCase("multilanguage")){
    		if(request.getParameter("language")!=null){
        		String languagecolumns = "";
        		String[] languages = request.getParameter("language").split(",");
        		for(int n=0;n<languages.length;n++){
        			languagecolumns+=",(select max(oc_label_value) from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_language='"+languages[n]+"') "+languages[n].toUpperCase();
        		}
    			query = "select a.oc_label_type TYPE,a.oc_label_id ID"+languagecolumns+
    					" from (select distinct oc_label_type,oc_label_id from oc_labels) a"+
    					"  order by oc_label_type,oc_label_id";
    			Debug.println(query);
    		}
    	}
    	else if(ScreenHelper.checkString(sTableType).equalsIgnoreCase("missinglabels")){
    		if(request.getParameter("sourcelanguage")!=null && request.getParameter("targetlanguage")!=null){
        		String languagecolumns = ",(select max(oc_label_value) from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_language='"+request.getParameter("targetlanguage")+"') "+request.getParameter("targetlanguage").toUpperCase();
        		String[] languages = request.getParameter("sourcelanguage").split(",");
        		for(int n=0; n<languages.length; n++){
        			languagecolumns+= ",(select max(oc_label_value) from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_language='"+languages[n]+"') "+languages[n].toUpperCase();
        		}
    			query = "select a.oc_label_type TYPE,a.oc_label_id ID"+languagecolumns+" from (select distinct oc_label_type,oc_label_id from oc_labels) a where not exists (select * from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_value<>'' and oc_label_language='"+request.getParameter("targetlanguage")+"') order by oc_label_type,oc_label_id";
    			Debug.println(query);
    		}
    	}
    }
	//*** 4 - USERS ******************************************************
    else if("user.list".equalsIgnoreCase(sQueryType)){
        query = "select userid as CODE, firstname as FIRSTNAME, lastname as LASTNAME, a.start as START, a.stop as STOP"+
                " from Users a, Admin b"+
                "  where a.personid = b.personid"+
                "   order by userid";
    }
	//*** UNDELIVERED RAW MATERIAL ORDERS ******************************************************
    else if("undelivered.rwamaterial.orders".equalsIgnoreCase(sQueryType)){
        query = "select oc_order_dateordered PO_DATE,"+
        		" o.oc_order_productionorderuid PO_NUMBER,"+
        		" pr.oc_product_code FG_ITEM_CODE,"+
        		" pr2.oc_product_code RM_ITEM_CODE,"+
        		" pr2.oc_product_name RM_ITEM_DESCRIPTION,"+
        		" o.oc_order_packagesordered RM_ORDERED,"+
        		" o.oc_order_packagesdelivered RM_DELIVERED,"+
        		" o.oc_order_comment RM_COMMENTS"+
        		" from oc_productorders o, oc_productionorders p, oc_productstocks s, oc_products pr, oc_productstocks s2, oc_products pr2 where"+
        		" oc_order_packagesordered>oc_order_packagesdelivered and"+
        		" oc_productionorder_id=oc_order_productionorderuid and"+
        		" s.oc_stock_objectid=replace(oc_productionorder_targetproductstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
        		" pr.oc_product_objectid=replace(s.oc_stock_productuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
        		" s2.oc_stock_objectid=replace(oc_order_productstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
        		" pr2.oc_product_objectid=replace(s2.oc_stock_productuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
        		" oc_order_processed=0 and"+
        		" oc_order_status is null";
    }
	//*** 5 - PRESTATIONS ************************************************
    else if("prestation.list".equalsIgnoreCase(sQueryType)){
        query = "select OC_PRESTATION_CODE CODE, OC_PRESTATION_DESCRIPTION DESCRIPTION, OC_PRESTATION_PRICE DEFAULTPRICE,"+
                "  OC_PRESTATION_CATEGORIES TARIFFS,OC_PRESTATION_REFTYPE FAMILY,OC_PRESTATION_TYPE TYPE,"+
                "  OC_PRESTATION_INVOICEGROUP INVOICEGROUP,OC_PRESTATION_CLASS CLASS"+
                " from oc_prestations"+
                "  where (OC_PRESTATION_INACTIVE is NULL OR OC_PRESTATION_INACTIVE<>1)"+
                "   ORDER BY OC_PRESTATION_CODE;";
    }
	//*** 6 - DEBETS *****************************************************
    else if("debet.list".equalsIgnoreCase(sQueryType)){
        query = "select oc_debet_date as DATE, lastname as NOM, firstname as PRENOM, oc_prestation_description as PRESTATION,"+
    			" oc_prestation_reftype as FAMILY, oc_prestation_invoicegroup as INVOICEGROUP,"+
                "  oc_debet_quantity as QUANTITE,"+MedwanQuery.getInstance().convert("int","oc_debet_amount")+" as PATIENT,"+
                   MedwanQuery.getInstance().convert("int","oc_debet_insuraramount")+" as ASSUREUR, oc_label_value as SERVICE,"+
                "  oc_debet_credited as ANNULE,replace(oc_debet_patientinvoiceuid,'1.','') as FACT_PATIENT, oc_encounter_type as ENCOUNTER_TYPE"+
        		" from oc_debets, oc_encounters, adminview, oc_prestations, servicesview, oc_labels"+
        		"  where oc_encounter_objectid = replace(oc_debet_encounteruid,'1.','')"+
        		"   and oc_prestation_objectid = replace(oc_debet_prestationuid,'1.','')"+
        		"   and serviceid = oc_debet_serviceuid"+
        		"   and oc_label_type = 'service'"+
        		"   and oc_label_id = serviceid"+
        		"   and oc_label_language = '"+sWebLanguage+"'"+
        		"   and oc_encounter_patientuid = personid"+
        		"   and oc_debet_date >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
        		"   and oc_debet_date <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
        		" ORDER BY oc_debet_date, lastname, firstname";
    }
	//*** LAB RESULTS *****************************************************
    else if("lab.list".equalsIgnoreCase(sQueryType)){
        query = "select a.personid PERSONID,lastname LASTNAME,firstname FIRSTNAME,dateofbirth DATE_OF_BIRTH,gender GENDER,resultdate RESULTDATE,analysiscode ANALYSIS,resultvalue RESULTVALUE,resultcomment COMMENT,"+
    			" (select max(oc_encounter_serviceuid) from oc_encounter_services where oc_encounter_objectid=replace(e.value,'1.','')) DEPARTMENT"+
        		" from adminview a,healthrecord b,transactions c,requestedlabanalyses d, items e"+
    			" where"+
        		" a.personid=b.personid and b.healthrecordid=c.healthrecordid and c.serverid=d.serverid and c.transactionid=d.transactionid and"+
    			" finalvalidationdatetime is not null and resultdate>="+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
    			" and resultdate<="+MedwanQuery.getInstance().convertStringToDate("'<end>'")+" and "+
    			" c.transactionid=e.transactionid and e.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID'"+
        		" order by personid,resultdate";
    }
	//*** 6 - DEBETS *****************************************************
    else if("debet.list.per.encounter".equalsIgnoreCase(sQueryType)){
        query = "select count(*) as TOTAL_ENCOUNTERS, "+MedwanQuery.getInstance().convert("int","avg(PATIENT)")+" as PATIENT,"+MedwanQuery.getInstance().convert("int",MedwanQuery.getInstance().getConfigString("stddevFunction","stdev")+"("+MedwanQuery.getInstance().convert("int","PATIENT")+")")+" as PATIENT_STDEV, "+MedwanQuery.getInstance().convert("int","avg(ASSUREUR)")+" as ASSUREUR,"+MedwanQuery.getInstance().convert("int",MedwanQuery.getInstance().getConfigString("stddevFunction","stdev")+"("+MedwanQuery.getInstance().convert("int","ASSUREUR")+")")+" as ASSUREUR_STDEV, "+MedwanQuery.getInstance().convert("int","avg(ASSUREUR_COMPL)")+" as ASSUREUR_COMPL,"+MedwanQuery.getInstance().convert("int",MedwanQuery.getInstance().getConfigString("stddevFunction","stdev")+"("+MedwanQuery.getInstance().convert("int","ASSUREUR_COMPL")+")")+" as ASSUREUR_COMPL_STDEV, ENCOUNTER_TYPE from (select sum("+MedwanQuery.getInstance().convert("int","oc_debet_amount")+") as PATIENT,sum("+
                MedwanQuery.getInstance().convert("int","oc_debet_insuraramount")+") as ASSUREUR,sum("+
                        MedwanQuery.getInstance().convert("int","oc_debet_extrainsuraramount")+") as ASSUREUR_COMPL,oc_encounter_objectid, oc_encounter_type as ENCOUNTER_TYPE"+
        		" from oc_debets, oc_encounters, adminview, oc_prestations, servicesview, oc_labels"+
        		"  where oc_encounter_objectid = replace(oc_debet_encounteruid,'1.','')"+
        		"   and oc_prestation_objectid = replace(oc_debet_prestationuid,'1.','')"+
        		"   and serviceid = oc_debet_serviceuid"+
        		"   and oc_label_type = 'service'"+
        		"   and oc_label_id = serviceid"+
        		"   and oc_label_language = '"+sWebLanguage+"'"+
        		"   and oc_encounter_patientuid = personid"+
        		"   and oc_debet_date >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
        		"   and oc_debet_date <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
        		" group BY oc_encounter_objectid,oc_encounter_type) a group by ENCOUNTER_TYPE";
    }
	//*** 7 - INVOICES ***************************************************
    else if("hmk.invoices.list".equalsIgnoreCase(sQueryType)){
    	try{
	        Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			
			// search all the invoices from this period     
			query = "select oc_patientinvoice_serverid,oc_patientinvoice_objectid from oc_patientinvoices"+
			        " where oc_patientinvoice_date>="+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
			        "  and oc_patientinvoice_date<="+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
			        "   order by oc_patientinvoice_date";
	        query = query.replaceAll("<begin>",request.getParameter("begin"))
	        		     .replaceAll("<end>",request.getParameter("end"));
			Debug.println(query);
			PreparedStatement ps = loc_conn.prepareStatement(query);
			ResultSet rs = ps.executeQuery();
			int counter = 1;
			String doctor =checkString(request.getParameter("doctor"));
			String service=checkString(request.getParameter("service"));
		    response.setContentType("application/octet-stream; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
		    
		    ServletOutputStream os = response.getOutputStream();
		    
		    // header
			sResult.append("SERIAL;DATE;PATIENTID;PATIENT;DATEOFBIRTH;AGE;GENDER;DEPARTMENT;DISEASE;DOCTOR;INSURER;COMPL_INSURER;PAT_SHARE_COVERAGE_INSURER;INS_PART;COMPL_INS_PART;PAT_SHARE_COVERAGE_PART;PAT_PART;TOTAL\r\n");
		    
	    	byte[] b = sResult.toString().getBytes();
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
	        int c=0;
			while(rs.next()){
				c++;
				sResult = new StringBuffer();
				PatientInvoice invoice = PatientInvoice.get(rs.getString("oc_patientinvoice_serverid")+"."+rs.getString("oc_patientinvoice_objectid"));
				if(invoice!=null){
					if(doctor.length()>0 && invoice.getSignatures().indexOf("("+doctor+")")<0){
						continue;
					}
					if(service.length()>0 && !invoice.getServices().contains(service)){
						continue;
					}
					sResult.append(invoice.getUid().split("\\.")[1]+";");
					sResult.append((invoice.getDate()==null?"":ScreenHelper.stdDateFormat.format(invoice.getDate()))+";");
					sResult.append((invoice.getPatientUid()==null?"":invoice.getPatientUid())+";");
					sResult.append((invoice.getPatient()==null?"":invoice.getPatient().getFullName())+";");
					sResult.append((invoice.getPatient()==null || invoice.getPatient().dateOfBirth==null?"":invoice.getPatient().dateOfBirth)+";");
				
					String age = "";
					try{
						int a = invoice.getPatient().getAge();
						if(a<5){
							age = "0->4";
						}
						else if(a<15){
							age = "5->14";
						}
						else {
							age = "15+";
						}
					}
					catch(Exception e){
						// empty
					}
					
					sResult.append(age+";");
					sResult.append((invoice.getPatient()==null?"":invoice.getPatient().gender)+";");
					sResult.append(invoice.getServicesAsString(sWebLanguage)+";");
					sResult.append(invoice.getDiseases(sWebLanguage)+";");
					sResult.append(invoice.getSignatures()+";");
					sResult.append(invoice.getInsurers()+";");
					sResult.append(invoice.getExtraInsurers()+";");
					sResult.append(invoice.getExtraInsurers2()+";");
					sResult.append(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getInsurarAmount())+";");
					sResult.append((new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getExtraInsurarAmount()))+";");
					sResult.append((new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getExtraInsurarAmount2()))+";");
					sResult.append((new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getPatientOwnAmount()))+";");
					sResult.append((new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getInsurarAmount()+invoice.getExtraInsurarAmount2()+invoice.getPatientOwnAmount()+invoice.getExtraInsurarAmount()))+";");
					sResult.append("\r\n");
				}
				
		    	b = sResult.toString().getBytes();
		        for(int n=0; n<b.length; n++){
		            os.write(b[n]);
		        }
		        os.flush();
			}
			rs.close();
			ps.close();
			
			loc_conn.close();
	        os.close();
	        done=true;
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    }
	//*** 7 - INVOICES ***************************************************
    else if("pbf.burundi.consultationslist".equalsIgnoreCase(sQueryType)){
        try{
    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		StringBuffer sResult = new StringBuffer();
		String service=checkString(request.getParameter("service"));
		String doctor =checkString(request.getParameter("doctor"));
		String encountertypes="'ooo'";
		if(checkString(request.getParameter("includevisits")).equalsIgnoreCase("1")){
			encountertypes+=",'visit'";
		}
		if(checkString(request.getParameter("includeadmissions")).equalsIgnoreCase("1")){
			encountertypes+=",'admission'";
		}
		long l = 24*3600*1000;
		java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
		endDate.setTime(endDate.getTime()+l);
		
		String childServices = Service.getChildIdsAsString(service);

		// search all the invoices from this period     
		query = "select a.oc_encounter_serviceuid,a.oc_encounter_objectid,a.oc_encounter_serverid,a.oc_encounter_begindate,b.personid,b.firstname,b.lastname,b.gender,b.dateofbirth,b.comment5,c.address,c.sector,c.cell,c.district,c.city from oc_encounters_view a,adminview b,privateview c where"+
		        " a.oc_encounter_patientuid=b.personid and"+
				" b.personid=c.personid and"+
				" a.oc_encounter_type in ("+encountertypes+") and"+
		        " oc_encounter_begindate>="+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+" and"+
		        " oc_encounter_begindate<"+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
				(service.length()>0?" and oc_encounter_serviceuid in ("+childServices+")":"")+
		        " order by oc_encounter_begindate,oc_encounter_objectid";
        query = query.replaceAll("<begin>",request.getParameter("begin"))
        		     .replaceAll("<end>",ScreenHelper.formatDate(endDate));
		Debug.println(query);
		PreparedStatement ps = loc_conn.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		int counter = 1;
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    
	    ServletOutputStream os = response.getOutputStream();
	    
	    // header
		sResult.append("DEPARTMENT;DATE;PATIENTID;FIRSTNAME;NAME;GENDER;AGE;BIRTHDATE;FAMILY_CHIEF;ADDRESS;PROVINCE;CITY;HILL;DOCTOR;ICD10;DIAGNOSIS/RFE*;TREATMENT\r\n");
	    
    	byte[] b = sResult.toString().getBytes();
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        int activeEncounterObjectId=-1;
		while(rs.next()){
			int encounterServerId = rs.getInt("oc_encounter_serverid");
			int encounterObjectId=rs.getInt("oc_encounter_objectid");
			if(doctor.length()>0 && !hasPBFTransaction(encounterServerId+"."+encounterObjectId, doctor)){
				continue;
			}
			if(encounterObjectId==activeEncounterObjectId){
				//We don't want to show the same encounter multiple times
				continue;
			}
			activeEncounterObjectId=encounterObjectId;
			
			sResult = new StringBuffer();
			sResult.append(getTranNoLink("service",checkString(rs.getString("oc_encounter_serviceuid")),sWebLanguage)+";");
			sResult.append(ScreenHelper.formatDate(rs.getDate("oc_encounter_begindate"))+";");
			sResult.append(rs.getString("personid")+";");
			sResult.append(ScreenHelper.removeAccents(rs.getString("firstname").toUpperCase()).replaceAll("�", "'").replaceAll("`", "'")+";");
			sResult.append(ScreenHelper.removeAccents(rs.getString("lastname").toUpperCase()).replaceAll("�", "'").replaceAll("`", "'")+";");
			sResult.append(rs.getString("gender").toUpperCase()+";");
			java.util.Date dateofbirth = rs.getDate("dateofbirth");
			String age = "";
			try{
				int a = AdminPerson.getAge(dateofbirth);
				if(a<1){
					age = "0->11m";
				}
				else if(a<5){
					age = "12->59m";
				}
				else if(a<10){
					age = "5->9";
				}
				else if(a<10){
					age = "5->9";
				}
				else if(a<15){
					age = "10->14";
				}
				else if(a<20){
					age = "15->19";
				}
				else if(a<25){
					age = "20->24";
				}
				else if(a<50){
					age = "25->49";
				}
				else {
					age = "50+";
				}
			}
			catch(Exception e){
				// empty
			}
			sResult.append(age+";");
			sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
			sResult.append(ScreenHelper.removeAccents(checkString(rs.getString("comment5")).toUpperCase()).replaceAll("�", "'").replaceAll("`", "'")+";");
			String address ="";
			if(checkString(rs.getString("address")).length()>0){
				address+=rs.getString("address");	
			}
			if(checkString(rs.getString("cell")).length()>0){
				if(address.length()>0){
					address+=", ";
				}
				address+=rs.getString("cell");	
			}
			sResult.append(address.toUpperCase()+";");
			sResult.append(checkString(rs.getString("district")).toUpperCase()+";");
			sResult.append(checkString(rs.getString("sector")).toUpperCase()+";");
			sResult.append(checkString(rs.getString("city")).toUpperCase()+";");
			SortedSet hAuthors = new TreeSet(),hDiagcodes = new TreeSet(),hDiaglabels = new TreeSet();
			//Now add the diagnoses for the Encounter
			if(checkString(request.getParameter("diagsicd10")).equalsIgnoreCase("1")){
				Vector diagnoses = Diagnosis.selectDiagnoses("", "", MedwanQuery.getInstance().getConfigString("serverId")+"."+encounterObjectId, doctor, "", "", "", "", "", "", "", "icd10", "");
				for(int n=0;n<diagnoses.size();n++){
					Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(n);
					hAuthors.add(User.getFullUserName(diagnosis.getAuthorUID()));
					hDiagcodes.add(diagnosis.getCode().toUpperCase());
					hDiaglabels.add(MedwanQuery.getInstance().getDiagnosisLabel("icd10", diagnosis.getCode(), sWebLanguage));
					//hDiagnoses.add(User.getFullUserName(diagnosis.getAuthorUID())+";"+diagnosis.getCode().toUpperCase()+";"+MedwanQuery.getInstance().getDiagnosisLabel("icd10", diagnosis.getCode(), sWebLanguage));
				}
			}
			if(checkString(request.getParameter("diagsrfe")).equalsIgnoreCase("1")){
				Vector rfes = ReasonForEncounter.getReasonsForEncounterByEncounterUid(MedwanQuery.getInstance().getConfigString("serverId")+"."+encounterObjectId);
				for(int n=0;n<rfes.size();n++){
					ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
					if(rfe.getCodeType().equalsIgnoreCase("icd10")){
						hAuthors.add(User.getFullUserName(rfe.getAuthorUID()));
						hDiagcodes.add(rfe.getCode().toUpperCase());
						hDiaglabels.add(MedwanQuery.getInstance().getDiagnosisLabel("icd10", rfe.getCode(), sWebLanguage));
						//hDiagnoses.add(User.getFullUserName(rfe.getAuthorUID())+";"+rfe.getCode().toUpperCase()+";*"+MedwanQuery.getInstance().getDiagnosisLabel("icd10", rfe.getCode(), sWebLanguage));
					}
				}
			}
			if(checkString(request.getParameter("diagsfreetext")).equalsIgnoreCase("1")){
				HashSet hFree = Encounter.getFreeTextDiagnoses(MedwanQuery.getInstance().getConfigString("serverId")+"."+encounterObjectId);
				Iterator iFree = hFree.iterator();
				while(iFree.hasNext()){
					String[] diaglabel=((String)iFree.next()).split(";");
					hAuthors.add(diaglabel[0]);
					hDiagcodes.add(diaglabel[1]);
					hDiaglabels.add(diaglabel[2]);
					//hDiagnoses.add(((String)iFree.next()).toUpperCase().replaceAll("\n", " ").replaceAll("\r", ""));
				}
			}
			
			if(hAuthors.size()==0){
				sResult.append("-;");
			}
			else{
				Iterator i = hAuthors.iterator();
				while(i.hasNext()){
					sResult.append(i.next());
					if(i.hasNext()){
						sResult.append(", ");
					}
				}
				sResult.append(";");
			}
			if(hDiagcodes.size()==0){
				sResult.append("-;");
			}
			else{
				Iterator i = hDiagcodes.iterator();
				while(i.hasNext()){
					sResult.append(i.next());
					if(i.hasNext()){
						sResult.append(", ");
					}
				}
				sResult.append(";");
			}
			if(hDiaglabels.size()==0){
				sResult.append("-;");
			}
			else{
				Iterator i = hDiaglabels.iterator();
				while(i.hasNext()){
					sResult.append(i.next());
					if(i.hasNext()){
						sResult.append(", ");
					}
				}
				sResult.append(";");
			}
			//Add Treatment here
			Vector treatments = MedwanQuery.getInstance().getEncounterItems(encounterServerId+"."+encounterObjectId, "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_TREATMENT");
			for(int n=0;n<treatments.size();n++){
				ItemVO item = (ItemVO)treatments.elementAt(n);
				sResult.append(ScreenHelper.removeAccents(item.getValue()).replaceAll("�", "'").replaceAll("`", "'").toUpperCase().replaceAll("\n", ", ").replaceAll("\r", "")+" ");
			}
			sResult.append("\r\n");
	    	b = sResult.toString().getBytes();
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
		}
		rs.close();
		ps.close();
		
		loc_conn.close();
        os.close();
        done=true;
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
    else if("pbf.burundi.admissionslist".equalsIgnoreCase(sQueryType)){
        try{
    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		StringBuffer sResult = new StringBuffer();
		String service=checkString(request.getParameter("service"));
		String doctor =checkString(request.getParameter("doctor"));
		long day = 24*3600*1000;
		java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
		endDate.setTime(endDate.getTime()+day);
		
		String childServices = Service.getChildIdsAsString(service);

		// search all the invoices from this period     
		query = "select personid,lastname,firstname,gender,dateofbirth,oc_encounter_origin,oc_encounter_begindate, oc_encounter_enddate,oc_encounter_outcome,oc_encounter_serverid,oc_encounter_objectid"+
		        " from oc_encounters a, adminview b where"+
				" ((oc_encounter_begindate>="+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+" and oc_encounter_begindate<"+MedwanQuery.getInstance().convertStringToDate("'<end>'")+") OR (oc_encounter_enddate>="+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+" and oc_encounter_enddate<"+MedwanQuery.getInstance().convertStringToDate("'<end>'")+")) and"+
				" oc_encounter_type='admission' and"+
		        " personid=oc_encounter_patientuid "+
				(service.length()>0?" and oc_encounter_serviceuid in ("+childServices+")":"")+
		        " order by oc_encounter_begindate,oc_encounter_objectid";
        query = query.replaceAll("<begin>",request.getParameter("begin"))
        		     .replaceAll("<end>",ScreenHelper.formatDate(endDate));
		Debug.println(query);
		PreparedStatement ps = loc_conn.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		int counter = 1;
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    
	    ServletOutputStream os = response.getOutputStream();
	    
	    // header
		sResult.append("PATIENTID;LASTNAME;FIRSTNAME;GENDER;DATEOFBIRTH;AGECLASS;DATE_IN;ORIGIN;DATE_OUT;DURATION;OUTCOME;ICD10_IN;ICD10_OUT;PAYMENT_TYPE;DEPARTMENT\r\n");
	    
    	byte[] b = sResult.toString().getBytes();
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        int activeEncounterObjectId=-1;
		while(rs.next()){
			int encounterServerId = rs.getInt("oc_encounter_serverid");
			int encounterObjectId=rs.getInt("oc_encounter_objectid");
			
			sResult = new StringBuffer();
			int personid = rs.getInt("personid");
			sResult.append(personid+";");
			sResult.append(rs.getString("lastname").toUpperCase().replaceAll(";","")+";");
			sResult.append(rs.getString("firstname").toUpperCase().replaceAll(";","")+";");
			sResult.append(rs.getString("gender").toUpperCase()+";");
			java.util.Date dateofbirth = rs.getDate("dateofbirth");
			sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
			String age = "";
			try{
				int a = AdminPerson.getAge(dateofbirth);
				if(a<1){
					age = "0->11m";
				}
				else if(a<5){
					age = "12->59m";
				}
				else if(a<10){
					age = "5->9";
				}
				else if(a<10){
					age = "5->9";
				}
				else if(a<15){
					age = "10->14";
				}
				else if(a<20){
					age = "15->19";
				}
				else if(a<25){
					age = "20->24";
				}
				else if(a<50){
					age = "25->49";
				}
				else {
					age = "50+";
				}
			}
			catch(Exception e){
				// empty
			}
			sResult.append(age+";");
			java.util.Date begindate = rs.getDate("oc_encounter_begindate");
			java.util.Date enddate = rs.getDate("oc_encounter_enddate");
			sResult.append(new SimpleDateFormat("dd/MM/yyyy HH:mm").format(begindate)+";");
			sResult.append(ScreenHelper.removeAccents(getTranNoLink("urgency.origin",rs.getString("oc_encounter_origin"),sWebLanguage)).toUpperCase()+";");
			if(enddate!=null){
				sResult.append(new SimpleDateFormat("dd/MM/yyyy HH:mm").format(enddate)+";");
				sResult.append(((enddate.getTime()-begindate.getTime())/day+1)+";");
			}
			else{
				sResult.append(";;");
			}
			sResult.append(ScreenHelper.removeAccents(getTranNoLink("encounter.outcome",rs.getString("oc_encounter_outcome"),sWebLanguage)).toUpperCase()+";");
			
			//Find ICD10 codes on addmission
			String freetext="";
			HashSet admissionDiagnoses = new HashSet();
			Vector admissions = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_HPRC_ADMISSION",encounterServerId+"."+encounterObjectId);
			for(int n=0;n<admissions.size();n++){
				TransactionVO transaction = (TransactionVO)admissions.elementAt(n);
				Collection items = transaction.getItems();
				Iterator i = items.iterator();
				while(i.hasNext()){
					ItemVO item = (ItemVO)i.next();
					if(item.getType().startsWith("ICD10Code")){
						admissionDiagnoses.add(item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType().toLowerCase(), sWebLanguage));
					}
					else if(item.getType().equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_DIAGNOSIS")){
						freetext=item.getValue();
					}
				}
			}
			Iterator it = admissionDiagnoses.iterator();
			boolean bInit =false;
			while(it.hasNext()){
				if(bInit){
					sResult.append(", ");
				}
				sResult.append(it.next());
				bInit=true;
			}
			if(freetext.length()>0){
				if(bInit){
					sResult.append(", ");
				}
				sResult.append(freetext.replaceAll(";",""));
			}
			sResult.append(";");

			//Find ICD10 codes and paymenttypes on discharge
			String paymenttype="";
			HashSet dischargeDiagnoses = new HashSet();
			Vector discharges = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_HPRC_DISCHARGE",encounterServerId+"."+encounterObjectId);
			for(int n=0;n<discharges.size();n++){
				TransactionVO transaction = (TransactionVO)discharges.elementAt(n);
				Collection items = transaction.getItems();
				Iterator i = items.iterator();
				while(i.hasNext()){
					ItemVO item = (ItemVO)i.next();
					if(item.getType().startsWith("ICD10Code")){
						dischargeDiagnoses.add(item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType().toLowerCase(), sWebLanguage));
					}
					else if(item.getType().equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PAYMENT_TYPE")){
						paymenttype=item.getValue();
					}
				}
			}
			it = dischargeDiagnoses.iterator();
			bInit =false;
			while(it.hasNext()){
				if(bInit){
					sResult.append(", ");
				}
				sResult.append(it.next());
				bInit=true;
			}
			sResult.append(";");
			sResult.append(ScreenHelper.removeAccents(getTranNoLink("payment.type",paymenttype,sWebLanguage)).toUpperCase()+";");
			
			Encounter encounter = Encounter.get(encounterServerId+"."+encounterObjectId);
			PreparedStatement ps2 = loc_conn.prepareStatement("select distinct oc_encounter_serviceuid from oc_encounters_view where oc_encounter_serverid=? and oc_encounter_objectid=?");
			ps2.setInt(1,encounterServerId);
			ps2.setInt(2,encounterObjectId);
			ResultSet rs2 = ps2.executeQuery();
			bInit =false;
			while(rs2.next()){
				if(bInit){
					sResult.append(", ");
				}
				sResult.append(rs2.getString("oc_encounter_serviceuid"));
				bInit=true;
			}
			rs2.close();
			ps2.close();
			sResult.append(";");
			
			sResult.append("\r\n");
	    	b = sResult.toString().getBytes();
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
		}
		rs.close();
		ps.close();
		
		loc_conn.close();
        os.close();
        done=true;
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
	//*** 8 - GLOBAL LIST ************************************************
    else if("global.list".equalsIgnoreCase(sQueryType)){
        Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection(),
    	           lad_conn = MedwanQuery.getInstance().getLongAdminConnection();
		StringBuffer sResult = null;
		
		// search all encounters from this period
		query = "select * from oc_encounters_view a, adminview b"+
		        " where a.oc_encounter_patientuid = b.personid"+
         		"  and OC_ENCOUNTER_BEGINDATE <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
		        "  and OC_ENCOUNTER_ENDDATE >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
		        " ORDER BY oc_encounter_objectid";
        query = query.replaceAll("<begin>",request.getParameter("begin"))
        		     .replaceAll("<end>",request.getParameter("end"));
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		Debug.println(query);
		PreparedStatement ps = loc_conn.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		SortedMap results = new TreeMap();
		while(rs.next()){
			String id = rs.getString("oc_encounter_serverid")+"_"+rs.getString("oc_encounter_objectid");

			sResult = new StringBuffer();
			sResult.append(id+";");			
			sResult.append(checkString(rs.getString("oc_encounter_type"))+";");			
			
			java.util.Date dbegin = rs.getDate("oc_encounter_begindate");
			sResult.append(dbegin==null?";":ScreenHelper.stdDateFormat.format(dbegin)+";");		
			
			java.util.Date dend = rs.getDate("oc_encounter_enddate");
			sResult.append(dend==null?";":ScreenHelper.stdDateFormat.format(dend)+";");			
			
			String patientid = checkString(rs.getString("oc_encounter_patientuid"));
			sResult.append(patientid+";");		
			
			java.util.Date dob = rs.getDate("dateofbirth");
			sResult.append(dob==null?";":new SimpleDateFormat("MM/yyyy").format(dob)+";");			
			sResult.append(checkString(rs.getString("gender"))+";");		
		
			try{
				long year = 1000*3600;
				year = year*24*365;
				long age = dbegin.getTime()-dob.getTime();
				age = age/year;
				
				sResult.append(age+";");
			}
			catch(Exception q){
				sResult.append(";");
			}
			
			sResult.append(checkString(rs.getString("oc_encounter_outcome"))+";");		
			sResult.append(checkString(rs.getString("oc_encounter_destinationuid"))+";");		
			sResult.append(checkString(rs.getString("oc_encounter_origin"))+";");
			
			String serviceid = checkString(rs.getString("oc_encounter_serviceuid")).replaceAll("\\.","_");
			sResult.append(serviceid+";");
			
			sResult.append(checkString(rs.getString("oc_encounter_beduid")).replaceAll("\\.","_")+";");
			sResult.append(checkString(rs.getString("oc_encounter_manageruid")).replaceAll("\\.","_")+";");
			sResult.append(checkString(rs.getString("oc_encounter_updateuid")).replaceAll("\\.","_")+";");
			
			results.put(id+";"+patientid+";"+(dbegin==null?"":new SimpleDateFormat("yyyyMMddHHmmsss").format(dbegin))+";"+serviceid,sResult.toString());
		}
		
		Iterator iResults = results.keySet().iterator();
		sResult = new StringBuffer();
		
		// header
		sResult.append("CODE;TYPE;BEGINDATE;ENDDATE;PATIENT_CODE;MONTH_OF_BIRTH;GENDER;AGE;OUTCOME;DESTINATION;ORIGIN;"+
		               "CODE_SERVICE;CODE_BED;CODE_WARDMANAGER;ENCODER;DISTRICT;INSURER;CODE_USER;TYPE;DIAGCODE;LABEL;CERTAINTY;GRAVITY\r\n");
		
		while(iResults.hasNext()){
			String line = (String)iResults.next();
			String content = (String)results.get(line);
			
			// Add the district
			ps2 = lad_conn.prepareStatement("select * from adminprivate where personid="+line.split(";")[1]);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				content+= rs2.getString("district")+";";
			}
			else{
				content+= ";";
			}
			rs2.close();
			ps2.close();
			
			// Add insurer
			query = "select max(OC_INSURAR_NAME) as INSURER"+
			        " from OC_INSURARS q, OC_INSURANCES r, OC_DEBETS s"+
			        "  where q.oc_insurar_objectid = replace(r.oc_insurance_insuraruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
			        "   and r.oc_insurance_objectid = replace(s.oc_debet_insuranceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
			        "   and s.oc_debet_encounteruid='"+line.split(";")[0].replaceAll("\\_", ".")+"'";
			ps2 = loc_conn.prepareStatement(query);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				content+= checkString(rs2.getString("insurer"))+";";
			}
			else{
				content+= ";";
			}
			rs2.close();
			ps2.close();
			
			// Add reasons for encounter
			ps2 = loc_conn.prepareStatement("select * from OC_DIAGNOSES"+
			                                " where OC_DIAGNOSIS_ENCOUNTERUID='"+line.split(";")[0].replaceAll("\\_", ".")+"'");
			rs2 = ps2.executeQuery();
			
			boolean bHasDiags=false;
			while(rs2.next()){
				bHasDiags = true;
				String codetype = checkString(rs2.getString("OC_DIAGNOSIS_CODETYPE"));
				String code = checkString(rs2.getString("OC_DIAGNOSIS_CODE"));
				
				sResult.append(content+checkString(rs2.getString("OC_DIAGNOSIS_AUTHORUID"))+";"+codetype+";"+code+";"+MedwanQuery.getInstance().getCodeTran((codetype.toLowerCase().startsWith("icpc")?"icpccode":"icd10code")+code, sWebLanguage)+";"+checkString(rs2.getString("OC_DIAGNOSIS_CERTAINTY"))+";"+checkString(rs2.getString("OC_DIAGNOSIS_GRAVITY"))+";\r\n");
			}
			rs2.close();
			ps2.close();
			
			if(!bHasDiags){
				sResult.append(content+";"+";"+";"+";"+";"+"\r\n");
			}
		}
		rs.close();
		ps.close();
		
        loc_conn.close();
        lad_conn.close();
        
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	   
	    ServletOutputStream os = response.getOutputStream();
    	byte[] b = sResult.toString().getBytes();
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 9 - GLOBAL RFE *************************************************
    else if("globalrfe.list".equalsIgnoreCase(sQueryType)){
        Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection(),
    	           lad_conn = MedwanQuery.getInstance().getLongAdminConnection();
		StringBuffer sResult = null;
		
		// First we search all encounters from this period
		query = "select * from oc_encounters_view a, adminview b where a.oc_encounter_patientuid=b.personid and "+
		        " OC_ENCOUNTER_BEGINDATE<="+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+" AND"+
		        " OC_ENCOUNTER_ENDDATE>="+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+" ORDER BY oc_encounter_objectid";
        query = query.replaceAll("<begin>",request.getParameter("begin"))
        		     .replaceAll("<end>",request.getParameter("end"));
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		PreparedStatement ps = loc_conn.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		SortedMap results = new TreeMap();
		while(rs.next()){
			sResult = new StringBuffer();
			
			String id = rs.getString("oc_encounter_serverid")+"_"+rs.getString("oc_encounter_objectid");
			sResult.append(id+";");
			
			sResult.append(checkString(rs.getString("oc_encounter_type"))+";");			
			
			java.util.Date dbegin = rs.getDate("oc_encounter_begindate");
			sResult.append(dbegin==null?";":ScreenHelper.stdDateFormat.format(dbegin)+";");		
			
			java.util.Date dend = rs.getDate("oc_encounter_enddate");
			sResult.append(dend==null?";":ScreenHelper.stdDateFormat.format(dend)+";");			
			
			String patientid = checkString(rs.getString("oc_encounter_patientuid"));
			sResult.append(patientid+";");		
			
			java.util.Date dob = rs.getDate("dateofbirth");
			sResult.append(dob==null?";":new SimpleDateFormat("MM/yyyy").format(dob)+";");			
			sResult.append(checkString(rs.getString("gender"))+";");		
			
			try{
				long year = 1000*3600;
				year = year*24*365;
				long age = dbegin.getTime()-dob.getTime();
				age = age/year;
				
				sResult.append(age+";");
			}
			catch(Exception q){
				sResult.append(";");
			}
			
			sResult.append(checkString(rs.getString("oc_encounter_outcome"))+";");		
			sResult.append(checkString(rs.getString("oc_encounter_destinationuid"))+";");		
			sResult.append(checkString(rs.getString("oc_encounter_origin"))+";");
			
			String serviceid = checkString(rs.getString("oc_encounter_serviceuid")).replaceAll("\\.","_");
			sResult.append(serviceid+";");
			
			sResult.append(checkString(rs.getString("oc_encounter_beduid")).replaceAll("\\.","_")+";");
			sResult.append(checkString(rs.getString("oc_encounter_manageruid")).replaceAll("\\.","_")+";");
			sResult.append(checkString(rs.getString("oc_encounter_updateuid")).replaceAll("\\.","_")+";");
			
			results.put(id+";"+patientid+";"+(dbegin==null?"":new SimpleDateFormat("yyyyMMddHHmmsss").format(dbegin))+";"+serviceid,sResult.toString());
		}
		
		Iterator iResults = results.keySet().iterator();
		sResult = new StringBuffer();
		
		// header
		sResult.append("CODE;TYPE;BEGINDATE;ENDDATE;PATIENT_CODE;MONTH_OF_BIRTH;GENDER;AGE;OUTCOME;DESTINATION;"+
		               "ORIGIN;CODE_SERVICE;CODE_BED;CODE_WARDMANAGER;ENCODER;DISTRICT;INSURER;CODE_USER;TYPE;"+
				       "DIAGCODE;LABEL;CERTAINTY;GRAVITY\r\n");
		
		while(iResults.hasNext()){
			String line =(String)iResults.next();
			String content = (String)results.get(line);
		
			// Add the district
			ps2 = lad_conn.prepareStatement("select * from adminprivate where personid="+line.split(";")[1]);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				content+= rs2.getString("district")+";";
			}
			else{
				content+= ";";
			}
			rs2.close();
			ps2.close();
			
			// Add insurer
			query = "select max(OC_INSURAR_NAME) as INSURER"+
			        " from OC_INSURARS q, OC_INSURANCES r, OC_DEBETS s"+
			        "  where q.oc_insurar_objectid = replace(r.oc_insurance_insuraruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
			        "   and r.oc_insurance_objectid = replace(s.oc_debet_insuranceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
			        "   and s.oc_debet_encounteruid = '"+line.split(";")[0].replaceAll("\\_", ".")+"'";
			ps2 = loc_conn.prepareStatement(query);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				content+= checkString(rs2.getString("insurer"))+";";
			}
			else{
				content+= ";";
			}
			rs2.close();
			ps2.close();
			
			// Add reasons for encounter
			ps2 = loc_conn.prepareStatement("select * from OC_RFE where OC_RFE_ENCOUNTERUID='"+line.split(";")[0].replaceAll("\\_", ".")+"'");
			rs2 = ps2.executeQuery();
			boolean bHasRfe = false;
			while(rs2.next()){
				bHasRfe = true;
				
				String codetype = checkString(rs2.getString("OC_RFE_CODETYPE"));
				String code = checkString(rs2.getString("OC_RFE_CODE"));
				
				sResult.append(content+checkString(rs2.getString("OC_RFE_UPDATEUID"))+";"+codetype+";"+code+";"+MedwanQuery.getInstance().getCodeTran((codetype.toLowerCase().startsWith("icpc")?"icpccode":"icd10code")+code, sWebLanguage)+";"+(checkString(rs2.getString("OC_RFE_FLAGS")).indexOf("N")>-1?"NEW":"OLD")+";\r\n");
			}
			rs2.close();
			ps2.close();
			
			if(!bHasRfe){
				sResult.append(content+";"+";"+";"+";"+";"+"\r\n");
			}
		}
		rs.close();
		ps.close();
		
        loc_conn.close();
        lad_conn.close();
        
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition","Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	   
	    ServletOutputStream os = response.getOutputStream();
    	byte[] b = sResult.toString().getBytes();
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 10 - COUNTERS **************************************************
    else if("encounter.list".equalsIgnoreCase(sQueryType)){
        query = "select "+ MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_SERVERID")+MedwanQuery.getInstance().concatSign()+"'_'"+MedwanQuery.getInstance().concatSign()+ MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_OBJECTID")+" as CODE,"+
                "  OC_ENCOUNTER_TYPE as TYPE, OC_ENCOUNTER_BEGINDATE as BEGINDATE, OC_ENCOUNTER_ENDDATE as ENDDATE,"+
                "  OC_ENCOUNTER_PATIENTUID as CODE_PATIENT,substring("+MedwanQuery.getInstance().convertDateToString("dateofbirth")+",4,10) as MONTH_OF_BIRTH,"+
                "  gender as GENDER,OC_ENCOUNTER_OUTCOME as OUTCOME, OC_ENCOUNTER_DESTINATIONUID as DESTINATION, OC_ENCOUNTER_ORIGIN as ORIGIN,"+
                "  district as DISTRICT,replace(OC_ENCOUNTER_SERVICEUID,'.','_') as CODE_SERVICE,replace(OC_ENCOUNTER_BEDUID,'.','_') as CODE_LIT,"+
                "  replace(OC_ENCOUNTER_MANAGERUID,'.','_') as CODE_WARD, OC_ENCOUNTER_UPDATEUID as ENCODER"+
		        " from OC_ENCOUNTERS_VIEW, AdminView a, PrivateView b"+
		        "  where OC_ENCOUNTER_PATIENTUID = a.personid"+
		        "   and b.personid = a.personid"+
		        "   and b.stop is null"+
		        "   and OC_ENCOUNTER_BEGINDATE <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
		        "   and OC_ENCOUNTER_ENDDATE >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
		        " union "+
		        "select "+MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_SERVERID")+MedwanQuery.getInstance().concatSign()+"'_'"+MedwanQuery.getInstance().concatSign()+ MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_OBJECTID")+" as CODE,"+
		        "  OC_ENCOUNTER_TYPE as TYPE, OC_ENCOUNTER_BEGINDATE as BEGINDATE, OC_ENCOUNTER_ENDDATE as ENDDATE,"+
		        "  OC_ENCOUNTER_PATIENTUID as CODE_PATIENT,substring("+ MedwanQuery.getInstance().convertDateToString("dateofbirth")+",4,10) as MONTH_OF_BIRTH,"+
		        "  gender GENDER,OC_ENCOUNTER_OUTCOME as OUTCOME, OC_ENCOUNTER_DESTINATIONUID as DESTINATION, OC_ENCOUNTER_ORIGIN as ORIGIN,"+
		        "  null as DISTRICT,replace(OC_ENCOUNTER_SERVICEUID,'.','_') as CODE_SERVICE,replace(OC_ENCOUNTER_BEDUID,'.','_') as CODE_LIT,"+
		        "  replace(OC_ENCOUNTER_MANAGERUID,'.','_') as CODE_WARD, OC_ENCOUNTER_UPDATEUID as ENCODER"+
		        " from OC_ENCOUNTERS_VIEW, AdminView a"+
		        "  where OC_ENCOUNTER_PATIENTUID = a.personid"+
		        "   and not exists (select * from PrivateView where personid = a.personid)"+
		        "   and OC_ENCOUNTER_BEGINDATE <= "+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
		        "   and OC_ENCOUNTER_ENDDATE >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
                " order by CODE";
    }
	//*** 11 - WICKET CREDITS ********************************************
    else if("wicketcredits.list".equalsIgnoreCase(sQueryType)){
        query = "select oc_wicket_credit_operationdate as DATE,a.oc_label_value as CASHDESK,b.oc_label_value as TYPE,"+MedwanQuery.getInstance().convert("int","oc_wicket_credit_amount")+" as AMOUNT,"+
                "  oc_wicket_credit_comment as COMMENT, oc_wicket_credit_invoiceuid as REF_INVOICE,"+
                "  lastname as USERLASTNAME, firstname as USERFIRSTNAME"+
        		" from oc_wicket_credits, oc_wickets, oc_labels a, oc_labels b, usersview c, adminview d"+
        		"  where oc_wicket_credit_updateuid = userid"+
        		"   and c.personid = d.personid"+
        		"   and oc_wicket_credit_operationdate >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
        		"   and oc_wicket_credit_operationdate < "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
        		"   and oc_wicket_objectid = replace(oc_wicket_credit_wicketuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
        		"   and a.oc_label_type = 'service'"+
        		"   and a.oc_label_id = oc_wicket_serviceuid"+
        		"   and a.oc_label_language = '"+sWebLanguage+"'"+
        		"   and b.oc_label_type = 'credit.type'"+
        		"   and b.oc_label_id = oc_wicket_credit_type"+
        		"   and b.oc_label_language = '"+sWebLanguage+"'"+
        		" order by DATE";
    }
	//*** 12 - DIAGNOSES *************************************************
    else if("diagnosis.list".equalsIgnoreCase(sQueryType)){
        query = "select replace(OC_DIAGNOSIS_ENCOUNTERUID,'.','_') as CODE_CONTACT, OC_DIAGNOSIS_AUTHORUID as CODE_USER,"+
                "  OC_DIAGNOSIS_CODETYPE as TYPE, OC_DIAGNOSIS_CODE as CODE,"+
                "  (CASE OC_DIAGNOSIS_CODETYPE"+
                "    WHEN 'icpc'"+
                "     THEN (select "+label+" from icpc2 where code=OC_DIAGNOSIS_CODE)"+
                "     ELSE (select "+label+" from icd10 where code=OC_DIAGNOSIS_CODE)"+
                "   END) as LABEL,"+
                "  OC_DIAGNOSIS_CERTAINTY as CERTAINTY, OC_DIAGNOSIS_GRAVITY as GRAVITY,"+
                "  replace(OC_ENCOUNTER_SERVICEUID,'.','_') as CODE_SERVICE,"+
                "  replace(OC_ENCOUNTER_BEDUID,'.','_') as CODE_LIT,"+
                "  replace(OC_ENCOUNTER_MANAGERUID,'.','_') as CODE_WARD"+
                " from OC_DIAGNOSES a, OC_ENCOUNTERS_VIEW"+
                "  where OC_DIAGNOSIS_ENCOUNTERUID = "+ MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_SERVERID")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_OBJECTID")+
                "   and OC_ENCOUNTER_BEGINDATE <= "+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
                "   and OC_ENCOUNTER_ENDDATE >= "+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
                " order by OC_ENCOUNTER_SERVERID, OC_ENCOUNTER_OBJECTID";
    }
	//*** 13 - RFE *******************************************************
    else if("rfe.list".equalsIgnoreCase(sQueryType)){
        query = "select replace(OC_RFE_ENCOUNTERUID,'.','_') as CODE_CONTACT, OC_RFE_UPDATEUID as CODE_USER,"+
                "  OC_RFE_CODETYPE as TYPE, OC_RFE_CODE as CODE,"+
                "  (CASE OC_RFE_CODETYPE"+
                "    WHEN 'icpc'"+
                "     THEN (select "+label+" from icpc2 where code=OC_RFE_CODE)"+
                "     ELSE (select "+label+" from icd10 where code=OC_RFE_CODE)"+
                "   END) as LABEL,"+
                "  replace(OC_ENCOUNTER_SERVICEUID,'.','_') as CODE_SERVICE,"+
                "  replace(OC_ENCOUNTER_BEDUID,'.','_') as CODE_LIT,"+
                "  replace(OC_ENCOUNTER_MANAGERUID,'.','_') as CODE_WARD"+
                " from OC_RFE a, OC_ENCOUNTERS_VIEW"+
                "  where OC_RFE_ENCOUNTERUID = "+MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_SERVERID")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_OBJECTID")+
                "   and OC_ENCOUNTER_BEGINDATE <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
                "   and OC_ENCOUNTER_ENDDATE >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
                " order by OC_ENCOUNTER_SERVERID, OC_ENCOUNTER_OBJECTID";
    }
	//*** 14 - DOCUMENTS *************************************************
    else if("document.list".equalsIgnoreCase(sQueryType)){
        query = "select c.personid as CODE_PATIENT, a.userId as CODE_USER, a.updatetime as REGISTRATIONDATE, b.oc_label_value as TYPE"+
                " from Transactions a, oc_labels b, Healthrecord c"+
                "  where a.healthrecordid = c.healthrecordid"+
                "   and b.oc_label_type = 'web.occup'"+
                "   and b.oc_label_id = a.transactionType"+
                "   and b.OC_LABEL_LANGUAGE = '"+sWebLanguage+"'"+
                "   and a.updatetime >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
                "   and a.updatetime <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
                " order by a.updatetime";
    }
    
	if(!done){
	    Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection(),
		           lad_conn = MedwanQuery.getInstance().getLongAdminConnection();
	    
	    Debug.println(query);
	    CsvStats csvStats = new CsvStats(request.getParameter("begin"),
	    		                         request.getParameter("end"),
	    		                         "admin".equalsIgnoreCase(request.getParameter("db"))?lad_conn:loc_conn,
	    		                         query);
	    
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	   
	    ServletOutputStream os = response.getOutputStream();
	    byte[] b = csvStats.execute().toString().getBytes();
	    for(int n=0; n<b.length; n++){
	        os.write(b[n]);
	    }
	    loc_conn.close();
	    lad_conn.close();
	    
	    os.flush();
	    os.close();
	}
%>