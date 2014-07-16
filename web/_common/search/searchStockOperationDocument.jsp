<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page import="be.openclinic.pharmacy.*" %>

<%=checkPermission("pharmacy.manageproductstockdocuments","all",activeUser)%>
<%=sJSSORTTABLE%>

<%
	String sAction = checkString(request.getParameter("formaction"));
	String sDoAction = checkString(request.getParameter("doaction"));
	if(sAction.length()==0 && sDoAction.length()>0){
		sAction=sDoAction;
	}
	
	String sUid = checkString(request.getParameter("documentuid")),
		   sType = checkString(request.getParameter("documenttype")),
		   sSource = checkString(request.getParameter("documentsource")),
		   sDestination = checkString(request.getParameter("documentdestination")),
		   sDate = checkString(request.getParameter("documentdate")),
		   sComment = checkString(request.getParameter("documentcomment")),
		   sReference = checkString(request.getParameter("documentreference"));
	
	String sFindType = checkString(request.getParameter("finddocumenttype")),
		   sFindSource = checkString(request.getParameter("finddocumentsource")),
		   sFindDestination = checkString(request.getParameter("finddocumentdestination")),
		   sFindSourceText = checkString(request.getParameter("finddocumentsourcetext")),
		   sFindDestinationText = checkString(request.getParameter("finddocumentdestinationtext")),
		   sFindMinDate = checkString(request.getParameter("finddocumentmindate")),
		   sFindMaxDate = checkString(request.getParameter("finddocumentmaxdate")),
		   sFindReference = checkString(request.getParameter("finddocumentreference"));
	
	String sReturnDocumentID = checkString(request.getParameter("ReturnDocumentID")),
		   sReturnDocumentName = checkString(request.getParameter("ReturnDocumentName")),
		   sReturnDestinationID = checkString(request.getParameter("ReturnDestinationID")),
		   sReturnDestinationName = checkString(request.getParameter("ReturnDestinationName")),
		   sReturnSourceName = checkString(request.getParameter("ReturnSourceName"));


    ///////////////////////////// <DEBUG> /////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n############ _common/search/searchStockOperationDocument.jsp ############");
        Debug.println("sAction      : "+sAction);
        Debug.println("sUid         : "+sUid);
        Debug.println("sType        : "+sType);
        Debug.println("sSource      : "+sSource);
        Debug.println("sDestination : "+sDestination);
        Debug.println("sDate        : "+sDate);
        Debug.println("sComment     : "+sComment);
        Debug.println("sReference   : "+sReference+"\n");
    }
    ///////////////////////////// </DEBUG> ////////////////////////////////////////////////////////

	OperationDocument operationDocument = new OperationDocument();

	if(sAction.equalsIgnoreCase("save")){
		operationDocument.setUid(sUid);
		operationDocument.setType(sType);
		operationDocument.setSourceuid(sSource);
		operationDocument.setDestinationuid(sDestination);
		java.util.Date d = null;
		try{
			d=ScreenHelper.parseDate(sDate);
		}
		catch(Exception e){};
		operationDocument.setDate(d);
		operationDocument.setComment(sComment);
		operationDocument.setReference(sReference);
		operationDocument.store();
		sAction="find";
		sFindType=sType;
		sFindSource=sSource;
		sFindSourceText=operationDocument.getSourceName(sWebLanguage);
		sFindDestination=sDestination;
		sFindDestinationText=operationDocument.getDestination().getName();
		sFindMinDate=sDate;
		sFindMaxDate=sDate;
		sFindReference=sReference;
	}
	
	if(sAction.length()==0 || sAction.equalsIgnoreCase("find")){
		if(sUid.length()>0){
			operationDocument=OperationDocument.get(sUid);
			sFindType=operationDocument.getType();
			sFindSource=operationDocument.getSourceuid();
			sFindSourceText=operationDocument.getSourceName(sWebLanguage);
			sFindDestination=operationDocument.getDestinationuid();
			sFindDestinationText=operationDocument.getDestination().getName();
			sFindMinDate=ScreenHelper.stdDateFormat.format(operationDocument.getDate());
			sFindMaxDate=ScreenHelper.stdDateFormat.format(operationDocument.getDate());
			sFindReference=operationDocument.getReference();
		}
		else if(sFindType.length()==0 && sFindSource.length()==0 && sFindDestination.length()==0 && sFindMinDate.length()==0 && sFindMaxDate.length()==0 && sFindReference.length()==0){
			sFindMinDate=ScreenHelper.stdDateFormat.format(new java.util.Date().getTime()-7*24*3600*1000);			
		}
		
		//First show search header
		%>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<form name="searchForm" method="get" action="<c:url value="/popup.jsp"/>">
							<input type="hidden" name="ReturnDocumentID" value="<%=sReturnDocumentID %>"/>
							<input type="hidden" name="ReturnDocumentName" value="<%=sReturnDocumentName %>"/>
							<input type="hidden" name="ReturnDestinationID" value="<%=sReturnDestinationID %>"/>
							<input type="hidden" name="ReturnDestinationName" value="<%=sReturnDestinationName %>"/>
							<input type="hidden" name="Page" value="/_common/search/searchStockOperationDocument.jsp"/>
							
			                <table class="list" width="100%" cellpadding="0" cellspacing="1">
								<tr class="admin" style="padding-left:0">
									<td colspan="2"><%=getTran("web","findoperationdocuments",sWebLanguage) %>&nbsp;</td>
								</tr>
								<tr>
									<td class="admin" width="1%" nowrap><%=getTran("web","type",sWebLanguage) %>&nbsp;</td>
									<td class="admin2">
										<select name="finddocumenttype" id="finddocumenttype" class="text">
											<option value=""></option>
											<%=ScreenHelper.writeSelect("operationdocumenttypes", sFindType, sWebLanguage) %>
										</select>
									</td>
								</tr>
								<tr>
									<td class="admin" width="1%" nowrap><%=getTran("web","source",sWebLanguage) %>&nbsp;</td>
									<td class="admin2">
						                <input class='text' type="text" name="finddocumentsourcetext" id="finddocumentsourcetext" readonly size="50" TITLE="" VALUE="<%=sFindSourceText %>" onchange="">
						                <img src='/openclinic/_img/icon_search.gif' id='buttonUnit' class='link' alt='Choisir'onclick='findsearchsource("finddocumentsource","finddocumentsourcetext");'>&nbsp;<img src='/openclinic/_img/icon_delete.gif' class='link' alt='Vider' onclick="document.getElementsByName('finddocumentsource')[0].value='';document.getElementsByName('finddocumentsourcetext')[0].value='';">
						                <input type="hidden" name="finddocumentsource" id="finddocumentsource" VALUE="">
									</td>
								</tr>
								<tr>
									<td class="admin" width="1%" nowrap><%=getTran("web","destination",sWebLanguage) %>&nbsp;</td>
									<td class="admin2">
						                <input class='text' type="text" name="finddocumentdestinationtext" id="finddocumentdestinationtext" readonly size="50" TITLE="" VALUE="<%=sFindDestinationText %>" onchange="">
						                <img src='/openclinic/_img/icon_search.gif' id='buttonUnit' class='link' alt='Choisir'onclick='openPopup("/_common/search/searchServiceStock.jsp&ts=<%=getTs()%>&ReturnServiceStockUidField=finddocumentdestination&ReturnServiceStockNameField=finddocumentdestinationtext");'>&nbsp;<img src='/openclinic/_img/icon_delete.gif' class='link' alt='Vider' onclick="document.getElementsByName('finddocumentdestination')[0].value='';document.getElementsByName('finddocumentdestinationtext')[0].value='';">
						                <input type="hidden" name="finddocumentdestination" id="finddocumentdestination" VALUE="">
									</td>
								</tr>
								<tr>
									<td class="admin" width="1%" nowrap><%=getTran("web","period",sWebLanguage) %>&nbsp;</td>
									<td class="admin2"><%=getTran("web", "from", sWebLanguage) %> <%=writeDateField("finddocumentmindate","searchForm",sFindMinDate,sWebLanguage) %> <%=getTran("web", "to", sWebLanguage) %> <%=writeDateField("finddocumentmaxdate","searchForm",sFindMaxDate,sWebLanguage) %></td>
								</tr>
								<tr>
									<td class="admin" width="1%" nowrap><%=getTran("web","documentreference",sWebLanguage) %>&nbsp;</td>
									<td class="admin2"><input type="text" class="text" name="finddocumentreference" id="finddocumentreference" value="<%=sFindReference%>" size="50"/></td>
								</tr>
							</table>
								
			            	<%-- BUTTONS --%>
			            	<div style="padding-top:3px;padding-left:1px;">
								<input type="submit" class="button" name="submitfind" value="<%=getTran("web","find",sWebLanguage)%>"/>
								<input type="button" class="button" name="submitnew" value="<%=getTran("web","new",sWebLanguage)%>" onclick="document.getElementById('formaction').value='new';searchForm.submit();"/>
								<input type="button" class="button" name="clear" value="<%=getTran("web","clear",sWebLanguage)%>" onclick="clearFindFields();"/>
							</div>
								
							<input type='hidden' name='formaction' id='formaction' value='find'/>
						</form>
					</td>
				</tr>
				
				<%-- LIST FOUND DOCUMENTS --%>
				<tr>
					<td>
					    <br>
						<table class="list" width="100%" cellpadding="0" cellspacing="1">
						<%
							Vector documents = OperationDocument.find(sFindType,sFindSource,sFindDestination,sFindMinDate,sFindMaxDate,sFindReference,"OC_DOCUMENT_DATE DESC, OC_DOCUMENT_OBJECTID DESC");
							if(documents.size()>0){
								%>
									<tr class='admin' style="padding-left:0">
										<td></td>
										<td><%=getTran("web","ID",sWebLanguage)%>&nbsp;</td>
										<td><%=getTran("web","date",sWebLanguage)%>&nbsp;</td>
										<td><%=getTran("web","type",sWebLanguage)%>&nbsp;</td>
										<td><%=getTran("web","source",sWebLanguage)%>&nbsp;</td>
										<td><%=getTran("web","destination",sWebLanguage)%>&nbsp;</td>
										<td><%=getTran("web","documentreference",sWebLanguage)%>&nbsp;</td>
									</tr>
								<%
							}
						
							for(int n=0;n<documents.size();n++){
								OperationDocument document = (OperationDocument)documents.elementAt(n);
								sType=checkString(document.getType());
								
								if(document.getSourceuid().length()>0){
									sSource=document.getSourceName(sWebLanguage);
								}
								else {
									sSource="";
								}
								
								if(document.getDestinationuid().length()>0){
									sDestination=document.getDestination().getName();
								}
								else {
									sDestination="";
								}
								
								if(document.getDate()!=null){
									sDate=ScreenHelper.stdDateFormat.format(document.getDate());
								}
								else {
									sDate="";
								}
								
								sComment=checkString(document.getComment());
								sReference=checkString(document.getReference());
								
								// display one document
								out.println("<tr class='listText'>"+
								             "<td><input type='button' class='button' value='"+getTran("web","select",sWebLanguage)+"' onclick='selectDocument(\""+document.getUid()+"\",\""+getTran("operationdocumenttypes",sType,sWebLanguage)+"\",\""+document.getDestinationuid()+"\",\""+sDestination+"\",\""+sSource+"\");'/></td>"+
								             "<td>"+document.getUid()+"</td>"+
								             "<td><a href='javascript:editDocument(\""+document.getUid()+"\");'>"+sDate+"</a></td>"+
								             "<td>"+getTran("operationdocumenttypes",sType,sWebLanguage)+"</td>"+
								             "<td>"+sSource+"</td>"+
								             "<td>"+sDestination+"</td>"+
								             "<td>"+sReference+"</td>"+
								            "</tr>");
							}
						%>
						</table>
					</td>
				</tr>
			</table>
		<%		
	}
	else if(sAction.equalsIgnoreCase("new") || sAction.equalsIgnoreCase("edit")){ 
		if(sAction.equalsIgnoreCase("edit")){
			operationDocument = OperationDocument.get(sUid);
		}
		
		%>
		<form name="editForm" method="get" action="<c:url value="/popup.jsp"/>">
			<input type="hidden" name="ReturnDocumentID" value="<%=sReturnDocumentID %>"/>
			<input type="hidden" name="ReturnDocumentName" value="<%=sReturnDocumentName %>"/>
			<input type="hidden" name="ReturnDestinationID" value="<%=sReturnDestinationID %>"/>
			<input type="hidden" name="ReturnDestinationName" value="<%=sReturnDestinationName %>"/>
			<input type="hidden" name="Page" value="_common/search/searchStockOperationDocument.jsp"/>
			<input type="hidden" name="documentuid" value="<%=sUid %>"/>
			
		    <table class="list" width="100%" cellpadding="0" cellspacing="1">
				<tr class="admin" style="padding-left:0">
					<td colspan="2"><%=getTran("web","editoperationdocument",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class="admin"><%=getTran("web","type",sWebLanguage) %> *</td>
					<td class="admin2">
						<select name="documenttype" id="documenttype" class="text">
							<%=ScreenHelper.writeSelect("operationdocumenttypes", operationDocument.getType(), sWebLanguage) %>
						</select>
					</td>
				</tr>
				<tr>
					<td class="admin"><%=getTran("web","source",sWebLanguage) %> *</td>
					<td class="admin2">
		                <input class='text' type="text" name="documentsourcetext" readonly size="50" TITLE="" VALUE="<%=operationDocument.getSourceuid().length()>0?operationDocument.getSourceName(sWebLanguage):"" %>" onchange="">
		                <img src='/openclinic/_img/icon_search.gif' id='buttonUnit' class='link' alt='Choisir'onclick='findsource("documentsource","documentsourcetext");'>&nbsp;<img src='/openclinic/_img/icon_delete.gif' class='link' alt='Vider' onclick="document.getElementsByName('documentsource')[0].value='';document.getElementsByName('documentsourcetext')[0].value='';">
		                <input type="hidden" name="documentsource" id="documentsource" VALUE="<%=operationDocument.getSourceuid()%>">
					</td>
				</tr>
				<tr>
					<td class="admin"><%=getTran("web","destination",sWebLanguage) %> *</td>
					<td class="admin2">
		                <input class='text' type="text" name="documentdestinationtext" readonly size="50" TITLE="" VALUE="<%=operationDocument.getDestinationuid().length()>0?operationDocument.getDestination().getName():"" %>" onchange="">
		                <img src='/openclinic/_img/icon_search.gif' id='buttonUnit' class='link' alt='Choisir'onclick='openPopup("/_common/search/searchServiceStock.jsp&ts=<%=getTs()%>&ReturnServiceStockUidField=documentdestination&ReturnServiceStockNameField=documentdestinationtext");'>&nbsp;<img src='/openclinic/_img/icon_delete.gif' class='link' alt='Vider' onclick="document.getElementsByName('documentdestination')[0].value='';document.getElementsByName('documentdestinationtext')[0].value='';">
		                <input type="hidden" name="documentdestination" id="documentdestination" VALUE="<%=operationDocument.getDestinationuid()%>">
					</td>
				</tr>
				<tr>
					<td class="admin"><%=getTran("web","date",sWebLanguage) %> *</td>
					<td class="admin2"><%=writeDateField("documentdate","editForm",operationDocument.getDate()!=null?ScreenHelper.stdDateFormat.format(operationDocument.getDate()):"",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class="admin"><%=getTran("web","documentcomment",sWebLanguage) %>&nbsp;</td>
					<td class="admin2"><textarea class="text" name="documentcomment" id="documentcomment" cols="50"><%=operationDocument.getComment()%></textarea></td>
				</tr>
				<tr>
					<td class="admin"><%=getTran("web","documentreference",sWebLanguage) %>&nbsp;</td>
					<td class="admin2"><input type="text" class="text" name="documentreference" id="documentreference" value="<%=operationDocument.getReference()%>" size="50"/></td>
				</tr>
			</table>
			
			<%-- BUTTONS --%>
	        <div style="padding-top:3px;padding-left:1px;">
				<input type="button" class="button" name="submitsave" value="<%=getTran("web","save",sWebLanguage)%>" onclick="saveForm();"/>
				<input type="button" class="button" name="cancel" value="<%=getTran("web","cancel",sWebLanguage)%>" onclick="findDocument('<%=sUid%>')"/>
			</div>
			
			<input type='hidden' name='formaction' id='formaction' value=''/>
		</form>		
		<%
	}
%>

<script>
  resizeTo(600,400);
  
	function saveForm(){
		if(document.getElementById("documentdate").value.length>0 && document.getElementById("documentsource").value.length>0 && document.getElementById("documentdestination").value.length>0 ){
			document.getElementById('formaction').value='save';
			editForm.submit();
		}
		else {
            alertDialog("web.manage","datamissing");
		}
	}
	
	function editDocument(uid){
		window.location.href='<c:url value="/popup.jsp"/>?Page=_common/search/searchStockOperationDocument.jsp&ts=<%=getTs()%>&doaction=edit&documentuid='+uid+'&ReturnDocumentID=<%=sReturnDocumentID%>&ReturnDocumentName=<%=sReturnDocumentName%>&ReturnDestinationID=<%=sReturnDestinationID%>&ReturnDestinationName=<%=sReturnDestinationName%>&ReturnSourceName=<%=sReturnSourceName%>';	
	}
	
	function findDocument(uid){
		window.location.href='<c:url value="/popup.jsp"/>?Page=_common/search/searchStockOperationDocument.jsp&ts=<%=getTs()%>&doaction=find&documentuid='+uid+'&ReturnDocumentID=<%=sReturnDocumentID%>&ReturnDocumentName=<%=sReturnDocumentName%>&ReturnDestinationID=<%=sReturnDestinationID%>&ReturnDestinationName=<%=sReturnDestinationName%>&ReturnSourceName=<%=sReturnSourceName%>';	
	}
	
	function selectDocument(documentuid,documentuidtext,destinationuid,destinationuidtext,sourceuidtext){
		if('<%=sReturnDocumentID%>'.length>0){
			window.opener.document.getElementById('<%=sReturnDocumentID%>').value=documentuid;
		}
		if('<%=sReturnDocumentName%>'.length>0){
			window.opener.document.getElementById('<%=sReturnDocumentName%>').innerHTML=documentuidtext;
		}
		if('<%=sReturnDestinationID%>'.length>0){
			window.opener.document.getElementById('<%=sReturnDestinationID%>').value=destinationuid;
		}
		if('<%=sReturnDestinationName%>'.length>0){
			window.opener.document.getElementById('<%=sReturnDestinationName%>').value=destinationuidtext;
		}
		if('<%=sReturnSourceName%>'.length>0){
			window.opener.document.getElementById('<%=sReturnSourceName%>').value=sourceuidtext;
		}
		window.close();
	}
	
    function findsource(sourceid,sourcename){
    	if('<%=MedwanQuery.getInstance().getConfigString("stockOperationDocumentServiceSources","")%>'.indexOf('*'+document.getElementById("documenttype").options[document.getElementById("documenttype").selectedIndex].value+'*')>-1){
			openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+sourceid+"&VarText="+sourcename);
		}
		else {
			openPopup("/_common/search/searchServiceStock.jsp&ts=<%=getTs()%>&ReturnServiceStockUidField="+sourceid+"&ReturnServiceStockNameField="+sourcename);
		}
    }

    function findsearchsource(sourceid,sourcename){
    	if('<%=MedwanQuery.getInstance().getConfigString("stockOperationDocumentServiceSources","")%>'.indexOf('*'+document.getElementById("finddocumenttype").options[document.getElementById("finddocumenttype").selectedIndex].value+'*')>-1){
			openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+sourceid+"&VarText="+sourcename);
		}
		else {
			openPopup("/_common/search/searchServiceStock.jsp&ts=<%=getTs()%>&ReturnServiceStockUidField="+sourceid+"&ReturnServiceStockNameField="+sourcename);
		}
    }
    
	function clearFindFields(){
		document.getElementById("finddocumenttype").selectedIndex=0;
		document.getElementById("finddocumentsourcetext").value='';
		document.getElementById("finddocumentsource").value='';
		document.getElementById("finddocumentdestinationtext").value='';
		document.getElementById("finddocumentdestination").value='';
		document.getElementById("finddocumentmindate").value='';
		document.getElementById("finddocumentmaxdate").value='';
		document.getElementById("finddocumentreference").value='';
	}
</script>