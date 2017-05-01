package be.openclinic.assets;

import be.openclinic.common.OC_Object;
import be.openclinic.util.Nomenclature;
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


public class MaintenanceOperation extends OC_Object {
    public int serverId;
    public int objectId;    

    public String maintenanceplanUID;
    public java.util.Date date;
    public String operator; // 255
    public String supplier; // 255
	public String result; // 50
    public String comment; // 255
    public java.util.Date nextDate;
    
    // extra search-criteria
    public java.util.Date periodPerformedBegin;
    public java.util.Date periodPerformedEnd;
    
    
    public String getSupplier() {
		return supplier;
	}

	public void setSupplier(String supplier) {
		this.supplier = supplier;
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

	public String getMaintenanceplanUID() {
		return maintenanceplanUID;
	}

	public void setMaintenanceplanUID(String maintenanceplanUID) {
		this.maintenanceplanUID = maintenanceplanUID;
	}
	
	public MaintenancePlan getMaintenancePlan(){
		MaintenancePlan plan = MaintenancePlan.get(this.maintenanceplanUID);
		if(plan==null){
			plan = new MaintenancePlan();
		}
		return plan;
	}

	public java.util.Date getDate() {
		return date;
	}

	public void setDate(java.util.Date date) {
		this.date = date;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public java.util.Date getNextDate() {
		return nextDate;
	}

	public void setNextDate(java.util.Date nextDate) {
		this.nextDate = nextDate;
	}

	public java.util.Date getPeriodPerformedBegin() {
		return periodPerformedBegin;
	}

	public void setPeriodPerformedBegin(java.util.Date periodPerformedBegin) {
		this.periodPerformedBegin = periodPerformedBegin;
	}

	public java.util.Date getPeriodPerformedEnd() {
		return periodPerformedEnd;
	}

	public void setPeriodPerformedEnd(java.util.Date periodPerformedEnd) {
		this.periodPerformedEnd = periodPerformedEnd;
	}

	//--- CONSTRUCTOR ---
    public MaintenanceOperation(){
        serverId = -1;
        objectId = -1;

        maintenanceplanUID = "";
        date = null;
        operator = ""; // 255
        supplier="";
        result = ""; // 50
        comment = ""; // 255
        nextDate = null;
        
        periodPerformedBegin = null;
        periodPerformedEnd = null;
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
                // insert new operation
                sSql = "INSERT INTO OC_MAINTENANCEOPERATIONS(OC_MAINTENANCEOPERATION_SERVERID,OC_MAINTENANCEOPERATION_OBJECTID,"+
                       "  OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID,OC_MAINTENANCEOPERATION_DATE,OC_MAINTENANCEOPERATION_OPERATOR,"+
                	   "  OC_MAINTENANCEOPERATION_RESULT,OC_MAINTENANCEOPERATION_COMMENT,OC_MAINTENANCEOPERATION_NEXTDATE,OC_MAINTENANCEOPERATION_SUPPLIER,"+
                       "  OC_MAINTENANCEOPERATION_UPDATETIME,OC_MAINTENANCEOPERATION_UPDATEID)"+
                       " VALUES(?,?,?,?,?,?,?,?,?,?,?)"; // 10 
                ps = oc_conn.prepareStatement(sSql);
                
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId"),
                    objectId = MedwanQuery.getInstance().getOpenclinicCounter("OC_MAINTENANCEOPERATIONS");
                this.setUid(serverId+"."+objectId);
                                
                int psIdx = 1;
                ps.setInt(psIdx++,serverId);
                ps.setInt(psIdx++,objectId);
                
                ps.setString(psIdx++,maintenanceplanUID);
                ps.setDate(psIdx++,new java.sql.Date(date.getTime()));
                ps.setString(psIdx++,operator);
                ps.setString(psIdx++,result);
                ps.setString(psIdx++,comment);
                
                // nextDate might be unspecified
                if(nextDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(nextDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                ps.setString(psIdx++,supplier);
                
                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx,userUid);
                
                ps.executeUpdate();
            } 
            else{
                // update existing record
                sSql = "UPDATE OC_MAINTENANCEOPERATIONS SET"+
                       "  OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID = ?, OC_MAINTENANCEOPERATION_DATE = ?,OC_MAINTENANCEOPERATION_OPERATOR = ?,"+
                	   "  OC_MAINTENANCEOPERATION_RESULT = ?, OC_MAINTENANCEOPERATION_COMMENT = ?, OC_MAINTENANCEOPERATION_NEXTDATE = ?, OC_MAINTENANCEOPERATION_SUPPLIER=?,"+
                       "  OC_MAINTENANCEOPERATION_UPDATETIME = ?, OC_MAINTENANCEOPERATION_UPDATEID = ?"+ // update-info
                       " WHERE (OC_MAINTENANCEOPERATION_SERVERID = ? AND OC_MAINTENANCEOPERATION_OBJECTID = ?)"; // identification
                ps = oc_conn.prepareStatement(sSql);

                int psIdx = 1;
                ps.setString(psIdx++,maintenanceplanUID);
                ps.setDate(psIdx++,new java.sql.Date(date.getTime()));
                ps.setString(psIdx++,operator);
                ps.setString(psIdx++,result);
                ps.setString(psIdx++,comment);
                
                // nextDate might be unspecified
                if(nextDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(nextDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }

                ps.setString(psIdx++,supplier);
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
    
    public java.util.Date getNextOperationDate(){
		MaintenancePlan plan = getMaintenancePlan();
		if(plan!=null){
			if(ScreenHelper.checkString(plan.getFrequency()).length()>0){
				String frequency = plan.getFrequency();
				if(frequency.length()>0){
					GregorianCalendar calendar = new GregorianCalendar();
					calendar.setTime(new java.util.Date());
					if(frequency.equalsIgnoreCase("1")){
						//Daily
						calendar.add(GregorianCalendar.HOUR, 24);
					}
					else if(frequency.equalsIgnoreCase("2")){
						//Weekly
						calendar.add(GregorianCalendar.HOUR, 24*7);
					}
					else if(frequency.equalsIgnoreCase("3")){
						//Monthly
						calendar.add(GregorianCalendar.MONTH, 1);
					}
					else if(frequency.equalsIgnoreCase("4")){
						//Quarterly
						calendar.add(GregorianCalendar.MONTH, 3);
					}
					else if(frequency.equalsIgnoreCase("5")){
						//Half-yearly
						calendar.add(GregorianCalendar.MONTH, 6);
					}
					else if(frequency.equalsIgnoreCase("6")){
						//Yearly
						calendar.add(GregorianCalendar.MONTH, 12);
					}
					else{
						return null;
					}
					return calendar.getTime();
				}
			}
			else{
				Nomenclature nomenclature = Nomenclature.get("asset", plan.getAssetNomenclature());
				if(nomenclature!=null){
					String frequency="";
					if(plan.getType().equalsIgnoreCase("1")){
						frequency = nomenclature.getParameter("controlfrequency");
					}
					else if(plan.getType().equalsIgnoreCase("2")){
						frequency = nomenclature.getParameter("maintenancefrequency");
					}
					if(frequency.length()>0){
						GregorianCalendar calendar = new GregorianCalendar();
						calendar.setTime(new java.util.Date());
						if(frequency.equalsIgnoreCase("1")){
							//Daily
							calendar.add(GregorianCalendar.HOUR, 24);
						}
						else if(frequency.equalsIgnoreCase("2")){
							//Weekly
							calendar.add(GregorianCalendar.HOUR, 24*7);
						}
						else if(frequency.equalsIgnoreCase("3")){
							//Monthly
							calendar.add(GregorianCalendar.MONTH, 1);
						}
						else if(frequency.equalsIgnoreCase("4")){
							//Quarterly
							calendar.add(GregorianCalendar.MONTH, 3);
						}
						else if(frequency.equalsIgnoreCase("5")){
							//Half-yearly
							calendar.add(GregorianCalendar.MONTH, 6);
						}
						else if(frequency.equalsIgnoreCase("6")){
							//Yearly
							calendar.add(GregorianCalendar.MONTH, 12);
						}
						else{
							return null;
						}
						return calendar.getTime();
					}
				}
			}
		}
		return null;
	}
    //--- DELETE ----------------------------------------------------------------------------------
    public static boolean delete(String sOperationUid){
    	boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "DELETE FROM OC_MAINTENANCEOPERATIONS"+
                          " WHERE (OC_MAINTENANCEOPERATION_SERVERID = ? AND OC_MAINTENANCEOPERATION_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sOperationUid.substring(0,sOperationUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sOperationUid.substring(sOperationUid.indexOf(".")+1)));
            
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
    public static MaintenanceOperation get(MaintenanceOperation operation){
    	return get(operation.getUid());
    }
       
    public static MaintenanceOperation get(String sOperationUid){
    	MaintenanceOperation operation = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM OC_MAINTENANCEOPERATIONS"+
                          " WHERE (OC_MAINTENANCEOPERATION_SERVERID = ? AND OC_MAINTENANCEOPERATION_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sOperationUid.substring(0,sOperationUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sOperationUid.substring(sOperationUid.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                operation = new MaintenanceOperation();
                operation.setUid(rs.getString("OC_MAINTENANCEOPERATION_SERVERID")+"."+rs.getString("OC_MAINTENANCEOPERATION_OBJECTID"));
                operation.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEOPERATION_SERVERID"));
                operation.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEOPERATION_OBJECTID"));
                
                operation.maintenanceplanUID = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID"));
                operation.date               = rs.getDate("OC_MAINTENANCEOPERATION_DATE");
                operation.operator           = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_OPERATOR"));
                operation.result             = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_RESULT"));
                operation.comment            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT"));
                operation.supplier            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_SUPPLIER"));
                operation.nextDate           = rs.getDate("OC_MAINTENANCEOPERATION_NEXTDATE");
                
                // update-info
                operation.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEOPERATION_UPDATETIME"));
                operation.setUpdateUser(rs.getString("OC_MAINTENANCEOPERATION_UPDATEID"));
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
        
        return operation;
    }
        
    //--- GET LIST --------------------------------------------------------------------------------
    public static List<MaintenanceOperation> getList(){
    	return getList(new MaintenanceOperation());     	
    }
    
    public static List<MaintenanceOperation> getList(MaintenanceOperation findItem){
        List<MaintenanceOperation> foundObjects = new LinkedList();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	//*** compose query ***************************
            String sSql = "SELECT * FROM OC_MAINTENANCEOPERATIONS,OC_MAINTENANCEPLANS,OC_ASSETS WHERE OC_ASSET_OBJECTID=replace(OC_MAINTENANCEPLAN_ASSETUID,'"+MedwanQuery.getInstance().getConfigString("serverId","1")+".','') AND OC_MAINTENANCEPLAN_OBJECTID=replace(OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID,'"+MedwanQuery.getInstance().getConfigString("serverId","1")+".','')"; // 'where' facilitates further composition of query

            //*** search-criteria *** 
            if(findItem.maintenanceplanUID.length() > 0){
                sSql+= " AND OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID = '"+findItem.maintenanceplanUID+"'";
            }

            // performed-period
            if(findItem.periodPerformedBegin!=null && findItem.periodPerformedEnd!=null){
                sSql+= " AND OC_MAINTENANCEOPERATION_DATE BETWEEN '"+findItem.periodPerformedBegin+"' AND '"+findItem.periodPerformedEnd+"'";
            }
            else if(findItem.periodPerformedBegin!=null){
                sSql+= " AND OC_MAINTENANCEOPERATION_DATE > '"+findItem.periodPerformedBegin+"'";
            }
            else if(findItem.periodPerformedEnd!=null){
                sSql+= " AND OC_MAINTENANCEOPERATION_DATE <= '"+findItem.periodPerformedEnd+"'";
            }
            
            if(ScreenHelper.checkString(findItem.getTag()).split(";")[0].length()>0){
                sSql+= " AND OC_MAINTENANCEPLAN_ASSETUID = '"+findItem.getTag().split(";")[0]+"'";
            }
            if(ScreenHelper.checkString(findItem.getTag()).split(";").length>1 && ScreenHelper.checkString(findItem.getTag()).split(";")[1].length()>0){
                sSql+= " AND OC_ASSET_SERVICE like '"+findItem.getTag().split(";")[1]+"%'";
            }
            if(ScreenHelper.checkString(findItem.operator).length() > 0){
                sSql+= " AND OC_MAINTENANCEOPERATION_OPERATOR LIKE '%"+findItem.operator+"%'";
            }
            if(ScreenHelper.checkString(findItem.result).length() > 0){
                sSql+= " AND OC_MAINTENANCEOPERATION_RESULT = '"+findItem.result+"'";
            }
            
            sSql+= " ORDER BY OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID ASC";
            
            System.out.println(sSql);
            ps = oc_conn.prepareStatement(sSql);
            
                        
            //*** execute query ***************************
            rs = ps.executeQuery();
            MaintenanceOperation operation;
            
            while(rs.next()){
            	operation = new MaintenanceOperation();   
            	operation.setUid(rs.getString("OC_MAINTENANCEOPERATION_SERVERID")+"."+rs.getString("OC_MAINTENANCEOPERATION_OBJECTID"));
                operation.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEOPERATION_SERVERID"));
                operation.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEOPERATION_OBJECTID"));

                operation.maintenanceplanUID = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID"));
                operation.date               = rs.getDate("OC_MAINTENANCEOPERATION_DATE");
                operation.operator           = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_OPERATOR"));
                operation.result             = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_RESULT"));
                operation.comment            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT"));
                operation.nextDate           = rs.getDate("OC_MAINTENANCEOPERATION_NEXTDATE");
                operation.supplier           = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_SUPPLIER"));
               
                // update-info
                operation.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEOPERATION_UPDATETIME"));
                operation.setUpdateUser(rs.getString("OC_MAINTENANCEOPERATION_UPDATEID"));
                
                foundObjects.add(operation);
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