<%@page import="be.openclinic.datacenter.*" %>
<%@ page import="be.mxs.common.util.system.HTMLEntities" %>
<%@ page import="java.util.Date" %>
<%@include file="/includes/validateUser.jsp"%>
<%
	int serverId=Integer.parseInt(request.getParameter("serverid"));
	String code=request.getParameter("code"); //ceci repr�sente le code du morceau � sortir de la graphique
	String period=request.getParameter("period");
	java.util.Vector financials = DatacenterHelper.getFinancials(serverId,period);
	for(int n=0;n<financials.size();n++){
		String financial=(String)financials.elementAt(n);
		String cls = financial.split(";")[0].toUpperCase(); //code/libell� de l'�l�ment
		if(cls==null || cls.length()==0){
			cls="?";
		}
		double amount=Double.parseDouble(financial.split(";")[1]); //montant de l'�l�ment
	}

%>