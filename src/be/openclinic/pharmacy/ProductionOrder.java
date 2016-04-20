package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.common.OC_Object;

public class ProductionOrder extends OC_Object{
	private int id=-1;
	private String targetProductStockUid;
	private String debetUid;
	private int patientUid;
	private int updateUid;
	private java.util.Date closeDateTime;
	private String comment;
	private int quantity;
	private String modifiers;
	
	public String getModifiers() {
		return modifiers;
	}

	public void setModifiers(String modifiers) {
		this.modifiers = modifiers;
	}

	public void setModifier(int index,String value){
		if(getModifiers()==null){
			setModifiers("");
		}
		String[] m = getModifiers().split(";");
		if(m.length<=index){
			setModifiers(getModifiers()+"; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;".substring(0,(index+1-m.length)*2));
			m = getModifiers().split(";");
		}
		m[index]=value;
		modifiers="";
		for(int n=0;n<m.length;n++){
			modifiers+=m[n]+";";
		}
	}

	public String getTechnician(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[0];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setTechnician(String s){
		setModifier(0,s);
	}

	public String getDestination(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[1];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setDestination(String s){
		setModifier(1,s);
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public Vector getMaterials() {
		return ProductionOrderMaterial.getProductionOrderMaterials(getId());
	}

	public static Vector getProductionOrders(int patientid){
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
	
	public static Vector getProductionOrders(String patientid, String productStockUid, String debetUid, java.util.Date mindate, java.util.Date maxdate){
		Vector orders = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			String sQuery="SELECT * FROM OC_PRODUCTIONORDERS where 1=1";
			if(ScreenHelper.checkString(patientid).length()>0){
				sQuery+=" AND OC_PRODUCTIONORDER_PATIENTUID=?";
			}
			if(ScreenHelper.checkString(productStockUid).length()>0){
				sQuery+=" AND OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID=?";
			}
			if(mindate!=null){
				sQuery+=" AND OC_PRODUCTIONORDER_CREATEDATETIME>=?";
			}
			if(maxdate!=null){
				sQuery+=" AND OC_PRODUCTIONORDER_CREATEDATETIME<=?";
			}
			if(ScreenHelper.checkString(debetUid).length()>0){
				sQuery+=" AND OC_PRODUCTIONORDER_DEBETUID=?";
			}
			sQuery+= " ORDER BY OC_PRODUCTIONORDER_CREATEDATETIME";
			ps=conn.prepareStatement(sQuery);
			int i=1;
			if(ScreenHelper.checkString(patientid).length()>0){
				ps.setInt(i++, Integer.parseInt(patientid));
			}
			if(ScreenHelper.checkString(productStockUid).length()>0){
				ps.setString(i++, productStockUid);;
			}
			if(mindate!=null){
				ps.setTimestamp(i++, new java.sql.Timestamp(mindate.getTime()));
			}
			if(maxdate!=null){
				ps.setTimestamp(i++, new java.sql.Timestamp(maxdate.getTime()));
			}
			if(ScreenHelper.checkString(debetUid).length()>0){
				ps.setString(i++, debetUid);;
			}
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
	
	public static Vector getOpenProductionOrders(String patientid, String productStockUid, String debetUid, java.util.Date mindate, java.util.Date maxdate){
		Vector orders = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			String sQuery="SELECT * FROM OC_PRODUCTIONORDERS where OC_PRODUCTIONORDER_CLOSEDATETIME IS NULL";
			if(ScreenHelper.checkString(patientid).length()>0){
				sQuery+=" AND OC_PRODUCTIONORDER_PATIENTUID=?";
			}
			if(ScreenHelper.checkString(productStockUid).length()>0){
				sQuery+=" AND OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID=?";
			}
			if(mindate!=null){
				sQuery+=" AND OC_PRODUCTIONORDER_CREATEDATETIME>=?";
			}
			if(maxdate!=null){
				sQuery+=" AND OC_PRODUCTIONORDER_CREATEDATETIME<=?";
			}
			if(ScreenHelper.checkString(debetUid).length()>0){
				sQuery+=" AND OC_PRODUCTIONORDER_DEBETUID=?";
			}
			sQuery+= " ORDER BY OC_PRODUCTIONORDER_CREATEDATETIME";
			ps=conn.prepareStatement(sQuery);
			int i=1;
			if(ScreenHelper.checkString(patientid).length()>0){
				ps.setInt(i++, Integer.parseInt(patientid));
			}
			if(ScreenHelper.checkString(productStockUid).length()>0){
				ps.setString(i++, productStockUid);;
			}
			if(mindate!=null){
				ps.setTimestamp(i++, new java.sql.Timestamp(mindate.getTime()));
			}
			if(maxdate!=null){
				ps.setTimestamp(i++, new java.sql.Timestamp(maxdate.getTime()));
			}
			if(ScreenHelper.checkString(debetUid).length()>0){
				ps.setString(i++, debetUid);;
			}
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
	
	public static Vector getProductionOrders(String transactionuid){
		Vector orders = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("SELECT * FROM OC_PRODUCTIONORDERS where OC_PRODUCTIONORDER_DEBETUID=? ORDER BY OC_PRODUCTIONORDER_CREATEDATETIME");
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
	
	public static Vector getProductionOrdersForProductStockUid(String productStockUid){
		Vector orders = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("SELECT * FROM OC_PRODUCTIONORDERS where OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID=? ORDER BY OC_PRODUCTIONORDER_CREATEDATETIME");
			ps.setString(1, productStockUid);
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
				productionOrder.setDebetUid(rs.getString("OC_PRODUCTIONORDER_DEBETUID"));
				productionOrder.setPatientUid(rs.getInt("OC_PRODUCTIONORDER_PATIENTUID"));
				productionOrder.setQuantity(rs.getInt("OC_PRODUCTIONORDER_QUANTITY"));
				productionOrder.setCreateDateTime(rs.getTimestamp("OC_PRODUCTIONORDER_CREATEDATETIME"));
				productionOrder.setUpdateDateTime(rs.getTimestamp("OC_PRODUCTIONORDER_UPDATETIME"));
				productionOrder.setCloseDateTime(rs.getTimestamp("OC_PRODUCTIONORDER_CLOSEDATETIME"));
				productionOrder.setUpdateUid(rs.getInt("OC_PRODUCTIONORDER_UPDATEUID"));
				productionOrder.setVersion(rs.getInt("OC_PRODUCTIONORDER_VERSION"));
				productionOrder.setComment(rs.getString("OC_PRODUCTIONORDER_COMMENT"));
				productionOrder.setModifiers(rs.getString("OC_PRODUCTIONORDER_MODIFIERS"));
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
			if(getCreateDateTime()==null){
				setCreateDateTime(new java.util.Date());
			}
		}
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			//COPY TO HISTORY
			ps=conn.prepareStatement("INSERT INTO OC_PRODUCTIONORDERS_HISTORY(OC_PRODUCTIONORDER_ID,"
					+ " OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID,"
					+ " OC_PRODUCTIONORDER_DEBETUID,"
					+ " OC_PRODUCTIONORDER_PATIENTUID,"
					+ " OC_PRODUCTIONORDER_QUANTITY,"
					+ " OC_PRODUCTIONORDER_CREATEDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATEUID,"
					+ " OC_PRODUCTIONORDER_VERSION,"
					+ " OC_PRODUCTIONORDER_CLOSEDATETIME,"
					+ " OC_PRODUCTIONORDER_MODIFIERS,"
					+ " OC_PRODUCTIONORDER_COMMENT)"
					+ " SELECT OC_PRODUCTIONORDER_ID,"
					+ " OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID,"
					+ " OC_PRODUCTIONORDER_DEBETUID,"
					+ " OC_PRODUCTIONORDER_PATIENTUID,"
					+ " OC_PRODUCTIONORDER_QUANTITY,"
					+ " OC_PRODUCTIONORDER_CREATEDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATEUID,"
					+ " OC_PRODUCTIONORDER_VERSION,"
					+ " OC_PRODUCTIONORDER_CLOSEDATETIME,"
					+ " OC_PRODUCTIONORDER_MODIFIERS,"
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
			ps=conn.prepareStatement("INSERT INTO OC_PRODUCTIONORDERS(OC_PRODUCTIONORDER_ID,"
					+ " OC_PRODUCTIONORDER_TARGETPRODUCTSTOCKUID,"
					+ " OC_PRODUCTIONORDER_DEBETUID,"
					+ " OC_PRODUCTIONORDER_PATIENTUID,"
					+ " OC_PRODUCTIONORDER_QUANTITY,"
					+ " OC_PRODUCTIONORDER_CREATEDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATETIME,"
					+ " OC_PRODUCTIONORDER_UPDATEUID,"
					+ " OC_PRODUCTIONORDER_VERSION,"
					+ " OC_PRODUCTIONORDER_CLOSEDATETIME,"
					+ " OC_PRODUCTIONORDER_MODIFIERS,"
					+ " OC_PRODUCTIONORDER_COMMENT)"
					+ " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)");
			ps.setInt(1, id);
			ps.setString(2, getTargetProductStockUid());
			ps.setString(3, getDebetUid());
			ps.setInt(4, getPatientUid());
			ps.setInt(5, getQuantity());
			ps.setTimestamp(6, new java.sql.Timestamp(getCreateDateTime().getTime()));
			ps.setTimestamp(7, new java.sql.Timestamp(getUpdateDateTime().getTime()));
			ps.setInt(8, getUpdateUid());
			ps.setInt(9, getVersion());
			ps.setTimestamp(10, getCloseDateTime()==null?null:new java.sql.Timestamp(getCloseDateTime().getTime()));
			ps.setString(11, getModifiers());
			ps.setString(12, getComment());
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
	public ProductStock getProductStock(){
		ProductStock stock = ProductStock.get(getTargetProductStockUid());
		if(stock==null){
			stock = new ProductStock();
		}
		return stock;
	}
	public String getDebetUid() {
		return debetUid;
	}
	public void setDebetUid(String debetUid) {
		this.debetUid = debetUid;
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
