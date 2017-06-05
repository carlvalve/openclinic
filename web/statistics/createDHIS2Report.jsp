<%@page import="ocdhis2.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","dhis2report",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","period",sWebLanguage) %></td>
			<td class='admin2'>
				<select name='period' id='period' class='text'>
					<%
						long day = 24*3600*1000;
						long month=30*day;
						java.util.Date activeMonth = new SimpleDateFormat("dd/MM/yyyy").parse(new SimpleDateFormat("15/MM/yyyy").format(new java.util.Date()));
						for(int n=1;n<13;n++){
							activeMonth=new java.util.Date(activeMonth.getTime()-month);
							out.println("<option value='"+new SimpleDateFormat("yyyyMM").format(activeMonth)+"'>"+new SimpleDateFormat("yyyyMM").format(activeMonth)+"</option>");
						}
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","format",sWebLanguage) %></td>
			<td class='admin2'>
				<select name='format' id='format' class='text'>
					<option value='html'>HTML</option>
					<option value='dhis2server'><%=getTranNoLink("web","dhis2server",sWebLanguage) %></option>
					<option value='html'>CSV</option>
				</select>
			</td>
		</tr>
	</table>
	<input type='button' class='button' name='execute' value='<%=getTranNoLink("web","execute",sWebLanguage) %>' onclick='executeReport()'/>
</form>

<script>
	function executeReport(){
	      var URL="/statistics/generateDHIS2Report.jsp&period="+document.getElementById("period").value+"&format="+document.getElementById("format").value;
			openPopup(URL,800,600,"OpenClinic-DHIS2");
	}
</script>