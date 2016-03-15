<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width='100%'>
<%
    String sInsurarUid = checkString(request.getParameter("EditInsurarUID"));
	if(sInsurarUid.length()>0){
		Insurar insurar = Insurar.get(sInsurarUid);
		if(insurar!=null){
			//First print all linked prestations
			HashSet prestations = insurar.getPrestations();
			if(prestations.size()>0){
				out.println("<tr class='admin'><td colspan='6'>"+getTran("web","linkedprestations",sWebLanguage)+" "+insurar.getName()+"</td></tr></table><table id='searchresults' class='sortable' width='100%'>");
				out.println("<tr class='admin'><td/>");
				out.println("<td>"+getTran("web","code",sWebLanguage)+"</td>");
				out.println("<td>"+getTran("web","prestation",sWebLanguage)+"</td>");
				out.println("<td>"+getTran("web","type",sWebLanguage)+"</td>");
				out.println("<td>"+getTran("web","invoicegroup",sWebLanguage)+"</td>");
				out.println("<td>"+getTran("web","class",sWebLanguage)+"</td></tr>");
				Iterator iPrestations = prestations.iterator();
				while(iPrestations.hasNext()){
					Prestation prestation = Prestation.get((String)iPrestations.next());
					if(prestation!=null){
						out.println("<tr><td class='admin'><input type='checkbox' checked name='cb."+prestation.getUid()+"' value='1'/></td>");
						out.println("<td class='admin2'>"+prestation.getCode()+"</td>");
						out.println("<td class='admin2'>"+prestation.getDescription()+"</td>");
						out.println("<td class='admin2'>"+checkString(prestation.getType())+"</td>");
						out.println("<td class='admin2'>"+checkString(prestation.getInvoiceGroup())+"</td>");
						out.println("<td class='admin2'>"+getTran("prestation.class",checkString(prestation.getPrestationClass()),sWebLanguage)+"</td></tr>");
					}
				}
				out.println("</tbody></table><table width='100%'>");
			}
			//Then print the other prestations
			boolean bFirstOther=false;
			Vector otherprestations=Prestation.getAllPrestations();
			for(int n=0;n<otherprestations.size();n++){
				Prestation prestation = (Prestation)otherprestations.elementAt(n);
				if(!prestations.contains(prestation.getUid())){
					if(!bFirstOther){
						bFirstOther=true;
						out.println("<tr class='admin'><td colspan='6'>"+getTran("web","nonlinkedprestations",sWebLanguage)+"</td></tr></table><table id='searchresults2' class='sortable' width='100%'>");
						out.println("<tr class='admin'><td/>");
						out.println("<td>"+getTran("web","code",sWebLanguage)+"</td>");
						out.println("<td>"+getTran("web","prestation",sWebLanguage)+"</td>");
						out.println("<td>"+getTran("web","type",sWebLanguage)+"</td>");
						out.println("<td>"+getTran("web","invoicegroup",sWebLanguage)+"</td>");
						out.println("<td>"+getTran("web","class",sWebLanguage)+"</td></tr>");
					}
					out.println("<tr><td class='admin'><input type='checkbox' name='cb."+prestation.getUid()+"' value='1'/></td>");
					out.println("<td class='admin2'>"+prestation.getCode()+"</td>");
					out.println("<td class='admin2'>"+prestation.getDescription()+"</td>");
					out.println("<td class='admin2'>"+checkString(prestation.getType())+"</td>");
					out.println("<td class='admin2'>"+checkString(prestation.getInvoiceGroup())+"</td>");
					out.println("<td class='admin2'>"+getTran("prestation.class",checkString(prestation.getPrestationClass()),sWebLanguage)+"</td></tr>");
				}
			}
		}
	}
	
%>
</table>
<script>sortables_init();</script>