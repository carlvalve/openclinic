<%@page import="be.mxs.common.util.system.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String country=request.getParameter("country");
	String os=request.getParameter("os");
	String database=request.getParameter("database");
	String admindb=request.getParameter("admindb");
	String openclinicdb=request.getParameter("openclinicdb");
	boolean bUpdateDb=request.getParameter("updatedb")!=null;
	if(admindb!=null){
		if(!admindb.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("admindbName", "ocadmin_dbo"))){
			bUpdateDb=true;
			MedwanQuery.getInstance().setConfigString("admindbName", admindb);
		}
	}
	if(openclinicdb!=null){
		if(!openclinicdb.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("openclinicdbName", "openclinic_dbo"))){
			bUpdateDb=true;
			MedwanQuery.getInstance().setConfigString("openclinicdbName", openclinicdb);
		}
	}
	if(country==null) country=MedwanQuery.getInstance().getConfigString("setup.country","");
	if(os==null) os=MedwanQuery.getInstance().getConfigString("setup.os","");
	if(database==null) database=MedwanQuery.getInstance().getConfigString("setup.database","");
	if(request.getParameter("update")!=null){		
        UpdateSystem systemUpdate = new UpdateSystem();
        
        systemUpdate.updateSetup("country",country,request);
        systemUpdate.updateSetup("os",os,request);
        systemUpdate.updateSetup("database",database,request);
		if(bUpdateDb){
			systemUpdate.updateDb();
		}
		if(request.getParameter("updatelabels")!=null){
			systemUpdate.updateLabels(sAPPFULLDIR);
		}
		if(checkString(request.getParameter("project")).length()>0){
			systemUpdate.updateProject(request.getParameter("project"));
		}
		MedwanQuery.getInstance().reloadConfigValues();
		MedwanQuery.getInstance().reloadLabels();
		
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select value from Items where itemid=(select min(itemid) from Items)");
		ResultSet rs = ps.executeQuery();
		int oldSize=rs.getMetaData().getColumnDisplaySize(1);
		int newSize=Integer.parseInt(request.getParameter("itemvaluesize"));
		if(oldSize!=newSize){
			String server = conn.getMetaData().getDatabaseProductName();
			String sQuery1="alter table Items modify column value varchar("+newSize+")";
			String sQuery2="alter table ItemsHistory modify column value varchar("+newSize+")";
			if(!server.startsWith("MySQL")){
				sQuery1="alter table Items alter column value varchar("+newSize+")";
				sQuery2="alter table ItemsHistory alter column value varchar("+newSize+")";
			}
			rs.close();
			ps.close();
			ps = conn.prepareStatement(sQuery1);
			ps.execute();
			ps.close();
			ps = conn.prepareStatement(sQuery2);
			ps.execute();
		}
		else{
			rs.close();
		}
		ps.close();
		conn.close();
	}
%>

