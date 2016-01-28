<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission("system.manageproductionorders","all",activeUser)%>
<%
	boolean bActivePatientOnly = checkString(request.getParameter("EditActivePatientOnly")).equalsIgnoreCase("1");
	String sProductStockUid = checkString(request.getParameter("EditProductStockUid"));
	String sMinDate = checkString(request.getParameter("EditMinDate"));
	String sMaxDate = checkString(request.getParameter("EditMaxDate"));
	java.util.Date mindate=null,maxdate=null;
	try{
		mindate = ScreenHelper.parseDate(sMinDate);
	}
	catch(Exception e){}
	try{
		maxdate = ScreenHelper.parseDate(sMaxDate);
	}
	catch(Exception e){}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran("web.manage","manageproductionorders",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran("web","activepatientonly",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><input type='checkbox' value ='1' name='EditActivePatientOnly' id='EditActivePatientOnly' <%=bActivePatientOnly?"checked":"" %>/></td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran("web","targetproductstock",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><input type='hidden' name='EditProductStockUid' id='EditProductStockUid' value='<%=sProductStockUid%>'/>
			<%
				String sProductStockName="";
				if(sProductStockUid.length()>0){
					ProductStock productStock=ProductStock.get(sProductStockUid);
					if(productStock!=null && productStock.getProduct()!=null){
						sProductStockName=productStock.getProduct().getName();
					}
				}
			%>
	        <input type="text" size="80" class="text" name="EditProductStockName" id="EditProductStockName" value="<%=sProductStockName%>"/>
	        <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProductStock('EditProductStockUid','EditProductStockName');">
	        <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditProductStockUid.value='';transactionForm.EditProductStockName.value='';">
	        </td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran("web","begindate",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><%=ScreenHelper.writeDateField("EditMinDate", "transactionForm", "", true, false, sWebLanguage, sCONTEXTPATH) %></td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran("web","begindate",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><%=ScreenHelper.writeDateField("EditMaxDate", "transactionForm", "", true, false, sWebLanguage, sCONTEXTPATH) %></td>
		</tr>
		<tr>
			<td><input type='submit' class='button' name='find' id='find' value='<%=getTran("web","find",sWebLanguage)%>'/></td>
		</tr>
	</table>
	
</form>
<%
	if(request.getParameter("find")!=null){
		Vector productionOrders = ProductionOrder.getProductionOrders(bActivePatientOnly?activePatient.personid:null, sProductStockUid,null, mindate, maxdate);
		if(productionOrders.size()>0){
			%>
			<table witdh="100%">
				<tr class='admin'>
					<td><%=getTran("web","id",sWebLanguage) %></td>
					<td><%=getTran("web","date",sWebLanguage) %></td>
					<td><%=getTran("web","patient",sWebLanguage) %></td>
					<td><%=getTran("web","productstock",sWebLanguage) %></td>
					<td><%=getTran("web","quantity",sWebLanguage) %></td>
					<td><%=getTran("web","comment",sWebLanguage) %></td>
				</tr>
			<%
			for(int n=0;n<productionOrders.size();n++){
				ProductionOrder order = (ProductionOrder)productionOrders.elementAt(n);
				ProductStock stock = order.getProductStock();
				%>
				<tr>
					<td class='admin'><%=order.getId() %></td>
					<td class='admin2'><%=ScreenHelper.formatDate(order.getCreateDateTime()) %></td>
					<td class='admin2'><a href='javascript:openProductionOrder("<%=order.getId() %>");'><%=AdminPerson.getFullName(""+order.getPatientUid()) %></a></td>
					<td class='admin2'><%=stock==null||stock.getProduct()==null?"":stock.getProduct().getName() %></td>
					<td class='admin2'><%=order.getQuantity() %></td>
					<td class='admin2'><%=checkString(order.getComment()) %></td>
				</tr>
				<%
			}
			%>
			</table>
			<%
		}
	}
%>

<script>
	function openProductionOrder(uid){
		window.location.href="<c:url value="main.do?Page=pharmacy/manageProductionOrder.jsp"/>&productionOrderUid="+uid;
	}
</script>