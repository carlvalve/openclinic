package be.openclinic.reporting;

import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.medical.Diagnosis;
import net.admin.AdminPerson;
import net.admin.AdminPrivateContact;

public class Register {
	private AdminPerson patient =null;
	private Encounter encounter = null;
	private TransactionVO transaction = null;
	private String sWebLanguage=null;
	private int counter=0;
	
	
	public int getCounter() {
		return counter;
	}

	public void setCounter(int counter) {
		this.counter = counter;
	}

	public Register(int serverid,int transactionid, int personid, String language){
		transaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid);
		patient = AdminPerson.getAdminPerson(personid+"");
		if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID")!=null){
			encounter = Encounter.get(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID"));
		}
		if(encounter==null){
			encounter = Encounter.getActiveEncounterOnDate(new java.sql.Timestamp(transaction.getUpdateTime().getTime()), personid+"");
		}
		sWebLanguage=language;
	}
	
	public String getValue(String source, String name, String translateresult){
		String s ="";
		if(source.equalsIgnoreCase("system")){
			if(name.equalsIgnoreCase("id")){
				counter++;
				s=""+counter;
			}
		}
		else if(source.equalsIgnoreCase("diagnosis")){
			if(name.equalsIgnoreCase("icd10")){
				Collection items = transaction.getItems();
				Iterator iItems = items.iterator();
				while(iItems.hasNext()){
					ItemVO item =(ItemVO)iItems.next();
					if(item.getType().startsWith("ICD10Code")){
						if(s.length()>0){
							s+=", ";
						}
						s+=item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType(), sWebLanguage);
					}
				}
			}
			else if(name.equalsIgnoreCase("icd10withlocalcodes")){
				Collection items = transaction.getItems();
				Iterator iItems = items.iterator();
				while(iItems.hasNext()){
					ItemVO item =(ItemVO)iItems.next();
					if(item.getType().startsWith("ICD10Code")){
						if(s.length()>0){
							s+=", ";
						}
						s+=item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType(), sWebLanguage);
					}
					else if(item.getType().startsWith("ICPCCode") && item.getType().replaceAll("ICPCCode", "").startsWith("J")){
						if(s.length()>0){
							s+=", ";
						}
						s+=item.getType().replaceAll("ICPCCode", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType(), sWebLanguage);
					}
				}
			}
			else if(name.equalsIgnoreCase("encountericd10")){
				Collection diagnoses = Diagnosis.selectDiagnoses("", "", encounter.getUid(), "", "", "", "", "", "", "", "", "icd10", "");
				Iterator iDiagnoses = diagnoses.iterator();
				while(iDiagnoses.hasNext()){
					Diagnosis diagnosis =(Diagnosis)iDiagnoses.next();
					if(s.length()>0){
						s+=", ";
					}
					s+=diagnosis.getCode()+" "+MedwanQuery.getInstance().getCodeTran("icd10code"+diagnosis.getCode(), sWebLanguage);
				}
			}
			else if(name.equalsIgnoreCase("icpc2")){
				Collection items = transaction.getItems();
				Iterator iItems = items.iterator();
				while(iItems.hasNext()){
					ItemVO item =(ItemVO)iItems.next();
					if(item.getType().startsWith("ICPCCode")){
						if(s.length()>0){
							s+=", ";
						}
						s+=item.getType().replaceAll("ICPCCode", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType(), sWebLanguage);
					}
				}
			}
		}
		else if(source.equalsIgnoreCase("patient")){
			if(name.equalsIgnoreCase("fullname")){
				s=patient.getFullName();
			}
			else if(name.equalsIgnoreCase("ageinyears")){
				s=patient.getAge()+"";
			}
			else if(name.equalsIgnoreCase("dateofbirth")){
				s=patient.dateOfBirth;
			}
			else if(name.equalsIgnoreCase("personid")){
				s=patient.personid+"";
			}
			else if(name.equalsIgnoreCase("gender")){
				s=patient.gender;
			}
			else if(name.equalsIgnoreCase("comment")){
				s=patient.comment;
			}
			else if(name.equalsIgnoreCase("comment1")){
				s=patient.comment1;
			}
			else if(name.equalsIgnoreCase("comment2")){
				s=patient.comment2;
			}
			else if(name.equalsIgnoreCase("comment3")){
				s=patient.comment3;
			}
			else if(name.equalsIgnoreCase("comment4")){
				s=patient.comment4;
			}
			else if(name.equalsIgnoreCase("comment5")){
				s=patient.comment5;
			}
			else if(name.equalsIgnoreCase("address")){
				if(patient.getActivePrivate()!=null){
					s=patient.getActivePrivate().address;
				}
			}
			else if(name.equalsIgnoreCase("profession")){
				if(patient.getActivePrivate()!=null){
					s=patient.getActivePrivate().businessfunction;
				}
			}
		}
		else if(source.equalsIgnoreCase("transaction")){
			if(name.equalsIgnoreCase("updatetime")){
				s=ScreenHelper.formatDate(transaction.getUpdateTime());
			}
			else {
				s = ScreenHelper.checkString(transaction.getItemValue(name)).replaceAll(";", ",").replaceAll("\r", "").replaceAll("\n", " ");
			}
		}
		else if(source.equalsIgnoreCase("encounter") && encounter!=null){
			if(name.equalsIgnoreCase("begin") && encounter.getBegin()!=null){
				s=ScreenHelper.formatDate(encounter.getBegin());
			}
			else if(name.equalsIgnoreCase("end") && encounter.getEnd()!=null){
				s=ScreenHelper.formatDate(encounter.getEnd());
			}
			else if(name.equalsIgnoreCase("duration") && encounter.getBegin()!=null && encounter.getEnd()!=null){
				long day = 24*3600*1000;
				java.util.Date start = ScreenHelper.parseDate(ScreenHelper.formatDate(encounter.getBegin()));
				java.util.Date stop = ScreenHelper.parseDate(ScreenHelper.formatDate(encounter.getEnd()));
				s=((stop.getTime()-start.getTime())/day+1)+"";
			}
			else if(name.equalsIgnoreCase("origin")){
				s=ScreenHelper.checkString(encounter.getOrigin());
			}
			else if(name.equalsIgnoreCase("outcome")){
				s=ScreenHelper.checkString(encounter.getOutcome());
			}
			
		}
		if(s.length()>0 && translateresult!=null && translateresult.length()>0){
			s=ScreenHelper.getTranNoLink(translateresult, s, sWebLanguage);
		}
		return s;
	}
}
