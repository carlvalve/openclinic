package be.openclinic.knowledge;

import java.sql.*;

import be.mxs.common.util.db.MedwanQuery;

public class Growth {
	public static double getZScore(double height,double weight, String gender){
		double zScore=-999;
		if(gender.toUpperCase().startsWith("M")){
			gender="m";
		}
		else{
			gender="f";
		}
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from OC_GROWTH where height>=? and gender=? order by height");
			ps.setDouble(1, height);
			ps.setString(2, gender);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				if(weight<rs.getDouble("SD3neg")){
					zScore= -3-(rs.getDouble("SD3neg")-weight)/(rs.getDouble("SD3neg")-rs.getDouble("SD4neg"));
				}
				else if(weight<rs.getDouble("SD2neg")){
					zScore= -2-(rs.getDouble("SD2neg")-weight)/(rs.getDouble("SD2neg")-rs.getDouble("SD3neg"));
				}
				else if(weight<rs.getDouble("SD1neg")){
					zScore= -1-(rs.getDouble("SD1neg")-weight)/(rs.getDouble("SD1neg")-rs.getDouble("SD2neg"));
				}
				else if(weight<rs.getDouble("SD0")){
					zScore= 0-(rs.getDouble("SD0")-weight)/(rs.getDouble("SD0")-rs.getDouble("SD1neg"));
				}
				else if(weight<rs.getDouble("SD1")){
					zScore= 1-(rs.getDouble("SD1")-weight)/(rs.getDouble("SD1")-rs.getDouble("SD0"));
				}
				else if(weight<rs.getDouble("SD2")){
					zScore= 2-(rs.getDouble("SD2")-weight)/(rs.getDouble("SD2")-rs.getDouble("SD1"));
				}
				else if(weight<rs.getDouble("SD3")){
					zScore= 3-(rs.getDouble("SD3")-weight)/(rs.getDouble("SD3")-rs.getDouble("SD2"));
				}
				else {
					zScore= 4-(rs.getDouble("SD4")-weight)/(rs.getDouble("SD4")-rs.getDouble("SD3"));
				}
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return zScore;
	}

}
