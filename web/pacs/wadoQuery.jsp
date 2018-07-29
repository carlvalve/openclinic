<%@ page import="be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %><?xml version="1.0" encoding="utf-8"?>
<%
	String server=(request.getProtocol().toLowerCase().startsWith("https")?"https":"http")+"://"+ request.getServerName()+":"+request.getServerPort();
	String wadoid=ScreenHelper.checkString(request.getParameter("wadouid"));
	String studyuid=MedwanQuery.getInstance().getConfigString(wadoid);
%>
<wado_query wadoURL="<%=server%><%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/<%=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_url","scan")%>/<%=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"%>">
	<Patient>
				<%
					//assemble filelist
					try{
						Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
						String[] activestudyuid=studyuid.split("@")[0].split("\\_");
						String[] activeseriesid=studyuid.split("@")[1].split("\\_");
						for(int n = 0;n<activestudyuid.length;n++){
							System.out.println("n="+n);
							%>
							<Study StudyInstanceUID="<%=activestudyuid[n]%>">
								<Series SeriesInstanceUID="<%=activestudyuid[n]+"."+activeseriesid[n] %>" SeriesNumber="<%=n%>">
							<%
							System.out.println("looking for study "+activestudyuid[n]+ " / "+activeseriesid[n]);
							String sQuery="select * from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=? order by OC_PACS_SEQUENCE";
							if(activeseriesid[n].length()==0){
								sQuery="select * from OC_PACS where OC_PACS_STUDYUID=? order by OC_PACS_SEQUENCE";
							}
							PreparedStatement ps =conn.prepareStatement(sQuery);
							ps.setString(1, activestudyuid[n]);
							if(activeseriesid[n].length()>0){
								ps.setString(2, activeseriesid[n]);
							}
							ResultSet rs =ps.executeQuery();
							int counter=0;
							while(rs.next()){
								out.println("<Instance SOPInstanceUID='"+n+"."+(counter++)+"' DirectDownloadFile='"+rs.getString("OC_PACS_FILENAME")+"' InstanceNumber='"+n+"'/>");
							}
							rs.close();
							ps.close();
							%>
								</Series>
							</Study>
							<%
						}
						conn.close();
					}
					catch(Exception e){
						e.printStackTrace();
					}
				%>
	</Patient>
</wado_query>
<%out.flush(); %>
