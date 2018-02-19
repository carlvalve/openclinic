<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@ page import="be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %>
<%
	Hashtable objects = MedwanQuery.getInstance().getObjectCache().getObjects();
	out.println("object = "+objects.get("wado."+request.getParameter("id"))+"<br/>");
	Hashtable objectcounts = new Hashtable();
	Enumeration e = objects.keys();
	while(e.hasMoreElements()){
		String key = ((String)e.nextElement());
		if(key.startsWith("wado")){
			out.println(key+"<br/>");
		}
	}
%>