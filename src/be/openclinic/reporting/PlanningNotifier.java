package be.openclinic.reporting;

import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.tools.SendSMS;
import be.mxs.common.util.tools.sendHtmlMail;
import be.openclinic.adt.Planning;
import net.admin.AdminPerson;

public class PlanningNotifier {
	public void sendPlanningReminders(){
		if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentEmail",0)==1 || MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentSMS",0)==1){
			int warntime=MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentDays",0);
			if(warntime>0){
				//First we look for all plannings that should receive a reminder
				Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
				try{
					long day=24*3600*1000;
					String language=MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en");
					PreparedStatement ps = conn.prepareStatement("select * from oc_planning where oc_planning_planneddate>=? and oc_planning_planneddate<=? and oc_planning_remindsent is null");
					ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
					ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()+warntime*day));
					ResultSet rs =ps.executeQuery();
					while(rs.next()){
						String planninguid=rs.getString("oc_planning_serverid")+"."+rs.getString("oc_planning_objectid");
						String patientid=rs.getString("oc_planning_patientuid");
						AdminPerson patient = AdminPerson.getAdminPerson(patientid);
						if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentEmail",0)==1){
							String sendto=patient.getActivePrivate().email;
							if(sendto!=null && sendto.length()>0){
								try{
									String sMailTitle = MedwanQuery.getInstance().getLabel("sendhtmlmail", "appointmentreminder", language);
									String sResult = MedwanQuery.getInstance().getLabel("web", "patientappointmentemailcontent", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
									sResult=sResult.replaceAll("#patientname#", patient.getFullName());
									sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(rs.getTimestamp("oc_planning_planneddate")));
									if(sendHtmlMail.sendSimpleMail(MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer"), MedwanQuery.getInstance().getConfigString("planningNotifierEmailSender","frank.verbeke@mxs.be"), sendto, sMailTitle, sResult)){					
										Planning.storeRemindSent(planninguid, new java.util.Date());
										Debug.println("E-mail correctly sent appointment warning "+planninguid+" to "+sendto);
									}
									else{
										Debug.println("Error sending e-mail with appointment warning "+planninguid+" to "+sendto);
									}
								}
								catch(Exception m){
									Debug.println("Error sending e-mail with appointment warning "+planninguid+" to "+sendto+": "+m.getMessage());
								}
							}
						}
						if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentSMS",0)==1){
							String sendto =patient.getActivePrivate().mobile;
							if(sendto!=null && sendto.length()>0){
								String sResult = MedwanQuery.getInstance().getLabel("web", "patientappointmentsmscontent", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
								sResult=sResult.replaceAll("#patientname#", patient.getFullName());
								sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(rs.getTimestamp("oc_planning_planneddate")));
								if(SendSMS.sendSMS(sendto, sResult)){
									Debug.println("SMS correctly sent appointment warning "+planninguid+" to "+sendto);
									Planning.storeRemindSent(planninguid, new java.util.Date());
								}
								else {
									Debug.println("Error sending SMS with appointment warning "+planninguid+" to "+sendto);
								}
							}
						}
					}
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
	}
}
