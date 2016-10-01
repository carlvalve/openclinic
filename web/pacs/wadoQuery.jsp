<%@ page import="be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %><?xml version="1.0" encoding="utf-8"?>
<%
	String server=(request.getProtocol().toLowerCase().startsWith("https")?"https":"http")+"://"+ request.getServerName()+":"+request.getServerPort();
%>
<wado_query wadoURL="<%=server%><%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/<%=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_url","scan")%>/<%=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"%>">
	<Patient>
		<Study>
			<Series>
				<%
					//assemble filelist
					try{
					    StringBuffer filelist=new StringBuffer();
						Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
						String sQuery="select * from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=? order by OC_PACS_SEQUENCE";
						if(ScreenHelper.checkString(request.getParameter("seriesid")).length()==0){
							sQuery="select * from OC_PACS where OC_PACS_STUDYUID=? order by OC_PACS_SEQUENCE";
						}
						PreparedStatement ps =conn.prepareStatement(sQuery);
						ps.setString(1, ScreenHelper.checkString(request.getParameter("studyuid")));
						if(ScreenHelper.checkString(request.getParameter("seriesid")).length()>0){
							ps.setString(2, ScreenHelper.checkString(request.getParameter("seriesid")));
						}
						ResultSet rs =ps.executeQuery();
						int counter=0;
						while(rs.next()){
							out.println("<Instance SOPInstanceUID='"+(counter++)+"' DirectDownloadFile='"+rs.getString("OC_PACS_FILENAME")+"'/>");
						}
						rs.close();
						ps.close();
						conn.close();
					}
					catch(Exception e){
						e.printStackTrace();
					}
				%>
			</Series>
		</Study>
	</Patient>
</wado_query>
