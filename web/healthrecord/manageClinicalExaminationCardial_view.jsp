<%@ include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>' onclick="setSaveButton();" onkeyup="setSaveButton();">

    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

    <input type="hidden" name="subClass" value="CARDIAL"/>
    <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input id="transactionType" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/healthrecord/editTransaction.do?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_RAS" property="itemId"/>]>.value" value="medwan.common.false"/>

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

<table width="100%" class="list" cellspacing="0">
    <tr class="admin">
        <td><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial",sWebLanguage)%></td>
        <td align="right" width="20%">
            <%=getLabel(request,"Web.Occup","medwan.common.nothing-to-mention",sWebLanguage,"mcec-c1")%>&nbsp;<input name="cardial-ras" type="checkbox" id="mcec-c1" value="medwan.common.true" onclick="if (this.checked == true) {hide('CARDIAL-details');setTrue('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_RAS" property="itemId"/>'); } else {show('CARDIAL-details');setFalse('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_RAS" property="itemId"/>'); }">
        </td>
        <td align="right" width ="1%"><a href="#top" class="'topbutton'">&nbsp;</a></td>
    </tr>
    <tr id="CARDIAL-details" style="display:none" width="100%">
        <td colspan="4" width="100%">
            <table width="100%" cellspacing="1">
                <tr class="admin">
                    <td colspan="4"><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_ANAMNESIS_EFFORT_DYSPNOE")%> type="checkbox" id="mcec-c2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_EFFORT_DYSPNOE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_EFFORT_DYSPNOE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.dyspnee-effort",sWebLanguage,"mcec-c2")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_ANAMNESIS_ORTHOPNOE")%> type="checkbox" id="mcec-c3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_ORTHOPNOE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_ORTHOPNOE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.orthopnee",sWebLanguage,"mcec-c3")%></td>
                    <td class="admin2" colspan="2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_ANAMNESIS_VERTIGO")%> type="checkbox" id="mcec-c4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_VERTIGO" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_VERTIGO;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.vertige",sWebLanguage,"mcec-c4")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_ANAMNESIS_PALPITATIONS")%> type="checkbox" id="mcec-c5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_PALPITATIONS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_PALPITATIONS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.palpitations",sWebLanguage,"mcec-c5")%></td>
                    <td class="admin2" colspan="3"><input <%=setRightClick("ITEM_TYPE_CARDIAL_ANAMNESIS_PRECORDIALGIA")%> type="checkbox" id="mcec-c6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_PRECORDIALGIA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_ANAMNESIS_PRECORDIALGIA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.precordialgie",sWebLanguage,"mcec-c6")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4"><%=getTran(request,"Web.Occup","medwan.healthrecord.clinical-examination",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2" colspan="4"><input <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_CYANOSIS")%> type="checkbox" id="mcec-c7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_CYANOSIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_CYANOSIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.inspection.cyanose",sWebLanguage,"mcec-c7")%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.auscultation",sWebLanguage)%></td>
                    <td class="admin2" colspan="3">
                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_AUSCULTATION")%> class="text" rows="2" cols="60" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_AUSCULTATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_AUSCULTATION" property="value"/></textarea>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onBlur="isNumber(this);">/min</td>
                    <td class="admin2" colspan="2">
                        <input <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="mcec-r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.regulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.regulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.regulier",sWebLanguage,"mcec-r1")%>
                        <input <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="mcec-r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.irregulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.irregulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.irregulier",sWebLanguage,"mcec-r2")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%></td>
                    <td class="admin2"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-droit",sWebLanguage)%><input <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>">/<input <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>">mmHg</td>
                    <td class="admin2" colspan="2"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-gauche",sWebLanguage)%><input <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="value"/>">/<input <%=setRightClick("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="value"/>">mmHg</td>
                </tr>
                <tr class="admin">
                    <td colspan="4"><%=getTran(request,"Web.Occup","medwan.healthrecord.diagnose",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_ANGINA_PECTORIS")%> type="checkbox" id="mcec-c8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_ANGINA_PECTORIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_ANGINA_PECTORIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.angine-de-poitrine",sWebLanguage,"mcec-c8")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_AMI")%> type="checkbox" id="mcec-c9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_AMI" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_AMI;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.infarctus-aigu-myocarde",sWebLanguage,"mcec-c9")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_CENTRAL_ANEURYSMA")%> type="checkbox" id="mcec-c10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_CENTRAL_ANEURYSMA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_CENTRAL_ANEURYSMA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.anevrysme",sWebLanguage,"mcec-c10")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_PACEMAKER")%> type="checkbox" id="mcec-c11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_PACEMAKER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_PACEMAKER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.pacemaker",sWebLanguage,"mcec-c11")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_HYPOTENSION")%> type="checkbox" id="mcec-c12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_HYPOTENSION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_HYPOTENSION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.hypotension",sWebLanguage,"mcec-c12")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_ABNORMAL_ECG")%> type="checkbox" id="mcec-c13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_ABNORMAL_ECG" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_ABNORMAL_ECG;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.ECG-anormal",sWebLanguage,"mcec-c13")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_CARDIOMYOPATHIA")%> type="checkbox" id="mcec-c14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_CARDIOMYOPATHIA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_CARDIOMYOPATHIA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.cardiomyopathie",sWebLanguage,"mcec-c14")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_VENTRIKEL_SEPTUM_DEFECT")%> type="checkbox" id="mcec-c15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_VENTRIKEL_SEPTUM_DEFECT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_VENTRIKEL_SEPTUM_DEFECT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.defaut-cloisonnement-ventriculaire",sWebLanguage,"mcec-c15")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_ATRIUM_SEPTUM_DEFECT")%> type="checkbox" id="mcec-c16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_ATRIUM_SEPTUM_DEFECT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_ATRIUM_SEPTUM_DEFECT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.defaut-cloisonnement-auriculaire",sWebLanguage,"mcec-c16")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_HEART_DECOMPENSATION")%> type="checkbox" id="mcec-c17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_HEART_DECOMPENSATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_HEART_DECOMPENSATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.insuffisance-cardiaque",sWebLanguage,"mcec-c17")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_CHRONIC_COR_PULMONALE")%> type="checkbox" id="mcec-c18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_CHRONIC_COR_PULMONALE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_CHRONIC_COR_PULMONALE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.cor-pulmonale-chronique",sWebLanguage,"mcec-c18")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_PALPITATIONS")%> type="checkbox" id="mcec-c19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_PALPITATIONS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_PALPITATIONS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.palpitations",sWebLanguage,"mcec-c19")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_ORTHOSTATISMUS")%> type="checkbox" id="mcec-c20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_ORTHOSTATISMUS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_ORTHOSTATISMUS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.orthostatisme",sWebLanguage,"mcec-c20")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_TUMOR_BENIGN")%> type="checkbox" id="mcec-c21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_TUMOR_BENIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_TUMOR_BENIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.tumeur.benin",sWebLanguage,"mcec-c21")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_TUMOR_MALIGN")%> type="checkbox" id="mcec-c22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_TUMOR_MALIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_TUMOR_MALIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.tumeur.malin",sWebLanguage,"mcec-c22")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_HYPERTENSION")%> type="checkbox" id="mcec-c23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_HYPERTENSION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_HYPERTENSION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.hypertension",sWebLanguage,"mcec-c23")%></td>
                </tr>
                <tr>
                    <td class="admin2"><%=getTran(request,"Web.Occup","medwan.common.remark",sWebLanguage)%></td>
                    <td class="admin2" colspan="3">
                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick("ITEM_TYPE_CARDIAL_DIAGNOSIS_OTHER")%> class="text" rows="2" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_DIAGNOSIS_OTHER" property="value"/></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<%-- BUTTONS --%>
<%=ScreenHelper.alignButtonsStart()%>
    <INPUT class="button" type="button" name="saveButton" onClick="doSubmit();" value="<%=getTranNoLink("Web.Occup","medwan.common.record",sWebLanguage)%>">
    <INPUT class="button" type="button" value="<%=getTranNoLink("Web","Back",sWebLanguage)%>" onclick="if(checkSaveButton()){window.location.href='<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>'}">
    <%=writeResetButton("transactionForm",sWebLanguage)%>
<%=ScreenHelper.alignButtonsStop()%>

<script>
  function doSubmit(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
    %>
  }

  document.getElementsByName('cardial-ras')[0].onclick();
</script>

</form>
<%=writeJSButtons("transactionForm", "document.getElementsByName('save')[0]")%>