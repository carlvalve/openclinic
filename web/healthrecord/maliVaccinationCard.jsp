<%@page import="be.openclinic.medical.Vaccination"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	long day = 24*3600*1000;
	long week=7*day;
	long month=30*day;
	long year=365*day;
	long age=0;
	try{
    	age = new java.util.Date().getTime()-ScreenHelper.parseDate(activePatient.dateOfBirth).getTime();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	Hashtable vaccinations = Vaccination.getVaccinations(activePatient.personid);
%>
<table width="100%">
	<tr class='admin'>
		<td colspan='6'><%=getTran("web","dateandtypeofvaccination",sWebLanguage) %></td>
	</tr>
	<tr class='admin'>
		<td><%=getTran("web","period",sWebLanguage) %></td>
		<td><%=getTran("web","type",sWebLanguage) %></td>
		<td><%=getTran("web","date",sWebLanguage) %></td>
		<td><%=getTran("web","batchnumber",sWebLanguage) %></td>
		<td><%=getTran("web","expirydate",sWebLanguage) %></td>
		<td><%=getTran("web","vaccinationlocation",sWebLanguage) %></td>
	</tr>
	<!-- Birth -->
	<tr>
		<td class='admin' rowspan='2'><%=getTran("web","birth",sWebLanguage) %></td>
		<td class='admin2'><%=getTran("web","BCG",sWebLanguage) %></td>
		<%=Vaccination.getVaccination(vaccinations,age,request,"bcg","date")%>
		<%=Vaccination.getVaccination(vaccinations,age,request,"bcg","batchnumber")%>
		<%=Vaccination.getVaccination(vaccinations,age,request,"bcg","expiry")%>
		<%=Vaccination.getVaccination(vaccinations,age,request,"bcg","location")%>
	</tr>
	<tr>
		<td class='admin2'><%=getTran("web","Polio",sWebLanguage) %> 0</td>
		<%=Vaccination.getVaccination(vaccinations,age,request,"polio0","date")%>
		<%=Vaccination.getVaccination(vaccinations,age,request,"polio0","batchnumber")%>
		<%=Vaccination.getVaccination(vaccinations,age,request,"polio0","expiry")%>
		<%=Vaccination.getVaccination(vaccinations,age,request,"polio0","location")%>
	</tr>
	<%
		if(age>=5*week){
	%>
		<tr><td colspan='6'><hr/></td></tr>
		<!-- 6 weeks -->
		<tr>
			<td class='admin' rowspan='4'><%=getTran("web","6weeks",sWebLanguage) %></td>
			<td class='admin2'><%=getTran("web","Polio",sWebLanguage) %> 1</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio1","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Penta",sWebLanguage) %> 1</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta1","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Pneumo",sWebLanguage) %> 1</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo1","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Rota",sWebLanguage) %> 1</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota1","location")%>
		</tr>
	<%
		}
		if(age>=9*week){
	%>
		<tr><td colspan='6'><hr/></td></tr>
		<!-- 10 weeks -->
		<tr>
			<td class='admin' rowspan='4'><%=getTran("web","10weeks",sWebLanguage) %></td>
			<td class='admin2'><%=getTran("web","Polio",sWebLanguage) %> 2</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio2","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio2","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio2","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio2","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Penta",sWebLanguage) %> 2</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta2","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta2","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta2","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta2","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Pneumo",sWebLanguage) %> 2</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo2","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo2","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo2","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo2","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Rota",sWebLanguage) %> 2</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota2","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota2","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota2","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota2","location")%>
		</tr>
	<%
		}
		if(age>=13*week){
	%>
		<tr><td colspan='6'><hr/></td></tr>
		<!-- 14 weeks -->
		<tr>
			<td class='admin' rowspan='4'><%=getTran("web","14weeks",sWebLanguage) %></td>
			<td class='admin2'><%=getTran("web","Polio",sWebLanguage) %> 3</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio3","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio3","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio3","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"polio3","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Penta",sWebLanguage) %> 3</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta3","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta3","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta3","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"penta3","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Pneumo",sWebLanguage) %> 3</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo3","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo3","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo3","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo3","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Rota",sWebLanguage) %> 3</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota3","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota3","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota3","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"rota3","location")%>
		</tr>
	<%
		}
		if(age>=9*month-week){
	%>
		<tr><td colspan='6'><hr/></td></tr>
		<!-- 9 mois -->
		<tr>
			<td class='admin' rowspan='3'><%=getTran("web","9months",sWebLanguage) %></td>
			<td class='admin2'><%=getTran("web","Measles",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"measles","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"measles","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"measles","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"measles","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","Yellowfever",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"yellowfever","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"yellowfever","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"yellowfever","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"yellowfever","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","MeningitisA",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"meningitisa","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"meningitisa","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"meningitisa","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"meningitisa","location")%>
		</tr>
	<%
		}
		if(age>=6*month-week){
	%>
		<tr><td colspan='6'><hr/></td></tr>
		<tr class='admin'>
			<td colspan='6'><%=getTran("web","supplementsandalbendazole",sWebLanguage) %></td>
		</tr>
		<!-- 6-11 mois -->
		<%
			//Calculate rows
			int rows=0;
		if((vaccinations.get("vita100")!=null && checkString(((Vaccination)vaccinations.get("vita100")).date).length()>0 ) || age<12*month) rows++;
			if((vaccinations.get("vita100")!=null && checkString(((Vaccination)vaccinations.get("vita100")).date).length()>0 && age<12*month) || (vaccinations.get("vita100a")!=null && checkString(((Vaccination)vaccinations.get("vita100a")).date).length()>0)) rows++;
			
			if((vaccinations.get("vita100")!=null && checkString(((Vaccination)vaccinations.get("vita100")).date).length()>0 ) || age<12*month){
		%>
		<tr>
			<td class='admin' rowspan='<%=rows*2%>'><%=getTran("web","6to11months",sWebLanguage) %></td>
			<td class='admin2'><%=getTran("web","vitaminea100",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita100","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita100","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita100","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita100","location")%>
		</tr>
		<%
			}
			if((vaccinations.get("vita100")!=null && checkString(((Vaccination)vaccinations.get("vita100")).date).length()>0 && age<12*month) || (vaccinations.get("vita100a")!=null && checkString(((Vaccination)vaccinations.get("vita100a")).date).length()>0)){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","vitaminea100",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita100a","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita100a","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita100a","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita100a","location")%>
		</tr>
	<%
			}
		}
		if(age>=12*month-week){
	%>
		<tr><td colspan='6'><hr/></td></tr>
		<%
			//Calculate rows
			int rows=0;
			int title=0;
			if((vaccinations.get("vita200.1")!=null && checkString(((Vaccination)vaccinations.get("vita200.1")).date).length()>0 ) || age<24*month) {
				rows++;
				title=1;
			}
			if((vaccinations.get("vita200.1")!=null && checkString(((Vaccination)vaccinations.get("vita200.1")).date).length()>0 && age <24*month)|| (vaccinations.get("vita200.1a")!=null && checkString(((Vaccination)vaccinations.get("vita200.1a")).date).length()>0)) {
				rows++;
				if(title==0) title=2;
			}
			if((vaccinations.get("vita200.1a")!=null && checkString(((Vaccination)vaccinations.get("vita200.1a")).date).length()>0 && age <24*month)|| (vaccinations.get("vita200.1b")!=null && checkString(((Vaccination)vaccinations.get("vita200.1b")).date).length()>0)) {
				rows++;
				if(title==0) title=3;
			}
			if((vaccinations.get("alben200.1")!=null && checkString(((Vaccination)vaccinations.get("alben200.1")).date).length()>0 ) || age<24*month) {
				rows++;
				if(title==0) title=4;
			}
			if((vaccinations.get("alben200.1")!=null && checkString(((Vaccination)vaccinations.get("alben200.1")).date).length()>0 && age <24*month)|| (vaccinations.get("alben200.1a")!=null && checkString(((Vaccination)vaccinations.get("alben200.1a")).date).length()>0)) {
				rows++;
				if(title==0) title=5;
			}
			if((vaccinations.get("alben200.1a")!=null && checkString(((Vaccination)vaccinations.get("alben200.1a")).date).length()>0 && age <24*month)|| (vaccinations.get("alben200.1b")!=null && checkString(((Vaccination)vaccinations.get("alben200.1b")).date).length()>0)) {
				rows++;
				if(title==0) title=6;
			}

			if((vaccinations.get("vita200.1")!=null && checkString(((Vaccination)vaccinations.get("vita200.1")).date).length()>0 ) || age<24*month){
		%>
		<!-- 12-23 mois -->
		<tr>
			<td class='admin' rowspan='<%=rows%>'><%=getTran("web","12to23months",sWebLanguage) %></td>
			<td class='admin2'><%=getTran("web","vitaminea200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1","location")%>
		</tr>
		<%
			}
			if((vaccinations.get("vita200.1")!=null && checkString(((Vaccination)vaccinations.get("vita200.1")).date).length()>0 && age <24*month)|| (vaccinations.get("vita200.1a")!=null && checkString(((Vaccination)vaccinations.get("vita200.1a")).date).length()>0)){
		%>
		<tr>
			<%
				if(title==2){
			%>
				<td class='admin' rowspan='<%=rows%>'><%=getTran("web","12to23months",sWebLanguage) %></td>
			<%
				}
			%>
			<td class='admin2'><%=getTran("web","vitaminea200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1a","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1a","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1a","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1a","location")%>
		</tr>
		<%
			}
			if((vaccinations.get("vita200.1a")!=null && checkString(((Vaccination)vaccinations.get("vita200.1a")).date).length()>0 && age <24*month)|| (vaccinations.get("vita200.1b")!=null && checkString(((Vaccination)vaccinations.get("vita200.1b")).date).length()>0)){
		%>
		<tr>
			<%
				if(title==3){
			%>
				<td class='admin' rowspan='<%=rows%>'><%=getTran("web","12to23months",sWebLanguage) %></td>
			<%
				}
			%>
			<td class='admin2'><%=getTran("web","vitaminea200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1b","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1b","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1b","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1b","location")%>
		</tr>
		<%
			}
			if((vaccinations.get("alben200.1")!=null && checkString(((Vaccination)vaccinations.get("alben200.1")).date).length()>0 ) || age<24*month){
		%>
		<tr>
			<%
				if(title==4){
			%>
				<td class='admin' rowspan='<%=rows%>'><%=getTran("web","12to23months",sWebLanguage) %></td>
			<%
				}
			%>
			<td class='admin2'><%=getTran("web","Albendazole200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1","location")%>
		</tr>
		<%
			}
			if((vaccinations.get("alben200.1")!=null && checkString(((Vaccination)vaccinations.get("alben200.1")).date).length()>0 && age <24*month)|| (vaccinations.get("alben200.1a")!=null && checkString(((Vaccination)vaccinations.get("alben200.1a")).date).length()>0)){
		%>
		<tr>
			<%
				if(title==5){
			%>
				<td class='admin' rowspan='<%=rows%>'><%=getTran("web","12to23months",sWebLanguage) %></td>
			<%
				}
			%>
			<td class='admin2'><%=getTran("web","Albendazole200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1a","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1a","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1a","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1a","location")%>
		</tr>
		<%
			}
			if((vaccinations.get("alben200.1a")!=null && checkString(((Vaccination)vaccinations.get("alben200.1a")).date).length()>0 && age <24*month)|| (vaccinations.get("alben200.1b")!=null && checkString(((Vaccination)vaccinations.get("alben200.1b")).date).length()>0)){
		%>
		<tr>
			<%
				if(title==6){
			%>
				<td class='admin' rowspan='<%=rows%>'><%=getTran("web","12to23months",sWebLanguage) %></td>
			<%
				}
			%>
			<td class='admin2'><%=getTran("web","Albendazole200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1b","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1b","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1b","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1b","location")%>
		</tr>
	<%
			}
		}
		if(age>=24*month-week){
	%>
		<tr><td colspan='6'><hr/></td></tr>
		<%
			//Calculate rows
			int rows=2;
			if(vaccinations.get("vita200.2")!=null && checkString(((Vaccination)vaccinations.get("vita200.2")).date).length()>0) rows++;
			if(vaccinations.get("vita200.2a")!=null && checkString(((Vaccination)vaccinations.get("vita200.2a")).date).length()>0) rows++;
			if(vaccinations.get("vita200.2b")!=null && checkString(((Vaccination)vaccinations.get("vita200.2b")).date).length()>0) rows++;
			if(vaccinations.get("vita200.2c")!=null && checkString(((Vaccination)vaccinations.get("vita200.2c")).date).length()>0) rows++;
			if(vaccinations.get("alben400.1")!=null && checkString(((Vaccination)vaccinations.get("alben400.1")).date).length()>0) rows++;
			if(vaccinations.get("alben400.1a")!=null && checkString(((Vaccination)vaccinations.get("alben400.1a")).date).length()>0) rows++;
			if(vaccinations.get("alben400.1b")!=null && checkString(((Vaccination)vaccinations.get("alben400.1b")).date).length()>0) rows++;
			if(vaccinations.get("alben400.1c")!=null && checkString(((Vaccination)vaccinations.get("alben400.1c")).date).length()>0) rows++;
		%>
		<!-- 24-59 mois -->
		<tr>
			<td class='admin' rowspan='<%=rows%>'><%=getTran("web","24to59months",sWebLanguage) %></td>
			<td class='admin2'><%=getTran("web","vitaminea200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2","location")%>
		</tr>
		<%
			if(vaccinations.get("vita200.2")!=null && checkString(((Vaccination)vaccinations.get("vita200.2")).date).length()>0){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","vitaminea200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2a","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2a","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2a","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2a","location")%>
		</tr>
		<%
			}
			if(vaccinations.get("vita200.2a")!=null && checkString(((Vaccination)vaccinations.get("vita200.2a")).date).length()>0){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","vitaminea200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2b","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2b","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2b","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2b","location")%>
		</tr>
		<%
			}
			if(vaccinations.get("vita200.2b")!=null && checkString(((Vaccination)vaccinations.get("vita200.2b")).date).length()>0){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","vitaminea200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2c","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2c","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2c","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2c","location")%>
		</tr>
		<%
			}
			if(vaccinations.get("vita200.2c")!=null && checkString(((Vaccination)vaccinations.get("vita200.2c")).date).length()>0){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","vitaminea200",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2d","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2d","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2d","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2d","location")%>
		</tr>
		<%
			}
		%>
		<tr>
			<td class='admin2'><%=getTran("web","Albendazole400",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1","location")%>
		</tr>
		<%
			if(vaccinations.get("alben400.1")!=null && checkString(((Vaccination)vaccinations.get("alben400.1")).date).length()>0){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","Albendazole400",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1a","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1a","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1a","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1a","location")%>
		</tr>
		<%
			}
			if(vaccinations.get("alben400.1a")!=null && checkString(((Vaccination)vaccinations.get("alben400.1a")).date).length()>0){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","Albendazole400",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1b","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1b","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1b","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1b","location")%>
		</tr>
		<%
			}
			if(vaccinations.get("alben400.1b")!=null && checkString(((Vaccination)vaccinations.get("alben400.1b")).date).length()>0){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","Albendazole400",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1c","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1c","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1c","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1c","location")%>
		</tr>
		<%
			}
			if(vaccinations.get("alben400.1c")!=null && checkString(((Vaccination)vaccinations.get("alben400.1c")).date).length()>0){
		%>
		<tr>
			<td class='admin2'><%=getTran("web","Albendazole400",sWebLanguage) %></td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1d","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1d","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1d","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1d","location")%>
		</tr>
	<%
			}
		}
		if(age>=15*year-month && activePatient.gender.equalsIgnoreCase("f")){
	%>
		<tr><td colspan='6'><hr/></td></tr>
		<tr class='admin'>
			<td colspan='6'><%=getTran("web","supplementsandalbendazole",sWebLanguage) %></td>
		</tr>
		<!-- 15-49 ans -->
		<tr>
			<td class='admin' rowspan='5'><%=getTran("web","15to49years",sWebLanguage) %></td>
			<td class='admin2'><%=getTran("web","VAT",sWebLanguage) %> 1</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vat1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vat1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vat1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vat1","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","VAT",sWebLanguage) %> 2</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vat2","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vat2","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vat2","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vat2","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","VAT",sWebLanguage) %> R1</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr1","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr1","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr1","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr1","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","VAT",sWebLanguage) %> R2</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr2","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr2","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr2","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr2","location")%>
		</tr>
		<tr>
			<td class='admin2'><%=getTran("web","VAT",sWebLanguage) %> R3</td>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr3","date")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr3","batchnumber")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr3","expiry")%>
			<%=Vaccination.getVaccination(vaccinations,age,request,"vatr3","location")%>
		</tr>
	<%
		}
	%>
</table>
<script>
	function editVaccination(type){
		window.location.href='<c:url value="main.do"/>?Page=healthrecord/maliVaccinationEdit.jsp&type='+type;
	}
</script>