<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>' onclick="setSaveButton();" onkeyup="setSaveButton();">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

    <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>

    <input type="hidden" name="subClass" value="ORL"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/healthrecord/editTransaction.do?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_RAS" property="itemId"/>]>.value" value="medwan.common.false"/>

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
        <td><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL",sWebLanguage)%></td>
        <td align="right" width="20%">
            <%=getLabel(request,"Web.Occup","medwan.common.nothing-to-mention",sWebLanguage,"orl-c1")%>&nbsp;<input name="orl-ras" type="checkbox" id="orl-c1" value="medwan.common.true" onclick="if (this.checked == true) {hide('ORL-details');setTrue('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_RAS" property="itemId"/>'); } else {show('ORL-details');setFalse('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_RAS" property="itemId"/>'); }">
        </td>
        <td align="right" width ="1%"><a href="#top" class="topbutton">&nbsp;</a></td>
    </tr>
    <tr id="ORL-details" style="display:none" width="100%">
        <td colspan="4" width="100%">
            <table width="100%" cellspacing="1">
                <tr class="admin">
                    <td colspan="4"><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_ORL_ANAMNESIS_OTITIS")%> type="checkbox" id="orl-c2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_OTITIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_OTITIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.otite",sWebLanguage,"orl-c2")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_ORL_ANAMNESIS_DRAINS")%> type="checkbox" id="orl-c3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_DRAINS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_DRAINS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.drains",sWebLanguage,"orl-c3")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_ORL_ANAMNESIS_ACOUPHENE")%> type="checkbox" id="orl-c4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_ACOUPHENE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_ACOUPHENE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.acouphene",sWebLanguage,"orl-c4")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_ORL_ANAMNESIS_AUDITIVE_LOSS")%> type="checkbox" id="orl-c5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_AUDITIVE_LOSS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_AUDITIVE_LOSS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.perte-auditive",sWebLanguage,"orl-c5")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_ANAMNESIS_EQUILIBRE_DISORDER")%> type="checkbox" id="orl-c6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_EQUILIBRE_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_EQUILIBRE_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.trouble-equilibre",sWebLanguage,"orl-c6")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_ANAMNESIS_NASAL_THROWING")%> type="checkbox" id="orl-c7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_NASAL_THROWING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_NASAL_THROWING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.jetage-nasal",sWebLanguage,"orl-c7")%></td>
                    <td class="admin2" colspan="2"><input <%=setRightClick("ITEM_TYPE_ORL_ANAMNESIS_APHONIE")%> type="checkbox" id="orl-c8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_APHONIE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_ANAMNESIS_APHONIE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.aphonie",sWebLanguage,"orl-c8")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4" width="100%"><%=getTran(request,"Web.Occup","medwan.healthrecord.clinical-examination",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.ganglions-lymphatiques",sWebLanguage)%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_GANGLIA_SUBMAXILLARY")%> type="checkbox" id="orl-c9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_GANGLIA_SUBMAXILLARY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_GANGLIA_SUBMAXILLARY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.ganglions-lymphatiques.sous-maxillaires",sWebLanguage,"orl-c9")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_GANGLIA_NECK")%> type="checkbox" id="orl-c10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_GANGLIA_NECK" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_GANGLIA_NECK;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.ganglions-lymphatiques.cou",sWebLanguage,"orl-c10")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_RETRO_AURICULAR")%> type="checkbox" id="orl-c11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_RETRO_AURICULAR" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_CLINICAL_EXAMINATION_LYMPHATIC_RETRO_AURICULAR;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.ganglions-lymphatiques.retro-auriculaires",sWebLanguage,"orl-c11")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4"><%=getTran(request,"Web.Occup","medwan.healthrecord.diagnose",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.otite-externe",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_EXTERNA_RIGHT")%> type="checkbox" id="orl-c12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_EXTERNA_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_EXTERNA_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c12")%>
                        <input type="checkbox" id="orl-c13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_EXTERNA_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_EXTERNA_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c13")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.otite-interne",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_INTERNA_RIGHT")%> type="checkbox" id="orl-c14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_INTERNA_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_INTERNA_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c14")%>
                        <input type="checkbox" id="orl-c15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_INTERNA_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTITIS_INTERNA_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c15")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.tympan-perfore",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_TYMPAN_PERFORATION_RIGHT")%> type="checkbox" id="orl-c16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_TYMPAN_PERFORATION_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_TYMPAN_PERFORATION_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c16")%>
                        <input type="checkbox" id="orl-c17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_TYMPAN_PERFORATION_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_TYMPAN_PERFORATION_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c17")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.bouchon-de-cerumen",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_CERUMEN_RIGHT")%> type="checkbox" id="orl-c18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_CERUMEN_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_CERUMEN_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c18")%>
                        <input type="checkbox" id="orl-c19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_CERUMEN_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_CERUMEN_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c19")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.drains",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_DRAINS_RIGHT")%> type="checkbox" id="orl-c20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_DRAINS_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_DRAINS_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c20")%>
                        <input type="checkbox" id="orl-c21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_DRAINS_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_DRAINS_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c21")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.cholesteatome",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_CHOLESTEATOME_RIGHT")%> type="checkbox" id="orl-c22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_CHOLESTEATOME_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_CHOLESTEATOME_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c22")%>
                        <input type="checkbox" id="orl-c23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_CHOLESTEATOME_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_CHOLESTEATOME_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c23")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.otosclerose",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_OTOSCLEROSIS_RIGHT")%> type="checkbox" id="orl-c24" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTOSCLEROSIS_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTOSCLEROSIS_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c24")%>
                        <input type="checkbox" id="orl-c25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTOSCLEROSIS_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTOSCLEROSIS_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c25")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.perte-auditive",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_AUDIOMETRY_RIGHT_LOSS")%> type="checkbox" id="orl-c26" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_AUDIOMETRY_RIGHT_LOSS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_AUDIOMETRY_RIGHT_LOSS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c26")%>
                        <input type="checkbox" id="orl-c27" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_AUDIOMETRY_LEFT_LOSS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_AUDIOMETRY_LEFT_LOSS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c27")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.surdite-professionnelle",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_PROFESSIONAL_DEAFNESS_RIGHT")%> type="checkbox" id="orl-c28" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_PROFESSIONAL_DEAFNESS_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_PROFESSIONAL_DEAFNESS_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c28")%>
                        <input type="checkbox" id="orl-c29" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_PROFESSIONAL_DEAFNESS_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_PROFESSIONAL_DEAFNESS_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c29")%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.ORL.hypoacousie",sWebLanguage)%></td>
                    <td class="admin2">
                        <input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_HYPOACCUSY_RIGHT")%> type="checkbox" id="orl-c30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_HYPOACCUSY_RIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_HYPOACCUSY_RIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.right",sWebLanguage,"orl-c30")%>
                        <input type="checkbox" id="orl-c31" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_HYPOACCUSY_LEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_HYPOACCUSY_LEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.common.left",sWebLanguage,"orl-c31")%>
                    </td>
                </tr>
                <tr><td>&nbsp;</td></tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_SINUSITIS")%> type="checkbox" id="orl-c32" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_SINUSITIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_SINUSITIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.sinusite",sWebLanguage,"orl-c32")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_LABYRINT_SYNDROME")%> type="checkbox" id="orl-c33" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_LABYRINT_SYNDROME" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_LABYRINT_SYNDROME;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.labyrinthopathie",sWebLanguage,"orl-c33")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_RHINITIS")%> type="checkbox" id="orl-c34" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_RHINITIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_RHINITIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.rhinite",sWebLanguage,"orl-c34")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_MENIERE")%> type="checkbox" id="orl-c35" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_MENIERE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_MENIERE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.maladie-de-meniere",sWebLanguage,"orl-c35")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_PHARYNGITIS")%> type="checkbox" id="orl-c36" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_PHARYNGITIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_PHARYNGITIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.pharyngite",sWebLanguage,"orl-c36")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_ADENOID_VEGETATIONS")%> type="checkbox" id="orl-c37" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_ADENOID_VEGETATIONS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_ADENOID_VEGETATIONS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.hypertrophie-des-amygdales",sWebLanguage,"orl-c37")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_NASAL_SEPTUM_DEVIATION")%> type="checkbox" id="orl-c38" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_NASAL_SEPTUM_DEVIATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_NASAL_SEPTUM_DEVIATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.deviation-cloison-nasale",sWebLanguage,"orl-c38")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_DENTAL_CARE_NEEDED")%> type="checkbox" id="orl-c39" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_DENTAL_CARE_NEEDED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_DENTAL_CARE_NEEDED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.dents-a-soigner",sWebLanguage,"orl-c39")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_DENTAL_PROSTHESIS")%> type="checkbox" id="orl-c40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_DENTAL_PROSTHESIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_DENTAL_PROSTHESIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.prothese-dentaire",sWebLanguage,"orl-c40")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_VOCAL_CORD_TUMOR")%> type="checkbox" id="orl-c41" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_VOCAL_CORD_TUMOR" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_VOCAL_CORD_TUMOR;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.tumeur-corde-vocale",sWebLanguage,"orl-c41")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_PHARYNX_TUMOR")%> type="checkbox" id="orl-c42" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_PHARYNX_TUMOR" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_PHARYNX_TUMOR;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.tumeur-gorge",sWebLanguage,"orl-c42")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_OTHER_TUMOR")%> type="checkbox" id="orl-c43" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTHER_TUMOR" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTHER_TUMOR;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"Web.Occup","medwan.healthrecord.ORL.autre-tumeur",sWebLanguage,"orl-c43")%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.common.remark",sWebLanguage)%></td>
                    <td class="admin2" colspan="3">
                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick("ITEM_TYPE_ORL_DIAGNOSIS_OTHER")%> class="text" rows="2" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ORL_DIAGNOSIS_OTHER" property="value"/></textarea>
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

  document.getElementsByName('orl-ras')[0].onclick();
</script>

</form>
<%=writeJSButtons("transactionForm", "document.getElementsByName('save')[0]")%>