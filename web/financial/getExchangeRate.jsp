<%@page import="be.mxs.common.util.system.ScreenHelper"%>
<%@page import="be.mxs.common.util.io.ExportSAP_AR_INV"%>
<%
	double er = ExportSAP_AR_INV.getExchangeRate(request.getParameter("currency"), ScreenHelper.getSQLDate(request.getParameter("date")),false);
	out.println(er==-1?"":er);
%>