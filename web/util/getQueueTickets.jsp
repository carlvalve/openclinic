<%@include file="/includes/helper.jsp"%>
<%@ page import="java.util.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.adt.Queue,net.admin.*" %>

<%
	if(request.getParameter("queueid")!=null){
		session.setAttribute("activequeue", request.getParameter("queueid"));
	}

%>
	<!-- table that shows top x tickets in the waiting queue -->
	<table width='100%' cellpadding='0' cellspacing='0'>
		<tr>
			<td width='50%'>
				<table width='100%' padding='0' cellspacing='0'>
					<%
						int counter = 0;
						long interval = MedwanQuery.getInstance().getConfigInt("queuestats.median."+request.getParameter("queueid"),0);
						Vector queues = Queue.getActiveQueue(request.getParameter("queueid"));
						for(int n=0;n<queues.size() && n<MedwanQuery.getInstance().getConfigInt("maximumRecentQueueTickets",5);n++){
							Queue queue=(Queue)queues.elementAt(n);
							if(n==0){
								out.println("<tr><td class='green' colspan='2'><font style='vertical-align: top; text-align: left; font-size: 30px;font-weight: bold;'>"+
											(n>0?"":ScreenHelper.getTranNoLink("web","next",(String)session.getAttribute((String)session.getAttribute("activeProjectTitle")+"WebLanguage")))+
											"</font></td></tr>");
							}
							String personname="?";
							AdminPerson person = AdminPerson.getAdminPerson(queue.getSubjectuid());
							if(person!=null){
								personname=person.getFullName();
							}
							if("1".equals(((String)session.getAttribute("showWaitingQueuePatientName")))){
								out.println("<tr height='86px'><td colspan='2' "+(n>0?"":"class='green'")+
									    " style='vertical-align: middle; text-align: center; font-size: 60px;font-weight: bold;'>"+
										"<font style='vertical-align: middle; text-align: center; font-size: 76px;font-weight: bold;'>"+queue.getTicketnumber()+"</font></td></tr>");
									    out.println("<tr x²height='14px'><td "+(n>0?"":"class='green'")+" style='vertical-align: middle; text-align: left; font-size: 14px;font-weight: bold;'>");
									    out.println("<a style='vertical-align: middle; text-align: center; font-size: 14px;font-weight: bold;color: darkblue' href='javascript:loadparent("+queue.getSubjectuid()+");'>"+personname+"</a>");
									    out.println(" <img onclick='registerseen("+queue.getObjectid()+","+queue.getTicketnumber()+")' height='12' src='"+sCONTEXTPATH+"/_img/icons/icon_eye.png'/>");
									    out.println(" <img onclick='registeraway("+queue.getObjectid()+","+queue.getTicketnumber()+")' height='12' src='"+sCONTEXTPATH+"/_img/icons/icon_run.png'/></td><td "+(n>0?"":"class='green'")+" style='vertical-align: middle; text-align: right; font-size: 14px;font-weight: bold;font-style:italic;'>");
									    if(interval>0){
									    	out.println(""+new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+counter*interval)));
									    }
									    out.println("</td></tr>"); 
								out.println("</td></tr>");
							}
							else {
								out.println("<tr height='"+(interval>0?86:100)+"px'><td "+(n>0?"":"class='green'")+
									    " style='vertical-align: middle; text-align: center; font-size: 60px;font-weight: bold;'>"+
										"<font style='vertical-align: middle; text-align: center; font-size: "+(interval>0?76:90)+"px;font-weight: bold;'>"+
									    queue.getTicketnumber()+"</font></td></tr>");
							    if(interval>0){
								    out.println("<tr height='14px'><td "+(n>0?"":"class='green'")+" style='vertical-align: middle; text-align: center; font-size: 14px;font-weight: bold;font-style:italic;'>");
							    	out.println(new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+counter*interval)));
								    out.println("</td></tr>");
							    }
							}
							counter++;
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
								String personname="?";
								AdminPerson person = AdminPerson.getAdminPerson(queue.getSubjectuid());
								if(person!=null){
									personname=person.getFullName();
								}
								if("1".equals(((String)session.getAttribute("showWaitingQueuePatientName")))){
									out.println("<tr height='20px'><td style='vertical-align: middle; text-align: center; font-size: 20px;font-weight: bold;'><font style='vertical-align: top; text-align: center; font-size: 20px;font-weight: bold;'>"+queue.getTicketnumber()+"</font></td><td><a href='javascript:loadparent("+queue.getSubjectuid()+");' style='vertical-align: middle;font-size: 14px;color: darkblue;font-weight: bold'>"+personname+"</a></td>");
								    if(interval>0){
									    out.println("<td style='vertical-align: middle; text-align: center; font-size: 14px;font-weight: bold;font-style:italic;'>");
								    	out.println(new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+counter*interval)));
									    out.println("</td>");
								    }
									out.println("</tr>");
								}
								else {
									out.println("<tr height='20px'><td style='vertical-align: top; text-align: right; font-size: 20px;font-weight: bold;'><font style='vertical-align: top; text-align: center; font-size: 20px;font-weight: bold;'>"+queue.getTicketnumber()+"</font></td>");
								    if(interval>0){
									    out.println("<td style='vertical-align: middle; text-align: center; font-size: 14px;font-weight: bold;font-style:italic;'>");
								    	out.println(new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+counter*interval)));
									    out.println("</td>");
								    }
									out.println("</tr>");
								}
								counter++;
							}
						}
					%>
				</table>
			</td>
		<tr>
	</table>
	
