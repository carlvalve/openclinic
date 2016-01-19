<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='action' id='action' value=''/>
	<table width='100%'>
		<tr class='admin'><td colspan='4'><%=getTran("web","printworddocuments",sWebLanguage) %></td></tr>
		<%
			Connection conn = MedwanQuery.getInstance().getAdminConnection();
			PreparedStatement ps = conn.prepareStatement("select name from WordDocuments order by name");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String name=rs.getString("name");
				out.println("<tr><td class='admin'><a href='javascript:printWordDocument(\""+name+"\");'>"+name+"</a>");
			}
			rs.close();
			ps.close();
		%>
	</table>
</form>
<script>
	function printWordDocument(name){
		window.open("<c:url value="/util/printWordDocument.jsp"/>?name="+name);
		window.close();
	}
	window.focus();
</script>
