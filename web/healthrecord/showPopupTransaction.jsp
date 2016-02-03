<%@page import="be.mxs.common.model.vo.healthrecord.util.TransactionFactoryGeneral"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	int serverid=Integer.parseInt(request.getParameter("be.mxs.healthrecord.server_id"));
	int transactionid=Integer.parseInt(request.getParameter("be.mxs.healthrecord.transaction_id"));
    SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
    TransactionVO showTransaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid); 
    TransactionFactoryGeneral factory = new TransactionFactoryGeneral();
    if(showTransaction!=null){
	    TransactionVO tempTran = factory.createTransactionVO(sessionContainerWO.getUserVO(),showTransaction.getTransactionType());
	    factory.populateTransaction(tempTran,showTransaction);
	    sessionContainerWO.setCurrentTransactionVO(tempTran);
    }
%>
<script>
	window.location.href="<c:url value="/"/><%=MedwanQuery.getInstance().getForward(showTransaction.getTransactionType()).replaceAll("main.do","popup.jsp")%>&be.mxs.healthrecord.transaction_id=<%=transactionid%>&be.mxs.healthrecord.server_id=<%=serverid%>";
</script>