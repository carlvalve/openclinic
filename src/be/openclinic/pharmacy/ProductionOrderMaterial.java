package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.common.OC_Object;

public class ProductionOrderMaterial extends OC_Object{
	private int id;
	private int productionOrderId;
	private String productStockUid;
	private double quantity;
	private int updateUid;
	private String comment;
	
	public static ProductionOrderMaterial get(int id){
		ProductionOrderMaterial productionOrderMaterial = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("select * from OC_PRODUCTIONORDERMATERIALS where OC_MATERIAL_ID=?");
			ps.setInt(1, id);
			rs=ps.executeQuery();
			if(rs.next()){
				productionOrderMaterial = new ProductionOrderMaterial();
				productionOrderMaterial.setId(id);
				productionOrderMaterial.setProductionOrderId(rs.getInt("OC_MATERIAL_PRODUCTORDERID"));
				productionOrderMaterial.setProductStockUid(rs.getString("OC_MATERIAL_PRODUCTSTOCKUID"));
				productionOrderMaterial.setCreateDateTime(rs.getTimestamp("OC_MATERIAL_CREATEDATETIME"));
				productionOrderMaterial.setUpdateDateTime(rs.getTimestamp("OC_MATERIAL_UPDATETIME"));
				productionOrderMaterial.setUpdateUid(rs.getInt("OC_MATERIAL_UPDATEUID"));
				productionOrderMaterial.setQuantity(rs.getInt("OC_MATERIAL_QUANTITY"));
				productionOrderMaterial.setVersion(rs.getInt("OC_MATERIAL_VERSION"));
				productionOrderMaterial.setComment(rs.getString("OC_MATERIAL_COMMENT"));
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
		return productionOrderMaterial;
	}
	
	public ProductionOrder getProductionOrder(){
		return ProductionOrder.get(getProductionOrderId());
	}
	
	public static Vector getProductionOrderMaterials(int productionOrderId){
		Vector materials = new Vector();
		ProductionOrderMaterial productionOrderMaterial = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("select * from OC_PRODUCTIONORDERMATERIALS where OC_MATERIAL_PRODUCTIONORDERID=?");
			ps.setInt(1, productionOrderId);
			rs=ps.executeQuery();
			while(rs.next()){
				productionOrderMaterial = new ProductionOrderMaterial();
				productionOrderMaterial.setId(rs.getInt("OC_MATERIAL_ID"));
				productionOrderMaterial.setProductionOrderId(rs.getInt("OC_MATERIAL_PRODUCTORDERID"));
				productionOrderMaterial.setProductStockUid(rs.getString("OC_MATERIAL_PRODUCTSTOCKUID"));
				productionOrderMaterial.setCreateDateTime(rs.getTimestamp("OC_MATERIAL_CREATEDATETIME"));
				productionOrderMaterial.setUpdateDateTime(rs.getTimestamp("OC_MATERIAL_UPDATETIME"));
				productionOrderMaterial.setUpdateUid(rs.getInt("OC_MATERIAL_UPDATEUID"));
				productionOrderMaterial.setQuantity(rs.getInt("OC_MATERIAL_QUANTITY"));
				productionOrderMaterial.setVersion(rs.getInt("OC_MATERIAL_VERSION"));
				productionOrderMaterial.setComment(rs.getString("OC_MATERIAL_COMMENT"));
				materials.add(productionOrderMaterial);
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
		return materials;
	}
	
	public boolean store(){
		boolean bStored=false;
		if(id==-1){
			id=MedwanQuery.getInstance().getOpenclinicCounter("OC_PRODUCTIONORDERMATERIAL_ID");
			setVersion(0);
		}
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			//COPY TO HISTORY
		ps=conn.prepareStatement("INSERT INTO OC_PRODUCTIONORDERMATERIALS_HISTORY(OC_MATERIAL_ID,"
					+ " OC_MATERIAL_PRODUCTIONORDERID,"
					+ " OC_MATERIAL_PRODUCTSTOCKUID,"
					+ " OC_MATERIAL_QUANTITY,"
					+ " OC_MATERIAL_CREATEDATETIME,"
					+ " OC_MATERIAL_UPDATETIME,"
					+ " OC_MATERIAL_UPDATEUID,"
					+ " OC_MATERIAL_VERSION,"
					+ " OC_MATERIAL_COMMENT)"
					+ " SELECT OC_MATERIAL_ID,"
					+ " OC_MATERIAL_PRODUCTIONORDERID,"
					+ " OC_MATERIAL_PRODUCTSTOCKUID,"
					+ " OC_MATERIAL_QUANTITY,"
					+ " OC_MATERIAL_CREATEDATETIME,"
					+ " OC_MATERIAL_UPDATETIME,"
					+ " OC_MATERIAL_UPDATEUID,"
					+ " OC_MATERIAL_VERSION,"
					+ " OC_MATERIAL_COMMENT"
					+ " FROM OC_PRODUCTIONORDERMATERIALS WHERE OC_MATERIAL_ID=?");
			ps.setInt(1, id);
			ps.execute();
			ps.close();
			//DELETE
			ps=conn.prepareStatement("DELETE FROM OC_PRODUCTIONORDERMATERIALS WHERE OC_MATERIAL_ID=?");
			ps.setInt(1, id);
			ps.execute();
			//STORE new version
			setVersion(getVersion()+1);
			ps=conn.prepareStatement("INSERT INTO OC_PRODUCTORDERMATERIALS(OC_MATERIAL_ID,"
					+ " OC_MATERIAL_PRODUCTIONORDERID,"
					+ " OC_MATERIAL_PRODUCTSTOCKUID,"
					+ " OC_MATERIAL_QUANTITY,"
					+ " OC_MATERIAL_CREATEDATETIME,"
					+ " OC_MATERIAL_UPDATETIME,"
					+ " OC_MATERIAL_UPDATEUID,"
					+ " OC_MATERIAL_VERSION,"
					+ " OC_MATERIAL_COMMENT)"
					+ " VALUES(?,?,?,?,?,?,?,?,?)");
			ps.setInt(1, id);
			ps.setInt(2, getProductionOrderId());
			ps.setString(3, getProductStockUid());
			ps.setDouble(4, getQuantity());
			ps.setTimestamp(5, new java.sql.Timestamp(getCreateDateTime().getTime()));
			ps.setTimestamp(6, new java.sql.Timestamp(getUpdateDateTime().getTime()));
			ps.setInt(7, getUpdateUid());
			ps.setInt(8, getVersion());
			ps.setString(9, getComment());
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
	public int getProductionOrderId() {
		return productionOrderId;
	}
	public void setProductionOrderId(int productionOrderId) {
		this.productionOrderId = productionOrderId;
	}
	public String getProductStockUid() {
		return productStockUid;
	}
	public void setProductStockUid(String productStockUid) {
		this.productStockUid = productStockUid;
	}
	public double getQuantity() {
		return quantity;
	}
	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
	public int getUpdateUid() {
		return updateUid;
	}
	public void setUpdateUid(int updateuid) {
		this.updateUid = updateuid;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}

}
