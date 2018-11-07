<%@include file="/includes/helper.jsp"%>
<%
	System.out.println("FingerPrintId for session "+session.getId()+" = "+(String)session.getAttribute("fingerprintid"));
%>
{
	"serial":"<%=checkString((String)session.getAttribute("fingerprintid"))%>"
}