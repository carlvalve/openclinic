<%@page import="be.mxs.common.util.tools.sendHtmlMail"%>
<%@page import="com.digitalpersona.uareu.Engine.EnrollmentCallback"%>
<%@page import="be.openclinic.reporting.*,
                java.util.Vector,
                be.mxs.common.util.system.*,
                be.openclinic.finance.*,be.openclinic.pharmacy.*,org.dom4j.*,org.dom4j.io.*,java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Vector receipts = ProductStockOperation.getReceiptsForServiceStock("1.1", ScreenHelper.parseDate("26/09/2016"), new java.util.Date(), "OC_OPERATION_DOCUMENTUID", "ASC");
	try{
	for(int n=0;n<receipts.size();n++){
		ProductStockOperation operation = (ProductStockOperation)receipts.elementAt(n);
		if(operation.getUnitsChanged()!=0){
			String provname="?";
			if(operation.getDocument()!=null && ScreenHelper.checkString(operation.getDocument().getSourceName(sWebLanguage)).length()>0){
				provname=ScreenHelper.checkString(operation.getDocument().getSourceName(sWebLanguage));
				System.out.println(1);
			}
			else{
				provname=operation.getSourceDestinationName(sWebLanguage);
				System.out.println(2);
			}
			System.out.println("provname="+provname+"*");
			if(provname.toLowerCase().contains("6")){
				System.out.println(3);
				String docid="?";
				if(operation.getDocument()!=null){
					docid=operation.getDocument().getUid();
				}
				System.out.println(provname+";"+docid+";"+(operation.getDate()==null?"?":new SimpleDateFormat("yyyyMMdd").format(operation.getDate()))+";"+operation.getUid());
			}
			System.out.println(4);
		}
	}
	}
	catch(Exception e){
		System.out.println(5);
		
	}
%>