<%@page import="be.mxs.common.util.system.*,be.openclinic.finance.*,be.mxs.common.util.db.MedwanQuery,java.sql.*,java.util.*,be.openclinic.knowledge.*"%>
<%
	Connection conn=MedwanQuery.getInstance().getLongOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_prestations");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		Prestation p = Prestation.get("1."+rs.getString("oc_prestation_objectid"));
		p.setATCCode("");
		System.out.println(p.getUid());
		p.store();
	}
	rs.close();
	ps.close();
	conn.close();
%>
