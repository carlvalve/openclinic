<%@include file="/includes/helper.jsp"%>
<head>
    <%=sCSSNORMAL%>
    <%=sJSPROTOTYPE%>
    
    <script>
      window.resizeTo(400,200);
      window.moveTo((self.screen.width-document.body.clientWidth)/2,(self.screen.height-document.body.clientHeight)/2);
    </script>
</head>

<table width='100%'>
	<tr>
		<td>
			<table width='100%'>
				<tr>
					<td>
						<%
							out.print("<img src='"+request.getParameter("referringServer")+"/_img/themes/default/ajax-loader.gif'/>"+
						              "<br><br>"+MedwanQuery.getInstance().getLabel("web","waiting_for_fingerprint","en")+"</br>");
						%>
					</td>
				</tr>
				<tr>
					<td>
						<form name="frmFingerPrint" method="post" action="<c:url value="/_common/readFingerPrint.jsp"/>">
						    <input type="hidden" name="language" value="en"/>
						    <input type="hidden" name="start" value="<%=ScreenHelper.getTs()%>"/>
						    <input type="hidden" name="referringServer" value="<%=request.getParameter("referringServer")%>"/>
						    <label name='readerID' id='readerID'></label>
						</form>
					</td>
				</tr>
			</table>
		</td>
		<td>
			<img width='80px' id='fingerprintImage' name='fingerprintImage' src="<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>"/>
		</td>
	</tr>
</table>

<script>

	function doRead(){
		var url = '<c:url value="/_common/dp/readUserFingerPrint.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: '',
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.success==1){
		    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmall.jpg"/>';
					selectUser(s.userid,s.password);
			    }
			    else{
		    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallWrong.jpg"/>';
		    		window.setTimeout("doDetect()",2000);
		    	}
		  	},
		  	onFailure: function(){
	    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallWrong.jpg"/>';
		  	}
		});
	}

	function doDetect(){
		var parameters= '';
		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>';
		var url = '<c:url value="/_common/dp/detectFingerPrintReader.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: parameters,
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.model!=''){
			    	document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","digital.persona.reader.detected","en")%>:<br/><b>'+s.model+"</b>";
			    }
			    else{
				    document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","no.reader","en")%>';
				    window.setTimeout("doDetect()",5000);
			    }
		  	},
		  	onFailure: function(){
			    document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","no.reader","en")%>';
			    window.setTimeout("doDetect()",5000);
		  	}
		});
	}
	
	function selectUser(userid,password){
		window.opener.location.href='<c:url value="/checkLogin.jsp"/>?ts=<%=ScreenHelper.getTs()%>&login='+userid+'&auto=true&password='+password;
		window.close();
	}

	doDetect();
	doRead();
</script>