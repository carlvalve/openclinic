<%@page import="net.admin.*,
                java.text.*,
                java.util.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.db.*,be.openclinic.reporting.*,pe.gob.sis.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sMonth = new SimpleDateFormat("yyyyMM").format(new java.util.Date());	

	String personid   = request.getParameter("personid"),
           insuraruid = request.getParameter("insuraruid"),
           userid     = request.getParameter("userid"),
           language   = request.getParameter("language");
	
	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n************** financial/checkInsuranceAuthorisation.jsp **************");
		Debug.println("sMonth     : "+sMonth);
		Debug.println("personid   : "+personid);
		Debug.println("insuraruid : "+insuraruid);
		Debug.println("userid     : "+userid);
		Debug.println("language   : "+language+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	if(ScreenHelper.checkString(request.getParameter("forceautorization")).length()>0){
		//TODO: get SIS authorization number
		ResultQueryAsegurado insurance = SIS.getAffiliationInformation(Integer.parseInt(activePatient.personid));
    	Pointer.storePointer("AUTH."+insuraruid+"."+personid+"."+new SimpleDateFormat("yyyyMM").format(new java.util.Date()), new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date(new java.util.Date().getTime()+24*3600*1000))+";90;"+insurance.getResultado()+";"+insurance.getContrato()+";"+insurance.getDescTipoSeguro()+";"+insurance.getEstado()+";"+insurance.getFecAfiliacion()+";"+insurance.getFecCaducidad()+";"+insurance.getIdNumReg()+";"+insurance.getIdPlan());
	}
	
	Vector pointers = Pointer.getPointers("AUTH."+insuraruid+"."+personid+"."+sMonth);
	boolean bValid = false;
	SimpleDateFormat deci = new SimpleDateFormat("yyyyMMddHHmmss");
	
	for(int n=0; n<pointers.size() && !bValid; n++){
		String pointer = (String)pointers.elementAt(n);
		
		java.util.Date dValidUntil = deci.parse(pointer.split(";")[0]);
		if(dValidUntil.after(new java.util.Date())){
			// Still valid
			User user = User.get(Integer.parseInt(pointer.split(";")[1]));
			String username = user!=null?user.person.getFullName():"?";
			if(MedwanQuery.getInstance().getConfigInt("peruEnabled",0)==1){
				out.print(HTMLEntities.htmlentities("<td class='admin'><input type='hidden' id='authorized' value='1'/>"+ScreenHelper.getTran(request,"web","insurance.authorization",language)+"</td>"+
                        "<td class='admin2'>"+ScreenHelper.getTran(request,"web","authorized.by",language)+": <b>SIS</b> "+ScreenHelper.getTran(request,"web","withauthorizationnumber",language)+" <b><a href='javascript:showdetails(\""+"AUTH."+insuraruid+"."+personid+"."+sMonth+"\")' title='"+getTranNoLink("web","details",sWebLanguage)+"'>"+pointer.split(";")[2]+"</b></td>"));
				
			}
			else{
				out.print(HTMLEntities.htmlentities("<td class='admin'>"+ScreenHelper.getTran(request,"web","insurance.agent.authorization",language)+"</td>"+
				                                    "<td class='admin2'>"+ScreenHelper.getTran(request,"web","authorized.by",language)+": "+username+" "+ScreenHelper.getTran(request,"web","until",language)+" <b>"+ScreenHelper.fullDateFormatSS.format(dValidUntil)+"</b></td>"));
			}
			bValid = true;
		}
	}
	
	if(!bValid){
		if(MedwanQuery.getInstance().getConfigString("InsuranceAgentAuthorizationNeededFor","").indexOf("*"+insuraruid+"*")>-1){
			User user = User.get(Integer.parseInt(userid));
			if(user!=null && ((user.getParameter("insuranceagent")!=null && user.getParameter("insuranceagent").equalsIgnoreCase(insuraruid)) || user.getAccessRightNoSA("financial.authorizeanyinsurance.select"))){
				// This agent can give an authorization for performing prestation encoding
				out.print(HTMLEntities.htmlentities("<td class='admin'>"+ScreenHelper.getTran(request,"web","insurance.agent.authorize",language)+"</td>"+
				                                    "<td class='admin2'><input type='checkbox' class='text' name='EditAuthorization' id='EditAuthorization' value='"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+";"+userid+"'>"+ScreenHelper.getTran(request,"web","authorize.until",language)+" <b>"+ScreenHelper.fullDateFormatSS.format(new java.util.Date(new java.util.Date().getTime()+24*3600*1000))+"</b></td>"));
			}
		}
		else{
			out.print("<td colapsn='2'><input type='hidden' id='authorized' value='1'/></td>");
		}
	}
%>