<form name='resetDefaults' method='post'>
	<table class="list" cellpadding="0" cellspacing="1" width="100%"> 
		<tr class='admin'><td colspan='2'><%=getTran("web","configure.core",sWebLanguage)%>&nbsp</td></tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","country",sWebLanguage)%></td>
			<td class='admin2'>
				<select name='country' id='country' class='text'>
					<option value=''></option>
					<option value='be' <%="be".equals(country)?"selected":""%>><%=getTran("country","be",sWebLanguage).toUpperCase() %></option>
					<option value='rw' <%="rw".equals(country)?"selected":""%>><%=getTran("country","rw",sWebLanguage).toUpperCase() %></option>
					<option value='bi' <%="bi".equals(country)?"selected":""%>><%=getTran("country","bi",sWebLanguage).toUpperCase() %></option>
					<option value='ml' <%="ml".equals(country)?"selected":""%>><%=getTran("country","ml",sWebLanguage).toUpperCase() %></option>
					<option value='cd' <%="cd".equals(country)?"selected":""%>><%=getTran("country","cd",sWebLanguage).toUpperCase() %></option>
					<option value='ci' <%="ci".equals(country)?"selected":""%>><%=getTran("country","ci",sWebLanguage).toUpperCase() %></option>
					<option value='cm' <%="cm".equals(country)?"selected":""%>><%=getTran("country","cm",sWebLanguage).toUpperCase() %></option>
					<option value='cg' <%="cg".equals(country)?"selected":""%>><%=getTran("country","cg",sWebLanguage).toUpperCase() %></option>
					<option value='al' <%="al".equals(country)?"selected":""%>><%=getTran("country","al",sWebLanguage).toUpperCase() %></option>
					<option value='tz' <%="tz".equals(country)?"selected":""%>><%=getTran("country","tz",sWebLanguage).toUpperCase() %></option>
					<option value='br' <%="br".equals(country)?"selected":""%>><%=getTran("country","br",sWebLanguage).toUpperCase() %></option>
					<option value='ke' <%="ke".equals(country)?"selected":""%>><%=getTran("country","ke",sWebLanguage).toUpperCase() %></option>
					<option value='ug' <%="ug".equals(country)?"selected":""%>><%=getTran("country","ug",sWebLanguage).toUpperCase() %></option>
					<option value='bd' <%="bd".equals(country)?"selected":""%>><%=getTran("country","bd",sWebLanguage).toUpperCase() %></option>
					<option value='lk' <%="lk".equals(country)?"selected":""%>><%=getTran("country","lk",sWebLanguage).toUpperCase() %></option>
					<option value='zm' <%="zm".equals(country)?"selected":""%>><%=getTran("country","zm",sWebLanguage).toUpperCase() %></option>
					<option value='ng' <%="ng".equals(country)?"selected":""%>><%=getTran("country","ng",sWebLanguage).toUpperCase() %></option>
					<option value='ga' <%="ga".equals(country)?"selected":""%>><%=getTran("country","ga",sWebLanguage).toUpperCase() %></option>
					<option value='sn' <%="sn".equals(country)?"selected":""%>><%=getTran("country","sn",sWebLanguage).toUpperCase() %></option>
					<option value='et' <%="et".equals(country)?"selected":""%>><%=getTran("country","et",sWebLanguage).toUpperCase() %></option>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","os",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<%
					String detectedos=System.getProperty("os.name").toLowerCase();
					if(detectedos.contains("windows")){
						detectedos="windows";
					}
					else if(detectedos.contains("linux")){
						detectedos="linux";
					}
					else if(detectedos.contains("solaris")){
						detectedos="solaris";
					}
					else if(detectedos.contains("mac")){
						detectedos="mac";
					}
				%>
			
				<select name='os' class='text'>
					<option value=''></option>
					<option value='linux' <%="mac".equals(detectedos)?"selected":""%>><%=getTran("web","mac",sWebLanguage).toUpperCase() %></option>
					<option value='linux' <%="solaris".equals(detectedos)?"selected":""%>><%=getTran("web","solaris",sWebLanguage).toUpperCase() %></option>
					<option value='linux' <%="linux".equals(detectedos)?"selected":""%>><%=getTran("web","linux",sWebLanguage).toUpperCase() %></option>
					<option value='windows' <%="windows".equals(detectedos)?"selected":""%>><%=getTran("web","windows",sWebLanguage).toUpperCase() %></option>
				</select>
				<%
					if(!detectedos.equals(os)){
				%>
				<font color="red"><img src="<c:url value="_img/icons/icon_warning.gif"/>"/> <%=getTran("web","wrong.os",sWebLanguage)+": "+os %></font>
				<%
					}
				%>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","databaseserver",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<%
					//Autodetect database
					Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			        String detecteddatabase = conn.getMetaData().getDatabaseProductName().toLowerCase();
				%>
				<select name='database' class='text'>
					<option value=''></option>
					<option value='mysql' <%="mysql".equals(detecteddatabase)?"selected":""%>><%=getTran("web","mysql",sWebLanguage).toUpperCase() %></option>
					<option value='sqlserver' <%=detecteddatabase.replaceAll(" ", "").contains("sqlserver")?"selected":""%>><%=getTran("web","sqlserver",sWebLanguage).toUpperCase() %></option>
				</select>
				<%
					if(!detecteddatabase.replaceAll(" ", "").contains(database)){
				%>
				<font color="red"><img src="<c:url value="_img/icons/icon_warning.gif"/>"/> <%=getTran("web","wrong.database",sWebLanguage)+": "+database+" (<> "+detecteddatabase+")" %></font>
				<%
					}
				%>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","project",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='text' name='project' id='project' value='<%=MedwanQuery.getInstance().getConfigString("defaultProject","openclinic")%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","updatelabels",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='checkbox' name='updatelabels' id='undatelabels'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","updatedatabase",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='checkbox' name='updatedb' id='undatedb'/>
			</td>
		</tr>
		<tr>
			<%
				PreparedStatement ps = conn.prepareStatement("select value from Items where itemid=(select min(itemid) from Items)");
				ResultSet rs = ps.executeQuery();
				int nSize=rs.getMetaData().getColumnDisplaySize(1);
				rs.close();
				ps.close();
				conn.close();
			%>
			<td class='admin'><%=getTran("web","itemvaluesize",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<select name='itemvaluesize' id ='itemvaluesize'>
					<option value='255' <%=nSize==255?"selected":"" %>>255</option>
					<option value='1000' <%=nSize==1000?"selected":"" %>>1000</option>
					<option value='3000' <%=nSize==3000?"selected":"" %>>3000</option>
					<option value='5000' <%=nSize==5000?"selected":"" %>>5000</option>
				</select>
			</td>
		</tr>
		<tr>
			<%
				String detectedadmindb=MedwanQuery.getInstance().getAdminConnection().getCatalog();
			%>
			<td class='admin'><%=getTran("web","admindb",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='text' name='admindb' id='admindb' value='<%=detectedadmindb%>'/>
				<%
					if(!detectedadmindb.equals(MedwanQuery.getInstance().getConfigString("admindbName","openclinic_dbo"))){
				%>
				<font color="red"><img src="<c:url value="_img/icons/icon_warning.gif"/>"/> <%=getTran("web","wrong.openclinicdb",sWebLanguage)+": <b>"+MedwanQuery.getInstance().getConfigString("admindbName","openclinic_dbo") %></b></font>
				<%
					}
				%>
			</td>
		</tr>
		<tr>
			<%
				String detectedopenclinicdb=MedwanQuery.getInstance().getOpenclinicConnection().getCatalog();
			%>
			<td class='admin'><%=getTran("web","openclinicdb",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='text' name='openclinicdb' id='openclinicdb' value='<%=detectedopenclinicdb%>'/>
				<%
					if(!detectedopenclinicdb.equals(MedwanQuery.getInstance().getConfigString("openclinicdbName","openclinic_dbo"))){
				%>
				<font color="red"><img src="<c:url value="_img/icons/icon_warning.gif"/>"/> <%=getTran("web","wrong.openclinicdb",sWebLanguage)+": <b>"+MedwanQuery.getInstance().getConfigString("openclinicdbName","openclinic_dbo") %></b></font>
				<%
					}
				%>
			</td>
		</tr>
	</table>
	
	<%=ScreenHelper.alignButtonsStart()%>
	    <input class='button' type = 'submit' name='update' value='<%=getTranNoLink("web","update",sWebLanguage)%>'/>
	<%=ScreenHelper.alignButtonsStop()%>
</form>

<script>
function sortlist(list) {
	var lb = document.getElementById(list);
	arrTexts = new Array();
	arrValues = new Array();
	
	for(i=0; i<lb.length; i++)  {
		  arrTexts[i] = lb.options[i].text+";"+lb.options[i].value;
	}
	
	arrTexts.sort();
	
	for(i=0; i<lb.length; i++)  {
	  lb.options[i].text = arrTexts[i].split(";")[0];
	  lb.options[i].value = arrTexts[i].split(";")[1];
	  if(lb.options[i].value=='<%=country%>'){
		  lb.options.selectedIndex=i;
	  }
	}
}

sortlist('country');
</script>