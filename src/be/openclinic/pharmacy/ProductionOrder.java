package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.common.OC_Object;

public class ProductionOrder extends OC_Object{
	private int id=-1;
	private String targetProductStockUid;
	private String transactionUid;
	private int patientUid;
	private int updateUid;
	private java.util.Date closeDateTime;
	private String comment;
	
	public Vector getMaterials() {
		return ProductionOrderMaterial.getProductionOrderMaterials(getId());
	}

	public Vector getProductionOrders(int patientid){
		Vector orders = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("SELECT * FROM OC_PRODUCTIONORDERS where OC_PRODUCTIONORDER_PATIENTUID=? ORDER BY OC_PRODUCTIONORDER_CREATEDATETIME");
			ps.setInt(1, patientid);
			rs=ps.executeQuery();
			while(rs.next()){
				orders.add(ProductionOrder.get(rs.getInt("OC_PRODUCTIONORDER_ID")));
			}
		}
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
		return orders;
	}
	
	public Vector getProductionOrders(String transactionuid){
		Vector orders = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("SELECT * FROM OC_PRODUCTIONORDERS where OC_PRODUCTIONORDER_TRANSACTIONUID=? ORDER BY OC_PRODUCTIONORDER_CREATEDATETIME");
			ps.setString(1, transactionuid);
			rs=ps.executeQuery();
			while(rs.next()){
				orders.add(ProductionOrder.get(rs.getInt("OC_PRODUCTIONORDER_ID")));
			}
		}
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
		return orders;
	}
	
	public static ProductionOrder get(int id){
		ProductionOrder productionOrder = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("select * from OC_PRODUCTIONORDERS where OC_PRODUCTIONORDER_ID=?");
			ps.setInt(1, id);
			rs=ps.executeQuery();
			if(rs.next()){
				productionOrder = new ProductionOrder();
				productionOrder.setId(id);
				productionOrder.setTargetProductStockUid(rs.getString("OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID"));
				productionOrder.setTransactionUid(rs.getString("OC_PRODUCTIONORDER_TRANSACTIONUID"));
				productionOrder.setPatientUid(rs.getInt("OC_PRODUCTIONORDER_PATIENTUID"));
				productionOrder.setCreateDateTime(rs.getTimestamp("OC_PRODUCTIONORDER_CREATEDATETIME"));
				productionOrder.setUpdateDateTime(rs.getTimestamp("OC_PRODUCTIONORDER_UPDATETIME"));
				productionOrder.setCloseDateTime(rs.getTimestamp("OC_PRODUCTIONORDER_CLOSEDATETIME"));
				productionOrder.setUpdateUid(rs.getInt("OC_PRODUCTIONORDER_UPDATEUID"));
				productionOrder.setVersion(rs.getInt("OC_PRODUCTIONORDER_VERSION"));
				productionOrder.setComment(rs.getString("OC_PRODUCTIONORDER_COMMENT"));
			}
		}
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
		return productionOrder;
	}
	
	public boolean store(){
		boolean bStored=false;
		if(id==-1){
			id=MedwanQuery.getInstance().getOpenclinicCounter("OC_PRODUCTIONORDER_ID");
			setVersion(0);
		}
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			//COPY TO HISTORY
			ps=conn.prepareStatement("INSERT INTO OC_PRODUCTIONORDERS_HISTORY(OC_PRODUCTIONORDER_ID,"
					+ " OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID,"
					+ " OC_PRODUCTIONORDER_TRANSACTIONUID,"
					+ " OC_PRODUCTIONORDER_PATIENTUID,"
					+ " OC_PRODUCTIONORDER_CREATEDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATEUID,"
					+ " OC_PRODUCTIONORDER_VERSION,"
					+ " OC_PRODUCTIONORDER_CLOSEDATETIME,"
					+ " OC_PRODUCTIONORDER_COMMENT)"
					+ " SELECT OC_PRODUCTIONORDER_ID,"
					+ " OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID,"
					+ " OC_PRODUCTIONORDER_TRANSACTIONUID,"
					+ " OC_PRODUCTIONORDER_PATIENTUID,"
					+ " OC_PRODUCTIONORDER_CREATEDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATEUID,"
					+ " OC_PRODUCTIONORDER_VERSION,"
					+ " OC_PRODUCTIONORDER_CLOSEDATETIME,"
					+ " OC_PRODUCTIONORDER_COMMENT"
					+ " FROM OC_PRODUCTIONORDERS WHERE OC_PRODUCTIONORDER_ID=?");
			ps.setInt(1, id);
			ps.execute();
			ps.close();
			//DELETE
			ps=conn.prepareStatement("DELETE FROM OC_PRODUCTIONORDERS WHERE OC_PRODUCTIONORDER_ID=?");
			ps.setInt(1, id);
			ps.execute();
			//STORE new version
			setVersion(getVersion()+1);
			ps=conn.prepareStatement("INSERT INTO OC_PRODUCTORDERS(OC_PRODUCTIONORDER_ID,"
					+ " OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID,"
					+ " OC_PRODUCTIONORDER_TRANSACTIONUID,"
					+ " OC_PRODUCTIONORDER_PATIENTUID,"
					+ " OC_PRODUCTIONORDER_CREATEDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATEUID,"
					+ " OC_PRODUCTIONORDER_VERSION,"
					+ " OC_PRODUCTIONORDER_CLOSEDATETIME,"
					+ " OC_PRODUCTIONORDER_COMMENT)"
					+ " VALUES(?,?,?,?,?,?,?,?,?,?)");
			ps.setInt(1, id);
			ps.setString(2, getTargetProductStockUid());
			ps.setString(3, getTransactionUid());
			ps.setInt(4, getPatientUid());
			ps.setTimestamp(5, new java.sql.Timestamp(getCreateDateTime().getTime()));
			ps.setTimestamp(6, new java.sql.Timestamp(getUpdateDateTime().getTime()));
			ps.setInt(7, getUpdateUid());
			ps.setInt(8, getVersion());
			ps.setTimestamp(9, new java.sql.Timestamp(getCreateDateTime().getTime()));
			ps.setString(10, getComment());
			bStored=ps.execute();
		}
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
		return bStored;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTargetProductStockUid() {
		return targetProductStockUid;
	}
	public void setTargetProductStockUid(String targetProductStockUid) {
		this.targetProductStockUid = targetProductStockUid;
	}
	public String getTransactionUid() {
		return transactionUid;
	}
	public void setTransactionUid(String transactionUid) {
		this.transactionUid = transactionUid;
	}
	public int getPatientUid() {
		return patientUid;
	}
	public void setPatientUid(int patientUid) {
		this.patientUid = patientUid;
	}
	public int getUpdateUid() {
		return updateUid;
	}
	public void setUpdateUid(int updateUid) {
		this.updateUid = updateUid;
	}
	public java.util.Date getCloseDateTime() {
		return closeDateTime;
	}
	public void setCloseDateTime(java.util.Date closeDateTime) {
		this.closeDateTime = closeDateTime;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
}
