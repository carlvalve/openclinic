<%@page import="java.sql.*,java.io.*"%><%@page import="be.mxs.common.util.db.MedwanQuery"%><%@page import="be.openclinic.archiving.*"%><%
	System.out.println("got it");
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
		System.out.println("Loading "+dicomfile);
		File dicomFile = new File(dicomfile);
		int n=0;
		while(n<100){
			if(session.getAttribute("dicomlocked")==null){
				session.setAttribute("dicomlocked","1");
				Dicom.convertDicomToJpegThumbnail(dicomFile , os);
				break;
			}
			else{
				Thread.sleep(100);
				n++;
			}
		}
		session.removeAttribute("dicomlocked");
	}
	rs.close();
	ps.close();
	conn.close();
    os.flush();
    os.close();

%>