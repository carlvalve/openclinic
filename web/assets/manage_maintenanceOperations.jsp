<%@page import="be.openclinic.util.Nomenclature"%>
<%@page import="be.openclinic.assets.*,
               java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../assets/includes/commonFunctions.jsp"%>
<%=checkPermission("maintenanceoperations","edit",activeUser)%>

<%=sJSPROTOTYPE%>
<%=sJSNUMBER%> 
<%=sJSSTRINGFUNCTIONS%>
<%=sJSSORTTABLE%>

<%
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n*************** assets/manage_maintenanceOperations.jsp ***************");
        Debug.println("no parameters\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    String sAction= ScreenHelper.checkString(request.getParameter("action"));
    String sPlanUID= ScreenHelper.checkString(request.getParameter("PlanUID"));
    String sAssetUID= ScreenHelper.checkString(request.getParameter("AssetUID"));
    String sAssetCode= ScreenHelper.checkString(request.getParameter("AssetCode"));
    String sOperationUID= ScreenHelper.checkString(request.getParameter("operationUID"));
    String serviceuid = "";
    if(sPlanUID.length()>0){
    	MaintenancePlan plan = MaintenancePlan.get(sPlanUID);
    	if(plan!=null){
    		sAssetUID=plan.getAssetUID();
    		sAssetCode=plan.getAssetCode()+" - "+getTranNoLink("admin.nomenclature.asset",plan.getAssetNomenclature(),sWebLanguage);
    		serviceuid=plan.getAsset().getServiceuid();
    	}
    }
    else if(sAssetUID.length()>0){
    	Asset asset = Asset.get(sAssetUID);
    	if(asset!=null){
    		sAssetCode=asset.getCode()+" - "+getTranNoLink("admin.nomenclature.asset",asset.getNomenclature(),sWebLanguage);
    		serviceuid=asset.getServiceuid();
    	}
    }
	if(serviceuid.length()==0){
		serviceuid=activeUser.getParameter("defaultserviceid");
	}
    
    if(sAction.length()==0){
%>            

		<form name="SearchForm" id="SearchForm" method="POST">
			<input type='hidden' name='action' id='action' value=''/>
			<input type='hidden' name='operationUID' id='operationUID' value=''/>
		    <%=writeTableHeader("web.assets","maintenanceOperations",sWebLanguage,"")%>
		                
		    <table class="list" border="0" width="100%" cellspacing="1">
		        <%-- search SERVICE --%>    
		        <tr>     
		            <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%>&nbsp;</td>
		           	<td class="admin2">
		                <input type="hidden" name="serviceuid" id="serviceuid" value="<%=serviceuid%>">
		                <input class="text" type="text" name="servicename" id="servicename" readonly size="50" value="<%=getTranNoLink("service",serviceuid,sWebLanguage)%>" >
		                <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('serviceuid','servicename');">
					</td>
				</tr>
		        <%-- search ASSET --%>    
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","asset",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		                <input type="hidden" name="searchAssetUID" id="searchAssetUID" value="<%=sAssetUID%>">
		                <input type="text" class="text" id="searchAssetCode" name="searchAssetCode" size="50" readonly value="<%=sAssetCode%>">
		                                   
		                <%-- buttons --%>
		                <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectAsset('searchAssetUID','searchAssetCode');">
		                <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="SearchForm.searchAssetUID.value='';SearchForm.searchAssetCode.value='';">
		                <img src="<c:url value="/_img/icons/icon_view.gif"/>" class="link" alt="<%=getTranNoLink("web","view",sWebLanguage)%>" onclick="viewAsset();">
		            </td>
		        </tr>  

		        <%-- search maintenance PLAN --%>
		        <tr>
		            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web.assets","maintenancePlan",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		                <input type="hidden" name="searchMaintenancePlanUID" id="searchMaintenancePlanUID" value="<%=sPlanUID%>">
		                <input type="text" class="text" id="searchMaintenancePlanName" name="searchMaintenancePlanName" size="50" readonly value="">
		                                   
		                <%-- buttons --%>
		                <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectMaintenancePlan('searchMaintenancePlanUID','searchMaintenancePlanName');">
		                <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearMaintenancePlanSearchFields();">
		                <img src="<c:url value="/_img/icons/icon_view.gif"/>" class="link" alt="<%=getTranNoLink("web","view",sWebLanguage)%>" onclick="viewPlan();">
		            </td>
		        </tr>   
		        
		        <%-- search PERIOD PERFORMED --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","periodPerformed",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		                <%=writeDateField("searchPeriodPerformedBegin","SearchForm","",sWebLanguage)%>&nbsp;&nbsp;<%=getTran(request,"web","until",sWebLanguage)%>&nbsp;&nbsp; 
		                <%=writeDateField("searchPeriodPerformedEnd","SearchForm","",sWebLanguage)%>            
		            </td>                        
		        </tr>        
		        
		        <%-- search OPERATOR (person) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","operator",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		                <input type="text" class="text" id="searchOperator" name="searchOperator" size="40" maxLength="50" value="">
		            </td>
		        </tr>     
		        
		        <%-- search RESULT --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","result",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">                
		                <select class="text" id="searchResult" name="searchResult">
		                    <option/>
		                    <%=ScreenHelper.writeSelect(request,"assets.maintenanceoperations.result","",sWebLanguage)%>
		                </select>
		            </td>
		        </tr>
		                    
		        <%-- search BUTTONS --%>
		        <tr>     
		            <td class="admin"/>
		            <td class="admin2" colspan="2">
		                <input class="button" type="button" name="buttonSearch" id="buttonSearch" value="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="searchMaintenanceOperations();">&nbsp;
		                <input class="button" type="button" name="buttonClear" id="buttonClear" value="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearSearchFields();">&nbsp;
		                <input class="button" type="button" name="buttonNew" id="buttonNew" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onclick="newOperation();">&nbsp;
		            </td>
		        </tr>
		    </table>
		</form>
		<div id="divMaintenanceOperations" class="searchResults" style="width:100%;height:360px;"></div>
	<%
		if(sPlanUID.length()>0 || sAssetUID.length()>0){
	%>
		<script>
			  SearchForm.searchMaintenancePlanUID.value='<%=sPlanUID%>';
			  SearchForm.searchMaintenancePlanName.value='<%=MaintenancePlan.get(sPlanUID)==null?"":MaintenancePlan.get(sPlanUID).name%>';
			  window.setTimeout("searchMaintenanceOperations();",500);
		</script>
	<%
		}
	}
	%>
	
<script>
  SearchForm.searchMaintenancePlanName.focus();

  function newOperation(){
		document.getElementById("action").value="new";
		SearchForm.submit();
  	}
	function viewAsset(){
		if(document.getElementById("assetUID") && document.getElementById("assetUID").value.length>0){
			window.location.href='<c:url value="/main.do?Page=assets/manage_assets.jsp&action=edit&EditAssetUID="/>'+document.getElementById("assetUID").value;
		}
		else if(document.getElementById("searchAssetUID") && document.getElementById("searchAssetUID").value.length>0){
			window.location.href='<c:url value="/main.do?Page=assets/manage_assets.jsp&action=edit&EditAssetUID="/>'+document.getElementById("searchAssetUID").value;
		}
	}
  function selectAsset(uidField,codeField){
	    var url = "/_common/search/searchAsset.jsp&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=500"+
				  "&ReturnFieldUid="+uidField+
	              "&ReturnFieldCode="+codeField;
	    openPopup(url);
	    document.getElementById(codeField).focus();
	  }  
  <%-- CLEAR MAINTENANCE PLAN SEARCH FIELDS --%>
  function clearMaintenancePlanSearchFields(){
    $("searchMaintenancePlanUID").value = "";
    $("searchMaintenancePlanName").value = "";
    
    $("searchMaintenancePlanName").focus();
  }
  
  <%-- SEARCH MAINTENANCE OPERATIONS --%>
  function searchMaintenanceOperations(){
	var okToSearch = true;
	
    <%-- periodBegin can not be after periodEnd --%>
    if(document.getElementById("searchPeriodPerformedEnd").value.length > 0){
      var periodBegin = makeDate(document.getElementById("searchPeriodPerformedBegin").value),
          periodEnd   = makeDate(document.getElementById("searchPeriodPerformedEnd").value);
        
      if(periodBegin > periodEnd){
    	okToSearch = false;
        alertDialog("web","beginMustComeBeforeEnd");
        document.getElementById("searchPeriodPerformedBegin").focus();
      }  
    }
      
    if(okToSearch==true){
      document.getElementById("divMaintenanceOperations").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Searching";            
      var url = "<c:url value='/assets/ajax/maintenanceOperation/getMaintenanceOperations.jsp'/>?ts="+new Date().getTime();
      new Ajax.Request(url,
        {
          method: "GET",
          parameters: "planUID="+encodeURIComponent(SearchForm.searchMaintenancePlanUID.value)+
			          "&serviceuid="+encodeURIComponent(SearchForm.serviceuid.value)+
			          "&assetuid="+encodeURIComponent(SearchForm.searchAssetUID.value)+
			          "&periodPerformedBegin="+encodeURIComponent(SearchForm.searchPeriodPerformedBegin.value)+
                      "&periodPerformedEnd="+encodeURIComponent(SearchForm.searchPeriodPerformedEnd.value)+
                      "&operator="+encodeURIComponent(SearchForm.searchOperator.value)+
                      "&result="+encodeURIComponent(SearchForm.searchResult.value),
          onSuccess: function(resp){
            $("divMaintenanceOperations").innerHTML = resp.responseText;
            sortables_init();
          },
          onFailure: function(resp){
            $("divMessage").innerHTML = "Error in 'assets/ajax/maintenanceOperation/getMaintenanceOperations.jsp' : "+resp.responseText.trim();
          }
        }
      );
    }
  }
  
  <%-- CLEAR SEARCH FIELDS --%>
  function clearSearchFields(){
    clearMaintenancePlanSearchFields();
    document.getElementById("searchPeriodPerformedBegin").value = "";
    document.getElementById("searchPeriodPerformedEnd").value = "";
    document.getElementById("searchOperator").value = "";
    document.getElementById("searchResult").value = "";
    document.getElementById("searchAssetUID").value = "";
    document.getElementById("searchAssetCode").value = "";
    
    resizeAllTextareas(8);
  }
</script>


<%
	MaintenanceOperation operation = null;
	if(sAction.equalsIgnoreCase("new")){
		operation = new MaintenanceOperation();
		operation.setDate(new java.util.Date());
		operation.setMaintenanceplanUID(checkString(request.getParameter("searchMaintenancePlanUID")));
		operation.setPeriodPerformedBegin(ScreenHelper.parseDate(request.getParameter("searchPeriodPerformedBegin")));
		operation.setPeriodPerformedEnd(ScreenHelper.parseDate(request.getParameter("searchPeriodPerformedEnd")));
		operation.setOperator(checkString(request.getParameter("searchOperator")));
		operation.setNextDate(operation.getNextOperationDate());
	}
	else if(sAction.equalsIgnoreCase("edit")){
		operation = MaintenanceOperation.get(sOperationUID);
	}
	
	if(operation!=null){
%>
	    <%=writeTableHeader("web.assets","maintenanceOperations",sWebLanguage,"")%>

		<form name="EditForm" id="EditForm" method="POST">
		    <input type="hidden" id="EditOperationUID" name="EditOperationUID" value="<%=operation.getUid()%>">
		                
		    <table class="list" border="0" width="100%" cellspacing="1">
		        <%-- MAINTENANCE PLAN (*) --%>
		        <tr>
		            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web.assets","maintenancePlan",sWebLanguage)%>&nbsp;*&nbsp;</td>
		            <td class="admin2">
		                <input type="hidden" name="maintenancePlanUID" id="maintenancePlanUID" value="<%=operation.getMaintenanceplanUID()%>">
		                <input type="text" class="text" id="maintenancePlanName" name="maintenancePlanName" size="50" readonly value="<%=operation.getMaintenancePlan().getName()%>">
		                                   
		                <%-- buttons --%>
		                <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectMaintenancePlan('maintenancePlanUID','maintenancePlanName');">
		                <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearMaintenancePlanFields();">
		                <img src="<c:url value="/_img/icons/icon_view.gif"/>" class="link" alt="<%=getTranNoLink("web","view",sWebLanguage)%>" onclick="viewPlan();">
		            </td>
		        </tr>   
		        
		        <%-- DATE (*) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","date",sWebLanguage)%>&nbsp;*&nbsp;</td>
		            <td class="admin2">
		                <%=writeDateField("date","EditForm",ScreenHelper.formatDate(operation.getDate()),sWebLanguage)%>
		            </td>
		        </tr> 
		            
		        <%-- OPERATOR (*) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","operator",sWebLanguage)%>&nbsp;*&nbsp;</td>
		            <td class="admin2">
		                <input type="text" class="text" id="operator" name="operator" size="40" maxLength="50" value="<%=operation.getOperator()%>">
		            </td>
		        </tr>      
		        
		        <%-- operator (person) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","externalsupplier",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2" colspan="3">
		                <input type="text" class="text" id="supplier" name="supplier" size="40" maxLength="50" value="<%=operation.getSupplier()%>">
		            	<!-- Structured field
		                <input type="hidden" name="supplier" id="supplier" value="<%=checkString(operation.getSupplier())%>">
		                <%
		                	String supplier="";
		                	if(checkString(operation.getSupplier()).length()>0){
			                	Supplier supplier2 = Supplier.get(operation.getSupplier());
			                	if(supplier2!=null){
			                		supplier=supplier2.getName();
			                	}
		                	}
		                %>
		                <input type="text" class="text" name="searchSupplierName" id="searchSupplierName" readonly size="60" value="<%=supplier%>">
		                   
		                <%-- buttons --%>
		                <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectSupplier('supplier','searchSupplierName');">
		                <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="EditForm.supplier.value='';EditForm.searchSupplierName.value='';">
						-->
		            </td>
		        </tr>  
		       
		        <%-- RESULT (*) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","result",sWebLanguage)%>&nbsp;*&nbsp;</td>
		            <td class="admin2">                
		                <select class="text" id="result" name="result">
		                    <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
		                    <%=ScreenHelper.writeSelect(request,"assets.maintenanceoperations.result",checkString(operation.getResult()),sWebLanguage)%>
		                </select>
		            </td>
		        </tr>
		        
		        <%-- COMMENT --%>                
		        <tr>
		            <td class="admin"><%=getTran(request,"web","comment",sWebLanguage)%></td>
		            <td class="admin2">
		                <textarea class="text" name="comment" id="comment" cols="80" rows="4" onKeyup="resizeTextarea(this,8);limitChars(this,255);"><%=operation.getComment() %></textarea>
		            </td>
		        </tr>
		               
		        <%-- NEXT DATE --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","nextMaintenanceDate",sWebLanguage)%></td>
		            <td class="admin2">
		                <%=writeDateField("nextDate","EditForm",ScreenHelper.formatDate(operation.getNextDate()),sWebLanguage)%>
		            </td>
		        </tr>                    
		            
		        <%-- BUTTONS --%>
		        <tr>     
		            <td class="admin"/>
		            <td class="admin2" colspan="2">
		                <input class="button" type="button" name="buttonSave" id="buttonSave" value="<%=getTranNoLink("web","save",sWebLanguage)%>" onclick="saveMaintenanceOperation();">&nbsp;
		                <input class="button" type="button" name="buttonDelete" id="buttonDelete" value="<%=getTranNoLink("web","delete",sWebLanguage)%>" onclick="deleteMaintenanceOperation();">&nbsp;
		                <input class="button" type="button" name="buttonList" id="buttonList" value="<%=getTranNoLink("web","list",sWebLanguage)%>" onclick="listMaintenanceOperations();">&nbsp;
		                <input class="button" type="button" name="buttonDocuments" id="buttonDocuments" value="<%=getTranNoLink("web","documents",sWebLanguage)%>" onclick="printWordDocuments();">&nbsp;
		            </td>
		        </tr>
		    </table>
		    <i><%=getTran(request,"web","colored_fields_are_obligate",sWebLanguage)%></i>
		    
		    <div id="divMessage" style="padding-top:10px;"></div>
		</form>
<%
		session.setAttribute("activeMaintenancePlan", operation.getMaintenancePlan());
		session.setAttribute("activeMaintenanceOperation", operation);
		if(operation.getMaintenancePlan()!=null){
			session.setAttribute("activeAsset", operation.getMaintenancePlan().getAsset());
		}
	}
%>    
<script>
  function selectSupplier(uidField,nameField){
    var url = "/_common/search/searchSupplier.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=400"+
              "&ReturnFieldUid="+uidField+
              "&ReturnFieldName="+nameField;
    openPopup(url);
    document.getElementById(nameField).focus();
  }
  <%-- SELECT MAINTENANCE PLAN --%>
  function selectMaintenancePlan(uidField,codeField){
    var url = "/_common/search/searchMaintenancePlan.jsp&ts=<%=getTs()%>&Action=search&PopupWidth=600&PopupHeight=400"+
		      (document.getElementById("searchAssetUID")?"&searchAssetUID="+document.getElementById("searchAssetUID").value+
		      "&searchAssetCode="+document.getElementById("searchAssetCode").value:"")+
   		      "&ReturnFieldUid="+uidField+
              "&ReturnFieldCode="+codeField;
    openPopup(url);
    document.getElementById(codeField).focus();
  }  
  function searchService(serviceUidField,serviceNameField){
	  	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	  	document.getElementById(serviceNameField).focus();
	    }
  <%-- SAVE MAINTENANCE OPERATION --%>
  function saveMaintenanceOperation(){
    var okToSubmit = true;
    
    <%-- check required fields --%>
    if(requiredFieldsProvided()){    	
      <%-- date can not be after nextDate --%>
      if(document.getElementById("nextDate").value.length > 0){
        var periodBegin = makeDate(document.getElementById("date").value),
            periodEnd   = makeDate(document.getElementById("nextDate").value);
            
        if(periodBegin > periodEnd){
        	okToSubmit = false;
          alertDialog("web","beginMustComeBeforeEnd");
          document.getElementById("date").focus();
        }  
      }
          
      if(okToSubmit==true){
        document.getElementById("divMessage").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Saving";  
        
        var sParams = "EditOperationUID="+EditForm.EditOperationUID.value+
                      "&maintenancePlanUID="+EditForm.maintenancePlanUID.value+
                      "&date="+EditForm.date.value+
                      "&operator="+EditForm.operator.value+
                      "&supplier="+EditForm.supplier.value+
                      "&result="+EditForm.result.value+
                      "&comment="+EditForm.comment.value+
                      "&nextDate="+EditForm.nextDate.value;

        var url = "<c:url value='/assets/ajax/maintenanceOperation/saveMaintenanceOperation.jsp'/>?ts="+new Date().getTime();
        new Ajax.Request(url,{
          method: "POST",
          postBody: sParams,                   
          onSuccess: function(resp){
            var data = eval("("+resp.responseText+")");
            $("divMessage").innerHTML = data.message;
			window.location.href='<c:url value="/main.do?Page=assets/manage_maintenanceOperations.jsp&PlanUID="/>'+EditForm.maintenancePlanUID.value;
          },
          onFailure: function(resp){
            $("divMessage").innerHTML = "Error in 'assets/ajax/maintenanceOperation/saveMaintenanceOperation.jsp' : "+resp.responseText.trim();
          }
        });
      }
    }
    else{
      alertDialog("web.manage","dataMissing");
      
      <%-- focus empty field --%>
           if(document.getElementById("maintenancePlanName").value.length==0) document.getElementById("maintenancePlanName").focus(); 
      else if(document.getElementById("date").value.length==0) document.getElementById("date").focus(); 
      else if(document.getElementById("operator").value.length==0) document.getElementById("operator").focus(); 
      else if(document.getElementById("result").value.length==0) document.getElementById("result").focus();          
    }
  }

  function viewPlan(){
	  if(document.getElementById('EditForm') && document.getElementById('maintenancePlanUID').value.length>0){
		  window.location.href='<c:url value="/main.do?Page=assets/manage_maintenancePlans.jsp&action=edit&EditPlanUID="/>'+EditForm.maintenancePlanUID.value;
	  }
	  else if(document.getElementById('SearchForm') && document.getElementById('searchMaintenancePlanUID').value.length>0){
		  window.location.href='<c:url value="/main.do?Page=assets/manage_maintenancePlans.jsp&action=edit&EditPlanUID="/>'+SearchForm.searchMaintenancePlanUID.value;
	  }
  }
  function listMaintenanceOperations(){
	  window.location.href='<c:url value="/main.do?Page=assets/manage_maintenanceOperations.jsp&PlanUID="/>'+EditForm.maintenancePlanUID.value;
  }
  
  <%-- REQUIRED FIELDS PROVIDED --%>
  function requiredFieldsProvided(){
    return (document.getElementById("maintenancePlanUID").value.length > 0 &&
            document.getElementById("date").value.length > 0 &&
            document.getElementById("operator").value.length > 0 &&
            document.getElementById("result").selectedIndex > 0);
  }
  
  <%-- LOAD MAINTENANCE OPERATIONS --%>
  function loadMaintenanceOperations(){
    document.getElementById("divMaintenanceOperations").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";            
    var url = "<c:url value='/assets/ajax/maintenanceOperation/getMaintenanceOperations.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      method: "GET",
      parameters: "",
      onSuccess: function(resp){
        $("divMaintenanceOperations").innerHTML = resp.responseText;
        sortables_init();
      },
      onFailure: function(resp){
        $("divMessage").innerHTML = "Error in 'assets/ajax/maintenanceOperation/getMaintenanceOperations.jsp' : "+resp.responseText.trim();
      }
    });
  }

  <%-- DISPLAY MAINTENANCE OPERATION --%>
  function displayMaintenanceOperation(operationUID){
	  document.getElementById("action").value="edit";
	  document.getElementById("operationUID").value=operationUID;
	  SearchForm.submit();
  }
  
  <%-- DELETE MAINTENANCE OPERATION --%>
  function deleteMaintenanceOperation(){
      if(yesnoDeleteDialog()){
      
      var url = "<c:url value='/assets/ajax/maintenanceOperation/deleteMaintenanceOperation.jsp'/>?ts="+new Date().getTime();
      new Ajax.Request(url,{
        method: "GET",
        parameters: "OperationUID="+document.getElementById("EditOperationUID").value,
        onSuccess: function(resp){
          var data = eval("("+resp.responseText+")");
          $("divMessage").innerHTML = data.message;
          listMaintenanceOperations();
        },
        onFailure: function(resp){
          $("divMessage").innerHTML = "Error in 'assets/ajax/maintenanceOperation/deleteMaintenanceOperation.jsp' : "+resp.responseText.trim();
        }  
      });
    }
  }

  <%-- NEW MAINTENANCE OPERATION --%>
  function newMaintenanceOperation(){                   
    <%-- hide irrelevant buttons --%>
    document.getElementById("buttonDelete").style.visibility = "hidden";
    document.getElementById("buttonNew").style.visibility = "hidden";

    $("EditOperationUID").value = "-1";  
    $("maintenancePlanUID").value = "";
    $("maintenancePlanName").value = "";
    $("date").value = "";
    $("operator").value = "";
    $("result").selectedIndex = 0;
    $("comment").value = "";
    $("nextDate").value = "";
    
    $("maintenancePlanName").focus();
    resizeAllTextareas(8);
  }
  
  <%-- DISABLE BUTTONS --%>
  function disableButtons(){
    document.getElementById("buttonSave").disabled = true;
    document.getElementById("buttonDelete").disabled = true;
    document.getElementById("buttonNew").disabled = true;
  }
  
  <%-- ENABLE BUTTONS --%>
  function enableButtons(){
    document.getElementById("buttonSave").disabled = false;
    document.getElementById("buttonDelete").disabled = false;
    document.getElementById("buttonNew").disabled = false;
  }
  
  <%-- CLEAR MAINTENANCE PLAN FIELDS --%>
  function clearMaintenancePlanFields(){
    $("maintenancePlanUID").value = "";
    $("maintenancePlanName").value = "";
    
    $("maintenancePlanName").focus();
  }
            
  //EditForm.maintenancePlanName.focus();
  //loadMaintenanceOperations();
  resizeAllTextareas(8);
  
</script>
<%=sJSBUTTONS%>
