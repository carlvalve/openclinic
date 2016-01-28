package be.mxs.common.util.tools;

import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.smslib.AGateway.*;
import org.smslib.*;
import org.smslib.modem.*;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;

public class SendSMS {
	public static boolean sendSMS(String to, String message){
		boolean bSuccess=false;
		//if country prefix already included, don't do anything
		if(!(MedwanQuery.getInstance().getConfigString("cellPhoneCountryPrefix","").length()>0 && to.startsWith(MedwanQuery.getInstance().getConfigString("cellPhoneCountryPrefix","")))){
			if(MedwanQuery.getInstance().getConfigInt("cellPhoneRemoveLeadingZero",0)==1){
				while(to.startsWith("0")){
					to=to.substring(1);
				}
			}
			if(MedwanQuery.getInstance().getConfigString("cellPhoneCountryPrefix","").length()>0){
				to=MedwanQuery.getInstance().getConfigString("cellPhoneCountryPrefix","")+to;
			}
		}
		Debug.println("Trying to send message to "+to+" using SMS gateway "+MedwanQuery.getInstance().getConfigString("smsgateway",""));
		if(MedwanQuery.getInstance().getConfigString("smsgateway","").equalsIgnoreCase("smsglobal")){
			try {						
				HttpClient client = new HttpClient();
				PostMethod method = new PostMethod(MedwanQuery.getInstance().getConfigString("smsglobal.url","http://www.smsglobal.com/http-api.php"));
				Vector<NameValuePair> vNvp = new Vector<NameValuePair>();
				vNvp.add(new NameValuePair("action","sendsms"));
				vNvp.add(new NameValuePair("user",MedwanQuery.getInstance().getConfigString("smsglobal.user","")));
				vNvp.add(new NameValuePair("password",MedwanQuery.getInstance().getConfigString("smsglobal.password","")));
				vNvp.add(new NameValuePair("from",MedwanQuery.getInstance().getConfigString("smsglobal.from","")));
				vNvp.add(new NameValuePair("to",to));
				vNvp.add(new NameValuePair("text",URLEncoder.encode(message,"utf-8")));
				NameValuePair[] nvp = new NameValuePair[vNvp.size()];
				vNvp.copyInto(nvp);
				method.setQueryString(nvp);
				client.executeMethod(method);
				String sResponse=method.getResponseBodyAsString();
				if(sResponse.contains("OK: 0")){
					bSuccess=true;
				}
			} catch (Exception e) {				
				e.printStackTrace();
			}
		}
		else if(MedwanQuery.getInstance().getConfigString("smsgateway","").equalsIgnoreCase("hqsms")){
			try {						
				HttpClient client = new HttpClient();
				PostMethod method = new PostMethod(MedwanQuery.getInstance().getConfigString("hqsms.url","http://api.hqsms.com/sms.do"));
				Vector<NameValuePair> vNvp = new Vector<NameValuePair>();
				vNvp.add(new NameValuePair("normalize","1"));
				vNvp.add(new NameValuePair("username",MedwanQuery.getInstance().getConfigString("hqsms.user","")));
				vNvp.add(new NameValuePair("password",MedwanQuery.getInstance().getConfigString("hqsms.password","")));
				vNvp.add(new NameValuePair("from",MedwanQuery.getInstance().getConfigString("hqsms.from","HQSMS.com")));
				vNvp.add(new NameValuePair("to",to));
				vNvp.add(new NameValuePair("message",message));
				NameValuePair[] nvp = new NameValuePair[vNvp.size()];
				vNvp.copyInto(nvp);
				method.setQueryString(nvp);
				client.executeMethod(method);
				String sResponse=method.getResponseBodyAsString();
				if(sResponse.contains("OK:")){
					bSuccess=true;
				}
			} catch (Exception e) {				
				e.printStackTrace();
			}
		}
		else if(MedwanQuery.getInstance().getConfigString("smsgateway","").equalsIgnoreCase("nokia")){
			try{
				String sPinCode = MedwanQuery.getInstance().getConfigString("smsPincode","0000"); 
				String sPort= MedwanQuery.getInstance().getConfigString("smsDevicePort","/dev/ttyS20");
				int nBaudrate=MedwanQuery.getInstance().getConfigInt("smsBaudrate",115200);
				System.setProperty("smslib.serial.polling", MedwanQuery.getInstance().getConfigString("smsPolling","false"));
				SendSMS sendSMS = new SendSMS();				
				if (message.length() > 160){ 					
					Vector vSMSs = new Vector();
					vSMSs = splitSMSText(message);
					Enumeration<String> eSMSs = vSMSs.elements();
					String sSMS;
					while (eSMSs.hasMoreElements()){
						sSMS = eSMSs.nextElement();
						sendSMS.send("modem.nokia",sPort, nBaudrate, "Nokia", "2690", sPinCode, to, sSMS);
					}
				}
				else { 
					sendSMS.send("modem.nokia", sPort, nBaudrate, "Nokia", "2690", sPinCode, to, message);
				}			
				bSuccess=true;
			}
			catch(Exception m){
				
			}
		}
		else {
			Debug.println("NO SMS GATEWAY DEFINED!");
		}
		return bSuccess;
	}

	public void send(String portname,String port,int baud,String brand,String model,String pin,String destination,String message) throws Exception
	{
		OutboundNotification outboundNotification = new OutboundNotification();
		SerialModemGateway gateway = new SerialModemGateway(portname, port, baud, brand,model);
		gateway.setInbound(true);
		gateway.setOutbound(true);
		gateway.setProtocol(Protocols.PDU);
		gateway.setSimPin(pin);
		Service.getInstance().setOutboundMessageNotification(outboundNotification);
		Service.getInstance().addGateway(gateway);
		Service.getInstance().startService();
		OutboundMessage msg = new OutboundMessage(destination, message);
		Service.getInstance().sendMessage(msg);
		gateway.stopGateway();
		Service.getInstance().stopService();
		Service.getInstance().removeGateway(gateway);
	}

	public class OutboundNotification implements IOutboundMessageNotification
	{
		public void process(AGateway gateway, OutboundMessage msg)
		{
		}
	}
	
	public static Vector<String> splitSMSText(String sResult){
		Vector<String> vSMSs = new Vector<String>();		
		String[] aLines = sResult.split("\n");
		
		if (aLines[0].length() < 160) {
			int iMsgsSend = 1;
			String sMsgToSend = aLines[0]+" (" + iMsgsSend + ")";
			int iLabLineToAdd = 1;
			int iLabLinesSent = 0;			
			String sNextLabLine;
			while (iLabLinesSent < aLines.length - 1) { // eg from 0 to 2
				sNextLabLine = aLines[iLabLineToAdd];
				if (sMsgToSend.length() + sNextLabLine.length() <= 160) {					
					sMsgToSend = sMsgToSend + "\n" + sNextLabLine;
					iLabLineToAdd = iLabLineToAdd + 1;
					iLabLinesSent = iLabLinesSent + 1;
					if (iLabLinesSent == aLines.length - 1){ // last line
						vSMSs.add(sMsgToSend);						
					}
				}
				else { // Longer than 160 ==>> Send earlier one									
					vSMSs.add(sMsgToSend);						
					iMsgsSend = iMsgsSend + 1;
					sMsgToSend = aLines[0]+" (" + iMsgsSend + ")";
				}								
			}			
		}
		return vSMSs;
	}
}