<%@ page import="java.util.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.adt.Queue" %>
	<!-- table that shows top x tickets in the waiting queue -->
	<table width='100%'>
		<tr>
			<td width='50%'>
				<table width='100%' padding='0' cellspacing='0'>
					<%
						Vector queues = Queue.getActiveQueue(request.getParameter("queueid"));
						for(int n=0;n<queues.size() && n<MedwanQuery.getInstance().getConfigInt("maximumRecentQueueTickets",5);n++){
							Queue queue=(Queue)queues.elementAt(n);
							if(n==0){
								out.println("<tr><td class='green'><font style='vertical-align: top; text-align: left; font-size: 30px;font-weight: bold;'>"+(n>0?"":ScreenHelper.getTranNoLink("web","next",(String)session.getAttribute((String)session.getAttribute("activeProjectTitle")+"WebLanguage")))+"</font></td></tr>");
							}
							out.println("<tr height='100px'><td "+(n>0?"":"class='green'")+" style='vertical-align: middle; text-align: center; font-size: 60px;font-weight: bold;'><font style='vertical-align: middle; text-align: center; font-size: 90px;font-weight: bold;'>"+queue.getObjectid()+"</font></td></tr>");
						}
					%>
				</table>
			</td>
			<td width='50%' valign='top'>
				<table width='100%' padding='0' cellspacing='0'>
					<%
						if(queues.size()>MedwanQuery.getInstance().getConfigInt("maximumRecentQueueTickets",5)){
							for(int n=MedwanQuery.getInstance().getConfigInt("maximumRecentQueueTickets",5);n<queues.size();n++){
								Queue queue=(Queue)queues.elementAt(n);
								out.println("<tr height='20px'><td style='vertical-align: top; text-align: center; font-size: 20px;font-weight: bold;'><font style='vertical-align: top; text-align: center; font-size: 20px;font-weight: bold;'>"+queue.getObjectid()+"</font></td></tr>");
							}
						}
					%>
				</table>
			</td>
		<tr>
	</table>
