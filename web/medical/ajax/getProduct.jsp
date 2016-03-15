<%@page import="java.util.*,be.openclinic.pharmacy.*,
                be.mxs.common.util.system.*"%>
<%@include file="/includes/validateUser.jsp"%>
                
<%
	Product product=null;
	if(request.getParameter("productUid")!=null){
		product = Product.get(request.getParameter("productUid"));
	}
	else if(request.getParameter("productStockUid")!=null){
		ProductStock productStock = ProductStock.get(request.getParameter("productStockUid"));
		product = productStock.getProduct();
	}
%>
{
	"name": "<%=product.getName() %>",
	"timeunitcount": "<%=product.getTimeUnitCount()>0?product.getTimeUnitCount():0 %>",
	"timeunit": "<%=product.getTimeUnit() %>",
	"startdate": "<%=ScreenHelper.formatDate(new java.util.Date()) %>",
	"unitspertimeunit": "<%=product.getUnitsPerTimeUnit() %>",
	"totalunits": "<%=product.getTotalUnits()>0?product.getTotalUnits():1 %>",
	"prescriberuid": "<%=activeUser.userid %>",
	"prescribername": "<%=activeUser.person.getFullName() %>",
	"levels": "<%=product.getAccessibleStockLevels() %>",
	"packageunits": "<%=product.getPackageUnits()>0?product.getPackageUnits():1 %>"
}
