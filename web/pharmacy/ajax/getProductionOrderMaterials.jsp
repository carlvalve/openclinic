<%@page import="be.openclinic.finance.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%><table width='100%'>
<%
	String productionOrderId = request.getParameter("productionOrderId");
	ProductionOrder order = ProductionOrder.get(Integer.parseInt(productionOrderId));
	if(order!=null){
		Vector materials = order.getMaterials();
		if(materials.size()>0){
			//Set header
			out.println("<tr>");
			out.println("<td class='admin'>"+ScreenHelper.getTran("web","date",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.getTran("web","product",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.getTran("web","quantity",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.getTran("web","unit",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.getTran("web","comment",sWebLanguage)+"</td>");
			out.println("</tr>");
		}
		for(int n=0;n<materials.size();n++){
			ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(n);
			String productname="?",productunit="?";
			ProductStock productStock = ProductStock.get(material.getProductStockUid());
			if(productStock!=null && productStock.getProduct()!=null){
				productname=productStock.getProduct().getName();
				productunit=productStock.getProduct().getPackageUnits()+" "+ productStock.getProduct().getUnit();
			}
			out.println("<tr>");
			out.println("<td class='admin2'>"+ScreenHelper.formatDate(material.getCreateDateTime())+"</td>");
			out.println("<td class='admin2'>"+productname+"</td>");
			out.println("<td class='admin2'>"+material.getQuantity()+"</td>");
			out.println("<td class='admin2'>"+productunit+"</td>");
			out.println("<td class='admin2'>"+checkString(material.getComment())+"</td>");
			out.println("</tr>");
		}
	}
%>
</table>