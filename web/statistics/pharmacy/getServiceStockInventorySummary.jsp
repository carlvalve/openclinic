<%@ page import="be.openclinic.pharmacy.*,java.io.*,be.mxs.common.util.system.*,be.mxs.common.util.pdf.general.*,org.dom4j.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sServiceStockId=checkString(request.getParameter("ServiceStockUid"));
%>
	<form name='transactionForm' method='post'>
		<table width='100%'>
			<tr>
				<td class='admin' width=1% nowrap>
					<%=getTran(request,"web","date",sWebLanguage)%>
				</td>
				<td class='admin2'>
					<%=writeDateField("FindDate", "transactionForm", ScreenHelper.formatDate(new java.util.Date()), sWebLanguage)%>
				</td>
				<td class='admin2' rowspan='3'>
					<input type='button' class="button" name='print' value='<%=getTranNoLink("web","print",sWebLanguage)%>' onclick='printReport();'/>
				</td>
			</tr>
			<tr>
				<td class='admin' width=1% nowrap>
					<%=getTran(request,"web","productgroup",sWebLanguage)%>
				</td>
				<td class='admin2'>
					<select style='width: 500px' class='text' name='productgroup' id='productgroup'>
						<option/>
						<%=ScreenHelper.writeSelect(request, "product.productgroup", "", sWebLanguage) %>
					</select>
				</td>
			</tr>
			<%
            	if(MedwanQuery.getInstance().getConfigInt("showProductCategory",1)==1){
            %>
            <%-- productSubGroup --%>
            <tr>
                <td class="admin" nowrap><%=getTran(request,"Web","productSubGroup",sWebLanguage)%></td>
                <td class="admin2">
		             <input type="text" readonly class="text" name="EditProductSubGroupText" value="" size="80">
		             <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchCategory('EditProductSubGroup','EditProductSubGroupText');">
		             <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="EditProductSubGroup.value='';EditProductSubGroupText.value='';">
		             <input type="hidden" name="EditProductSubGroup" id="EditProductSubGroup" value="" onchange="updateDrugCategoryParents(this.value)">
		             <div name="drugcategorydiv" id="drugcategorydiv"></div>
                </td>
            </tr>
            <%
            	}
			%>
		</table>
	</form>

	<script>
		function printReport(){
			window.open('<c:url value="pharmacy/printServiceStockInventorySummary.jsp"/>?ProductGroup='+document.getElementById('productgroup').value+'&ProductSubGroup='+document.getElementById('EditProductSubGroup').value+'&FindDate='+document.getElementById('FindDate').value+'&ServiceStockUid=<%=sServiceStockId%>');
			window.close();
		}
		
		  <%-- SEARCH CATEGORY --%>
		  function searchCategory(CategoryUidField,CategoryNameField){
		    openPopup("/_common/search/searchDrugCategory.jsp&ts=<%=getTs()%>&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
		  }

		  <%-- UPDATE DRUG CATEGORY PARENTS --%>
		  function updateDrugCategoryParents(code){
		    document.getElementById('drugcategorydiv').innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br/>Loading..";
		    
		    var params = 'code='+code+'&language=<%=sWebLanguage%>';
		    var url = '<c:url value="/pharmacy/updateDrugCategoryParents.jsp"/>?ts='+new Date();
			new Ajax.Request(url,{
		      method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
		        $('drugcategorydiv').innerHTML = resp.responseText;
		      },
			  onFailure: function(resp){
			    $('drugcategorydiv').innerHTML = "";
		      }
			});
		  }

	</script>