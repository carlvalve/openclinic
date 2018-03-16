<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@ page import="be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %>
<%
	SAXReader reader = new SAXReader(false);
	Document document = reader.read(new URL("file:///c:/tmp/dataElements.xml"));
	Element root = document.getRootElement();
	Iterator dataelements = root.element("dataElements").elementIterator("dataElement");
	while(dataelements.hasNext()){
		Element dataelement = (Element)dataelements.next();
		out.println("<dataelement code='"+dataelement.element("displayName").getText().replaceAll("2017-Nb deces-","").split(" ")[0] +"' uid='"+dataelement.attributeValue("id")+"'/>");
	}

%>