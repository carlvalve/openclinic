<%@page import="be.openclinic.finance.Prestation"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sPrestationGroupUID = checkString(request.getParameter("PrestationGroupUID"));

	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n****************** financial/getGroupPrestations.jsp ******************");
		Debug.println("sPrestationGroupUID  : "+sPrestationGroupUID); // no newline here
	}
	///////////////////////////////////////////////////////////////////////////////////////////////

    String prestationcontent = "";
	int recCount = 0;
	
	if(sPrestationGroupUID.length() > 0){
	    try{
	        prestationcontent = "<table class='list' cellpadding='0' cellspacing='1' width='100%'>"+
	                             "<tr class='admin'>"+
	          	                  "<td width='20'>&nbsp;</td>"+
	          	     	          "<td width='80'>"+getTran("web","code",sWebLanguage)+"</td>"+
		                          "<td width='*'>"+getTran("web","description",sWebLanguage)+"</td>"+
	                             "</tr>";
	        
	    	String sSql = "select oc_prestationgroup_prestationuid from oc_prestationgroups_prestations"+
	                      " where oc_prestationgroup_groupuid = ?";
	        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
	    	PreparedStatement ps = oc_conn.prepareStatement(sSql);
	    	ps.setString(1,sPrestationGroupUID);
	    	ResultSet rs = ps.executeQuery();
	    	
	    	String sPrestationUid;
	    	while(rs.next()){
	    		sPrestationUid = rs.getString("oc_prestationgroup_prestationuid");
	    		
	    		Prestation prestation = Prestation.get(sPrestationUid);
	    		if(prestation!=null){
	    			recCount++;
	    	        prestationcontent+= "<tr>"+ 
	    		                         "<td><img class='link' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.gif' onClick='deletePrestation(\\\""+prestation.getUid()+"\\\");'/></a></td>"+
	    		                      	 "<td>"+prestation.getCode()+"</td>"+
	    	        		             "<td><b>"+prestation.getDescription()+"</b></td>"+
	    	        		            "</tr>";
	   	        }
	    	}
	        rs.close();
	        ps.close();
	        oc_conn.close();
	        
	        Debug.println("--> recCount : "+recCount);
		    
		    prestationcontent+= "</table>";	
		    prestationcontent+= recCount+" "+getTran("web","recordsFound",sWebLanguage);		
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>

{
  "PrestationContent":"<%=prestationcontent%>"
}