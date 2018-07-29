<%@page import="be.openclinic.knowledge.*"%>
<%
	double zindex=Growth.getZScore(Double.parseDouble(request.getParameter("height")), Double.parseDouble(request.getParameter("weight")), request.getParameter("gender"));
%>
{
"zindex":"<%=zindex%>"
}