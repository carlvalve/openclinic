<%@ page import="be.openclinic.adt.Queue" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	if(request.getParameter("queue")!=null){
		if(request.getParameter("addqueue")!=null){
			session.setAttribute("activequeue", request.getParameter("queue"));
			if(!Queue.activePatientQueueExists(request.getParameter("queue"), activePatient.personid)){
				Queue queue = new Queue();
				queue.setId(request.getParameter("queue"));
				queue.setBegin(new java.util.Date());
				queue.setBeginuid(activeUser.userid);
				queue.setSubjecttype("patient");
				queue.setSubjectuid(activePatient.personid);
				queue.store();
			}
			else {
				out.println("<script>alert('"+getTranNoLink("web","activepatientqueueexistsfor",sWebLanguage)+" ["+getTran("queue",request.getParameter("queue"),sWebLanguage)+"]')</script>");
			}
		}
		Enumeration pars = request.getParameterNames();
		while(pars.hasMoreElements()){
			String parname = (String)pars.nextElement();
			if(parname.startsWith("queueendbutton.")){
				Queue queue = Queue.get(Integer.parseInt(parname.split("\\.")[1]));
				if(queue!=null){
					queue.setEnd(new java.util.Date());
					queue.setEnduid(activeUser.userid);
					queue.setEndreason(request.getParameter(parname.replaceAll("queueendbutton", "queueendreason")));
					queue.store();
				}
			}
		}
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran("web","activequeues",sWebLanguage) %></td>
			<td colspan='3'>
				<select class='text' name='queue' id='queue'>
					<%=ScreenHelper.writeSelect("queue", checkString((String)session.getAttribute("activequeue")), sWebLanguage) %>
				</select>
				<input class='button' type='submit' name='addqueue' value='<%=getTran("web","add",sWebLanguage) %>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","name",sWebLanguage) %></td>
			<td class='admin'><%=getTran("web","number",sWebLanguage) %></td>
			<td class='admin'><%=getTran("web","since",sWebLanguage) %></td>
			<td class='admin'><%=getTran("web","username",sWebLanguage) %></td>
			<td class='admin'><%=getTran("web","action",sWebLanguage) %></td>
		</tr>
		<%
			Vector queues = Queue.getActivePatientQueues(activePatient.personid);
			for(int n=0;n<queues.size();n++){
				Queue queue =(Queue)queues.elementAt(n);
				%>
				<tr height='20px'>
					<td class='menuItemGreen'><%=getTran("queue",queue.getId(),sWebLanguage)%></td>
					<td class='admin2'><%=queue.getTicketnumber()%></td>
					<td class='admin2'><%=ScreenHelper.formatDate(queue.getBegin(),new SimpleDateFormat("dd/MM/yyyy HH:mm"))%></td>
					<td class='admin2'><%=User.getFullUserName(queue.getBeginuid())%></td>
					<td class='admin2'>
						<select name='queueendreason.<%=queue.getObjectid()%>'>
							<%=ScreenHelper.writeSelect("queueendreason",MedwanQuery.getInstance().getConfigString("defaultQueueEndReason","1"),sWebLanguage) %>
						</select>
						<input class='button' type='submit' name='queueendbutton.<%=queue.getObjectid()%>' value='<%=getTranNoLink("web","close",sWebLanguage) %>'/>
						<input class='button' type='button' value='<%=getTranNoLink("web","print",sWebLanguage) %>' onclick='printticket(<%=queue.getObjectid()%>)'/>
					</td>
				</tr>
				<%
			}
			if(queues.size()==0){
				out.println("<tr><td colspan='5'>"+getTran("web","none",sWebLanguage)+"</td></tr>");
			}
			out.println("<tr ><td colspan='5'><input type='checkbox' "+(request.getParameter("showpassive")==null?"":"checked")+" class='text' name='showpassive' onchange='transactionForm.submit();'>"+getTran("web","showclosedtickets",sWebLanguage)+"</td></tr>");
			if(request.getParameter("showpassive")!=null){
				%>
				<tr>
					<td class='admin'><%=getTran("web","name",sWebLanguage) %></td>
					<td class='admin'><%=getTran("web","begin",sWebLanguage) %></td>
					<td class='admin'><%=getTran("web","end",sWebLanguage) %></td>
					<td class='admin'><%=getTran("web","waitingduration",sWebLanguage) %></td>
					<td class='admin'><%=getTran("web","action",sWebLanguage) %></td>
				</tr>
				<%
				queues = Queue.getPassivePatientQueues(activePatient.personid);
				for(int n=0;n<queues.size();n++){
					Queue queue =(Queue)queues.elementAt(n);
					long millis=queue.getEnd().getTime()-queue.getBegin().getTime();
					long second = (millis / 1000) % 60;
					long minute = (millis / (1000 * 60)) % 60;
					long hour = (millis / (1000 * 60 * 60)) % 24;
					String time = String.format("%02d:%02d:%02d", hour, minute, second);
					%>
					<tr height='20px'>
						<td class='admin2'><%=getTran("queue",queue.getId(),sWebLanguage)%></td>
						<td class='admin2'><%=ScreenHelper.formatDate(queue.getBegin(),new SimpleDateFormat("dd/MM/yyyy HH:mm"))%></td>
						<td class='admin2'><%=ScreenHelper.formatDate(queue.getEnd(),new SimpleDateFormat("dd/MM/yyyy HH:mm"))%></td>
						<td class='admin2'>
							<%=time%>
						</td>
						<td class='admin2'><%=getTran("queueendreason",queue.getEndreason(),sWebLanguage) %></td>
					</tr>
					<%
				}
				
			}
		%>
	</table>
</form>

<script>
	function printticket(objectid){
        var url = "<c:url value='/util/createTicketPdf.jsp'/>?objectid="+objectid+"&ts=<%=getTs()%>&PrintLanguage=<%=sWebLanguage%>";
        window.open(url,"TicketPdf<%=new java.util.Date().getTime()%>","height=300,width=400,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
	}
</script>