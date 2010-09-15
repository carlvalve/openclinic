package be.openclinic.healthrecord;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.system.Debug;

import java.io.FileOutputStream;
import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Document {

    public static String load(String sDocumentId){
        String sFilename = "";
        if (sDocumentId.length()>0){
            String [] ids = sDocumentId.split("\\.");
            Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
            try{
                if (ids.length==2){
                    String sSelect = "SELECT * FROM OC_DOCUMENTS WHERE OC_DOCUMENT_SERVERID = ? AND OC_DOCUMENT_OBJECTID = ?";
                    PreparedStatement ps;
                    ResultSet rs;

                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    rs = ps.executeQuery();

                    if(rs.next()){
                        sFilename = ScreenHelper.checkString(rs.getString("OC_DOCUMENT_NAME"));
                        String sFolderStore = MedwanQuery.getInstance().getConfigString("DocumentsFolder","c:/projects/openclinic/web/documents/");
                        File file = new File(sFolderStore+"/"+sFilename);
                        FileOutputStream fileOutputStream = new FileOutputStream(file);
                        fileOutputStream.write(rs.getBytes("OC_DOCUMENT_VALUE"));
                        fileOutputStream.close();
                    }
                    rs.close();
                    ps.close();
                }
            }catch(Exception e){
                Debug.println("OpenClinic => Document.java => load => "+e.getMessage());
                e.printStackTrace();
            }
            try {
				oc_conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
        return sFilename;
    }

     public static String store(String sFileName, String sUserId, byte[] aValue){
        String sId = "";

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            int iServerId = MedwanQuery.getInstance().getConfigInt("serverId");
            int iObjectId = MedwanQuery.getInstance().getCounter("DocumentID");
            String sSelect = "INSERT INTO OC_DOCUMENTS (OC_DOCUMENT_SERVERID, OC_DOCUMENT_OBJECTID, OC_DOCUMENT_NAME, OC_DOCUMENT_CREATETIME, OC_DOCUMENT_UPDATETIME"
                    +", OC_DOCUMENT_UPDATEUID, OC_DOCUMENT_VALUE) VALUES (?,?,?,?,?,?,?)";
            PreparedStatement ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1, iServerId);
            ps.setInt(2, iObjectId);
            ps.setString(3, iServerId+"."+iObjectId+"_"+sFileName);
            ps.setTimestamp(4, ScreenHelper.getSQLTime());
            ps.setTimestamp(5, ScreenHelper.getSQLTime());
            ps.setString(6,sUserId);
            ps.setBytes(7,aValue);
            ps.executeUpdate();
            ps.close();

            sId = iServerId+"."+iObjectId;
        }catch(Exception e){
            Debug.println("OpenClinic => Document.java => store => "+e.getMessage());
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
         return sId;
    }

    public static String getName(String sDocumentId){
        if (sDocumentId.length()>0){
            String [] ids = sDocumentId.split("\\.");
            Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
            try{
                if (ids.length==2){
                    String sSelect = "SELECT * FROM OC_DOCUMENTS WHERE OC_DOCUMENT_SERVERID = ? AND OC_DOCUMENT_OBJECTID = ?";
                    PreparedStatement ps;
                    ResultSet rs;

                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    rs = ps.executeQuery();

                    if(rs.next()){
                        return ScreenHelper.checkString(rs.getString("OC_DOCUMENT_NAME"));
                    }
                    rs.close();
                    ps.close();
                }
            }catch(Exception e){
                Debug.println("OpenClinic => Document.java => getName => "+e.getMessage());
                e.printStackTrace();
            }
            try {
				oc_conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
        return "";
    }
}
