<%@page import="be.openclinic.assets.Asset,
               java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../assets/includes/commonFunctions.jsp"%>
<%
	String componentuid = checkString(request.getParameter("componentuid"));
	System.out.println("deleting"+componentuid);
	String assetuid=componentuid.split("\\.")[0]+"."+componentuid.split("\\.")[1];
	String nomenclature = componentuid.replaceAll(assetuid+".", "");
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_assetcomponents where oc_component_assetuid=? and oc_component_nomenclature=?");
	ps.setString(1, assetuid);
	ps.setString(2, nomenclature);
	ps.execute();
	ps.close();
%>
