<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>' onclick="setSaveButton();" onkeyup="setSaveButton();">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

    <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" name="subClass" value="VISUS"/>
    <input id="transactionType" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/healthrecord/editTransaction.do?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_RAS" property="itemId"/>]>.value" value="medwan.common.false"/>

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
        <td><%=getTran(request,"Web.Occup","medwan.healthrecord.vision",sWebLanguage)%></td>
        <td align="right" width="20%">
            <%=getLabel(request,"Web.Occup","medwan.common.nothing-to-mention",sWebLanguage,"vis-c1")%>&nbsp;<input name="visus-ras" type="checkbox" id="vis-c1" value="medwan.common.true" onclick="if (this.checked == true) {hide('VISUS-details');setTrue('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_RAS" property="itemId"/>'); } else {show('VISUS-details');setFalse('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_RAS" property="itemId"/>'); }">
        </td>
        <td align="right" width ="1%"><a href="#top" class="topbutton">&nbsp;</a></td>
    </tr>
    <tr id="VISUS-details" style="display:none" width="100%">
        <td colspan="4" width="100%">
            <table width="100%" cellspacing="1">
                <tr class="admin">
                    <td colspan="4"><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_MER_SECTION_A_OPTION")%> type="checkbox" id="vis-c2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_ANAMNESIS_RUNNING_EYE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_ANAMNESIS_RUNNING_EYE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.vision.ecoulement-oeuil",sWebLanguage,"vis-c2")%></td>
                    <td class="admin2" colspan="3"><input <%=setRightClick("ITEM_TYPE_MER_SECTION_A_OPTION")%> type="checkbox" id="vis-c3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_ANAMNESIS_STRANGE_CORPUS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_ANAMNESIS_STRANGE_CORPUS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.vision.corps-etranger",sWebLanguage,"vis-c3")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4"><%=getTran(request,"Web.Occup","medwan.healthrecord.diagnose",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin" width="25%"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.acuite-visuelle-insuffisante-de-loin",sWebLanguage)%></td>
                    <td class="admin2" width="25%">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_FAR_RIGHT")%> type="checkbox" id="vis-c4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_FAR_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_FAR_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c4")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_FAR_LEFT")%> type="checkbox" id="vis-c5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_FAR_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_FAR_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c5")%>
                    </td>
                    <td class="admin" width="25%"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.acuite-visuelle-insuffisante-intermediaire",sWebLanguage)%></td>
                    <td class="admin2" width="25%">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_INTERMEDIATE_RIGHT")%> type="checkbox" id="vis-c6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_INTERMEDIATE_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_INTERMEDIATE_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c6")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_INTERMEDIATE_LEFT")%> type="checkbox" id="vis-c7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_INTERMEDIATE_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_INTERMEDIATE_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c7")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.acuite-visuelle-insuffisante-proche",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_NEAR_RIGHT")%> type="checkbox" id="vis-c8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_NEAR_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_NEAR_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c8")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_NEAR_LEFT")%> type="checkbox" id="vis-c9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_NEAR_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_NEAR_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c9")%>
                    </td>
                    <td class="admin2" colspan="2"><input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_WITHOUT_CORRECTION")%> type="checkbox" id="vis-c10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_WITHOUT_CORRECTION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INSUFFICIENT_SHARP_WITHOUT_CORRECTION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.vision.acuite-visuelle-insuffisante-sans-correction-optique",sWebLanguage,"vis-c10")%></td>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.keratotomie",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_RIGHT")%> type="checkbox" id="vis-c11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c11")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LEFT")%> type="checkbox" id="vis-c12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c12")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.keratectomie-laser",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LASER_RIGHT")%> type="checkbox" id="vis-c13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LASER_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LASER_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c13")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LASER_LEFT")%> type="checkbox" id="vis-c14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LASER_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_KERATOTOMIA_LASER_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c14")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.amblyopie",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_AMBLYOPIA_RIGHT")%> type="checkbox" id="vis-c15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_AMBLYOPIA_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_AMBLYOPIA_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c15")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_AMBLYOPIA_LEFT")%> type="checkbox" id="vis-c16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_AMBLYOPIA_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_AMBLYOPIA_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c16")%>
                    </td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_COLOR")%> type="checkbox" id="vis-c17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_COLOR" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_COLOR;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.vision.erreur-couleur",sWebLanguage,"vis-c17")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_STEREOSCOPY")%> type="checkbox" id="vis-c18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_STEREOSCOPY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_STEREOSCOPY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.vision.erreur-stereoscopie",sWebLanguage,"vis-c18")%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.erreur-champs-vision",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_VISUS_AREA_RIGHT")%> type="checkbox" id="vis-c19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_VISUS_AREA_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_VISUS_AREA_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c19")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_VISUS_AREA_LEFT")%> type="checkbox" id="vis-c20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_VISUS_AREA_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ERROR_VISUS_AREA_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c20")%>
                    </td>
                    <td class="admin2" colspan="2"><input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_NIGHTBLINDNESS")%> type="checkbox" id="vis-c21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_NIGHTBLINDNESS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_NIGHTBLINDNESS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.vision.cecite-nocturne",sWebLanguage,"vis-c21")%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.lentille-intra-oculaire",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INTRAOCULAR_LENS_RIGHT")%> type="checkbox" id="vis-c22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INTRAOCULAR_LENS_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INTRAOCULAR_LENS_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c22")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_INTRAOCULAR_LENS_LEFT")%> type="checkbox" id="vis-c23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INTRAOCULAR_LENS_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_INTRAOCULAR_LENS_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c23")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.cataracte",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_CATARACT_RIGHT")%> type="checkbox" id="vis-c24" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_CATARACT_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_CATARACT_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c24")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_CATARACT_LEFT")%> type="checkbox" id="vis-c25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_CATARACT_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_CATARACT_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c25")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.borgne",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_ONE_EYED_RIGHT")%> type="checkbox" id="vis-c26" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ONE_EYED_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ONE_EYED_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c26")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_ONE_EYED_LEFT")%> type="checkbox" id="vis-c27" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ONE_EYED_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ONE_EYED_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c27")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.decollement-retine",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_RETINA_LEFT_RIGHT")%> type="checkbox" id="vis-c28" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_RETINA_LEFT_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_RETINA_LEFT_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c28")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_RETINA_LEFT_LEFT")%> type="checkbox" id="vis-c29" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_RETINA_LEFT_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_RETINA_LEFT_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c29")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.glaucome",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_GLAUCOMA_RIGHT")%> type="checkbox" id="vis-c30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_GLAUCOMA_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_GLAUCOMA_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c30")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_GLAUCOMA_LEFT")%> type="checkbox" id="vis-c31" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_GLAUCOMA_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_GLAUCOMA_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c31")%>
                    </td>
                    <td class="admin2" colspan="2"><input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_STRABISMUS")%> type="checkbox" id="vis-c32" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_STRABISMUS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_STRABISMUS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.vision.strabisme",sWebLanguage,"vis-c32")%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.conjonctivite",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_CONJUNCTIVITIS_RIGHT")%> type="checkbox" id="vis-c33" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_CONJUNCTIVITIS_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_CONJUNCTIVITIS_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c33")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_CONJUNCTIVITIS_LEFT")%> type="checkbox" id="vis-c34" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_CONJUNCTIVITIS_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_CONJUNCTIVITIS_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c34")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.conjonctivite-allergique",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_ALLERGIC_CONJUNCTIVITIS_RIGHT")%> type="checkbox" id="vis-c35" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ALLERGIC_CONJUNCTIVITIS_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ALLERGIC_CONJUNCTIVITIS_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c35")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_ALLERGIC_CONJUNCTIVITIS_LEFT")%> type="checkbox" id="vis-c36" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ALLERGIC_CONJUNCTIVITIS_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_ALLERGIC_CONJUNCTIVITIS_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c36")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.lesion-oeuil",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_EYE_LAESION_RIGHT")%> type="checkbox" id="vis-c37" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_EYE_LAESION_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_EYE_LAESION_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c37")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_EYE_LAESION_LEFT")%> type="checkbox" id="vis-c38" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_EYE_LAESION_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_EYE_LAESION_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c38")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.vision.tumeur",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_TUMOR_RIGHT")%> type="checkbox" id="vis-c39" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_TUMOR_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_TUMOR_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"vis-c39")%>
                        <input <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_TUMOR_LEFT")%> type="checkbox" id="vis-c40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_TUMOR_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_TUMOR_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"vis-c40")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.common.remark",sWebLanguage)%></td>
                    <td class="admin2" colspan="3">
                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick("ITEM_TYPE_VISUS_DIAGNOSIS_OTHER")%> class="text" rows="2" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VISUS_DIAGNOSIS_OTHER" property="value"/></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<%-- BUTTONS --%>
<%=ScreenHelper.alignButtonsStart()%>
    <INPUT class="button" type="button" name="saveButton" onClick="doSubmit();" value="<%=getTranNoLink("Web.Occup","medwan.common.record",sWebLanguage)%>">
    <INPUT class="button" type="button" value="<%=getTranNoLink("Web","Back",sWebLanguage)%>" onclick="if(checkSaveButton()){window.location.href='<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction'}">
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

  document.getElementsByName('visus-ras')[0].onclick();
</script>

</form>
<%=writeJSButtons("transactionForm", "document.getElementsByName('save')[0]")%>