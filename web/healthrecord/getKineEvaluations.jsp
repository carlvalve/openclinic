<%@include file="/includes/helper.jsp"%>
<table width='100%'>
<%
	String sWebLanguage = request.getParameter("language");
	if(request.getParameter("evaluations").length()>0){
		String[] evaluations = request.getParameter("evaluations").split("£");
		for(int n=0;n<evaluations.length;n++){
			String objectives="",functional="",comment="";
			if(evaluations[n].split(";").length>1){
				objectives=evaluations[n].split(";")[1];
			}
			if(evaluations[n].split(";").length>2){
				functional=evaluations[n].split(";")[2];
			}
			if(evaluations[n].split(";").length>3){
				comment=evaluations[n].split(";")[3];
			}
			out.println("<tr>");
			out.println("<td width='50px' class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.gif' onclick='deleteEvaluation("+n+")'><img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.gif' onclick='editEvaluationLine("+n+")'></td>");
			out.println("<td width='20%' class='admin2'>"+evaluations[n].split(";")[0]+"</td>");
			out.println("<td width='20%' class='admin2'>"+objectives.replaceAll("\r","<BR/>")+"</td>");
			out.println("<td width='20%' class='admin2'>"+functional.replaceAll("\r","<BR/>")+"</td>");
			out.println("<td class='admin2'>"+comment.replaceAll("\r","<BR/>")+"</td>");
			out.println("</tr>");
		}
	}
%>
