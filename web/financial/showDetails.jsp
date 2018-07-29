<%@page import="net.admin.*,
                java.text.*,
                java.util.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.db.*,be.openclinic.reporting.*,pe.gob.sis.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String p = Pointer.getPointer(request.getParameter("pointer"));
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","insurancedetails",sWebLanguage) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","authorizationnumber",sWebLanguage) %></td>
		<td class='admin2'><%=p.split(";")[2] %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","contractr",sWebLanguage) %></td>
		<td class='admin2'><%=p.split(";")[3] %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","insurancetype",sWebLanguage) %></td>
		<td class='admin2'><%=p.split(";")[4] %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","insurancestatus",sWebLanguage) %></td>
		<td class='admin2'><%=p.split(";")[5] %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","begin",sWebLanguage) %></td>
		<td class='admin2'><%=p.split(";")[6] %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","end",sWebLanguage) %></td>
		<td class='admin2'><%=p.split(";")[7] %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","registrationnumber",sWebLanguage) %></td>
		<td class='admin2'><%=p.split(";")[8] %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","coverageplan",sWebLanguage) %></td>
		<td class='admin2'><%=p.split(";")[9] %></td>
	</tr>
</table>