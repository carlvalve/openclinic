<%@page import="be.mxs.common.util.io.ExportSAP_AR_INV"%>
<%
	out.println(ExportSAP_AR_INV.getExchangeRate("USD", new java.util.Date()));
%>