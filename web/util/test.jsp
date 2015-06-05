<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String sSelect="select * from oc_batches";
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement(sSelect);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String uid=rs.getString("oc_batch_serverid")+"."+rs.getString("oc_batch_objectid");
		System.out.println(uid);
		be.openclinic.pharmacy.Batch.calculateBatchLevel(uid);
	}
	rs.close();
	ps.close();
	conn.close();
%>