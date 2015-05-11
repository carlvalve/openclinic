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
	String vaccinationlocation = checkString(request.getParameter("vaccinationlocation"))+":"+checkString(request.getParameter("vaccinationlocationtext"));
	
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
				<select name='vaccinationlocation' id='vaccinationlocation' onchange='if(this.value==1){document.getElementById("vaccinationlocationtext").style.visibility="visible"} else {document.getElementById("vaccinationlocationtext").value="";document.getElementById("vaccinationlocationtext").style.visibility="hidden"}'>
					<option value='0' <%=(vaccinationlocation.length()>1 && vaccinationlocation.substring(0,1).equalsIgnoreCase("0"))?"selected":"" %>><%=getTranNoLink("vaccinationlocation",MedwanQuery.getInstance().getConfigString("defaultVaccinationLocation",""),sWebLanguage) %></option>
					<%
						Hashtable labels=(Hashtable)((Hashtable)(MedwanQuery.getInstance().getLabels())).get(sWebLanguage.toLowerCase());
						if(labels!=null) labels=(Hashtable)labels.get("vaccinationlocation");
						if(labels!=null){
							Enumeration en = labels.keys();
							while(en.hasMoreElements()){
								String key = (String)en.nextElement();
								if(!key.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("defaultVaccinationLocation",""))){
									out.println("<option value='"+key+"' "+(key.equalsIgnoreCase(vaccinationlocation.length()>1?vaccinationlocation.substring(0,1):"")?"selected":"")+">"+((Label)labels.get(key)).value+"</option>");
								}
							}
						}
					%>
					<option value='1' <%=(vaccinationlocation.length()>1 && vaccinationlocation.substring(0,1).equalsIgnoreCase("1"))?"selected":"" %>><%=getTran("web","other",sWebLanguage) %></option>
				</select>
				<input type='text' name='vaccinationlocationtext' id='vaccinationlocationtext' value='<%=vaccinationlocation.length()>1?vaccinationlocation.substring(2):""%>'  size='80'/>
			</td>
		</tr>
	</table>
	<input type='submit' class='button' name='submit' value='<%=getTran("web","save",sWebLanguage)%>'/>
	<input type='submit' class='button' name='delete' value='<%=getTran("web","delete",sWebLanguage)%>'/>
</form>
<script>
	if(document.getElementById("vaccinationlocation").value==1){document.getElementById("vaccinationlocationtext").style.visibility="visible"} else {document.getElementById("vaccinationlocationtext").value="";document.getElementById("vaccinationlocationtext").style.visibility="hidden"};
</script>