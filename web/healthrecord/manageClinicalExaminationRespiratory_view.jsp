<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
    
%>
<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>' onclick="setSaveButton();" onkeyup="setSaveButton();">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

    <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>

    <input type="hidden" name="subClass" value="RESPIRATORY"/>
    <input id="transactionType" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/healthrecord/editTransaction.do?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_RAS" property="itemId"/>]>.value" value="medwan.common.false"/>

<script>
  function setTrue(itemType){
    var fieldName;
    fieldName = "currentTransactionVO.items.<ItemVO[hashCode="+itemType+"]>.value";
    document.getElementsByName(fieldName)[0].value = "medwan.common.true";
  }

  function setFalse(itemType){
    var fieldName;
    fieldName = "currentTransactionVO.items.<ItemVO[hashCode="+itemType+"]>.value";
    document.getElementsByName(fieldName)[0].value = "medwan.common.false";
  }
</script>

<table width="100%" cellspacing="0" class="list">
    <tr class="admin">
        <td><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese.respiratoire",sWebLanguage)%></td>
        <td align="right" width="20%">
            <%=getLabel(request,"Web.Occup","medwan.common.nothing-to-mention",sWebLanguage,"resp-c1")%>&nbsp;<input name="respiratory-ras" type="checkbox" id="resp-c1" value="medwan.common.true" onclick="if (this.checked == true) {hide('RESPIRATORY-details');setTrue('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_RAS" property="itemId"/>'); } else {show('RESPIRATORY-details');setFalse('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_RAS" property="itemId"/>'); }">
        </td>
        <td align="right" width ="1%"><a href="#top" class="topbutton">&nbsp;</a></td>
    </tr>
    <tr id="RESPIRATORY-details" style="display:none" width="100%">
        <td colspan="4" width="100%">
            <table width="100%" cellspacing="1">
                <tr class="admin">
                    <td colspan="3"><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2" width="30%"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_ANAMNESIS_COUGH")%> type="checkbox" id="resp-c2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_COUGH" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_COUGH;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.cough",sWebLanguage,"resp-c2")%></td>
                    <td class="admin2" width="30%"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_ANAMNESIS_EXPECTORATIONS")%> type="checkbox" id="resp-c3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_EXPECTORATIONS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_EXPECTORATIONS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.expectorations",sWebLanguage,"resp-c3")%></td>
                    <td class="admin2" width="*"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_ANAMNESIS_HAEMOPTOE")%> type="checkbox" id="resp-c4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_HAEMOPTOE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_HAEMOPTOE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.hemoptoe",sWebLanguage,"resp-c4")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_ANAMNESIS_STRIDA")%> type="checkbox" id="resp-c5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_STRIDA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_STRIDA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.strida",sWebLanguage,"resp-c5")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_ANAMNESIS_THORACALGIA")%> type="checkbox" id="resp-c6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_THORACALGIA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_THORACALGIA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.thoracalgia",sWebLanguage,"resp-c6")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_ANAMNESIS_DYSPNOE")%> type="checkbox" id="resp-c7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_DYSPNOE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_ANAMNESIS_DYSPNOE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.dyspnoe",sWebLanguage,"resp-c7")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="3"><%=getTran(request,"Web.Occup","medwan.healthrecord.clinical-examination",sWebLanguage)%></td>
                </tr>
                <tr class="admin">
                    <td colspan="3">&nbsp; - <%=getTran(request,"Web.Occup","medwan.healthrecord.respiratory.inspection",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PECTUS_EXCAVATUS")%> type="checkbox" id="resp-c8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PECTUS_EXCAVATUS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PECTUS_EXCAVATUS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.pectus-excavatus",sWebLanguage,"resp-c8")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PECTUS_CARINATUS")%> type="checkbox" id="resp-c9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PECTUS_CARINATUS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PECTUS_CARINATUS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.pectus-carinatus",sWebLanguage,"resp-c9")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_BREATHING_PROBLEM")%> type="checkbox" id="resp-c10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_BREATHING_PROBLEM" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_BREATHING_PROBLEM;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.disturbed-respiration",sWebLanguage,"resp-c10")%></td>
                </tr>
                <tr>
                    <td class="admin2" colspan="3"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_THORAX_EXPANSION")%> type="checkbox" id="resp-c11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_THORAX_EXPANSION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_THORAX_EXPANSION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.thorax-expansion",sWebLanguage,"resp-c11")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="3">&nbsp; - <%=getTran(request,"Web.Occup","medwan.healthrecord.respiratory.palpation",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2" colspan="3"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PRESSURE_PAIN")%> type="checkbox" id="resp-c12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PRESSURE_PAIN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PRESSURE_PAIN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.pressure-pain",sWebLanguage,"resp-c12")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="3">&nbsp; - <%=getTran(request,"Web.Occup","medwan.healthrecord.respiratory.auscultation",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_VAG")%> type="checkbox" id="resp-c13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_VAG" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_VAG;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.vag",sWebLanguage,"resp-c13")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_BAG")%> type="checkbox" id="resp-c14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_BAG" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_BAG;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.bag",sWebLanguage,"resp-c14")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_TAG")%> type="checkbox" id="resp-c15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_TAG" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_TAG;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.tag",sWebLanguage,"resp-c15")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_REUTELS")%> type="checkbox" id="resp-c16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_REUTELS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_REUTELS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.reutels",sWebLanguage,"resp-c16")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_WHEEZING")%> type="checkbox" id="resp-c17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_WHEEZING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_WHEEZING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.wheezing",sWebLanguage,"resp-c17")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_CREPITATIONS")%> type="checkbox" id="resp-c18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_CREPITATIONS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_CREPITATIONS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.crepitations",sWebLanguage,"resp-c18")%></td>
                </tr>
                <tr>
                    <td class="admin2" colspan="3"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PLEURAAL_WRIJVEN")%> type="checkbox" id="resp-c19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PLEURAAL_WRIJVEN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_CLINICAL_EXAMINATION_PLEURAAL_WRIJVEN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.pleuraal-wrijven",sWebLanguage,"resp-c19")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="3"><%=getTran(request,"Web.Occup","medwan.healthrecord.diagnose",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_HAY_FEVER")%> type="checkbox" id="resp-c20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_HAY_FEVER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_HAY_FEVER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.hay-fever",sWebLanguage,"resp-c20")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_DISTURBED_LUNG_FUNCTION")%> type="checkbox" id="resp-c21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_DISTURBED_LUNG_FUNCTION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_DISTURBED_LUNG_FUNCTION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.disturbed-lung-function",sWebLanguage,"resp-c21")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_ASBESTOSIS")%> type="checkbox" id="resp-c22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_ASBESTOSIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_ASBESTOSIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.asbestosis",sWebLanguage,"resp-c22")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUBERCULOSIS")%> type="checkbox" id="resp-c23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUBERCULOSIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUBERCULOSIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.tuberculosis",sWebLanguage,"resp-c23")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_SARCOIDOSIS")%> type="checkbox" id="resp-c24" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_SARCOIDOSIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_SARCOIDOSIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.sarcoidosis",sWebLanguage,"resp-c24")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_ABNORMAL_X_RAY")%> type="checkbox" id="resp-c25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_ABNORMAL_X_RAY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_ABNORMAL_X_RAY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.abnormal-x-ray",sWebLanguage,"resp-c25")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_MUCOVISCIDOSIS")%> type="checkbox" id="resp-c26" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_MUCOVISCIDOSIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_MUCOVISCIDOSIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.respiratory.mucoviscidosis",sWebLanguage,"resp-c26")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUMOR_BENIGN")%> type="checkbox" id="resp-c27" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUMOR_BENIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUMOR_BENIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.tumeur.benin",sWebLanguage,"resp-c27")%></td>
                    <td class="admin2"><input <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUMOR_MALIGN")%> type="checkbox" id="resp-c28" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUMOR_MALIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_TUMOR_MALIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.tumeur.malin",sWebLanguage,"resp-c28")%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.common.remark",sWebLanguage)%></td>
                    <td class="admin2" colspan="2">
                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_RESPIRATORY_DIAGNOSIS_OTHER")%> class="text" rows="2" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RESPIRATORY_DIAGNOSIS_OTHER" property="value"/></textarea>
                    </td>
                </tr>
           </table>
        </td>
    </tr>
</table>

<%-- BUTTONS --%>
<p align="right">
    <INPUT class="button" type="button" name="saveButton" onClick="doSubmit();" value="<%=getTranNoLink("Web.Occup","medwan.common.record",sWebLanguage)%>">
    <INPUT class="button" type="button" value="<%=getTranNoLink("Web","Back",sWebLanguage)%>" onclick="if(checkSaveButton()){window.location.href='<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>'}">
    <%=writeResetButton("transactionForm",sWebLanguage)%>
</p>

<script>
  function doSubmit(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
    %>
  }

  document.getElementsByName('respiratory-ras')[0].onclick();
</script>

</form>
<%=writeJSButtons("transactionForm", "document.getElementsByName('save')[0]")%>