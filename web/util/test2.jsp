<%@page import="be.openclinic.reporting.*,pe.gob.sis.*"%>
<%
	out.println(SUSALUD.getAffiliationInformation(9966).getNuControlST());
	//out.println(SIS.getAffiliationInformation(9966,"10001").getIdError());
%>