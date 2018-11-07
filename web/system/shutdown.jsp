<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	try{
		org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(MedwanQuery.getInstance().getConfigString("shutdown.semaphore","/backups/doshutdown")), "ok");
	}
	catch(Exception e){
		e.printStackTrace();
	}
	if(request.getParameter("os_shutdown")!=null){
		out.println("<h4>"+getTran(request,"web","system.shutdown",sWebLanguage)+"...</H4>");
		out.flush();
		ProcessBuilder pb = new ProcessBuilder(MedwanQuery.getInstance().getConfigString("shutdownScript","/sbin/shutdown"));
		pb.redirectErrorStream(true); 
		Process p = pb.start();
	}
	else if(request.getParameter("os_reboot")!=null){
		out.println("<h4>"+getTran(request,"web","system.reboot",sWebLanguage)+"...</H4>");
		out.flush();
		ProcessBuilder pb = new ProcessBuilder(MedwanQuery.getInstance().getConfigString("rebootScript","/sbin/reboot"));
		pb.redirectErrorStream(true); 
		Process p = pb.start();
	}
	else{
%>
		<form name='transactionForm' method='post'>
			<table width='100%'>
				<tr class='admin'><td colspan='2'><%=getTran(request,"web","system.shutdown",sWebLanguage) %></td></tr>
				<tr>
				<%
					if(activeUser.getAccessRightNoSA("system.shutdown.select")){
				%>
					<td class='admin2'><input type='submit' class='button' name='os_shutdown' value='<%=getTranNoLink("web","shutdown",sWebLanguage)%>'/></td>
				<%
					}
					else{
						out.println("<td/>");
					}
					if(activeUser.getAccessRightNoSA("system.reboot.select")){
				%>
					<td class='admin2'><input type='submit' class='button' name='os_reboot' value='<%=getTranNoLink("web","reboot",sWebLanguage)%>'/></td>
				<%
					}
					else{
						out.println("<td/>");
					}
				%>
				</tr>
			</table>
		</form>
<%
	}
%>