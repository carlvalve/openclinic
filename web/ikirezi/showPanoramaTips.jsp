<%@page import="org.jfree.ui.LengthAdjustmentType"%>
<%@page import="org.dom4j.io.SAXReader,
				java.awt.*,java.awt.image.*,be.openclinic.adt.*,
                java.net.URL,
                org.dom4j.Document,
                org.dom4j.Element,
                be.mxs.common.util.db.MedwanQuery,
                org.dom4j.DocumentException,
                java.net.MalformedURLException,java.util.*,
                be.openclinic.knowledge.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String disease = checkString(request.getParameter("disease"));
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='3'><center><%=disease.toUpperCase() %></center></td>
	</tr>
	<tr>
		<th class='admin'><%=getTran(request,"web","finding",sWebLanguage) %></th>
		<th class='admin'><%=getTran(request,"web","positive",sWebLanguage) %></th>
		<th class='admin'><%=getTran(request,"web","negative",sWebLanguage) %></th>
	</tr>
<%
	String[] signs = checkString(request.getParameter("signs")).split("\\$");
	for(int n=0;n<signs.length;n++){
		String[] fields = signs[n].split(";");
		double confirmingPower = Double.parseDouble(fields[2]);
		int confirmingcolor = new Double(255-confirmingPower*255/100).intValue();
		if(confirmingcolor<0){
			confirmingcolor=0;
		}
		double excludingPower = Double.parseDouble(fields[3]);
		int excludingcolor = new Double(255-excludingPower*255/100).intValue();
		if(excludingcolor<0){
			excludingcolor=0;
		}
		out.println("<tr>");
		out.println("<td class='admin'>"+fields[1].replaceAll("--pct--","%")+"</td>");
		out.println("<td style='color: "+(confirmingcolor<122?"white":"black")+";background-color: rgb(255,"+confirmingcolor+","+confirmingcolor+");'><center><b>"+new DecimalFormat("#.0").format(confirmingPower)+"</b></center></td>");
		out.println("<td style='color: "+(excludingcolor<122?"white":"black")+";background-color: rgb(255,"+excludingcolor+","+excludingcolor+");'><center><b>"+new DecimalFormat("#.0").format(excludingPower)+"</b></center></td>");
		out.println("</tr>");
	}
%>
</table>