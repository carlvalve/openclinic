<%@page import="be.openclinic.system.Screen"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission("occup.pacs","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action="<c:url value='/healthrecord/updateTransaction.do'/>?ts=<%=getTs()%>" focus='type'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>

    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp?ts=<%=getTs()%>"/>
   
    <%=writeTableHeader("web.occup",sPREFIX+"TRANSACTION_TYPE_PACS",sWebLanguage,sCONTEXTPATH+"/main.do?Page=healthrecord/index.jsp&ts="+getTs())%>   
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <% TransactionVO tran = (TransactionVO)transaction; %>
    
    <table class="list" width="100%" cellspacing="1"> 
                
        <%-- date --%>
        <tr>
            <td class="admin">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("web.occup","history",sWebLanguage)%>">...</a>&nbsp;<%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%>&nbsp;*&nbsp;
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" id="trandate" OnBlur="checkDate(this);">
                <script>writeTranDate();</script>
            </td>
            <td class='admin2' rowspan='10' width='30%'>
            	<center><img style='max-width: 300px; max-height: 300px' src='<%=sCONTEXTPATH %>/pacs/getDICOMJpeg.jsp?excludefromFilter=1&uid=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID" property="value"/>;<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID" property="value"/>'/></center>
            </td>
        </tr>
        
        <%-- studyuid --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","studyuid",sWebLanguage)%></td>
            <td class="admin2">
                <input readonly type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID" property="value"/>" size="80">
            </td>
        </tr>
        
        <%-- seriesid --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","seriesid",sWebLanguage)%></td>
            <td class="admin2">
                <input readonly type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID" property="value"/>" size="80">
            </td>
        </tr>
        
        <%-- studydescription --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%></td>
            <td class="admin2">
                <input readonly type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION" property="value"/>" size="80">
            </td>
        </tr>
        
        <%-- studydate --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","studydate",sWebLanguage)%></td>
            <td class="admin2">
                <input readonly type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE" property="value"/>" size="10">
            </td>
        </tr>
        
        <%-- seriesdate --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","seriesdate",sWebLanguage)%></td>
            <td class="admin2">
                <input readonly type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESDATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESDATE" property="value"/>" size="10">
            </td>
        </tr>
        
        <%-- modality --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","modality",sWebLanguage)%></td>
            <td class="admin2">
                <input readonly type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY" property="value"/>" size="80">
            </td>
        </tr>
        
        <%-- patientposition --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","patientposition",sWebLanguage)%></td>
            <td class="admin2">
                <input readonly type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_PATIENTPOSITION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_PATIENTPOSITION" property="value"/>" size="80">
            </td>
        </tr>
        
        <%-- referringphysician --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","referringphysician",sWebLanguage)%></td>
            <td class="admin2">
                <input readonly type="text" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_REFMED" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_REFMED" property="value"/>" size="80">
            </td>
        </tr>
        
        <%-- view --%>
        <tr>
            <td class="admin"></td>
            <td class="admin2">
                <input type='button' name='view' value='<%=getTran(null,"web","view",sWebLanguage)%>' onclick="viewstudy()"/>
            </td>
        </tr>
        
    </table>

</form>

<script>  
  
  <%-- SUBMIT FORM --%>
  function submitForm(){
	  transactionForm.saveButton.disabled = true; 
  	  transactionForm.backButton.disabled = true;
	
      <%
          SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
          out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
      %>
  }
  
  function viewstudy(){
      var url = "<c:url value='/pacs/viewStudy.jsp'/>?studyuid=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID" property="value"/>&seriesid=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID" property="value"/>";
      window.open(url);
  }

</script>

<%=writeJSButtons("transactionForm","saveButton")%>