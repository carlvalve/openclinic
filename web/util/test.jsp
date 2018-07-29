<%@page import="be.openclinic.reporting.*,java.util.*,org.apache.http.util.*,java.text.SimpleDateFormat,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,org.apache.http.client.methods.*"%>
<%@page import="pe.gob.susalud.jr.transaccion.susalud.bean.*,org.dom4j.*,be.mxs.common.util.system.*"%>
<%@page import="pe.gob.susalud.jr.transaccion.susalud.service.*"%>
<%@page import="pe.gob.susalud.jr.transaccion.susalud.util.*,org.apache.http.impl.client.*,org.apache.http.message.*,org.apache.http.client.entity.*,org.apache.http.entity.mime.*,org.apache.http.*,org.apache.http.entity.*"%>
<%
	InConNom271 insuranceData = SUSALUD.getAffiliationInformation(9966);
	if(ScreenHelper.checkString(insuranceData.getNuControl()).equalsIgnoreCase("99")){
		System.out.println("Error = "+insuranceData.getNuControlST());
	}
	

%>