<%@ page import="java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'><td><%=getTran("web","mandatory.patientdata.ismissing",sWebLanguage) %></td></tr>
<%
	Vector missing = activePatient.getMissingMandatoryFieldsTranslated(sWebLanguage);
	for(int n=0;n<missing.size();n++){
		out.println("<tr><td class='admin2'>"+missing.elementAt(n)+"</td></tr>");
	}
%>
</table>
<center><input type='button' value='<%=getTran("web","close",sWebLanguage) %>' onclick='window.close();'/></center>
