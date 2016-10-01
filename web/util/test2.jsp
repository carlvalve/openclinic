<%@page import="be.mxs.common.util.db.MedwanQuery,java.sql.*"%>
<%
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn =  DriverManager.getConnection("jdbc:sqlserver://192.168.6.100:1433;databaseName=openclinic;user=sa;password=qwerty$1234");
	PreparedStatement ps = conn.prepareStatement("select count(*) total from oc_debets");
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		System.out.println("records: "+rs.getInt("total"));
	}
	rs.close();
	ps.close();
	conn.close();
	System.out.println("OK");
%>
OK