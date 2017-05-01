<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String code = checkString(request.getParameter("code"));
	String type = checkString(request.getParameter("type"));
	String sMessage = "";
	String frequency = "";
	Nomenclature nomenclature = Nomenclature.get("asset",code);
	if(nomenclature!=null){
		if(type.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("controlMaintenancePlan","1"))){
			sMessage=nomenclature.getParameter("controlcontent");
			frequency = nomenclature.getParameter("controlfrequency");
		}
		else if(type.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("preventiveMaintenancePlan","2"))){
			sMessage=nomenclature.getParameter("maintenancecontent");
			frequency = nomenclature.getParameter("maintenancefrequency");
		}
	}
    
%>

{
  "instructions":"<%=HTMLEntities.htmlentities(sMessage.replaceAll("\r","").replaceAll("\n","<br/>"))%>",
  "frequency":"<%=frequency %>"
}