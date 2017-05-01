<%@page import="be.openclinic.assets.Asset,
                be.mxs.common.util.system.HTMLEntities,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../../../assets/includes/commonFunctions.jsp"%>

<%
    String sPatientId = checkString(request.getParameter("PatientId"));

    // search-criteria
    String sCode                = checkString(request.getParameter("code")),
           sNomenclatureCode    = checkString(request.getParameter("nomenclature")),
           sCompNomenclatureCode    = checkString(request.getParameter("compnomenclature")),
           sServiceUid		    = checkString(request.getParameter("serviceuid")),
           sDescription         = checkString(request.getParameter("description")),
           sSerialnumber        = checkString(request.getParameter("serialnumber")),
           sAssetStatus         = checkString(request.getParameter("assetStatus")),
           sComponentStatus         = checkString(request.getParameter("componentStatus")),
           sSupplierUID         = checkString(request.getParameter("supplierUID")),
           sShowInactive        = checkString(request.getParameter("showinactive")),
           sPurchasePeriodBegin = checkString(request.getParameter("purchasePeriodBegin")),
           sPurchasePeriodEnd   = checkString(request.getParameter("purchasePeriodEnd"));
    
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n******************* assets/ajax/asset/getAssets.jsp *******************");
        Debug.println("sCode         : "+sCode);
        Debug.println("sNomenclature : "+sNomenclatureCode);
        Debug.println("sServiceUid	 : "+sServiceUid);
        Debug.println("sDescription  : "+sDescription);
        Debug.println("sShowInactive : "+sShowInactive);
        Debug.println("sSerialnumber : "+sSerialnumber);
        Debug.println("sAssetStatus  : "+sAssetStatus);
        Debug.println("sSupplierUID  : "+sSupplierUID);
        Debug.println("sPurchasePeriodBegin : "+sPurchasePeriodBegin);
        Debug.println("sPurchasePeriodEnd   : "+sPurchasePeriodEnd+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    // compose object to pass search criteria with
    Asset findObject = new Asset();
    findObject.code = sCode;
    findObject.nomenclature = sNomenclatureCode;
    findObject.description = sDescription;
    findObject.serialnumber = sSerialnumber;
    findObject.comment9 = sAssetStatus;
    findObject.supplierUid = sSupplierUID;
    findObject.serviceuid = sServiceUid;
    findObject.comment15=sCompNomenclatureCode;
    findObject.comment16=sComponentStatus;
    
    if(sPurchasePeriodBegin.length() > 0){
        findObject.purchasePeriodBegin = ScreenHelper.parseDate(sPurchasePeriodBegin);
    }

    if(sPurchasePeriodEnd.length() > 0){    
        findObject.purchasePeriodEnd = ScreenHelper.parseDate(sPurchasePeriodEnd);
    }
    
    List assets = Asset.getList(findObject);
    String sReturn = "";
    
    if(assets.size() > 0){
        Hashtable hSort = new Hashtable();
        Asset asset;
    	int i=0;
        // sort on asset.code
        for(i=0; i<assets.size(); i++){
            asset = (Asset)assets.get(i);
            if(sShowInactive.equalsIgnoreCase("false") && asset.isInactive()){
            	continue;
            }
            boolean bAuthorized=asset.isAuthorizedUser(activeUser.userid);
            if(!bAuthorized && !activeUser.isAdmin()){
            	continue;
            }

            hSort.put(asset.code+"="+asset.getUid(),
                      " onclick=\"displayAsset('"+asset.getUid()+"');\">"+
                      "<td class='hand'>["+asset.getUid()+"] "+asset.code+"</td>"+
                      "<td class='hand'>"+asset.description+"</td>"+
                      "<td class='hand' width='1px' nowrap>"+checkString(asset.nomenclature)+"</td>"+
                      "<td class='hand'>"+getTranNoLink("admin.nomenclature.asset", asset.nomenclature,sWebLanguage)+"</td>"+
                      "<td class='hand'>"+getTranNoLink("service",asset.serviceuid,sWebLanguage)+(!bAuthorized?" <img src='"+sCONTEXTPATH+"/_img/icons/icon_forbidden.png'/>":"")+"</td>"+
                      "<td class='hand'>"+getTranNoLink("assets.status",checkString(asset.comment9),sWebLanguage)+"</td>"+
                      "<td class='hand'>"+ScreenHelper.formatDate(asset.purchaseDate)+"</td>"+
                      (sShowInactive.equalsIgnoreCase("true")?"<td class='hand'>"+ScreenHelper.formatDate(asset.saleDate)+"</td>":"")+
                     "</tr>");
            if(i>MedwanQuery.getInstance().getConfigInt("maxAssetRecords",100)){
            	break;
            }
        }
    
        Vector keys = new Vector(hSort.keySet());
        Collections.sort(keys);
        Iterator iter = keys.iterator();
        String sClass = "1";
        
        while(iter.hasNext()){
            // alternate row-style
            if(sClass.length()==0) sClass = "1";
            else                   sClass = "";
            
            sReturn+= "<tr class='list"+sClass+"' "+hSort.get(iter.next());
        }
        if(i>=MedwanQuery.getInstance().getConfigInt("maxAssetRecords",100)){
            sReturn+= "</table><table><tr><td colspan='6'><i>&gt;"+i+" "+getTran(request,"web","records",sWebLanguage)+"</i></td></tr>";
        }
        else{
        	sReturn+="</table><table><tr><td colspan='6'><i>"+assets.size()+" "+getTran(request,"web","recordsFound",sWebLanguage)+"</i></td></tr>";
        }
        
    }
    else{
        sReturn = "<tr><td colspan='6'>"+getTran(request,"web","noRecordsFound",sWebLanguage)+"</td></tr>";
    }
%>

<%
    if(assets.size() > 0){
        %>
<table width="100%" class="sortable" id="searchresults" cellspacing="1" style="border:none;">
    <%-- header --%>
    <tr class="admin" style="padding-left:1px;">    
        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web","code",sWebLanguage))%></asc></td>
        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web","name",sWebLanguage))%></asc></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","nomenclature",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","label",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","service",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","status",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","purchaseDate",sWebLanguage))%></td>
        <%
        	if(sShowInactive.equalsIgnoreCase("true")){
        %>
		        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","saleDate",sWebLanguage))%></td>
        <%
        	}
        %>
    </tr>
    
    <tbody class="hand">
        <%=sReturn%>
    </tbody>
</table> 

        <%
    }
    else{
        %><%=sReturn%><%
    }
%>