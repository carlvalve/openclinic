<%@page import="be.mxs.common.util.system.*,net.admin.*"%>
<%@page import="be.openclinic.assets.*"%>
<%
	String serviceid = ScreenHelper.checkString(request.getParameter("serviceid"));
	System.out.println("received upload request for "+serviceid);
	response.setContentType("application/octet-stream");
	ServletOutputStream os = response.getOutputStream();
	byte[] b = Asset.toXmlForServiceUnlocked(serviceid).toString().getBytes();
	for(int n=0; n<b.length; n++){
		if(n%1000==0){
			System.out.print(".");
		}
	    os.write(b[n]);
	}
	System.out.println(".");
	System.out.println("Sent "+b.length+" bytes");
	os.flush();
	os.close();
%>