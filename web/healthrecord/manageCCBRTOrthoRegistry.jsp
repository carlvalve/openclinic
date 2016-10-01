<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission("occup.ccbrt.orthoregistry","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>

        <%-- DESCRIPTION --%>
        <tr>
        	<td width="50%">
	        	<table width='100%'>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.eye","from",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <select id="from" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_FROM" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.eye.from",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_FROM"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin">
			                <%=getTran(request,"ccbrt.eye","attendencytype",sWebLanguage)%>
			            </td>
			            <td class="admin2" colspan="6">
			                <select id="attendencytype" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_ATTENDENCYTYPE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.attendencytype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_ATTENDENCYTYPE"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.ortho","remarks",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="remarks" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick("ITEM_TYPE_CCBRT_ORTHO_REGISTRY_REMARKS")%> class="text" cols='60' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_REMARKS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_REMARKS" property="value"/></textarea>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"ccbrt.ortho","unit",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
							<%
								String serviceid=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_UNIT");
								String servicename="";
								Service service = Service.getService(serviceid);
								if(service!=null){
									servicename=service.getLabel(sWebLanguage);
								}
							%>
							<input type='hidden' id="ccbrtunit" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_UNIT" property="itemId"/>]>.value" value="<%=serviceid%>"/>
							<input type='hidden' id="unit" name="unit" value="<%=serviceid%>">
							<input class='text' type='text' name='unitname' id='unitname' readonly size='40' value="<%=servicename %>">
							<img src='<c:url value="/_img/icons/icon_search.gif"/>' class='link' alt='<%=getTranNoLink("Web","select",sWebLanguage)%>' onclick='searchService("unit","unitname");'>				            
							<img src='<c:url value="/_img/icons/icon_delete.gif"/>' class='link' alt='<%=getTranNoLink("Web","clear",sWebLanguage)%>' onclick='document.getElementById("unit").value="";document.getElementById("unitname").value="";'>				            
						</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.ortho","examiner",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			            	<%
			            		ItemVO item = ((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_USER");
			            		String userid="";
			            		if(item!=null){
			            			userid=item.getValue();
			            		}
			            		
			            	%>
			                <input type="hidden" id="ccbrtuser" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_USER" property="itemId"/>]>.value"/>
			                <input type="hidden" name="diagnosisUser" id="diagnosisUser" value="<%=userid%>">
			                <input class="text" type="text" name="diagnosisUserName" id="diagnosisUserName" readonly size="40" value="<%=User.getFullUserName(userid)%>">
			                <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchUser('diagnosisUser','diagnosisUserName');">
			                <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="document.getElementById('diagnosisUser').value='';document.getElementById('diagnosisUserName').value='';">
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.ortho","followup",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="4">
			            	<select class='text' id='frequency' onchange='calculateNextDate()'>
			            		<option/>
			            		<option value='1'>1</option>
			            		<option value='2'>2</option>
			            		<option value='3'>3</option>
			            		<option value='4'>4</option>
			            		<option value='5'>5</option>
			            		<option value='6'>6</option>
			            		<option value='7'>7</option>
			            		<option value='8'>8</option>
			            		<option value='9'>9</option>
			            		<option value='10'>10</option>
			            		<option value='11'>11</option>
			            		<option value='12'>12</option>
			            	</select>
			            	<select class='text' id='frequencytype' onchange='calculateNextDate()'>
			            		<option/>
			            		<option value='week'><%=getTran(request,"web","weeks",sWebLanguage) %></option>
			            		<option value='month'><%=getTran(request,"web","months",sWebLanguage) %></option>
			            		<option value='year'><%=getTran(request,"web","year",sWebLanguage) %></option>
			            	</select>
			                <input type="hidden" id="ccbrtdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_FOLLOWUPDATE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("followupdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_FOLLOWUPDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
			            </td>
			            <td class="admin2" colspan="2">
			            	<a href="javascript:openPopup('planning/findPlanning.jsp&FindDate='+document.getElementById('followupdate').value+'&isPopup=1&FindUserUID='+document.getElementById('diagnosisUser').value,1024,600,'Agenda','toolbar=no,status=yes,scrollbars=no,resizable=yes,width=1024,height=600,menubar=no');void(0);"><%=getTran(request,"web","findappointment",sWebLanguage) %></a>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.ortho","serviceclassification",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <select id="serviceclassification" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_SERVICECLASSIFICATION" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.serviceclassification",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ORTHO_REGISTRY_SERVICECLASSIFICATION"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
	            </table>
	        </td>
	        <%-- DIAGNOSES --%>
	    	<td class="admin2">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.orthoregistry",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode=currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID" property="itemId"/>]>.value&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if(document.getElementById('encounteruid').value==""){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	

  <%-- SUBMIT FORM --%>
  function calculateNextDate(){
	  var nextdate = new Date();
	  if(document.getElementById('frequencytype').value.length>0 && document.getElementById('frequency').value.length>0){
		  if(document.getElementById('frequencytype').value=='month'){
			  nextdate.setMonth(nextdate.getMonth()+document.getElementById('frequency').value*1);
		  }
		  else if(document.getElementById('frequencytype').value=='year'){
			  nextdate.setYear(nextdate.getFullYear()+document.getElementById('frequency').value*1);
		  }
		  else if(document.getElementById('frequencytype').value=='week'){
			  nextdate.setDate(nextdate.getDate()+document.getElementById('frequency').value*7);
		  }
		  document.getElementById('followupdate').value=("0"+nextdate.getDate()).substring(("0"+nextdate.getDate()).length-2,("0"+nextdate.getDate()).length)+"/"+("0"+(nextdate.getMonth()+1)).substring(("0"+(nextdate.getMonth()+1)).length-2,("0"+(nextdate.getMonth()+1)).length)+"/"+nextdate.getFullYear();
  	 }
  }
  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTOrthoRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }
	function searchService(serviceUidField,serviceNameField){
	    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	    document.getElementsByName(serviceNameField)[0].focus();
	}

  function submitForm(){
	  if(document.getElementById('attendencytype').value.trim().length>0){
		  document.getElementById("ccbrtunit").value=document.getElementById("unit").value;
		  document.getElementById("ccbrtuser").value=document.getElementById("diagnosisUser").value;
		  document.getElementById("ccbrtdate").value=document.getElementById("followupdate").value;
	      transactionForm.saveButton.disabled = true;
  		    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
		    %>
  	  }
	  else {
		  alert('"<%=getTran(null,"ccbrt.eye","attendencytype",sWebLanguage)%>" <%=getTran(null,"web","ismandatory",sWebLanguage)%>')
	  }
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>