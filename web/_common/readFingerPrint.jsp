<%@include file="/includes/validateUser.jsp"%>
<%=sJSPROTOTYPE%>
<%=sJSNUMBER%>

<table width='100%'>
	<tr>
		<td>
			<table width='100%'>
				<tr>
					<td>
						<%
							out.print("<img src='"+request.getParameter("referringServer")+"/_img/themes/"+sUserTheme+"/ajax-loader.gif'/>"+
						              "<br><br>"+MedwanQuery.getInstance().getLabel("web","waiting_for_fingerprint",((User)session.getAttribute("activeUser")).person.language)+"</br>");
						%>
					</td>
				</tr>
				<tr>
					<td>
						<form name="frmFingerPrint" method="post" action="<c:url value="/_common/readFingerPrint.jsp"/>">
						    <input type="hidden" name="language" value="<%=((User)session.getAttribute("activeUser")).person.language%>"/>
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
		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>';
		var url = '<c:url value="/_common/dp/readFingerPrint.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: '',
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.success==1 && s.personid*1>-1){
		    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmall.jpg"/>';
					window.opener.location.href='<c:url value="/main.do?Page=curative/index.jsp&PersonID="/>'+s.personid;
					window.close();
			    }
			    else{
		    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallWrong.jpg"/>';
		    		window.setTimeout("doRead()",2000);
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
			    	document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","digital.persona.reader.detected",sWebLanguage)%>:<br/><b>'+s.model+"</b>";
			    }
			    else{
				    document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","no.reader",sWebLanguage)%>';
				    window.setTimeout("doDetect()",5000);
			    }
		  	},
		  	onFailure: function(){
			    document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","no.reader",sWebLanguage)%>';
			    window.setTimeout("doDetect()",5000);
		  	}
		});
	}
	doDetect();
	doRead();
</script>