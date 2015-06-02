<%@page import="java.util.*,be.openclinic.pharmacy.*,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
    <%
        String sDrugName      = checkString(request.getParameter("findDrugName")).toUpperCase(),
               sField     = checkString(request.getParameter("field"));

        int iMaxRows = MedwanQuery.getInstance().getConfigInt("MaxSearchFieldsRows",30);
        List lResults = Product.getLimitedDrugs(sDrugName,iMaxRows);
        String levels="";
        if(lResults.size() > 0){
            Iterator it = lResults.iterator();
            Product product;
            
            while(it.hasNext()){
                product = (Product)it.next();
                
                out.write("<li>");
                levels=product.getAccessibleStockLevels();
                if(levels.equalsIgnoreCase("0/0")){
                	out.write("<font color='lightgray'>"+HTMLEntities.htmlentities(product.getName())+" ("+levels+")</font>");
                }
                else if(levels.indexOf("0/")==0){
                	out.write(HTMLEntities.htmlentities(product.getName())+" ("+levels+")");
                }
                else {
                	out.write("<b>"+HTMLEntities.htmlentities(product.getName())+"</b> ("+levels+")");
                }
                out.write("<span style='display:none'>"+product.getUid()+"-idcache</span>");
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
