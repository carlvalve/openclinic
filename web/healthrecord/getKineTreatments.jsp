<%@include file="/includes/helper.jsp"%>
<table width='100%'>
<%
	String sWebLanguage = request.getParameter("language");
	if(request.getParameter("treatments").length()>0){
		String[] treatments = request.getParameter("treatments").split("£");
		for(int n=0;n<treatments.length;n++){
			String act1="",act2="",act3="",comment="";
			if(treatments[n].split(";").length>1){
				act1=getTranNoLink("cnrkr.acts",treatments[n].split(";")[1],sWebLanguage);
			}
			if(treatments[n].split(";").length>2){
				act2=getTranNoLink("cnrkr.acts",treatments[n].split(";")[2],sWebLanguage);
			}
			if(treatments[n].split(";").length>3){
				act3=getTranNoLink("cnrkr.acts",treatments[n].split(";")[3],sWebLanguage);
			}
			if(treatments[n].split(";").length>4){
				comment=treatments[n].split(";")[4];
			}
			out.println("<tr>");
			out.println("<td width='46px' class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.gif' onclick='deleteTreatment("+n+")'><img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.gif' onclick='editTreatmentLine("+n+")'></td>");
			out.println("<td width='15%' class='admin2'>"+treatments[n].split(";")[0]+"</td>");
			out.println("<td width='15%' class='admin2'>"+act1+"</td>");
			out.println("<td width='15%' class='admin2'>"+act2+"</td>");
			out.println("<td width='15%' class='admin2'>"+act3+"</td>");
			out.println("<td class='admin2'>"+comment+"</td>");
			out.println("</tr>");
		}
	}
%>
