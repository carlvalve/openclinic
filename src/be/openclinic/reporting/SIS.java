package be.openclinic.reporting;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import net.admin.AdminPerson;
import pe.gob.sis.ResultQueryAsegurado;
import pe.gob.sis.Service1;
import pe.gob.sis.Service1Soap;

public class SIS {

	public static ResultQueryAsegurado getAffiliationInformation(int personid){
		AdminPerson person = AdminPerson.getAdminPerson(personid+"");
		Service1 service = new Service1();
		Service1Soap soap = service.getService1Soap();
		String autorization = soap.getSession(MedwanQuery.getInstance().getConfigString("sis.username","OPENCLINIC"), MedwanQuery.getInstance().getConfigString("sis.password","123456"));
		try{
			autorization = Long.parseLong(autorization)+"";
		}
		catch(Exception e){
			autorization="0";
		}
		ResultQueryAsegurado r = soap.consultarAfiliadoFuaE(1, autorization, MedwanQuery.getInstance().getConfigString("sis.senderdni","02424160"), "1", ScreenHelper.checkString(person.getID("natreg")), "", "", "", "");
		if(!autorization.equalsIgnoreCase("0")){
			r.setResultado(autorization);
		}
		return r;
	}
}
