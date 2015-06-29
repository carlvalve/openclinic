<%@page import="be.openclinic.pharmacy.*,
                java.io.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.pdf.general.*,
                org.dom4j.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sServiceStockId = checkString(request.getParameter("ServiceStockUid"));
	long day = 24*3600*1000;
	long year = 365*day;

	String sBegin = "01/01/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1),
		   sEnd   = "31/12/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1);

	// US-date
    if(ScreenHelper.stdDateFormat.toPattern().equals("MM/dd/yyyy")){
        sEnd = "12/31/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1);
    }

    /// DEBUG ///////////////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n****** statistics/pharmacy/getServiceIncomingStockOperationsPerProvider.jsp *******");
    	Debug.println("sServiceStockId : "+sServiceStockId);
    	Debug.println("sBegin          : "+sBegin);
    	Debug.println("sEnd            : "+sEnd+"\n");
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
%>
<form name='transactionForm' method='post'>
	<table width="100%" cellpadding="0" cellspacing="1" class="list">
	    <%-- PERIOD --%>
		<tr>
			<td class='admin2' width="<%=sTDAdminWidth%>">
				<%=getTran("web","from",sWebLanguage)%> <%=writeDateField("FindBeginDate","transactionForm",sBegin,sWebLanguage)%>
				<%=getTran("web","to",sWebLanguage)%> <%=writeDateField("FindEndDate","transactionForm",sEnd,sWebLanguage)%>
			</td>
		</tr>
		<tr>
			<td class='admin2'>
				<%=getTran("web","provider",sWebLanguage)%>: 
				<select name='providerUid' id='providerUid' class='text'>
					<option value=""></option>
					<%
						Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
						PreparedStatement ps = null;
					  	if(MedwanQuery.getInstance().getConfigString("stockOperationDocumentServiceSources","").indexOf("4")<0){
							ps=conn.prepareStatement("SELECT distinct oc_operation_srcdestuid FROM oc_productstockoperations o where oc_operation_description like 'medicationreceipt%' and oc_operation_srcdesttype ='supplier' order by oc_operation_srcdestuid");
					  	}
					  	else {
					  		ps = conn.prepareStatement("SELECT distinct OC_DOCUMENT_SOURCEUID as oc_operation_srcdestuid FROM oc_productstockoperationdocuments o where oc_document_type=4");
					  	}
						ResultSet rs = ps.executeQuery();
						while(rs.next()){
							String provider=rs.getString("oc_operation_srcdestuid");
						  	if(MedwanQuery.getInstance().getConfigString("stockOperationDocumentServiceSources","").indexOf("4")<0){
						  		out.print("<option value='"+provider+"'>"+provider+"</option>");
						  	}
						  	else {
						  		String service=getTran("service",provider,sWebLanguage);
						  		if(!service.equalsIgnoreCase(provider)){
						  			out.print("<option value='"+service+"'>"+service+"</option>");
						  		}
						  	}
						}
						rs.close();
						ps.close();
						conn.close();
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin2'>
				<input type='button' class="button" name='print' value='<%=getTranNoLink("web","print",sWebLanguage)%>' onclick='printReport();'/>
			</td>
		</tr>
	</table>
</form>

<script>
  function printReport(){
	window.open('<c:url value="pharmacy/printServiceIncomingStockOperationsPerProvider.jsp"/>?FindBeginDate='+document.getElementById('FindBeginDate').value+'&FindEndDate='+document.getElementById('FindEndDate').value+'&ServiceStockUid=<%=sServiceStockId%>&provider='+document.getElementById('providerUid').value);
	window.close();
  }
</script>