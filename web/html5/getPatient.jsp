<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<%@include file="/includes/validateUser.jsp"%>
<%
	String personid = checkString(request.getParameter("searchpersonid"));
	try{
		activePatient=null;
		activePatient = AdminPerson.getAdminPerson(Integer.parseInt(personid)+"");
        session.setAttribute("activePatient",activePatient);
	    PersonVO person = MedwanQuery.getInstance().getPerson(activePatient.personid);
        SessionContainerWO sessionContainerWO= (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
	    sessionContainerWO.setPersonVO(person);
	    sessionContainerWO.setHealthRecordVO(MedwanQuery.getInstance().loadHealthRecord(person, null, sessionContainerWO));
	}
	catch(Exception e){}
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","patientfile",sWebLanguage) %></title>
<html>
	<body>
		<table width='100%'>
			<tr>
				<td style='font-size:8vw;text-align: left'></td>
				<td style='font-size:8vw;text-align: right'>
					<img onclick="window.location.href='../html5/findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
					<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
					<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
				</td>
			</tr>
			<tr>
				<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
					<%
						if(activePatient==null){
							out.println(getTran(request,"web","patientrecorddoesnotexist",sWebLanguage)+":<br/>["+personid+"]");
						}
						else{
							out.println("["+activePatient.personid+"] "+activePatient.getFullName());
						}
					%>
				</td>
			</tr>
			<%	
				if(activePatient!=null){
			%>
			<%if(Encounter.getActiveEncounter(activePatient.personid)!=null){ %>
			<tr onclick="window.location.href='getEncounter.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/encounter.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","activeencounter",sWebLanguage) %>
				</td>
			</tr>
			<%	}
			else{
			%>
			<tr onclick="window.location.href='createEncounter.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img style='opacity:0.3' src='<%=sCONTEXTPATH%>/_img/icons/mobile/encounter.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px;color:lightgrey'>
					<%=getTran(request,"web","activeencounter",sWebLanguage) %>
				</td>
			</tr>
			<%} %>
			<tr onclick="window.location.href='getAdmin.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/admin.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","admindata",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getVitalSigns.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/thermometer.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"openclinic.chuk","vital.signs",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getVaccinations.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/vacc.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","vaccinations",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getLab.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/lab.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","labresults",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getDrugs.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/drugs.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","drugprescriptions",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getImaging.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/xray.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","imaging",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getExaminations.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/exam.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","examinations",sWebLanguage) %>
				</td>
			</tr>
			<%	
				}
			%>
		</table>
	</body>
</html>