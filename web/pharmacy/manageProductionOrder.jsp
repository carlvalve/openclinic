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
	else if(checkString(request.getParameter("action")).equalsIgnoreCase("close")){
		java.util.Date dClose = ScreenHelper.parseDate(request.getParameter("ProductionOrderCloseDateTime"));
		if(dClose==null){
			dClose=new java.util.Date();
		}
		int nQuantity=0;
		try{
			nQuantity=Integer.parseInt(request.getParameter("ProductionOrderQuantity"));
		}
		catch(Exception e){}
		//First add produced quantity to product stock
		if(nQuantity>0){
			//If personalized batch doesn't exist, create it
			if(!Batch.exists(order.getTargetProductStockUid(), order.getPatientUid()+"")){
				Batch batch = new Batch();
				batch.setUid("-1");
				batch.setBatchNumber(order.getPatientUid()+"");
				batch.setCreateDateTime(new java.util.Date());
				batch.setLevel(0);
				batch.setProductStockUid(order.getTargetProductStockUid());
				batch.setType("production");
				batch.setUpdateDateTime(new java.util.Date());
				batch.setUpdateUser(activeUser.userid);
				batch.setComment(AdminPerson.getFullName(order.getPatientUid()+""));
				batch.store();
			}
			ProductStockOperation operation = new ProductStockOperation();
			operation.setUid("-1");
			operation.setCreateDateTime(new java.util.Date());
			operation.setDate(new java.util.Date());
			operation.setDescription(MedwanQuery.getInstance().getConfigString("productionStockReceiptOperationDescription","medicationreceipt.production"));
			//Link operation to productionorder
			operation.setSourceDestination(new ObjectReference("production",sProductionOrderUid));
			operation.setProductStockUid(order.getTargetProductStockUid());
			operation.setUnitsChanged(nQuantity);
			operation.setVersion(1);
			operation.setUpdateUser(activeUser.userid);
			//Add person data to batch information
			operation.setBatchUid(Batch.getByBatchNumber(order.getTargetProductStockUid(), order.getPatientUid()+"").getUid());
			operation.store();
			//Now close the production order
			order.setCloseDateTime(dClose);
			order.setQuantity(nQuantity);
			order.setComment(request.getParameter("ProductionOrderComment"));
			order.store();
		}
	}
	else if(checkString(request.getParameter("action")).equalsIgnoreCase("save")){
		int nQuantity=0;
		try{
			nQuantity=Integer.parseInt(request.getParameter("ProductionOrderQuantity"));
		}
		catch(Exception e){}
		//Now save the production order
		order.setQuantity(nQuantity);
		order.setComment(request.getParameter("ProductionOrderComment"));
		order.store();
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
	<input type='hidden' name='action' id='action'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='4'><%=getTran("web.manage","manageproductionorder",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","productionof",sWebLanguage) %></td>
			<td class='admin2'><%=order.getProductStock()==null||order.getProductStock().getProduct()==null?"?":order.getProductStock().getProduct().getName().toUpperCase()%></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","productionorderclosed",sWebLanguage) %></td>
			<td class='admin2'><%=order.getCloseDateTime()!=null?ScreenHelper.formatDate(order.getCloseDateTime()):ScreenHelper.writeDateField("ProductionOrderCloseDateTime", "transactionForm", ScreenHelper.formatDate(order.getCloseDateTime()), true, false, sWebLanguage, sCONTEXTPATH)%></td>
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
			<td class='admin2'><textarea <%=order.getCloseDateTime()!=null?"readonly":"" %> class='text' cols='80' rows='2' name='ProductionOrderComment' id='ProductionOrderComment'><%=checkString(order.getComment()) %></textarea></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran("web","quantityproduced",sWebLanguage) %></td>
			<td class='admin2'><input <%=order.getCloseDateTime()!=null?"readonly":"" %> type='text' class='text' size='5' name='ProductionOrderQuantity' id='ProductionOrderQuantity' value='<%=order.getQuantity()%>'></td>
		</tr>
		<tr class='admin'>
			<td><%=getTran("web","billofmaterials",sWebLanguage) %></td>
			<td colspan='2'>
				<%if(order.getCloseDateTime()==null){ %>
					<input class='button' type='button' name='addmaterial' id='addmaterial' value='<%=getTran("web","addmaterials",sWebLanguage) %>' onclick='addMaterials()'/>
					<input class='button' type='button' name='addmaterialquick' id='addmaterialquick' value='<%=getTran("web","quicklist",sWebLanguage) %>' onclick='addMaterialsQuickList()'/>
					<input class='button' type='button' name='saveButton' id='saveButton' value='<%=getTran("web","save",sWebLanguage) %>' onclick='doSave()'/>
				<%} %>
			</td>
			<td>
				<%if(order.getCloseDateTime()==null){ %>
					<input class='button' type='button' name='closeButton' id='closeButton' value='<%=getTran("web","closeorder",sWebLanguage) %>' onclick='closeProductionOrder()'/>
				<%} %>
			</td>
		</tr>
		<tr>
			<td class='admin2' colspan='4'>
				<div name='divMaterials' id='divMaterials'/>
			</td>
		</tr>
	</table>
</form>

<script>
	function closeProductionOrder(){
		var bCanClose=false;
		if(document.getElementById('ProductionOrderQuantity').value*1<=0){
			bCanClose=window.confirm("<%=getTranNoLink("web","quantityzero.areyousure",sWebLanguage)%>");
		}
		else {
			bCanClose=true;
		}
		if(bCanClose){
			document.getElementById('action').value='close';
			transactionForm.submit();
		}
	}
	
	function doSave(){
		document.getElementById('action').value='save';
		transactionForm.submit();
	}

	function addMaterials(){
		  openPopup("/pharmacy/addMaterials.jsp&PopupHeight=200&PopupWidth=600&productionOrderId="+transactionForm.ProductionOrderId.value);
	}
	
	function addMaterialsQuickList(){
		  openPopup("/_common/search/searchMaterials.jsp&PopupHeight=400&PopupWidth=600&productionOrderId="+transactionForm.ProductionOrderId.value);
	}
	
	function loadMaterials(){
	    document.getElementById('divMaterials').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    var params = 'productionOrderId=' + transactionForm.ProductionOrderId.value;
	    var today = new Date();
	    var url= '<c:url value="/pharmacy/ajax/getProductionOrderMaterials.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        $('divMaterials').innerHTML=resp.responseText;
	      }
		});
	}
	
	function viewProductionOrderPrescriptions(examinationid){
		openPopup("/pharmacy/viewProductionOrderPrescriptions.jsp&PopupHeight=400&PopupWidth=600&examinationid="+examinationid);
	}
	
	window.setTimeout('loadMaterials();',200);
</script>