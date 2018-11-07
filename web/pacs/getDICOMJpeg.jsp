<%@page import="java.sql.*,java.io.*,javax.imageio.*,java.util.*"%><%@page import="be.mxs.common.util.db.MedwanQuery"%><%@page import="be.openclinic.archiving.*"%><%
try{
	String uid = request.getParameter("uid");
	response.setContentType("application/octet-stream");
	ServletOutputStream os = response.getOutputStream();
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=? order by OC_PACS_SEQUENCE*1");
	ps.setString(1,uid.split(";")[0]);
	ps.setString(2,uid.split(";")[1]);
	ResultSet rs = ps.executeQuery();
	if(request.getParameter("skipImages")!=null){
		System.out.println("skipping "+Integer.parseInt(request.getParameter("skipImages"))+" images for uid="+uid);
		for(int n=0;n<Integer.parseInt(request.getParameter("skipImages"));n++){
			rs.next();
		}
	}
	if(rs.next()){
		String dicomfile=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"+rs.getString("OC_PACS_FILENAME");
		File dicomFile = new File(dicomfile);
		int n=0;
		while(n<100){
			Thread.sleep(new Double(Math.random()*100).longValue());
			if(session.getAttribute("dicomlocked")==null||new java.util.Date().getTime()-(Long)session.getAttribute("dicomlocked")>2000){
				Thread.sleep(new Double(Math.random()*100).longValue());
				if(session.getAttribute("dicomlocked")==null||new java.util.Date().getTime()-(Long)session.getAttribute("dicomlocked")>2000){
					Thread.sleep(new Double(Math.random()*100).longValue());
					session.setAttribute("dicomlocked",new java.util.Date().getTime());
					ImageIO.scanForPlugins();
					Iterator<ImageReader> iter = ImageIO.getImageReadersByFormatName("DICOM");
					ImageReader reader = iter.next();
					try{
						Dicom.convertDicomToJpegThumbnail(dicomFile , os, reader);
						session.removeAttribute("dicomlocked");
						break;
					}
					catch(ConcurrentModificationException a){
						session.removeAttribute("dicomlocked");
						a.printStackTrace();
					}
				}
			}
			n++;
		}
	}
	rs.close();
	ps.close();
	conn.close();
    os.flush();
    os.close();
}
catch(Exception e){
	e.printStackTrace();
}
%>