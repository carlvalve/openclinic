<%@page import="be.openclinic.archiving.ArchiveDocument"%>
<%@page import="be.openclinic.assets.*,be.openclinic.util.*,
                be.mxs.common.util.system.*,be.mxs.common.util.db.*,
                java.util.*"%>
<%@include file="/includes/helper.jsp"%>
<table>
	<%
		String sServer = 	MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_url","scan")+"/"+
	               			MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
		Vector docs = new Vector();
		String sAssetUid = "";
	    if(ScreenHelper.checkString(request.getParameter("assetuid")).length()>0){
	    	sAssetUid = ScreenHelper.checkString(request.getParameter("assetuid"));
			docs = ArchiveDocument.getAllByReference("asset."+sAssetUid);
		    System.out.println(1);
	    }
	    else if(ScreenHelper.checkString(request.getParameter("maintenanceplanuid")).length()>0){
	    	sAssetUid = ScreenHelper.checkString(request.getParameter("maintenanceplanuid"));
			docs = ArchiveDocument.getAllByReference("maintenanceplan."+sAssetUid);
	    }
		for(int n=0;n<docs.size();n++){
			ArchiveDocument doc = (ArchiveDocument)docs.elementAt(n);
			if(doc!=null && ScreenHelper.checkString(doc.storageName).length()>0){
				String extension = "";
				if(doc.storageName.split("\\.").length>1){
					extension="("+doc.storageName.split("\\.")[doc.storageName.split("\\.").length-1].toUpperCase()+")";
				}
				String link="<a target='_new' href='"+sServer+"/"+doc.storageName+"'>"+doc.title+"</a>";
				if(doc.storageName.startsWith("http") || doc.storageName.startsWith("ftp")){
					link="<a target='_new' href='"+doc.storageName+"'>"+doc.title+"</a>";
				}
				out.println("<tr><td width='1%' nowrap><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.gif' onclick='deleteDocument("+doc.getUid().split("\\.")[1]+")'/> "+extension+"</td><td>"+link+"</td></tr>");
			}
		}
	%>
</table>