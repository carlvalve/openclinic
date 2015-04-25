package be.openclinic.medical;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;

import net.admin.AdminPerson;
import net.admin.User;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class Vaccination {
	public String personid,date,type,batchnumber,expiry,location;
	
	public long getAge(){
		long d = 0;
		try{
			d= new java.util.Date().getTime()-ScreenHelper.parseDate(date).getTime();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return d;
	}
	
	public void delete(){
		date="";
		batchnumber="";
		expiry="";
		location="";
		save();
	}
	
	public void save(){
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("delete from OC_VACCINATIONS where OC_VACCINATION_PATIENTUID = ? and"
					+ " OC_VACCINATION_TYPE=?");
			ps.setString(1,personid);
			ps.setString(2,type);
			ps.execute();
			ps.close();
			ps = conn.prepareStatement("insert into OC_VACCINATIONS(OC_VACCINATION_PATIENTUID,OC_VACCINATION_DATE,OC_VACCINATION_TYPE,"
					+ "OC_VACCINATION_BATCHNUMBER,OC_VACCINATION_EXPIRY,OC_VACCINATION_LOCATION,OC_VACCINATION_UPDATETIME) values(?,?,?,?,?,?,?)");
			ps.setString(1,personid);
			ps.setString(2,date);
			ps.setString(3,type);
			ps.setString(4,batchnumber);
			ps.setString(5,expiry);
			ps.setString(6,location);
			ps.setTimestamp(7,new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static Hashtable getVaccinations(String personid){
		Hashtable vaccinations = new Hashtable();
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from OC_VACCINATIONS where OC_VACCINATION_PATIENTUID=?");
			ps.setString(1,personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Vaccination vaccination = new Vaccination();
				vaccination.personid=rs.getString("OC_VACCINATION_PATIENTUID");
				vaccination.date=rs.getString("OC_VACCINATION_DATE");
				vaccination.type=rs.getString("OC_VACCINATION_TYPE");
				vaccination.batchnumber=rs.getString("OC_VACCINATION_BATCHNUMBER");
				vaccination.expiry=rs.getString("OC_VACCINATION_EXPIRY");
				vaccination.location=rs.getString("OC_VACCINATION_LOCATION");
				vaccinations.put(vaccination.type,vaccination);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return vaccinations;
	}

	public static HashSet getVaccinationsTodo(String personid){
		boolean bred=false;
		long age=0;
		try{
			AdminPerson person = AdminPerson.getAdminPerson(personid);
	    	age = new java.util.Date().getTime()-ScreenHelper.parseDate(person.dateOfBirth).getTime();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		long day = 24*3600*1000;
		long week=7*day;
		long month=30*day;
		long year=365*day;
		HashSet vaccinations = new HashSet();
		Hashtable allvaccinations = getVaccinations(personid);
		String[] vaccins="bcg;polio0;polio1;penta1;pneumo1;rota1;polio2;penta2;pneumo2;rota2;polio3;penta3;pneumo3;rota3;measles;yellowfever;meningitisa;vat1;vat2;vatr1;vatr2;vatr3;vita100;vita200.1;vita200.2;alben200.1;alben400.1".split(";");
		for(int n=0;n<vaccins.length;n++){
			Vaccination vaccination=(Vaccination)allvaccinations.get(vaccins[n]);
			if(vaccination==null || vaccination.date==null || vaccination.date.trim().length()==0){
				Vaccination vat1=(Vaccination)allvaccinations.get("vat1");
				Vaccination vat2=(Vaccination)allvaccinations.get("vat2");
				Vaccination vatr1=(Vaccination)allvaccinations.get("vatr1");
				Vaccination vatr2=(Vaccination)allvaccinations.get("vatr2");
				Vaccination vatr3=(Vaccination)allvaccinations.get("vatr3");
			
				//Vaccination rules base
				if("*bcg*polio0*".contains(vaccins[n])){
					//BIRTH
					bred=age<week;
				}
				if("*polio1*penta1*pneumo1*rota1*".contains(vaccins[n])){
					//6 WEEKS
					bred=(age>=6*week&&age<10*week);
				}
				if("*polio2*penta2*pneumo2*rota2*".contains(vaccins[n])){
					//10 WEEKS
					bred=(age>=10*week&&age<14*week);
				}
				if("*polio3*penta3*pneumo3*rota3*".contains(vaccins[n])){
					//14 WEEKS
					bred=(age>=14*week&&age<9*month);
				}
				if("*measles*yellowfever*meningitisa*".contains(vaccins[n])){
					//9 MONTHS
					bred=(age>=9*month&&age<13*month);
				}
				else if("*vat1*vat2*vatr1*vatr2*vatr3*".contains(vaccins[n])){
					//15-49 years
					if(age>=15*year&&age<50*year){
						
						bred=vaccins[n].equalsIgnoreCase("vat1") && vat2==null && vatr1==null && vatr2==null && vatr3==null;
						bred=bred||(vaccins[n].equalsIgnoreCase("vat2") && vat1!=null && vat1.getAge()>=30*day && vatr1==null && vatr2==null && vatr3==null);
						bred=bred||(vaccins[n].equalsIgnoreCase("vatr1") && vat2!=null && vat2.getAge()>=6*month && vatr2==null && vatr3==null);
						bred=bred||(vaccins[n].equalsIgnoreCase("vatr2") && vatr1!=null && vatr1.getAge()>=year && vatr3==null);
						bred=bred||(vaccins[n].equalsIgnoreCase("vatr3") && vatr2!=null && vatr2.getAge()>=year);
					}
				}
				else if("*vita100*vita100a*".contains(vaccins[n])){
					bred=(age>=6*month-week && age<12*month);
				}
				else if("*vita200.1*alben200.1*vita200.1a*alben200.1a*vita200.1b*alben200.1b*".contains(vaccins[n])){
					bred=(age>=12*month-week && age<24*month);
				}
				else if("*vita200.2*alben400.1*vita200.2a*alben400.1a*vita200.2b*alben400.1b*vita200.2c*alben400.1c*vita200.2d*alben400.1d*".contains(vaccins[n])){
					bred=(age>=24*month-week && age<60*month);
				}
				if(bred){
					vaccinations.add(vaccins[n]);
				}
			}

		}
		return vaccinations;
	}

	public static String getVaccination(Hashtable vaccinations,long age,HttpServletRequest request,String type,String parameter){
		String sResult="";
		String tag="<td class='admin2'>";
		String redtag="<td bgcolor='#FE4B59'>";
		//Find vaccination here
		Vaccination vaccination=(Vaccination)vaccinations.get(type);
		if(vaccination!=null){
			if(parameter.equalsIgnoreCase("date")){
				sResult=vaccination.date;
			}
			else if(parameter.equalsIgnoreCase("type")){
				sResult=vaccination.type;
			}
			else if(parameter.equalsIgnoreCase("batchnumber")){
				sResult=vaccination.batchnumber;
			}
			else if(parameter.equalsIgnoreCase("expiry")){
				sResult=vaccination.expiry;
			}
			else if(parameter.equalsIgnoreCase("location")){
				sResult=vaccination.location;
			}
		}
		
		if(parameter.equalsIgnoreCase("date")){
			boolean bred=false,bgreen=false;
			long day = 24*3600*1000;
			long week=7*day;
			long month=30*day;
			long year=365*day;
			Vaccination vat1=(Vaccination)vaccinations.get("vat1");
			Vaccination vat2=(Vaccination)vaccinations.get("vat2");
			Vaccination vatr1=(Vaccination)vaccinations.get("vatr1");
			Vaccination vatr2=(Vaccination)vaccinations.get("vatr2");
			Vaccination vatr3=(Vaccination)vaccinations.get("vatr3");
		
			//Vaccination rules base
			if(sResult.length()==0){
				if("*bcg*polio0*".contains(type)){
					//BIRTH
					bred=age<week;
				}
				if("*polio1*penta1*pneumo1*rota1*".contains(type)){
					//6 WEEKS
					bred=(age>=6*week&&age<10*week);
				}
				if("*polio2*penta2*pneumo2*rota2*".contains(type)){
					//10 WEEKS
					bred=(age>=10*week&&age<14*week);
				}
				if("*polio3*penta3*pneumo3*rota3*".contains(type)){
					//14 WEEKS
					bred=(age>=14*week&&age<9*month);
				}
				if("*measles*yellowfever*meningitisa*".contains(type)){
					//9 MONTHS
					bred=(age>=9*month&&age<13*month);
				}
				else if("*vat1*vat2*vatr1*vatr2*vatr3*".contains(type)){
					//15-49 years
					if(age>=15*year&&age<50*year){
						
						bred=type.equalsIgnoreCase("vat1") && vat2==null && vatr1==null && vatr2==null && vatr3==null;
						bred=bred||(type.equalsIgnoreCase("vat2") && vat1!=null && vat1.getAge()>=30*day && vatr1==null && vatr2==null && vatr3==null);
						bred=bred||(type.equalsIgnoreCase("vatr1") && vat2!=null && vat2.getAge()>=6*month && vatr2==null && vatr3==null);
						bred=bred||(type.equalsIgnoreCase("vatr2") && vatr1!=null && vatr1.getAge()>=year && vatr3==null);
						bred=bred||(type.equalsIgnoreCase("vatr3") && vatr2!=null && vatr2.getAge()>=year);
					}
				}
				else if("*vita100*vita100a*".contains(type)){
					bred=(age>=6*month-week && age<12*month);
				}
				else if("*vita200.1*alben200.1*".contains(type)){
					bred=(age>=12*month-week && age<24*month);
				}
				else if("*vita200.2*alben400.1*".contains(type)){
					bred=(age>=24*month-week && age<60*month);
				}
				sResult=(bred?redtag:tag)+"<img src='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/_img/icons/icon_new.gif' "
						+ "onclick='editVaccination(\""+type+"\");'/>";
			}
			else {
				//result is a date value
				java.util.Date vaccinationDate = ScreenHelper.parseDate(sResult);
				if(vaccinationDate!=null){
					if("*bcg*polio0*polio1*penta1*pneumo1*rota1*polio2*penta2*pneumo2*rota2*polio3*penta3*pneumo3*rota3*".contains(type)){
						//express in weeks
						sResult+=" ("+(vaccinationDate.getTime()-new java.util.Date().getTime()+age)/week+" "+ScreenHelper.getTran("web","weeks",((User)request.getSession().getAttribute("activeUser")).person.language)+")";
					}
					else if("*measles*yellowfever*meningitisa*vita100*vita100a*vita200.1*alben200.1*vita200.1a*alben200.1a*vita200.1b*alben200.1b*vita200.2*alben400.1*vita200.2a*alben400.1a*vita200.2b*alben400.1b*vita200.2c*alben400.1c*vita200.2d*alben400.1d*".contains(type)){
						//express in months
						sResult+=" ("+(vaccinationDate.getTime()-new java.util.Date().getTime()+age)/month+" "+ScreenHelper.getTran("web","months",((User)request.getSession().getAttribute("activeUser")).person.language)+")";
					}
					else if("*vat1*vat2*vatr1*vatr2*vatr3*".contains(type)){
						//express in years
						sResult+=" ("+(vaccinationDate.getTime()-new java.util.Date().getTime()+age)/year+" "+ScreenHelper.getTran("web","years",((User)request.getSession().getAttribute("activeUser")).person.language)+")";
					}
				}
				sResult="<td bgcolor='lightgreen'><img src='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/_img/icons/icon_edit.gif' "
						+ "onclick='editVaccination(\""+type+"\");'/>"+sResult;
			}
		}
		else {
			sResult=tag+sResult;
		}
		sResult+="</td>";
		return sResult;
	}
}
