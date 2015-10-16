package be.openclinic.adt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;

public class Queue {
	private int objectid=-1;
	private String id;
	private String subjecttype;
	private String subjectuid;
	private java.util.Date begin;
	private String beginuid;
	private java.util.Date end;
	private String enduid;
	private String endreason;
	private String transferto;
	
	public int getObjectid() {
		return objectid;
	}

	public void setObjectid(int objectid) {
		this.objectid = objectid;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getSubjecttype() {
		return subjecttype;
	}

	public void setSubjecttype(String subjecttype) {
		this.subjecttype = subjecttype;
	}

	public String getSubjectuid() {
		return subjectuid;
	}

	public void setSubjectuid(String subjectuid) {
		this.subjectuid = subjectuid;
	}

	public java.util.Date getBegin() {
		return begin;
	}

	public void setBegin(java.util.Date begin) {
		this.begin = begin;
	}

	public String getBeginuid() {
		return beginuid;
	}

	public void setBeginuid(String beginuid) {
		this.beginuid = beginuid;
	}

	public java.util.Date getEnd() {
		return end;
	}

	public void setEnd(java.util.Date end) {
		this.end = end;
	}

	public String getEnduid() {
		return enduid;
	}

	public void setEnduid(String enduid) {
		this.enduid = enduid;
	}

	public String getEndreason() {
		return endreason;
	}

	public void setEndreason(String endreason) {
		this.endreason = endreason;
	}

	public String getTransferto() {
		return transferto;
	}

	public void setTransferto(String transferto) {
		this.transferto = transferto;
	}
	
	public static boolean activePatientQueueExists(String queueid,String personid){
		boolean bExists=false;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_subjectuid=? and oc_queue_id=? and oc_queue_end is null");
			ps.setString(1,personid);
			ps.setString(2,queueid);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				bExists=true;
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return bExists;
	}
	
	public void store(){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps=null;
		try {
			if(this.getObjectid()>-1){
				ps = conn.prepareStatement("delete from oc_queues where oc_queue_objectid=?");
				ps.setInt(1, this.getObjectid());
				ps.execute();
				ps.close();
			}
			else {
				this.setObjectid(MedwanQuery.getInstance().getOpenclinicCounter("QUEUEID"));
			}
			ps=conn.prepareStatement("insert into oc_queues(oc_queue_objectid,oc_queue_id,oc_queue_begin,oc_queue_beginuid,oc_queue_end,oc_queue_enduid,"+
									"oc_queue_endreason,oc_queue_subjecttype,oc_queue_subjectuid,oc_queue_transferto) values (?,?,?,?,?,?,?,?,?,?)");
			ps.setInt(1, this.getObjectid());
			ps.setString(2, this.getId());
			ps.setTimestamp(3, this.getBegin()==null?null:new java.sql.Timestamp(this.getBegin().getTime()));
			ps.setString(4, this.getBeginuid());
			ps.setTimestamp(5, this.getEnd()==null?null:new java.sql.Timestamp(this.getEnd().getTime()));
			ps.setString(6, this.getEnduid());
			ps.setString(7, this.getEndreason());
			ps.setString(8, this.getSubjecttype());
			ps.setString(9, this.getSubjectuid());
			ps.setString(10, this.getTransferto());
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public static Vector getActivePatientQueues(String personid){
		Vector v=new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_subjectuid=? and oc_queue_end is null");
			ps.setString(1,personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Queue queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
				v.add(queue);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return v;
	}

	public static Vector getActiveQueue(String queueid){
		Vector v=new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_id=? and oc_queue_end is null order by oc_queue_begin");
			ps.setString(1,queueid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Queue queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
				v.add(queue);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return v;
	}

	public static Queue get(int objectid){
		Queue queue=null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_objectid=?");
			ps.setInt(1,objectid);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return queue;
	}
}