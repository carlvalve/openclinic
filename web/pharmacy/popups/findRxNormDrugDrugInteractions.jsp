<%@ page import="be.openclinic.pharmacy.*,java.io.*,org.dom4j.*,org.dom4j.io.*,sun.misc.*,be.mxs.common.util.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.finance.*,net.admin.*,java.util.*,java.text.*,be.openclinic.adt.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<form name="transactionForm" method="post">
	<%
		if(checkString(request.getParameter("key")).length()>0){
	%>
	<input type='text' class='text' size='80' name='key' value='<%=checkString(request.getParameter("key"))%>'/>
	<input type='submit' name='submit' value='<%=getTran("web","find",sWebLanguage) %>'/>
	<%
		}
	%>	
	<table width="100%">
		<tr class='admin'>
			<td width='25%'><%=getTran("web","drugnames",sWebLanguage) %></td>
			<td><%=getTran("web","interaction",sWebLanguage) %></td>
		</tr>
	<%
		
  		SortedMap codes=null;
		if(checkString(request.getParameter("key")).length()>0){
			String key=checkString(request.getParameter("key"));
			while(key.indexOf(";;")>-1){
				key=key.replaceAll(";;",";");
			}
			key=key.replaceAll(";", "+");
			codes=Utils.getDrugDrugInteractions(key);
		}
		else {
			codes=Utils.getPatientDrugDrugInteractions(activePatient.personid);
		}
		Iterator i = codes.keySet().iterator();
		int counter=0;
		while(i.hasNext()){
			String drugcodes=(String)i.next();
			String code = (String)codes.get(drugcodes);
			%>
			<tr>
				<td class='admin'><%=code.split(";")[0]%></td>
				<td class='admin2' valign='top'><%=code.split(";")[1]%></td>
			</tr>
			
			<%	
			counter++;
		}
		if(counter==0){
		%>
			<tr>
			<td class='admin' colspan="2"><%= getTran("web","no_known_interactions",sWebLanguage)%></td>
		</tr>
		<%
		}
	%>
	</table>
</form>

<script>
	function copyData(){
		var codes="";
		for(n=0;n<document.all.length;n++){
			if(document.all[n].name && document.all[n].name.startsWith("chkrxnorm") && document.all[n].checked){
				if(codes.length>0){
					codes=codes+";";
				}
				codes=codes+document.all[n].id;
			}
		}		
		window.opener.<%=request.getParameter("returnField")%>.value=codes;
		window.close();
	}
</script>