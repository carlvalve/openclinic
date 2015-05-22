<%@ page import="be.openclinic.pharmacy.*,java.io.*,org.dom4j.*,org.dom4j.io.*,sun.misc.*,be.mxs.common.util.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.finance.*,net.admin.*,java.util.*,java.text.*,be.openclinic.adt.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	boolean bHasInteractions = false;
	if(request.getParameter("key")!=null){
		String key=checkString(request.getParameter("key"));
		while(key.indexOf(";;")>-1){
			key=key.replaceAll(";;",";");
		}
		key=key.replaceAll(";", "+");
		bHasInteractions = Utils.hasDrugDrugInteractions(key);
	}
	else {
		bHasInteractions=Utils.patientHasDrugDrugInteractions(activePatient.personid);
	}
%>
{
	"interactionsexist": "<%=bHasInteractions?1:0 %>"
}
