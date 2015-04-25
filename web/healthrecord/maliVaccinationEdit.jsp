<%@page import="be.openclinic.medical.Vaccination"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String date = checkString(request.getParameter("date"));
	if(date.length()==0){
		date=ScreenHelper.formatDate(new java.util.Date());
	}
	String type = checkString(request.getParameter("type"));
	String batchnumber = checkString(request.getParameter("batchnumber"));
	String expirydate = checkString(request.getParameter("expirydate"));
	String vaccinationlocation = checkString(request.getParameter("vaccinationlocation"));
	
	if(request.getParameter("submit")!=null){
		//Save this vaccination record
		Vaccination vaccination = new Vaccination();
		vaccination.personid=activePatient.personid;
		vaccination.type=type;
		vaccination.date=date;
		vaccination.batchnumber=batchnumber;
		vaccination.expiry=expirydate;
		vaccination.location=vaccinationlocation;
		vaccination.save();
		out.println("<script>window.location.href='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/main.do?Page=/healthrecord/maliVaccinationCard.jsp';</script>");
		out.flush();
	}
	if(request.getParameter("delete")!=null){
		//Save this vaccination record
		Vaccination vaccination = new Vaccination();
		vaccination.personid=activePatient.personid;
		vaccination.type=type;
		vaccination.delete();
		out.println("<script>window.location.href='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/main.do?Page=/healthrecord/maliVaccinationCard.jsp';</script>");
		out.flush();
	}
	Vaccination vaccination = (Vaccination)Vaccination.getVaccinations(activePatient.personid).get(type);
	if(vaccination!=null){
		if(vaccination.date!=null && vaccination.date.length()>0){
			date=vaccination.date;
		}
		batchnumber=vaccination.batchnumber;
		vaccinationlocation=vaccination.location;
		expirydate=vaccination.expiry;
	}
%>
<form name='transactionForm' method='post'>
	<table>
		<tr class='admin'>
			<td colspan='2'><%=getTran("web","editvaccination",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","date",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDateField("date", "transactionForm", date, true, false, sWebLanguage, sCONTEXTPATH) %>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","type",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='hidden' name="type" id="type" value="<%=type %>"/><%=getTran("web",type,sWebLanguage) %>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","batchnumber",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='text' name='batchnumber' id='batchnumber' value='<%=batchnumber%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","expirydate",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='text' name='expirydate' id='expirydate' value='<%=expirydate%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","vaccinationlocation",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='text' name='vaccinationlocation' id='vaccinationlocation' value='<%=vaccinationlocation%>'/>
			</td>
		</tr>
	</table>
	<input type='submit' class='button' name='submit' value='<%=getTran("web","save",sWebLanguage)%>'/>
	<input type='submit' class='button' name='delete' value='<%=getTran("web","delete",sWebLanguage)%>'/>
</form>