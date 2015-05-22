<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%
	try{
		String resourceuid=ScreenHelper.checkString(request.getParameter("resourceuid"));
		String begin=ScreenHelper.checkString(request.getParameter("begin"));
		Date dbegin = ScreenHelper.getSQLDate(begin);
		int mintime=7*12;
		int maxtime=18*12;
		long minute=60000;
		long hour=60*minute;
		long day=24*hour;
		Hashtable occupiedSegments = new Hashtable();
		Vector reservations = Reservation.getReservationsForResourceUid(resourceuid, dbegin, new java.util.Date(dbegin.getTime()+7*day-1));
		for(int n=0;n<reservations.size();n++){
			Reservation reservation = (Reservation)reservations.elementAt(n);
			if(!reservation.getPlanningUid().startsWith("0.")){
				if(Integer.parseInt(new SimpleDateFormat("HH").format(reservation.getBegin()))*12<mintime){
					mintime=Integer.parseInt(new SimpleDateFormat("HH").format(reservation.getBegin()))*12;
				}
				if(Integer.parseInt(new SimpleDateFormat("HH").format(reservation.getEnd()))*12>maxtime){
					maxtime=Integer.parseInt(new SimpleDateFormat("HH").format(reservation.getEnd()))*12;
				}
				String username=ScreenHelper.getTran("web","user",request.getParameter("language"))+": "+reservation.getPlanning().getUser().getFullName()+" | "+ScreenHelper.getTran("web","hour",request.getParameter("language"))+": "+ new SimpleDateFormat("HH:mm").format(reservation.getBegin())+"-"+new SimpleDateFormat("HH:mm").format(reservation.getEnd());
				if(reservation.getPlanning().getPatientUID()!=null && reservation.getPlanning().getPatientUID().length()>0){
					username=ScreenHelper.getTran("web","patient",request.getParameter("language"))+": "+reservation.getPlanning().getPatient().getFullName()+" | "+username;
				}
				if( reservation.getPlanning().getDescription()!=null && reservation.getPlanning().getDescription().length()>0){
					username=username+" | "+ScreenHelper.getTran("web","comment",request.getParameter("language"))+": "+reservation.getPlanning().getDescription();
				}
				username+=";"+reservation.getPlanningUid();
				for(long i=reservation.getBegin().getTime();i<reservation.getEnd().getTime();i+=5*minute){
					occupiedSegments.put(new SimpleDateFormat("yyyyMMddHHmm").format(new java.util.Date(i)),username);
				}
			}			
		}
		
%>
		<table width='100%' style="border-spacing: 1px 0;">
			<tr class='admin'>
				<td colspan='8'><%=ScreenHelper.getTran("web","resourceavailability.for",request.getParameter("language")) %>: <%=ScreenHelper.getTran("planningresource", resourceuid, request.getParameter("language"))%></td>
			</tr>
			<tr>
				<td class='admin' width='1%'><%=ScreenHelper.getTran("web","hour",request.getParameter("language")) %></td>
				<% for(int n=0;n<7;n++){ %>
				<td class='admin'><%=ScreenHelper.formatDate(new java.util.Date(dbegin.getTime()+n*day)) %></td>
				<% } %>
			</tr>
			<% for(int n=mintime;n<maxtime;n++){ %>
				<tr>
					<% if(n%12==0){ %>
						<td valign='top' bgcolor='lightgray' rowspan='12'><%=n/12+":00" %></td>
					<% } %>
					<% for(int i=0;i<7;i++){ 
						String sUser=ScreenHelper.checkString((String)occupiedSegments.get(new SimpleDateFormat("yyyyMMddHHmm").format(new java.util.Date(dbegin.getTime()+i*day+n*5*minute))));	
					%>
						<td height='5' <%=sUser.split(";")[0].length()>0?"title='"+sUser.split(";")[0]+"' ondblclick='openResourceAppointment(\""+sUser.split(";")[1]+"\")' bgcolor='lightgray' style='{padding: 0px 0px 0px 0px}'":"" %>> </td>
					<% } %>
				</tr>
			<% } %>
		</table>
<%
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
