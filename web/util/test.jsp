<%@ page import="be.mxs.common.util.io.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%
	out.println("solar system = "+GoogleTranslate.translate(MedwanQuery.getInstance().getConfigString("googleTranslateKey","AIzaSyAPk18gciaKdwl3Z2rmFSog4ZwBbmfhByg"), "en", "es", "solar system"));
%>