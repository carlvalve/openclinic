<%@page import="com.digitalpersona.uareu.Engine.EnrollmentCallback"%>
<%@page import="be.openclinic.finance.*,
                java.util.Vector,
                be.mxs.common.util.io.*,
                be.openclinic.finance.Insurance,org.dom4j.*,org.dom4j.io.*,java.text.*"%>
<%
	DigitalPersona dp = new DigitalPersona();
	dp.EnrollFingerprint();
	if(dp.getEnrollmentFmd()!=null){
		System.out.println("Enrollment FMD count= "+dp.getEnrollmentFmd().getViewCnt());
		System.out.println("Enrollment FMD size= "+dp.getEnrollmentFmd().getData().length);
	}
    
%>