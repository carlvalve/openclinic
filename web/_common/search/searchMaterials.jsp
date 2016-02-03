<%@page import="be.openclinic.finance.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sProductionOrderId=checkString(request.getParameter("productionOrderId"));
	String sAction = checkString(request.getParameter("action"));
	Debug.println("sProductionOrderId = "+sProductionOrderId);
	if(request.getParameter("submitButton")!=null){
		Enumeration pars = request.getParameterNames();
		while(pars.hasMoreElements()){
			String parName = (String)pars.nextElement();
			if(parName.startsWith("material.")){
				//Add material to bill of materials
				String sProductStockUid = parName.replaceAll("material.","");
				java.util.Date dDate =new java.util.Date();
				int quantity = 0;
				try{
					quantity=new Double(Double.parseDouble(request.getParameter(parName))).intValue();
				}
				catch(Exception e){}
				if(quantity!=0){
					//Reduce source stock with taken quantity
					ProductStockOperation operation = new ProductStockOperation();
					operation.setUid("-1");
					operation.setCreateDateTime(new java.util.Date());
					operation.setDate(dDate);
					operation.setDescription(MedwanQuery.getInstance().getConfigString("productionStockOperationDescription","medicationdelivery.production"));
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
		}
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='4'><%=getTran("web","findmaterials",sWebLanguage) %></td>
			<td><input type='submit' name='submitButton' value='<%=getTran("web","save",sWebLanguage)%>'/></td>
		</tr>
		<%
			Vector materials = ProductStock.findMaterials();
			if(materials.size()>0){
				//Print header
				%>
				<tr>
					<td class='admin'><%=getTran("web","productname",sWebLanguage) %></td>
					<td class='admin'><%=getTran("web","servicestock",sWebLanguage) %></td>
					<td class='admin'><%=getTran("web","unit",sWebLanguage) %></td>
					<td class='admin'><%=getTran("web","level",sWebLanguage) %></td>
					<td class='admin'><%=getTran("web","quantity",sWebLanguage) %></td>
				</tr>
				<%
			}
			for(int n=0;n<materials.size();n++){
				ProductStock productStock = (ProductStock)materials.elementAt(n);
				Product product = productStock.getProduct();
				ServiceStock serviceStock = productStock.getServiceStock();
				if(product!=null && serviceStock!=null){
					out.println("<tr>");
					out.println("<td>"+product.getName()+"</td>");
					out.println("<td>"+serviceStock.getName()+"</td>");
					out.println("<td>"+getTran("product.unit",product.getUnit(),sWebLanguage)+"</td>");
					out.println("<td>"+productStock.getLevel()+"</td>");
					out.println("<td><input type='text' class='text' name='material."+productStock.getUid()+"' size='5' value='0'/></td>");
					out.println("</tr>");
				}
			}
		%>
	</table>
</form>