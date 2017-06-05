<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
%>
<table width='100%'>
	<tr class='admin'>
		<td>
			<select class='text' name="servicestock" id="servicestock" onchange="loadQueueContent();">
				<%
	                String defaultPharmacy = (String)session.getAttribute("defaultPharmacy");
	                Vector servicestocks = ServiceStock.getStocksByUser(activeUser.userid);
	                
	                ServiceStock stock;
	                for(int n=0; n<servicestocks.size(); n++){
	                    stock = (ServiceStock)servicestocks.elementAt(n);
	                    out.print("<option value='"+stock.getUid()+"' "+(stock.getUid().equals(defaultPharmacy)?"selected":"")+">"+stock.getName().toUpperCase()+"</option>");
	                }
	            %>
			</select>
		</td>
		<td>
			<div id='lastupdate'/>
		</td>
	</tr>
	<tr id='queueContent'/>
</table>

<script>
	function loadQueueContent(){
	    var url = '<c:url value="/pharmacy/getQueueContent.jsp"/>?servicestockuid='+document.getElementById('servicestock').value+'&ts='+new Date();
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: "",
	      onSuccess: function(resp){
            $('queueContent').innerHTML = resp.responseText;
            var date = new Date();
            document.getElementById("lastupdate").innerHTML='<%=getTranNoLink("web","lastupdatetime",sWebLanguage)%>: '+('00'+date.getHours()).slice(-2)+':'+('00'+date.getMinutes()).slice(-2)+':'+('00'+date.getSeconds()).slice(-2);
        	window.setTimeout("loadQueueContent()",<%=MedwanQuery.getInstance().getConfigInt("pharmacyQueueRefreshInterval",5000)%>);
	      }
	    });
	}
	
	function deliverProduct(operationuid){
	    var URL = "/pharmacy/deliverQueue.jsp&operationuid="+operationuid;
	    openPopup(URL,400,200,"OpenClinic");
	}
	
	window.setTimeout("loadQueueContent()",500);
</script>