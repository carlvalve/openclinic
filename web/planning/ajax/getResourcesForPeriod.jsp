<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%
boolean bHasConflicts=false;
	try{
		String resourceuid=ScreenHelper.checkString(request.getParameter("resourceuid"));
		String excludeplanninguid=ScreenHelper.checkString(request.getParameter("excludeplanninguid"));
		String begin=ScreenHelper.checkString(request.getParameter("begin"));
		String end=ScreenHelper.checkString(request.getParameter("end"));
		String begintime=ScreenHelper.checkString(request.getParameter("begintime"));
		String endtime=ScreenHelper.checkString(request.getParameter("endtime"));
		Date dbegin = ScreenHelper.getSQLTime(begin+" "+begintime, "dd/MM/yyyy HH:mm");
		Date dend = ScreenHelper.getSQLTime(end+" "+endtime, "dd/MM/yyyy HH:mm");
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='6'><%=ScreenHelper.getTran("web","resourceavailability.for",request.getParameter("language")) %>: <%=ScreenHelper.getTran("planningresource", resourceuid, request.getParameter("language"))%></td>
	</tr>
	<tr>
		<td class='admin'><%=ScreenHelper.getTran("web","begin",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran("web","end",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran("web","duration",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran("web","user",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran("web","patient",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran("web","comment",request.getParameter("language")) %></td>
	</tr>
<%
		Vector reservations = Reservation.getReservationsForResourceUid(resourceuid,ScreenHelper.getSQLTime(begin+" 00:00", "dd/MM/yyyy HH:mm"),ScreenHelper.getSQLTime(end+" 23:59", "dd/MM/yyyy HH:mm"));
		if(reservations.size()>0){
			for(int n=0;n<reservations.size();n++){
				Reservation reservation = (Reservation)reservations.elementAt(n);
				if(!reservation.getPlanningUid().startsWith("0.") && !reservation.getPlanningUid().equalsIgnoreCase(excludeplanninguid)){
					try{
						if((reservation.getBegin().before(dbegin) && reservation.getEnd().before(dbegin))||(reservation.getBegin().after(dend) && reservation.getEnd().after(dend))){
							out.println("<tr><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getBegin())+"</td><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getEnd())+"</td><td class='admin2'>"+ScreenHelper.getDuration(reservation.getBegin(),reservation.getEnd())+"</td><td class='admin2'>"+(reservation.getPlanning().getUser()==null?"?":reservation.getPlanning().getUser().getFullName())+"</td><td class='admin2'>"+(reservation.getPlanning().getPatient()==null?"?":reservation.getPlanning().getPatient().getFullName())+"</td><td class='admin2'>"+ScreenHelper.checkString(reservation.getPlanning().getDescription())+"</td></tr>");
						}
						else {
							out.println("<tr><td class='red'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getBegin())+"</td><td class='red'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getEnd())+"</td><td class='red'>"+ScreenHelper.getDuration(reservation.getBegin(),reservation.getEnd())+"</td><td class='red'>"+(reservation.getPlanning().getUser()==null?"?":reservation.getPlanning().getUser().getFullName())+"</td><td class='red'>"+(reservation.getPlanning().getPatient()==null?"?":reservation.getPlanning().getPatient().getFullName())+"</td><td class='red'>"+ScreenHelper.checkString(reservation.getPlanning().getDescription())+"</td></tr>");
							bHasConflicts=true;
						}
					}
					catch(Exception e1){
						e1.printStackTrace();
					}
				}
			}
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
</table>
<%
	if(bHasConflicts){
%>
<input type='hidden' name='conflict' id='conflict' value='1'/>
<%
	}
%>