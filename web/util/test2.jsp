<%@page import="java.util.Iterator"%>
<%@page import="org.dom4j.*"%>
<%@page import="org.dom4j.io.SAXReader"%>
<%@page import="java.io.File"%>
<%@page import="be.mxs.common.util.db.MedwanQuery,java.sql.*"%>
<%
	SAXReader reader = new SAXReader(false);
	Document document= reader.read(new File("c:/tmp/dhis2/dataelements.xml"));
	Element root = document.getRootElement();
	Element dataElements =root.element("dataElements");
	Iterator i = dataElements.elementIterator("dataElement");
	while(i.hasNext()){
		Element dataElement = (Element)i.next();
		out.println("<dataelement code='"+dataElement.element("displayName").getText().split(" ")[1].replaceAll("cas-", "")+"' uid='"+dataElement.attributeValue("id")+"'/>");
	}

%>