<%@page import="pe.gob.sis.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission("financial.fua","edit",activeUser)%>
<%
	String list="1";
	if(checkString(request.getParameter("list")).length()>0){
		list=request.getParameter("list");
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
	<% 
		if(list.equalsIgnoreCase("1") && activePatient!=null){
			//Encounters without FUA
			Vector encounters = FUA.getEncountersWithoutFUA(Integer.parseInt(activePatient.personid));
			if(encounters.size()>0){
				out.println("<tr class='admin'>");
				out.println("<td colspan='5'>"+getTran(request,"web","fuatobecreated",sWebLanguage)+"</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td class='admin'>"+getTran(request,"web","encounterid",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","begindate",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","enddate",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","type",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","service",sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			for(int n=0;n<encounters.size();n++){
				Encounter encounter = (Encounter)encounters.elementAt(n);
				out.println("<tr>");
				if(encounter.getEnd()!=null){
					out.println("<td class='admin'><a href='javascript:createFUA(\""+encounter.getUid()+"\")'>"+encounter.getUid()+"</a></td>");
				}
				else{
					out.println("<td class='admin'><i>"+encounter.getUid()+"</i></td>");
				}
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(encounter.getBegin())+"</td>");
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(encounter.getEnd())+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"encountertype",encounter.getType(),sWebLanguage)+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"service",encounter.getServiceUID(),sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			if(encounters.size()>0){
				out.println("<tr><td colspan='5'><hr/></td></tr>");
			}
			
			//Open FUA with financial data that was modified
			Vector fuas = FUA.getFUAToBeUpdated(Integer.parseInt(activePatient.personid));
			if(fuas.size()>0){
				out.println("<tr class='admin'>");
				out.println("<td colspan='5'>"+getTran(request,"web","existingfuatobeupdated",sWebLanguage)+"</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td class='admin'>"+getTran(request,"web","fuaid",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","date",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","amount",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","type",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","service",sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			for(int n=0;n<fuas.size();n++){
				FUA fua = (FUA)fuas.elementAt(n);
				out.println("<tr>");
				out.println("<td class='admin'><a href='javascript:updateFUA(\""+fua.getUid()+"\")'>"+fua.getObjectId()+"</a></td>");
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(fua.getDate())+"</td>");
				out.println("<td class='admin2'>"+ScreenHelper.getPriceFormat(fua.getAmount())+" "+MedwanQuery.getInstance().getConfigString("currency","EUR")+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"encountertype",fua.getEncounter().getType(),sWebLanguage)+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"service",fua.getEncounter().getServiceUID(),sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			if(fuas.size()>0){
				out.println("<tr><td colspan='5'><hr/></td></tr>");
			}
			
			//Existing FUA
			fuas = FUA.getEncountersWithFUA(Integer.parseInt(activePatient.personid));
			if(fuas.size()>0){
				out.println("<tr class='admin'>");
				out.println("<td colspan='5'>"+getTran(request,"web","existingfua",sWebLanguage)+"</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td class='admin'>"+getTran(request,"web","fuaid",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","date",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","amount",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","type",sWebLanguage)+"</td>");
				out.println("<td class='admin'>"+getTran(request,"web","service",sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			for(int n=0;n<fuas.size();n++){
				FUA fua = (FUA)fuas.elementAt(n);
				out.println("<tr>");
				out.println("<td class='admin'><a href='javascript:editFUA(\""+fua.getUid()+"\")'>"+fua.getObjectId()+"</a></td>");
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(fua.getDate())+"</td>");
				out.println("<td class='admin2'>"+ScreenHelper.getPriceFormat(fua.getAmount())+" "+MedwanQuery.getInstance().getConfigString("currency","EUR")+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"encountertype",fua.getEncounter().getType(),sWebLanguage)+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"service",fua.getEncounter().getServiceUID(),sWebLanguage)+"</td>");
				out.println("</tr>");
			}
			if(fuas.size()>0){
				out.println("<tr><td colspan='5'><hr/></td></tr>");
			}
		}
	%>
	</table>
</form>
<script>
	function createFUA(encounteruid){
		window.location.href='main.jsp?Page=financial/manageFUA.jsp&encounteruid='+encounteruid;
	}
	function editFUA(fuauid){
		window.location.href='main.jsp?Page=financial/manageFUA.jsp&fuauid='+fuauid;
	}
	function updateFUA(fuauid){
		window.location.href='main.jsp?Page=financial/manageFUA.jsp&update=1&fuauid='+fuauid;
	}
</script>