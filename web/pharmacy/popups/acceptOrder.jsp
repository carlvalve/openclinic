<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/templateAddIns.jsp"%>
<%
	String sServiceStockUid=request.getParameter("ServiceStockUid");
	String sRequestingServiceStockUid=request.getParameter("RequestingServiceStockUid");
	String serviceName="";
	ServiceStock serviceStock = ServiceStock.get(sRequestingServiceStockUid);
	if(serviceStock!=null){
		serviceName=serviceStock.getName();
	}
	if(checkString(request.getParameter("action")).startsWith("close.")){
		ProductOrder order = ProductOrder.get(request.getParameter("action").replaceAll("close.", ""));
		if(order!=null){
			order.setStatus("closed");
			order.setProcessed(1);
			order.store();
		}
	}
%>
<form name="transactionForm" method="post">
	<table width="100%">
		<tr class='admin'><td colspan='5'><%=getTran("web","acceptorderfrom",sWebLanguage) %> [<%=serviceName %>]</td></tr>
		<tr class='admin'>
			<td><%=getTran("web","product",sWebLanguage) %></td>
			<td></td>
			<td><%=getTran("web","ordered",sWebLanguage) %></td>
			<td><%=getTran("web","delivered",sWebLanguage) %></td>
			<td><%=getTran("web","available",sWebLanguage) %></td>
		</tr>
		<%
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			String sql="select * from oc_productorders o,oc_productstocks p,oc_products n"+
						" where"+
						" o.oc_order_from=? and"+
						" o.oc_order_processed=0 and"+
						" p.oc_stock_servicestockuid=? and"+
						" n.oc_product_objectid=replace(p.oc_stock_productuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"+
						" p.oc_stock_objectid=replace(o.oc_order_productstockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, sServiceStockUid);
			ps.setString(2, sRequestingServiceStockUid);
			ResultSet rs = ps.executeQuery();
			int counter=0;
			while(rs.next()){
				counter++;
				//Must first find a matching productstock in servicestock
				Vector productstocks = ProductStock.find(sServiceStockUid, rs.getString("oc_stock_productuid"), "", "", "", "", "", "", "", "", "", "oc_stock_productuid", "");
				String orderuid=rs.getInt("oc_order_serverid")+"."+rs.getInt("oc_order_objectid");
				if(productstocks.size()>0 ){
					ProductStock localStock = (ProductStock)productstocks.elementAt(0);
					if(localStock.getLevel()>0){
						int ordered=rs.getInt("oc_order_packagesordered");
						int delivered=rs.getInt("oc_order_packagesdelivered");
						int quantity=ordered-delivered;
						out.println("<tr><td class='admin'><a href='javascript:doOrder(\""+localStock.getUid()+"\","+quantity+",\""+orderuid+"\")'>"+rs.getString("oc_product_name")+"</a></td><td class='admin2'><input type='button' value='"+getTran("web","close",sWebLanguage)+"' onclick='closeOrder(\""+orderuid+"\")'</td><td class='admin2'>"+ordered+"</td><td class='admin2'>"+delivered+"</td><td class='admin2'>"+localStock.getLevel()+"</td></tr>");
					}
					else{
						out.println("<tr><td class='admingrey'>"+rs.getString("oc_product_name")+"</td><td class='admin2'><input type='button' value='"+getTran("web","close",sWebLanguage)+"' onclick='closeOrder(\""+orderuid+"\")'</td><td class='admin2'>"+rs.getString("oc_order_packagesordered")+"</td><td class='admin2'>"+rs.getString("oc_order_packagesdelivered")+"</td><td class='admin2'/></tr>");
					}
				}
				else{
					out.println("<tr><td class='admingrey'>"+rs.getString("oc_product_name")+"</td><td class='admin2'><input type='button' value='"+getTran("web","close",sWebLanguage)+"' onclick='closeOrder(\""+orderuid+"\")'</td><td class='admin2'>"+rs.getString("oc_order_packagesordered")+"</td><td class='admin2'>"+rs.getString("oc_order_packagesdelivered")+"</td><td class='admin2'/></tr>");
				}
			}
			rs.close();
			ps.close();
			conn.close();
			if(counter==0){
				ServiceStock masterStock=ServiceStock.get(sServiceStockUid);
				if(!masterStock.hasOpenOrders()){
					out.println("<script>window.opener.location.reload();</script>");
				}
				out.println("<script>window.close();</script>");
				out.flush();
			}
		%>
	</table>
	<input type='hidden' name='action' id='action'/>
</form>
<script>
	function doOrder(productstockuid,quantity,orderuid){
		openPopup("pharmacy/medication/popups/deliverMedicationPopupAuto.jsp&EditOperationDescr=medicationdelivery.2&EditSrcDestType=servicestock&EditSrcDestUid=<%=sRequestingServiceStockUid%>&EditUnitsChanged="+quantity+"&EditSrcDestName=<%=serviceName%>&Action=deliverMedication&EditProductStockUid="+productstockuid+"&EditOrderUid="+orderuid,800,600);
	}
	function closeOrder(orderuid){
		document.getElementById('action').value='close.'+orderuid;
		transactionForm.submit();
	}
</script>
