<%@page import="be.openclinic.finance.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission("system.manageproductionorders","all",activeUser)%>
<%
	String sProductionOrderUid=checkString(request.getParameter("productionOrderUid"));
	ProductionOrder order = null;
	if(sProductionOrderUid.length()>0){
		try{
			order=ProductionOrder.get(Integer.parseInt(sProductionOrderUid));
		}
		catch(Exception e){}
	}
	if(order==null){
		order= new ProductionOrder();
	}
	sTDAdminWidth="20%";
	PatientInvoice invoice=null;
	Debet debet = Debet.get(order.getDebetUid());
	if(debet!=null){
		invoice = debet.getPatientInvoice();
	}
	if(invoice==null){
		invoice=new PatientInvoice();
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='4'><%=getTran("web.manage","manageproductionorder",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","productionof",sWebLanguage) %></td>
			<td class='admin2'><%=order.getProductStock()==null||order.getProductStock().getProduct()==null?"?":order.getProductStock().getProduct().getName().toUpperCase()%></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","productionorderclosed",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("ProductionOrderCloseDateTime", "transactionForm", ScreenHelper.formatDate(order.getCloseDateTime()), true, false, sWebLanguage, sCONTEXTPATH)%></td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","productionorderid",sWebLanguage) %></td>
			<td class='admin2'><%=order.getId()>0?order.getId()+"":"" %><input type='hidden' name='ProductionOrderId' value='<%=order.getId()%>'/></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","patient",sWebLanguage) %></td>
			<td class='admin2'><%=AdminPerson.getFullName(order.getPatientUid()+"") %></td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","invoice",sWebLanguage) %></td>
			<td class='admin2'><%=invoice.getUid() %></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","invoicedate",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.formatDate(invoice.getDate()) %></td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","productionorderprescription",sWebLanguage)%></td>
			<td class='admin2'><a href='javascript:viewProductionOrderPrescriptions("<%=debet==null||debet.getPrestation()==null?-1:debet.getPrestation().getProductionOrderPrescription()%>")'><%=debet==null||debet.getPrestation()==null?"":getTranNoLink("examination",debet.getPrestation().getProductionOrderPrescription()+"",sWebLanguage)%></a></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","linkedprestation",sWebLanguage) %></td>
			<td class='admin2'><%=debet==null||debet.getPrestation()==null?"":debet.getPrestation().getDescription() %></td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","comment",sWebLanguage) %></td>
			<td class='admin2'><textarea class='text' cols='80' rows='2' name='ProductionOrderComment' id='ProductionOrderComment'><%=checkString(order.getComment()) %></textarea></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","quantityproduced",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='5' name='ProductionOrderQuantity' id='ProductionOrderQuantity'><%=checkString(order.getComment()) %></textarea></td>
		</tr>
	</table>
</form>