<%@include file="/includes/validateUser.jsp"%>

<form name="frmEnrollFingerPrint" method="post">
    <%=writeTableHeader("web","enrollFingerPrint",sWebLanguage)%>
    <table width="100%" class="list" cellspacing="1" cellpadding="0">
        <tr>
            <td class="admin2" nowrap>
                <input type="radio" id="righthand" name="rightleft" value="R" checked/><%=getLabel(request,"web","right",sWebLanguage,"righthand")%>
                <input type="radio" id="lefthand" name="rightleft" value="L"/><%=getLabel(request,"web","left",sWebLanguage,"lefthand")%>
            </td>
            <td class="admin2">
                <select name="finger" class="text">
                    <option value="0"><%=getTranNoLink("web","thumb",sWebLanguage)%></option>
                    <option selected value="1"><%=getTranNoLink("web","index",sWebLanguage)%></option>
                    <option value="2"><%=getTranNoLink("web","middlefinger",sWebLanguage)%></option>
                    <option value="3"><%=getTranNoLink("web","ringfinger",sWebLanguage)%></option>
                    <option value="4"><%=getTranNoLink("web","littlefinger",sWebLanguage)%></option>
                </select>
            </td>
        </tr>
    </table>
    
    <%=ScreenHelper.alignButtonsStart()%>
        <input type="button" class="button" name="enrollButton" value="<%=getTranNoLink("web","read",sWebLanguage)%>" onclick="doRead()"/>
        <input type="button" class="button" name="buttonClose" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onclick="window.close()"/>
    <%=ScreenHelper.alignButtonsStop()%>
    
    <table width='100%'>
        <tr>
            <td>
                <table>
                    <tr>
                        <td>
                        	<div name='clock' id='clock'></div>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap>
                        	<label name='readerID' id='readerID'></label>
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <img width='80px' id='fingerprintImage' name='fingerprintImage' src="<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>"/>
            </td>
        </tr>
    </table>
    <br>
</form>

<script>
	
	var ncounter;
	
	function doRead(){
		countAttempts(0);
		ncounter=0;
		document.getElementById("clock").innerHTML="<img src='<%=sCONTEXTPATH%>/_img/themes/default/ajax-loader.gif'/>";
		var r = 'L';
	      if(document.getElementById('righthand').checked){
	        r = 'R';
	      }
	    var parameters= 'rightleft='+r+'&finger='+frmEnrollFingerPrint.finger.value;		
		var url = '<c:url value="/_common/dp/enrollFingerPrint.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: parameters,
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.success==1){
				    document.getElementById("clock").innerHTML="";
			    	document.getElementById('readerID').innerHTML = '<h4><%=getTranNoLink("web","enrollment_succeeded",sWebLanguage)%></h4>';
			    }
			    else{
				    document.getElementById("clock").innerHTML="";
			    	document.getElementById('readerID').innerHTML = '<h4><%=getTranNoLink("web","enrollment_failed",sWebLanguage)%></h4>';
			    }
			    window.setTimeout("doDetect()",5000);
		  	},
		  	onFailure: function(){
		  		alert("error");
		  	}
		});
	}
	
	
	function countAttempts(n){
		var parameters= '';
		if(n>-1){
			parameters = 'initiate='+n;
		}
		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>';
		var url = '<c:url value="/_common/dp/countEnrollAttempts.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: parameters,
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.count>-1){
			    	document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","enroll.fingerprint",sWebLanguage)%>: <font style="font-size: 20px" color="red">'+s.count+'</font></span>';
			    	if(s.count>ncounter){
			    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmall.jpg"/>';
			    		ncounter=s.count*1;
			    	}
			    	window.setTimeout("countAttempts(-1)",1000);          
			    }
			    else{
			    	//doDetect();
			    }
		  	},
		  	onFailure: function(){
		  		alert("error counting attempts");
		  	}
		});
	}
	
	function doDetect(){
		var parameters= '';
		var url = '<c:url value="/_common/dp/detectFingerPrintReader.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: parameters,
		  	onSuccess: function(resp){
			    document.getElementById("clock").innerHTML="";
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

</script>