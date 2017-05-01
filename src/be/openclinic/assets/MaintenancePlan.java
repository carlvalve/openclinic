package be.openclinic.assets;

import be.openclinic.common.OC_Object;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;


public class MaintenancePlan extends OC_Object {
    public int serverId;
    public int objectId;    

    public String name; // 255
    public String assetUID; // 50
    public java.util.Date startDate;
    public java.util.Date endDate;
    public String frequency;
    public String operator; // 255
    public String planManager; // 255
    public String instructions; // text
    public String type;
    public String comment1;
    public String comment2;
    public String comment3;
    public String comment4;
    public String comment5;
    public String comment6;
    public String comment7;
    public String comment8;
    public String comment9;
    public String comment10;

    public boolean isOverdue(){
    	return isOverdue(new java.util.Date());
    }
    
    public boolean isOverdue(java.util.Date date){
    	java.util.Date nd = getNextOperationDate();
    	return nd!=null && nd.before(date);
    }
    
    public java.util.Date getNextOperationDate(){
    	if(isInactive()){
    		return null;
    	}
    	java.util.Date date = null;
    	//First find out the last next operation date specified for this plan
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select * from OC_MAINTENANCEOPERATIONS where OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID=? order by OC_MAINTENANCEOPERATION_NEXTDATE desc");
    		ps.setString(1, getUid());
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()){
    			date = rs.getDate("OC_MAINTENANCEOPERATION_NEXTDATE");
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    	if(date==null){
    		//No operations specified yet, take the startdate of thye plan as the next operation date
    		date = getStartDate();
    	}
    	return date;
    }
    
    public String getComment10() {
		return comment10;
	}

	public void setComment10(String comment10) {
		this.comment10 = comment10;
	}

	public String getComment1() {
		return comment1;
	}

	public void setComment1(String comment1) {
		this.comment1 = comment1;
	}

	public String getComment2() {
		return comment2;
	}

	public void setComment2(String comment2) {
		this.comment2 = comment2;
	}

	public String getComment3() {
		return comment3;
	}

	public void setComment3(String comment3) {
		this.comment3 = comment3;
	}

	public String getComment4() {
		return comment4;
	}

	public void setComment4(String comment4) {
		this.comment4 = comment4;
	}

	public String getComment5() {
		return comment5;
	}

	public void setComment5(String comment5) {
		this.comment5 = comment5;
	}

	public String getComment6() {
		return comment6;
	}

	public void setComment6(String comment6) {
		this.comment6 = comment6;
	}

	public String getComment7() {
		return comment7;
	}

	public void setComment7(String comment7) {
		this.comment7 = comment7;
	}

	public String getComment8() {
		return comment8;
	}

	public void setComment8(String comment8) {
		this.comment8 = comment8;
	}

	public String getComment9() {
		return comment9;
	}

	public void setComment9(String comment9) {
		this.comment9 = comment9;
	}

	public java.util.Date getEndDate() {
		return endDate;
	}

