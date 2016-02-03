<%@page import="be.openclinic.finance.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sProductionOrderId=checkString(request.getParameter("productionOrderId"));
	String sAction = checkString(request.getParameter("action"));
	Debug.println("sProductionOrderId = "+sProductionOrderId);
	Debug.println("sAction            = "+sAction);
	if(sAction.equalsIgnoreCase("save")){
		Debug.println("EditMaterialQuantity      = "+request.getParameter("EditMaterialQuantity"));
		//Add material to bill of materials
		String sProductStockUid = request.getParameter("EditMaterialProductStockUid");
		java.util.Date dDate =new java.util.Date();
		try{
			dDate=ScreenHelper.parseDate(request.getParameter("EditMaterialDate"));
		}
		catch(Exception e){}
		int quantity = 0;
		try{
			quantity=new Double(Double.parseDouble(request.getParameter("EditMaterialQuantity"))).intValue();
		}
		catch(Exception e){}
		if(quantity!=0){
			//Reduce source stock with taken quantity
			ProductStockOperation operation = new ProductStockOperation();
			operation.setUid("-1");
			operation.setCreateDateTime(new java.util.Date());
			operation.setDate(dDate);
			operation.setDescription(MedwanQuery.getInstance().getConfigString("productionStockDeliveryOperationDescription","medicationdelivery.production"));
			//Link operation to productionorder
			operation.setSourceDestination(new ObjectReference("production",sProductionOrderId));
			operation.setProductStockUid(sProductStockUid);
			operation.setUnitsChanged(quantity);
			operation.setVersion(1);
			operation.setUpdateUser(activeUser.userid);
			operation.store();
			//Add materials to productorder
			ProductionOrderMaterial material = new ProductionOrderMaterial();
			material.setCreateDateTime(operation.getCreateDateTime());
			material.setProductionOrderId(Integer.parseInt(sProductionOrderId));
			material.setProductStockUid(operation.getProductStockUid());
			material.setQuantity(operation.getUnitsChanged());
			material.setUpdateDateTime(new java.util.Date());
			material.setUpdateUid(Integer.parseInt(activeUser.userid));
			material.setComment(request.getParameter("EditMaterialComment"));
			material.store();
			%>
			<script>
				window.opener.loadMaterials();
				window.close();
			</script>
			<%
			out.flush();
		}
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='action' id='action'/>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran("web","addmaterials",sWebLanguage) %></td></tr>
	    <tr>
			<td class='admin'><%=getTran("web","date",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDateField("EditMaterialDate", "transactionForm", ScreenHelper.formatDate(new java.util.Date()), true, false, sWebLanguage, sCONTEXTPATH) %>
	        </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran("web","product",sWebLanguage) %></td>
			<td class='admin2'>
	            <input type="hidden" name="EditMaterialProductStockUid" id="EditMaterialProductStockUid">
	            <input type="text" size="80" class="text" name="EditMaterialProductStockName" id="EditMaterialProductStockName"/>
	            <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProductStock('EditMaterialProductStockUid','EditMaterialProductStockName');">
	            <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditMaterialProductStockUid.value='';transactionForm.EditMaterialProductStockName.value='';">
	        </td>
	    </tr>
	    <tr>
			<td class='admin'><%=getTran("web","quantity",sWebLanguage) %></td>
			<td class='admin2'>
	            <input type="text" size="10" class="text" name="EditMaterialQuantity" id="EditMaterialQuantity" value='0'/>
	        </td>
		</tr>
	    <tr>
			<td class='admin'><%=getTran("web","comment",sWebLanguage) %></td>
			<td class='admin2'>
	            <textarea type="text" cols="80" class="text" name="EditMaterialComment" id="EditMaterialComment" ></textarea>
	        </td>
		</tr>
	</table>
	<input type='button' class='button' name='saveButton' value='<%=getTran("web","save",sWebLanguage) %>' onclick='doSave();'/>
</form>

<script>
	function searchProductStock(productStockUidField,productStockNameField){
    	openPopup("/_common/search/searchProductStock.jsp&ts=<%=getTs()%>&PopupWidth=600&ReturnProductStockUidField="+productStockUidField+"&ReturnProductStockNameField="+productStockNameField);
  	}
	
	function doSave(){
		if(document.getElementById('EditMaterialProductStockUid').value.length==0 || 1*document.getElementById('EditMaterialQuantity').value==0){
			alert('<%=getTran("web","somedataismissing",sWebLanguage)%>');
		}
		else{
			document.getElementById('action').value='save';
			transactionForm.submit();
		}
	}
</script>