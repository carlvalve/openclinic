<%@ page import="be.openclinic.adt.Queue" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'>
			<select class='text' name='queue' id='queue' onchange='loadtickets();'>
				<%=ScreenHelper.writeSelect("queue", checkString((String)session.getAttribute("activequeue")), sWebLanguage) %>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<div id='tickets'></div>
		<td>
	</tr>
</table>
<script>
	loadtickets();
	window.setInterval("loadtickets();",5000);
	
	function loadtickets(){
	    document.getElementById('tickets').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    var params = 'queueid=' + document.getElementById("queue").value;
	    var today = new Date();
	    var url= '<c:url value="/util/getQueueTickets.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  method: "GET",
	      parameters: params,
	      onSuccess: function(resp){
	        $('tickets').innerHTML=resp.responseText;
	      }
		});
	}
</script>