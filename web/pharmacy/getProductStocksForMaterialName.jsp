<%@page import="java.util.*,be.openclinic.pharmacy.*,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
    <%
        String sDrugName      = checkString(request.getParameter("findMaterialName"));

        int iMaxRows = MedwanQuery.getInstance().getConfigInt("MaxSearchFieldsRows",30);
        List lResults = ProductStock.findMaterials(sDrugName);
        int level=0;
        if(lResults.size() > 0){
            Iterator it = lResults.iterator();
            ProductStock productStock;
            
            while(it.hasNext()){
            	productStock = (ProductStock)it.next();
                String name="?";
                if(productStock!=null && productStock.getProduct()!=null){
                	name=productStock.getProduct().getName();
                }
                out.write("<li>");
                level=productStock.getLevel();
                if(level==0){
                	out.write("<font color='lightgray'>"+HTMLEntities.htmlentities(name)+" ("+productStock.getServiceStock().getName()+" - "+level+")</font>");
                }
                else {
                	out.write("<b>"+HTMLEntities.htmlentities(name)+"</b> ("+productStock.getServiceStock().getName()+" - "+level+")");
                }
                out.write("<span style='display:none'>"+productStock.getUid()+"-idcache</span>");
                out.write("</li>");
            }
        }
    %>
</ul>
<%
    boolean hasMoreResults = (lResults.size() >= iMaxRows);
    if(hasMoreResults){
        out.write("<ul id='autocompletion'><li>...</li></ul>");
    }
%>
