<%@page import="be.openclinic.assets.Asset,
               java.text.*,java.net.*,java.io.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../assets/includes/commonFunctions.jsp"%>
<%
	Vector assets = new Vector();
	Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from openclinic.cleaned where id>0");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String url = rs.getString("view_degradation2");
		if(url!=null){
			//Store the url to an image file
			//System.out.println("Reading "+url);
			try{
			    String id = rs.getString("id");
			    String shortfilename="0/"+id+".6.jpg";
			    PreparedStatement ps2 = conn.prepareStatement("select * from arch_documents where arch_document_storagename=?");
			    ps2.setString(1,shortfilename);
			    ResultSet rs2=ps2.executeQuery();
			    if(!rs2.next()){
				    URL u = new URL(url);
				    URLConnection uc = u.openConnection();
				    String contentType = uc.getContentType();
				    int contentLength = uc.getContentLength();
				    InputStream raw = uc.getInputStream();
				    InputStream in = new BufferedInputStream(raw);
				    byte[] data = new byte[contentLength];
				    int bytesRead = 0;
				    int offset = 0;
				    while (offset < contentLength) {
				      bytesRead = in.read(data, offset, data.length - offset);
				      if (bytesRead == -1)
				        break;
				      offset += bytesRead;
				    }
				    in.close();				    
				    String filename = "c:/projects/openclinicnew/web/scan/to/"+shortfilename;
				    FileOutputStream sout = new FileOutputStream(filename);
				    sout.write(data);
				    sout.flush();
				    sout.close();					
				    //System.out.println("Stored to "+filename);
				    int documentid=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				    System.out.println("document id = "+documentid+"  id="+id);				   	
				    rs2.close();
				   	ps2.close();
				    ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				    " values(?,?,?,?,?,?,?,?,?,?)");
				    ps2.setString(1,"1");
				    ps2.setString(2,documentid+"");
				    ps2.setString(3,documentid+"");
				    ps2.setString(4,"Dégradation");
				    ps2.setString(5,"asset");
				    ps2.setDate(6,new java.sql.Date(new java.util.Date().getTime()));
				    ps2.setString(7,"asset.1."+id);
				    ps2.setString(8,shortfilename);
				    ps2.setDate(9,new java.sql.Date(new java.util.Date().getTime()));
				    ps2.setString(10,"4");
				    ps2.execute();
				    ps2.close();
			    }
			    else{
			    	rs2.close();
			    	ps2.close();
			    }
				//System.out.println("Saved in database to "+documentid);
			}
			catch(Exception e){
				//e.printStackTrace();
				System.out.println("error reading picture "+url);
			}
		}
	}
	rs.close();
	ps.close();
	conn.close();

%>