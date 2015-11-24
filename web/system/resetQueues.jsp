<%@ page import="be.openclinic.adt.Queue" %>
<%@include file="/includes/validateUser.jsp"%>

<form name='transactionForm' method='post'>
	<table>
		<tr>
			<td class='admin'>
				<select name='queueendreason' class='text'>
					<%=ScreenHelper.writeSelect("queueendreason",MedwanQuery.getInstance().getConfigString("defaultResetQueueEndReason","99"),sWebLanguage) %>
				</select>
				<input class='button' type='submit' name='resetqueue' value='<%=getTran("web","reset",sWebLanguage) %>'/>
			</td>
		</tr>
	</table>
</form>

<%
	if(request.getParameter("resetqueue")!=null){
		Queue.resetQueues(request.getParameter("queueendreason"),Integer.parseInt(activeUser.userid));
		out.println(getTran("web","queueshavebeenreset",sWebLanguage));
	}
%>