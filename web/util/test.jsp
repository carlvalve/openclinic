<%@page import="ocdhis2.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	try{
		DHIS2Exporter exporter = new DHIS2Exporter();
		exporter.setBegin(new SimpleDateFormat("dd/MM/yyyy").parse("01/04/2015"));
		exporter.setEnd(new SimpleDateFormat("dd/MM/yyyy").parse("01/05/2017"));
		exporter.setDhis2document(MedwanQuery.getInstance().getConfigString("dhis2document","c:/projects/openclinicnew/web/_common/xml/dhis2.bi.xml"));
		exporter.setLanguage(sWebLanguage);
		if(exporter.export("html")){
			out.println(exporter.getHtml());
		}
		else{
			out.println("Error!");
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>