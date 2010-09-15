<%@ page import="be.openclinic.finance.Wicket,java.util.Vector" %>
<%@ page import="be.openclinic.finance.Insurar" %>
<%@ page import="be.openclinic.finance.InsuranceCategory" %>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<%
    String sFindInsurarName = checkString(request.getParameter("FindInsurarName"));
    String sVarCode = checkString(request.getParameter("VarCode"));
    String sVarText = checkString(request.getParameter("VarText"));
    String sVarCat = checkString(request.getParameter("VarCat"));
    String sVarTyp = checkString(request.getParameter("VarTyp"));
    String sVarTypName = checkString(request.getParameter("VarTypName"));
    String sVarCompUID = checkString(request.getParameter("VarCompUID"));

%>
<form name='SearchForm' method="POST" onSubmit="doFind();return false;" onsubmit="doFind();return false;">
    <input type="hidden" name="VarCode" value="<%=sVarCode%>">
    <input type="hidden" name="VarText" value="<%=sVarText%>">
    <input type="hidden" name="VarCat" value="<%=sVarCat%>">
    <table width='100%' border='0' cellspacing='0' cellpadding='0' class='menu'>
        <%-- search fields row 1 --%>
        <%-- service --%>
        <%
            if (!"false".equalsIgnoreCase(request.getParameter("header"))) {
        %>
        <tr>
            <td><%=getTran("Web", "insurar", sWebLanguage)%>
            </td>
            <td>
                <input class="text" type="text" name="FindInsurarName" size="<%=sTextWidth%>"
                       value="<%=sFindInsurarName%>">
            </td>
        </tr>
        <tr height='25'>
            <td/>
            <td>
                <%-- BUTTONS --%>
                <input class="button" type="button" onClick="doFind();" name="findButton"
                       value="<%=getTran("Web","find",sWebLanguage)%>">
                <input class="button" type="button" onClick="clearFields();" name="clearButton"
                       value="<%=getTran("Web","clear",sWebLanguage)%>">&nbsp;
            </td>
        </tr>
        <%
            }
        %>
        <%-- SEARCH RESULTS TABLE --%>
        <tr>
            <td valign="top" colspan="3" align="center" class="white" width="100%">
                <div id="divFindRecords">
                </div>
            </td>
        </tr>
    </table>
    <br>

    <%-- CLOSE BUTTON --%>
    <center>
        <input type="button" class="button" name="buttonclose" value='<%=getTran("Web","Close",sWebLanguage)%>'
               onclick='window.close()'>
    </center>

    <script>
        window.resizeTo(500, 510);

        <%-- CLEAR FIELDS --%>
        function clearFields() {
            SearchForm.FindInsurarName.value = "";
        }

        <%-- DO FIND --%>
        function doFind() {
            ajaxChangeSearchResults('_common/search/searchByAjax/searchInsuranceCategoryShow.jsp', SearchForm);
        }

        <%-- SET BALANCE --%>
        function setInsuranceCategory(sInsuranceCategoryLetter, sInsurarUID, sInsurarName, sInsuranceCategory, sInsuranceType, sInsuranceTypeName) {
            window.opener.document.all['<%=sVarCode%>'].value = sInsuranceCategoryLetter;

            if ('<%=sVarText%>' != '') {
                window.opener.document.all['<%=sVarText%>'].value = sInsurarName;
            }

            if ('<%=sVarCompUID%>' != '') {
                window.opener.document.all['<%=sVarCompUID%>'].value = sInsurarUID;
            }

            if ('<%=sVarCat%>' != '') {
                window.opener.document.all['<%=sVarCat%>'].value = sInsuranceCategory;
            }

            if ('<%=sVarTyp%>' != '') {
                window.opener.document.all['<%=sVarTyp%>'].value = sInsuranceType;
            }

            if ('<%=sVarTypName%>' != '') {
                window.opener.document.all['<%=sVarTypName%>'].value = sInsuranceTypeName;
            }

            window.close();
        }
        window.setTimeout("document.all['FindInsurarName'].focus();document.all['FindInsurarName'].select();", 100);

    </script>
</form>