	public void setEndDate(java.util.Date endDate) {
		this.endDate = endDate;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getServerId() {
		return serverId;
	}

	public void setServerId(int serverId) {
		this.serverId = serverId;
	}

	public int getObjectId() {
		return objectId;
	}

	public void setObjectId(int objectId) {
		this.objectId = objectId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAssetUID() {
		return assetUID;
	}
	
	public String getAssetNomenclature(){
		String nomenclature="";
		Asset asset = getAsset();
		if(asset!=null){
			nomenclature=asset.getNomenclature();
		}
		return nomenclature;
	}
	
	public String getAssetName(){
		String name="";
		Asset asset = getAsset();
		if(asset!=null){
			name=asset.getDescription();
		}
		return name;
	}
	
	public String getAssetCode(){
		String code="";
		Asset asset = getAsset();
		if(asset!=null){
			code=asset.getCode();
		}
		return code;
	}
	
	public boolean isInactive(){
		return isInactive(new java.util.Date());
	}
	
	public boolean isInactive(java.util.Date date){
		return (getEndDate()!=null && !getEndDate().after(date)) || (getAsset()!=null && getAsset().isInactive(date));
	}
	
	public Asset getAsset(){
		Asset asset = null;
		if(ScreenHelper.checkString(getAssetUID()).length()>0){
			 asset = Asset.get(getAssetUID());
		}
		return asset;
	}

	public void setAssetUID(String assetUID) {
		this.assetUID = assetUID;
	}

	public java.util.Date getStartDate() {
		return startDate;
	}

	public void setStartDate(java.util.Date startDate) {
		this.startDate = startDate;
	}

	public String getFrequency() {
		return frequency;
	}

	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getPlanManager() {
		return planManager;
	}

	public void setPlanManager(String planManager) {
		this.planManager = planManager;
	}

	public String getInstructions() {
		return instructions;
	}

	public void setInstructions(String instructions) {
		this.instructions = instructions;
	}

	//--- CONSTRUCTOR ---
    public MaintenancePlan(){
        serverId = -1;
        objectId = -1;

        name = "";
        assetUID = "";
        startDate = null;
        endDate = null;

        frequency = "";
        operator = "";
        planManager = "";
        instructions = "";
        comment1 = "";
        comment2 = "";
        comment3 = "";
        comment4 = "";
        comment5 = "";
        comment6 = "";
        comment7 = "";
        comment8 = "";
        comment9 = "";
        comment10 = "";
    }
    
    //--- GET NAME --------------------------------------------------------------------------------
    public static String getName(String sPlanUID){
    	String sPlanName = "";

        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT OC_MAINTENANCEPLAN_NAME FROM OC_MAINTENANCEPLANS"+
                          " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sPlanUID.substring(0,sPlanUID.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sPlanUID.substring(sPlanUID.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                sPlanName = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NAME"));
            }
        }
        catch(Exception e){
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
    	return sPlanName;
    }
        
    //--- STORE -----------------------------------------------------------------------------------
    public boolean store(String userUid){
    	boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSql;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                
        try{            
            if(getUid().equals("-1")){            	  
                // insert new plan
                sSql = "INSERT INTO OC_MAINTENANCEPLANS(OC_MAINTENANCEPLAN_SERVERID,OC_MAINTENANCEPLAN_OBJECTID,"+
                       "  OC_MAINTENANCEPLAN_NAME,OC_MAINTENANCEPLAN_ASSETUID,OC_MAINTENANCEPLAN_STARTDATE,"+
                	   "  OC_MAINTENANCEPLAN_FREQUENCY,OC_MAINTENANCEPLAN_OPERATOR,OC_MAINTENANCEPLAN_PLANMANAGER,"+
                       "  OC_MAINTENANCEPLAN_INSTRUCTIONS,OC_MAINTENANCEPLAN_TYPE,OC_MAINTENANCEPLAN_ENDDATE,OC_MAINTENANCEPLAN_COMMENT1"
                       + ",OC_MAINTENANCEPLAN_COMMENT2,OC_MAINTENANCEPLAN_COMMENT3,OC_MAINTENANCEPLAN_COMMENT4,OC_MAINTENANCEPLAN_COMMENT5"
                       + ",OC_MAINTENANCEPLAN_COMMENT6,OC_MAINTENANCEPLAN_COMMENT7,OC_MAINTENANCEPLAN_COMMENT8,OC_MAINTENANCEPLAN_COMMENT9"
                       + ",OC_MAINTENANCEPLAN_COMMENT10"+
                       "  ,OC_MAINTENANCEPLAN_UPDATETIME,OC_MAINTENANCEPLAN_UPDATEID)"+
                       " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; // 11
                ps = oc_conn.prepareStatement(sSql);
                
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId"),
                    objectId = MedwanQuery.getInstance().getOpenclinicCounter("OC_MAINTENANCEPLANS");
                this.setUid(serverId+"."+objectId);
                                
                int psIdx = 1;
                ps.setInt(psIdx++,serverId);
                ps.setInt(psIdx++,objectId);
                
                ps.setString(psIdx++,name);
                ps.setString(psIdx++,assetUID);

                // purchaseDate date might be unspecified
                if(startDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(startDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                
                ps.setString(psIdx++,frequency);
                ps.setString(psIdx++,operator);
                ps.setString(psIdx++,planManager);
                ps.setString(psIdx++,instructions);
                ps.setString(psIdx++,type);

                if(endDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(endDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                ps.setString(psIdx++,comment1);
                ps.setString(psIdx++,comment2);
                ps.setString(psIdx++,comment3);
                ps.setString(psIdx++,comment4);
                ps.setString(psIdx++,comment5);
                ps.setString(psIdx++,comment6);
                ps.setString(psIdx++,comment7);
                ps.setString(psIdx++,comment8);
                ps.setString(psIdx++,comment9);
                ps.setString(psIdx++,comment10);
                
                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx,userUid);
                
                ps.executeUpdate();
            } 
            else{
                // update existing record
                sSql = "UPDATE OC_MAINTENANCEPLANS SET"+
                       "  OC_MAINTENANCEPLAN_NAME = ?, OC_MAINTENANCEPLAN_ASSETUID = ?, OC_MAINTENANCEPLAN_STARTDATE = ?,"+
                	   "  OC_MAINTENANCEPLAN_FREQUENCY = ?, OC_MAINTENANCEPLAN_OPERATOR = ?, OC_MAINTENANCEPLAN_PLANMANAGER = ?,"+
                       "  OC_MAINTENANCEPLAN_INSTRUCTIONS = ?,OC_MAINTENANCEPLAN_TYPE = ?,OC_MAINTENANCEPLAN_ENDDATE = ?"
                       + ",OC_MAINTENANCEPLAN_COMMENT1 = ?,OC_MAINTENANCEPLAN_COMMENT2 = ?,OC_MAINTENANCEPLAN_COMMENT3 = ?,OC_MAINTENANCEPLAN_COMMENT4 = ?"
                       + ",OC_MAINTENANCEPLAN_COMMENT5 = ?,OC_MAINTENANCEPLAN_COMMENT6 = ?,OC_MAINTENANCEPLAN_COMMENT7 = ?,OC_MAINTENANCEPLAN_COMMENT8 = ?"
                       + ",OC_MAINTENANCEPLAN_COMMENT9 = ?,OC_MAINTENANCEPLAN_COMMENT10 = ?"+
                       "  ,OC_MAINTENANCEPLAN_UPDATETIME = ?, OC_MAINTENANCEPLAN_UPDATEID = ?"+ // update-info
                       " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ?)"; // identification
                ps = oc_conn.prepareStatement(sSql);

                int psIdx = 1;
                
                ps.setString(psIdx++,name);
                ps.setString(psIdx++,assetUID);

                // purchaseDate date might be unspecified
                if(startDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(startDate.getTime()));
                }
                else{
                    ps.setObject(psIdx++,null);
                }
                
                ps.setString(psIdx++,frequency);
                ps.setString(psIdx++,operator);
                ps.setString(psIdx++,planManager);
                ps.setString(psIdx++,instructions);
                ps.setString(psIdx++,type);
                if(endDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(endDate.getTime()));
                }
                else{
                    ps.setObject(psIdx++,null);
                }
                ps.setString(psIdx++,comment1);
                ps.setString(psIdx++,comment2);
                ps.setString(psIdx++,comment3);
                ps.setString(psIdx++,comment4);
                ps.setString(psIdx++,comment5);
                ps.setString(psIdx++,comment6);
                ps.setString(psIdx++,comment7);
                ps.setString(psIdx++,comment8);
                ps.setString(psIdx++,comment9);
                ps.setString(psIdx++,comment10);

                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                
                // where
                ps.setInt(psIdx++,Integer.parseInt(getUid().substring(0,getUid().indexOf("."))));
                ps.setInt(psIdx,Integer.parseInt(getUid().substring(getUid().indexOf(".")+1)));
                
                ps.executeUpdate();
            }            
        }
        catch(Exception e){
        	errorOccurred = true;
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return errorOccurred;
    }
    
    //--- DELETE ----------------------------------------------------------------------------------
    public static boolean delete(String sPlanUID){
    	boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "DELETE FROM OC_MAINTENANCEPLANS"+
                          " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sPlanUID.substring(0,sPlanUID.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sPlanUID.substring(sPlanUID.indexOf(".")+1)));
            
            ps.executeUpdate();
        }
        catch(Exception e){
        	errorOccurred = true;
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return errorOccurred;
    }
    
    //--- GET -------------------------------------------------------------------------------------
    public static MaintenancePlan get(MaintenancePlan plan){
    	return get(plan.getUid());
    }
       
    public static MaintenancePlan get(String splanUid){
    	MaintenancePlan plan = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM OC_MAINTENANCEPLANS"+
                          " WHERE (OC_MAINTENANCEPLAN_SERVERID = ? AND OC_MAINTENANCEPLAN_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(splanUid.substring(0,splanUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(splanUid.substring(splanUid.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                plan = new MaintenancePlan();
                plan.setUid(rs.getString("OC_MAINTENANCEPLAN_SERVERID")+"."+rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));
                plan.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_SERVERID"));
                plan.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));
                
                plan.name         = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NAME"));
                plan.assetUID     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_ASSETUID"));
                plan.startDate    = rs.getDate("OC_MAINTENANCEPLAN_STARTDATE");
                plan.endDate    = rs.getDate("OC_MAINTENANCEPLAN_ENDDATE");
                plan.frequency    = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_FREQUENCY"));
                plan.operator     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_OPERATOR"));
                plan.planManager  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_PLANMANAGER"));
                plan.instructions = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_INSTRUCTIONS"));
                plan.type 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_TYPE"));
                plan.comment1 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT1"));
                plan.comment2 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT2"));
                plan.comment3 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT3"));
                plan.comment4 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT4"));
                plan.comment5 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT5"));
                plan.comment6 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT6"));
                plan.comment7 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT7"));
                plan.comment8 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT8"));
                plan.comment9 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT9"));
                plan.comment10 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT10"));
                
                // update-info
                plan.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEPLAN_UPDATETIME"));
                plan.setUpdateUser(rs.getString("OC_MAINTENANCEPLAN_UPDATEID"));
            }
        }
        catch(Exception e){
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return plan;
    }
        
    //--- GET LIST --------------------------------------------------------------------------------
    public static List<MaintenancePlan> getList(){
    	return getList(new MaintenancePlan());     	
    }
    
    public static List<MaintenancePlan> getList(MaintenancePlan findItem){
        List<MaintenancePlan> foundObjects = new LinkedList();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	//*** compose query ***************************
            String sSql = "SELECT * FROM OC_MAINTENANCEPLANS,OC_ASSETS WHERE oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+MedwanQuery.getInstance().getConfigString("serverId","1")+".','') "; // 'where' facilitates further composition of query

            //*** search-criteria *** 
            if(findItem.name.length() > 0){
                sSql+= " AND OC_MAINTENANCEPLAN_NAME LIKE '%"+findItem.name+"%'";
            }
            if(ScreenHelper.checkString(findItem.assetUID).length() > 0){
                sSql+= " AND OC_MAINTENANCEPLAN_ASSETUID = '"+findItem.assetUID+"'";
            }
            if(ScreenHelper.checkString(findItem.type).length() > 0){
                sSql+= " AND OC_MAINTENANCEPLAN_TYPE = '"+findItem.type+"'";
            }
            if(ScreenHelper.checkString(findItem.getTag()).length() > 0){
                sSql+= " AND OC_ASSET_SERVICE like '"+findItem.getTag()+"%'";
            }
            if(ScreenHelper.checkString(findItem.operator).length() > 0){
                sSql+= " AND OC_MAINTENANCEPLAN_OPERATOR LIKE '%"+findItem.operator+"%'";
            }
            
            sSql+= " ORDER BY OC_MAINTENANCEPLAN_NAME ASC";
            
            ps = oc_conn.prepareStatement(sSql);
            
                        
            //*** execute query ***************************
            rs = ps.executeQuery();
            MaintenancePlan plan;
            
            while(rs.next()){
            	plan = new MaintenancePlan();   
            	plan.setUid(rs.getString("OC_MAINTENANCEPLAN_SERVERID")+"."+rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));
                plan.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_SERVERID"));
                plan.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEPLAN_OBJECTID"));

                plan.name         = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_NAME"));
                plan.assetUID     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_ASSETUID"));
                plan.startDate    = rs.getDate("OC_MAINTENANCEPLAN_STARTDATE");
                plan.endDate    = rs.getDate("OC_MAINTENANCEPLAN_ENDDATE");
                plan.frequency    = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_FREQUENCY"));
                plan.operator     = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_OPERATOR"));
                plan.planManager  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_PLANMANAGER"));
                plan.instructions = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_INSTRUCTIONS"));
                plan.type 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_TYPE"));
                plan.comment1 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT1"));
                plan.comment2 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT2"));
                plan.comment3 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT3"));
                plan.comment4 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT4"));
                plan.comment5 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT5"));
                plan.comment6 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT6"));
                plan.comment7 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT7"));
                plan.comment8 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT8"));
                plan.comment9 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT9"));
                plan.comment10 		  = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEPLAN_COMMENT10"));
                
                // update-info
                plan.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEPLAN_UPDATETIME"));
                plan.setUpdateUser(rs.getString("OC_MAINTENANCEPLAN_UPDATEID"));
                
                foundObjects.add(plan);
            }
        }
        catch(Exception e){
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return foundObjects;
    }

}