<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>' onclick="setSaveButton();" onkeyup="setSaveButton();">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

    <input type="hidden" name="subClass" value="GENITAL"/>
    <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input id="transactionType" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/healthrecord/editTransaction.do?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_RAS" property="itemId"/>]>.value" value="medwan.common.false"/>

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
        <td><%=getTran("Web.Occup","medwan.healthrecord.anamnese.genital",sWebLanguage)%></td>
        <td align="right" width="20%">
            <%=getLabel("Web.Occup","medwan.common.nothing-to-mention",sWebLanguage,"mcegeni-c1")%>&nbsp;<input name="genital-ras" type="checkbox" id="mcegeni-c1" value="medwan.common.true" onclick="if (this.checked == true) {hide('GENITAL-details');setTrue('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_RAS" property="itemId"/>'); } else {show('GENITAL-details');setFalse('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_RAS" property="itemId"/>'); }">
        </td>
        <td align="right" width ="1%"><a href="#top" class='topbutton'>&nbsp;</a></td>
    </tr>
    <tr id="GENITAL-details" style="display:none" width="100%">
        <td colspan="4" width="100%">
            <table width="100%" cellspacing="1">
                <tr class="admin">
                    <td colspan="4"><%=getTran("Web.Occup","medwan.healthrecord.anamnese",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_ANAMNESIS_WHITE_LOSS")%> type="checkbox" id="mcegeni-c2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_ANAMNESIS_WHITE_LOSS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_ANAMNESIS_WHITE_LOSS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.white-loss",sWebLanguage,"mcegeni-c2")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_ANAMNESIS_CONTINUED_DRIPPING")%> type="checkbox" id="mcegeni-c3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_ANAMNESIS_CONTINUED_DRIPPING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_ANAMNESIS_CONTINUED_DRIPPING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.continued-drip",sWebLanguage,"mcegeni-c3")%></td>
                    <td class="admin2" colspan="2"><input <%=setRightClick("ITEM_TYPE_GENITAL_ANAMNESIS_NIPPLE_LOSS")%> type="checkbox" id="mcegeni-c4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_ANAMNESIS_NIPPLE_LOSS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_ANAMNESIS_NIPPLE_LOSS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.nipple",sWebLanguage,"mcegeni-c4")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4"><%=getTran("Web.Occup","medwan.healthrecord.clinical-examination",sWebLanguage)%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4">&nbsp; - <%=getTran("Web.Occup","medwan.healthrecord.genital.palpation",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2" colspan="4"><input <%=setRightClick("ITEM_TYPE_GENITAL_CLINICAL_EXAMINATION_BREAST_LUMP")%> type="checkbox" id="mcegeni-c5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_CLINICAL_EXAMINATION_BREAST_LUMP" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_CLINICAL_EXAMINATION_BREAST_LUMP;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.breast-lump",sWebLanguage,"mcegeni-c5")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4">&nbsp; - <%=getTran("Web.Occup","medwan.healthrecord.genital.ppa",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2" colspan="4"><input <%=setRightClick("ITEM_TYPE_GENITAL_CLINICAL_EXAMINATION_ENLARGED_PROSTATE")%> type="checkbox" id="mcegeni-c6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_CLINICAL_EXAMINATION_ENLARGED_PROSTATE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_CLINICAL_EXAMINATION_ENLARGED_PROSTATE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.prostate-enlargement",sWebLanguage,"mcegeni-c6")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4"><%=getTran("Web.Occup","medwan.healthrecord.diagnose",sWebLanguage)%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4">&nbsp; - <%=getTran("Web.Occup","medwan.common.tumors",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin" width="25%"><%=getTran("Web.Occup","medwan.common.tumors.breast",sWebLanguage)%></td>
                    <td class="admin2" width="25%">
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BREAST_BENIGN")%> type="checkbox" id="mcegeni-c7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BREAST_BENIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BREAST_BENIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.benign",sWebLanguage,"mcegeni-c7")%>
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BREAST_MALIGNANT")%> type="checkbox" id="mcegeni-c8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BREAST_MALIGNANT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BREAST_MALIGNANT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.malignant",sWebLanguage,"mcegeni-c8")%>
                    </td>
                    <td class="admin" width="25%"><%=getTran("Web.Occup","medwan.common.tumors.ovaria",sWebLanguage)%></td>
                    <td class="admin2" width="25%">
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_OVARIA_BENIGN")%> type="checkbox" id="mcegeni-c9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_OVARIA_BENIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_OVARIA_BENIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.benign",sWebLanguage,"mcegeni-c9")%>
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_OVARIA_MALIGNANT")%> type="checkbox" id="mcegeni-c10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_OVARIA_MALIGNANT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_OVARIA_MALIGNANT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.malignant",sWebLanguage,"mcegeni-c10")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran("Web.Occup","medwan.common.tumors.uterus",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_UTERUS_BENIGN")%> type="checkbox" id="mcegeni-c11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_UTERUS_BENIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_UTERUS_BENIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.benign",sWebLanguage,"mcegeni-c11")%>
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_UTERUS_MALIGNANT")%> type="checkbox" id="mcegeni-c12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_UTERUS_MALIGNANT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_UTERUS_MALIGNANT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.malignant",sWebLanguage,"mcegeni-c12")%>
                    </td>
                    <td class="admin"><%=getTran("Web.Occup","medwan.common.tumors.cervix",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_CERVIX_BENIGN")%> type="checkbox" id="mcegeni-c13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_CERVIX_BENIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_CERVIX_BENIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.benign",sWebLanguage,"mcegeni-c13")%>
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_CERVIX_MALIGNANT")%> type="checkbox" id="mcegeni-c14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_CERVIX_MALIGNANT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_CERVIX_MALIGNANT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.malignant",sWebLanguage,"mcegeni-c14")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran("Web.Occup","medwan.common.tumors",sWebLanguage)%></td>
                    <td class="admin2" colspan="3">
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BENIGN")%> type="checkbox" id="mcegeni-c15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BENIGN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_BENIGN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.benign",sWebLanguage,"mcegeni-c15")%>
                        <input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_MALIGNANT")%> type="checkbox" id="mcegeni-c16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_MALIGNANT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_TUMOR_MALIGNANT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.common.malignant",sWebLanguage,"mcegeni-c16")%>
                    </td>
                </tr>
                <tr class="admin">
                    <td colspan="4">&nbsp; - <%=getTran("Web.Occup","medwan.common.other",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_HYPERTROPHIC_PROSTATE")%> type="checkbox" id="mcegeni-c17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_HYPERTROPHIC_PROSTATE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_HYPERTROPHIC_PROSTATE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.prostate-hypertrophy",sWebLanguage,"mcegeni-c17")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_FERTILITY_DISORDER")%> type="checkbox" id="mcegeni-c18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_FERTILITY_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_FERTILITY_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.fertility-disorders",sWebLanguage,"mcegeni-c18")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_VARICOCOELE")%> type="checkbox" id="mcegeni-c19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_VARICOCOELE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_VARICOCOELE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.varicocoele",sWebLanguage,"mcegeni-c19")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_HYDROCOELE")%> type="checkbox" id="mcegeni-c20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_HYDROCOELE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_HYDROCOELE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.hydrocoele",sWebLanguage,"mcegeni-c20")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GASTRO_DIAGNOSIS_LIVER_STEATOSIS")%> type="checkbox" id="mcegeni-c21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_PROSTATITIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_PROSTATITIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.prostatitis",sWebLanguage,"mcegeni-c21")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_PROSTATITIS")%> type="checkbox" id="mcegeni-c22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_VAGINITIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_VAGINITIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.vaginitis",sWebLanguage,"mcegeni-c22")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_EPIDIDYMITIS_ORCHITIS")%> type="checkbox" id="mcegeni-c23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_EPIDIDYMITIS_ORCHITIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_EPIDIDYMITIS_ORCHITIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.epididimytis-orchites",sWebLanguage,"mcegeni-c23")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_EPIDIDYMIS_CYSTE")%> type="checkbox" id="mcegeni-c24" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_EPIDIDYMIS_CYSTE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_EPIDIDYMIS_CYSTE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.epididymis-cyste",sWebLanguage,"mcegeni-c24")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_RECLUS")%> type="checkbox" id="mcegeni-c25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_RECLUS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_RECLUS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.reclus",sWebLanguage,"mcegeni-c25")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_CYSTE")%> type="checkbox" id="mcegeni-c26" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_CYSTE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_CYSTE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.breast-cyste",sWebLanguage,"mcegeni-c26")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_FIBROADENOMA")%> type="checkbox" id="mcegeni-c27" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_FIBROADENOMA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_FIBROADENOMA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.breast-fibroadenoma",sWebLanguage,"mcegeni-c27")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_MENSTRUATION_DISORDER")%> type="checkbox" id="mcegeni-c28" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_MENSTRUATION_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_MENSTRUATION_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.menstruation-disorders",sWebLanguage,"mcegeni-c28")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_ENDOMETRIOSIS")%> type="checkbox" id="mcegeni-c29" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_ENDOMETRIOSIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_ENDOMETRIOSIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.endometriosis",sWebLanguage,"mcegeni-c29")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_FIBROADENOMA_UTERUS")%> type="checkbox" id="mcegeni-c30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_FIBROADENOMA_UTERUS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_FIBROADENOMA_UTERUS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.uterine-fibro-adenoma",sWebLanguage,"mcegeni-c30")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_OVARIUM_CYSTE")%> type="checkbox" id="mcegeni-c31" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_OVARIUM_CYSTE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_OVARIUM_CYSTE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.ovarium-cyste",sWebLanguage,"mcegeni-c31")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_UTERUS_DISORDER")%> type="checkbox" id="mcegeni-c32" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_UTERUS_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_UTERUS_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.uterine-disorder",sWebLanguage,"mcegeni-c32")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_OVARIA_DISORDER")%> type="checkbox" id="mcegeni-c33" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_OVARIA_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_OVARIA_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.ovarium-disorder",sWebLanguage,"mcegeni-c33")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_FEEDING")%> type="checkbox" id="mcegeni-c34" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_FEEDING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_BREAST_FEEDING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.breast-feeding",sWebLanguage,"mcegeni-c34")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_MENOPAUZE_DISORDER")%> type="checkbox" id="mcegeni-c35" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_MENOPAUZE_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_MENOPAUZE_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.menopausal-disorders",sWebLanguage,"mcegeni-c35")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_PREGNANCY")%> type="checkbox" id="mcegeni-c36" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_PREGNANCY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_PREGNANCY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.pregnancy",sWebLanguage,"mcegeni-c36")%></td>
                </tr>
                <tr>
                    <td class="admin2" colspan="4"><input <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_EXTRA_UTERINE_PREGNANCY")%> type="checkbox" id="mcegeni-c37" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_EXTRA_UTERINE_PREGNANCY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_EXTRA_UTERINE_PREGNANCY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.genital.pregnancy-extrauterine",sWebLanguage,"mcegeni-c37")%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran("Web.Occup","medwan.common.remark",sWebLanguage)%></td>
                    <td class="admin2" colspan="3">
                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick("ITEM_TYPE_GENITAL_DIAGNOSIS_OTHER")%> class="text" rows="2" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_GENITAL_DIAGNOSIS_OTHER" property="value"/></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<%-- BUTTONS --%>
<%=ScreenHelper.alignButtonsStart()%>
    <INPUT class="button" type="button" name="saveButton" onClick="doSubmit();" value="<%=getTran("Web.Occup","medwan.common.record",sWebLanguage)%>">
    <INPUT class="button" type="button" value="<%=getTran("Web","Back",sWebLanguage)%>" onclick="if (checkSaveButton('<%=sCONTEXTPATH%>','<%=getTran("Web.Occup","medwan.common.buttonquestion",sWebLanguage)%>')){window.location.href='<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>'}">
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

  document.getElementsByName('genital-ras')[0].onclick();
</script>

</form>
<%=writeJSButtons("transactionForm", "document.getElementsByName('save')[0]")%>