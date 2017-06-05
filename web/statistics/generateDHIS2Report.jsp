<%@page import="ocdhis2.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	try{
		long day = 24*3600*1000;
		long month=30*day;
		DHIS2Exporter exporter = new DHIS2Exporter();
		String format = checkString(request.getParameter("format"));
		exporter.setBegin(new SimpleDateFormat("yyyyMMdd").parse(request.getParameter("period")+"01"));
		exporter.setEnd(new SimpleDateFormat("yyyyMMdd").parse(new SimpleDateFormat("yyyyMM").format(new java.util.Date(exporter.getBegin().getTime()+month))+"01"));
		exporter.setDhis2document(MedwanQuery.getInstance().getConfigString("dhis2document","c:/projects/openclinicnew/web/_common/xml/dhis2.bi.xml"));
		exporter.setLanguage(sWebLanguage);
		if(format.equalsIgnoreCase("html") && exporter.export("html")){
			out.println(exporter.getHtml());
		}
		else if(format.equalsIgnoreCase("dhis2server") && exporter.export("dhis2server")){
			out.println("Success!");
		}
		else{
			out.println("Error!");
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>