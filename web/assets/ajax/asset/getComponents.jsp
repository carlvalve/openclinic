<%@page import="be.openclinic.assets.*,be.openclinic.util.*,
                be.mxs.common.util.system.HTMLEntities,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../../../assets/includes/commonFunctions.jsp"%>
<table width='100%'>
	<%
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps=null;
		ResultSet rs = null;
		String assetuid = checkString(request.getParameter("assetuid"));
		System.out.println("assetuid="+assetuid);
	    String[] sComponents = checkString(request.getParameter("components")).split(";");
	    SortedSet comps = new TreeSet();
		for(int n=0;n<sComponents.length;n++){
			comps.add(sComponents[n]);
		}
		Iterator iComps=comps.iterator();
		while(iComps.hasNext()){
			Nomenclature nomenclature = Nomenclature.get("assetcomponent", (String)iComps.next());
			if(nomenclature!=null){
				out.println("<tr>");
				out.println("<td valign='bottom'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.gif' onclick='deleteComponent(\""+nomenclature.getId()+"\")'/> <img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.gif' onclick='editComponent(\""+assetuid+"."+nomenclature.getId()+"\")'/>"+nomenclature.getId()+" "+nomenclature.getFullyQualifiedName(sWebLanguage)+"</td>");
				//Insert component details here
				ps = conn.prepareStatement("select * from oc_assetcomponents where oc_component_assetuid=? and oc_component_nomenclature=?");
				ps.setString(1,assetuid);
				ps.setString(2,nomenclature.getId());
				rs = ps.executeQuery();
				String type="",status="",characteristics="";
				while(rs.next()){
					if(type.indexOf(checkString(rs.getString("oc_component_type")))<0){
						if(type.length()>0){
							type+=", ";
						}
						type+=checkString(rs.getString("oc_component_type"));
					}
					status=checkString(rs.getString("oc_component_status"));
					if(characteristics.indexOf(checkString(rs.getString("oc_component_characteristics")))<0){
						if(characteristics.length()>0){
							characteristics+=", ";
						}
						characteristics+=checkString(rs.getString("oc_component_characteristics"));
					}
				}
				if(type.length()>0){
					out.println("<td  valign='bottom'><b>"+type+"</b></td>");
					out.println("<td  valign='bottom' nowrap><b>"+getTran(request,"component.status",status,sWebLanguage)+"</b></td>");
					out.println("<td  valign='bottom' ><b>"+characteristics+"</b></td>");
				}
				else{
					out.println("<td colspan='3'/>");
				}
				rs.close();
				ps.close();
				out.println("</tr>");
			}
		}
		conn.close();
	%>
</table>