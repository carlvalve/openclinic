<%@page import="be.mxs.common.util.db.MedwanQuery"%>

<%
	if(request.getParameter("veld")!=null){
		out.println("<script>alert('veld="+request.getParameter("veld")+"');</script>");
	}
%>
<h1>welkom <%=new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></h1>

<input type='text' name='veld' id='veld' value=''/>
<input type='button' value='click me' onclick='loadpage();'/>

<%
	java.sql.Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	java.sql.PreparedStatement statement = conn.prepareStatement("select * from oc_config");
	java.sql.ResultSet rs = statement.executeQuery();
	while(rs.next()){
		out.println(rs.getString("oc_key")+"="+rs.getString("oc_value")+"<br/>");
	}
	rs.close();
	statement.close();
	conn.close();
%>

<script>
	function loadpage(){
		window.location.href='test.jsp?veld='+document.getElementById('veld').value;
	}
</script>