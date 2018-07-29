<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String transactionId = checkString(request.getParameter("transactionId"));
	String serverId = checkString(request.getParameter("serverId"));
%>
<form name="transactionForm" id="printForm" method="post">
    <input type="hidden" name="Action" value="send">
	<table width='100%'>
        <tr>
            <td class='admin'>
                <%=getTran(request,"web","destination",sWebLanguage)%>
            </td>
            <td class='admin2'>
                <select class='text' name='destination' id='destination' onchange='checkReceiverPersonId();'>
                	<%=ScreenHelper.writeSelect(request, "sendRecordDestinations", checkString(activePatient.comment4).split(";")[0].split("\\.")[0], sWebLanguage) %>
                </select>
            </td>
            <td class="admin2">
                <div id='destinationmsg'></div>
                <div>
                <%
                	//Default insurarnr known?
                	String insuranceNr = activePatient.getReferenceInsuranceNumber();
                	if(insuranceNr.length()>0){
                		out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif'/>"+getTran(request,"web","using.reference.insureruid",sWebLanguage)+" = <b>"+insuranceNr+"</b>");
                	}
                %>
                </div>
            </td>
        </tr>
        <tr>
            <td class='admin'>
                <%=getTran(request,"web","and",sWebLanguage)%> (e-mail)
            </td>
            <td class='admin2' colspan="2">
                <input type='text' name='destination2' value='' class='text' size='40'/>
            </td>
        </tr>
	</table>
	<input type='button' name='send' value='<%=getTranNoLink("web","send",sWebLanguage) %>' onclick='doSend()'/>
</form>

<script>
	function checkReceiverPersonId(){
	    var today = new Date();
	    var url= '<c:url value="/util/checkReceiverPersonId.jsp"/>?receiverid='+document.getElementById('destination').value+'&ts='+today;
	    new Ajax.Request(url,{
	        method: "POST",
	        postBody: "",
	        onSuccess: function(resp){
	            var label = eval('('+resp.responseText+')');
	  		  	$('destinationmsg').innerHTML=label.msg;
	        },
	        onFailure: function(){
	            $('destinationmsg').innerHTML = "Error in function checkReceiverPersonId() => AJAX";
	        }
	    }
	 	);
	}

	function doSend(){
		window.location.href='<c:url value="healthrecord/sendTransaction.jsp?actionField=send&destination="/>'+document.getElementById("destination").value+'&tranAndServerID_1=<%=transactionId%>_<%=serverId%>';
	}
	
	checkReceiverPersonId();
</script>
