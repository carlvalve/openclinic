<%@page import="be.mxs.common.util.system.*,net.admin.*"%>
<%@page import="be.openclinic.assets.*"%>
<%
	try{
		String serviceid = ScreenHelper.checkString(request.getParameter("serviceid"));
		String serverid = ScreenHelper.checkString(request.getParameter("serverid"));
		System.out.println("Checking out assets for service "+serviceid);
		Asset.checkOutAssetsForService(serviceid,Integer.parseInt(serverid));
		out.println("<OK>");
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>