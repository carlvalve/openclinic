<%@page import="be.openclinic.finance.*,
                java.text.DecimalFormat"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Balance balance = Balance.getActiveBalance(activePatient.personid);
	double saldo = Balance.getPatientBalance(activePatient.personid);
    String sCurrency = MedwanQuery.getInstance().getConfigParam("currency","€");
%>
<table width="100%" cellpadding="0" cellspacing="0" class="list">
    <tr class="admin" stile='vertical-align: middle;'>
        <td>
            <%=getTran("curative","financial.status.title",sWebLanguage)%>&nbsp;
            <a href="<c:url value='/main.do'/>?Page=financial/editBalance.jsp&ts=<%=getTs()%>"><img src="<c:url value='/_img/icons/icon_edit.gif'/>" class="link" title="<%=getTranNoLink("web","editBalance",sWebLanguage)%>" style="vertical-align:-4px;"></a>
            <a href="<c:url value='/main.do'/>?Page=financial/debetEdit.jsp&ts=<%=getTs()%>"><img src="<c:url value='/_img/icons/icon_money2.gif'/>" class="link" title="<%=getTranNoLink("web","debetEdit",sWebLanguage)%>" style="vertical-align:-4px;"></a>
            <a href="<c:url value='/main.do'/>?Page=financial/patientInvoiceEdit.jsp&ts=<%=getTs()%>"><img src="<c:url value='/_img/icons/icon_invoice.gif'/>" class="link" title="<%=getTranNoLink("web.finance","patientinvoice",sWebLanguage)%>" style="vertical-align:-4px;"></a>
        </td>
        <td>
        	<table width='100%'>
        		<tr class='admin'>
        			<td>
				        <%if(saldo<balance.getMinimumBalance() && MedwanQuery.getInstance().getConfigInt("negativePatientBalanceAllowed",1)==0){%>
				        	<a href='javascript:newFastTransaction("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PATIENTCREDITREQUEST");'><img height='36px' src="<c:url value='/_img/forbidden.jpg'/>"/></a></td><td nowrap><font style="vertical-align: middle; font-weight:bolder; font-size: 14px; color: #FF9A64">
				        <%}
				          else if(saldo<balance.getMinimumBalance()){%>
				        	<font style="color: #FF9A64">
				        <%} %>
				        <%=getTran("balance","balance",sWebLanguage)%>:
				        <%=new DecimalFormat("#0.00").format(saldo)+" "+sCurrency%>
				        <%if(saldo<balance.getMinimumBalance()){%>
				        	</font>
				        <%}%>
				    </td>
			    </tr>
        	</table>
        </td>
        <td><%=getTran("balance","out_of_balance_since",sWebLanguage)%>:
        <%=ScreenHelper.getSQLDate(balance.getCreateDateTime())%></td>
    </tr>
    
    <%
    	if(MedwanQuery.getInstance().getConfigInt("enableFinancialStatusPrestations",1)==1){
		    %>
			    <tr class="gray">
			    	<td colspan="3"><b><%=getTran("web","deliveries.in.last.24.hours",sWebLanguage)%></b></td>
			    </tr>
		   	<%

	   		Vector debets = Debet.getPatientDebetPrestations(activePatient.personid,ScreenHelper.formatDate(new java.util.Date()),"","","");
	   		int n=0;
	   		for(;n<debets.size();n++){
	   			if(n%3==0){
	   				if(n>0){
	   	   				out.print("</tr>");
	   				}
	   				out.print("<tr>");
	   			}
	   			
	   			String debet = (String)debets.elementAt(n);
	   			out.print("<td>"+debet+"</td>");
	   		}
	   		
			if(n>0){
				out.print("</tr>");
			}
    	}
   	%>
</table>