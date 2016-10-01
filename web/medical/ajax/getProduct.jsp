<%@page import="java.util.*,be.openclinic.pharmacy.*,
                be.mxs.common.util.system.*"%>
<%@include file="/includes/validateUser.jsp"%>
                
<%
	Product product=null;
	int quantity=0;
	if(request.getParameter("productUid")!=null){
		product = Product.get(request.getParameter("productUid"));
	}
	else if(request.getParameter("productStockUid")!=null){
		ProductStock productStock = ProductStock.get(request.getParameter("productStockUid"));
		product = productStock.getProduct();
		if(productStock.getLevel()>0){
			quantity=productStock.getLevel();
		}
	}
	
%>
{
	"name": "<%=product.getName() %>",
	"timeunitcount": "<%=product.getTimeUnitCount()>0?product.getTimeUnitCount():1 %>",
	"timeunit": "<%=ScreenHelper.checkString(product.getTimeUnit()).length()>0?product.getTimeUnit():"type2day" %>",
	"startdate": "<%=ScreenHelper.formatDate(new java.util.Date()) %>",
	"unitspertimeunit": "<%=product.getUnitsPerTimeUnit()>0?product.getUnitsPerTimeUnit():1 %>",
	"totalunits": "<%=product.getTotalUnits()>0?product.getTotalUnits():1 %>",
	"prescriberuid": "<%=activeUser.userid %>",
	"prescribername": "<%=activeUser.person.getFullName() %>",
	"levels": "<%=product.getAccessibleStockLevels() %>",
	"quantity": "<%=quantity %>",
	"packageunits": "<%=product.getPackageUnits()>0?product.getPackageUnits():1 %>"
}
