package ocspring2;

import java.awt.BorderLayout;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTable;

/**
 *
 * @author riknew
 */
public class OC {

   final Double PCPEMIN = 3.0;
   final Double CUTOFF = 0.15;

   //static int selNrs1 = 136;
   //static int selNrs2 = 542;
   //static int selNrs3 = 134;
   //static int selNrs4 = 0;
   private int selNrs1;
   private int selNrs2;
   private int selNrs3;
   private int selNrs4;
   private String language;

   Statement statement;
   String mysql, vectorSQL;
   private int testi;

   public Vector<String> getListHeader() {
      Vector<String> cNames = new Vector<String>();
      try {
    	  
         statement = Db.conn.createStatement();
         ResultSet rs = statement.executeQuery(vectorSQL);
         ResultSetMetaData meta = rs.getMetaData();
         int colCount = meta.getColumnCount();
         cNames = new Vector<String>();
         for (int h = 1; h <= colCount; h++) {
            cNames.addElement(meta.getColumnName(h));
         }
         rs.close();
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return cNames;
   }

   public Vector<Vector> getListData() {
      Vector<Vector> tVector = new Vector<Vector>();
      Vector<String> rVector;
      try {
         statement = Db.conn.createStatement();
         ResultSet rs = statement.executeQuery(vectorSQL);
         ResultSetMetaData meta = rs.getMetaData();
         int colCount = meta.getColumnCount();
         while (rs.next()) {
            rVector = new Vector<String>();
            for (int i = 0; i < colCount; i++) {
               rVector.addElement(rs.getString(i + 1));
            }
            tVector.addElement(rVector);
         }
         rs.close();
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return tVector;
   }

   public void setup() {
      Db.Connect();
      
      //************
      //* Modified *
      //************
      	Db.runsql("drop temporary table if exists tmp_sel");
      //************
      	
      Db.runsql("create temporary table tmp_sel as select id,nrz,nrs, 0 as selection from assocdata");
      Db.runsql("create index temporary1 on tmp_sel(nrs)");
      Db.runsql("create index temporary2 on tmp_sel(nrz)");
      
      //************
      //* Modified *
      //************
      	Db.runsql("drop temporary table if exists tmp_did");
      //************
      	
      Db.runsql("create temporary table tmp_did (id int(11) NOT NULL AUTO_INCREMENT,NRZ int(11) DEFAULT NULL, PRIMARY KEY (id))");

      //************
      //* Modified *
      //************
      	Db.runsql("drop temporary table if exists tmp_sin");
      //************
      	
      Db.runsql("create temporary table tmp_sin (id int(11) NOT NULL AUTO_INCREMENT, NRS int(11) DEFAULT NULL, PRIMARY KEY (id))");

      //************
      //* Modified *
      //************
      	Db.runsql("drop temporary table if exists tmp_nrs");
      //************
      	
      Db.runsql("create temporary table tmp_nrs (id int(11) NOT NULL AUTO_INCREMENT, NRS int(11) DEFAULT NULL, PRIMARY KEY (id))");

      testi = Db.get_integer("select count(*) from sym where (SYM.TTYPE=0) and nrs=" + selNrs1);
      if (testi == 0) {
         //JOptionPane.showMessageDialog(null, "argument 1  error");
         //System.exit(0);
      } else {
         mysql = "insert into tmp_sin (nrs) values (" + selNrs1 + ")";
         Db.runsql(mysql);
      }

      testi = Db.get_integer("select count(*) from sym where  ((SYM.TTYPE=1) or (SYM.TTYPE=8)) and nrs=" + selNrs2);
      if (testi == 0) {
         //JOptionPane.showMessageDialog(null, "argument 2  error");
         //System.exit(0);
      } else {
         mysql = "insert into tmp_sin (nrs) values (" + selNrs2 + ")";
         Db.runsql(mysql);
      }

      testi = Db.get_integer("select count(*) from sym where  (SYM.TTYPE<>1 And SYM.TTYPE<>0 AND SYM.STARTUP=-1" + " AND sym.nrs not in (select nrsexclude from excludes where nrs in (" + selNrs1 + "," + selNrs2 + "))"
              + " AND sym.nrs not in (select nrs from excludes where nrsexclude in (" + selNrs1 + "," + selNrs2 + "))) and nrs=" + selNrs3);
      if (testi == 0) {
         //JOptionPane.showMessageDialog(null, "argument 3  error");
         //System.exit(0);
      } else {
         mysql = "insert into tmp_sin (nrs) values (" + selNrs3 + ")";
         Db.runsql(mysql);
      }

      if (selNrs4 != 0) {
         testi = Db.get_integer("select count(*) from sym where  (SYM.TTYPE<>1 And SYM.TTYPE<>0 AND SYM.STARTUP=-1"
                 + " AND sym.nrs not in (select nrsexclude from excludes where nrs in (" + selNrs1 + "," + selNrs2 + "," + selNrs3 + "))"
                 + " AND sym.nrs not in (select nrs from excludes where nrsexclude in (" + selNrs1 + "," + selNrs2 + "," + selNrs3 + ")))"
                 + " AND sym.nrs =" + selNrs4);
         if (testi == 0) {
            //JOptionPane.showMessageDialog(null, "argument 4 error");
            //System.exit(0);
         } else {
            mysql = "insert into tmp_sin (nrs) values (" + selNrs4 + ")";
            Db.runsql(mysql);
         }
      }

      if (selNrs4 == 0) {
         mysql = "update tmp_sel set selection=1 where (nrz in (select nrz from diag)) and ((tmp_sel.nrs=" + selNrs1 + ") OR (tmp_sel.nrs=" + selNrs2 + ") OR (tmp_sel.nrs=" + selNrs3 + "))";
         Db.runsql(mysql);
      } else {
         mysql = "update tmp_sel set selection=1 where (nrz in (select nrz from diag)) and ((tmp_sel.nrs=" + selNrs1 + ") OR (tmp_sel.nrs=" + selNrs2 + ") OR (tmp_sel.nrs=" + selNrs3 + ") OR (tmp_sel.nrs=" + selNrs4 + "))";
         Db.runsql(mysql);
      }

      int cntSelected = Db.get_integer("select count(*) from tmp_sin");

      Db.runsql("insert into tmp_did (nrz) SELECT tmp_sel.nrz FROM tmp_sel "
              + " WHERE selection=1 GROUP BY NRZ HAVING count(nrz)=" + cntSelected);  //wordt nu 3 of 4 

      String symptomlabel="s.sympf";
      String diseaselabel="e.zieke";
      if(language.equalsIgnoreCase("fr")){
    	  symptomlabel="s.sympf";
    	  diseaselabel="e.ziekf";
      }
      else if(language.equalsIgnoreCase("nl")){
    	  symptomlabel="s.sympn";
    	  diseaselabel="e.ziekn";
      }
      
      vectorSQL = "SELECT 200 as RESULTCODE,a.nrz,a.nrs,"+diseaselabel+","+symptomlabel+",AFRICA_PC, AFRICA_PE ,d.cutoff,m.icd10 from assocdata a "
              + "join diag d on a.nrz=d.NRZ "
              + "join diag_lang e on a.nrz=e.NRZ "
              + "join sym s on a.nrs=s.nrs "
              + "join diseasemappings m on a.nrz=m.nrz "
              + "join tmp_sel on a.id=tmp_sel.id "
              + "where (a.nrz in (select nrz from tmp_did) and "
              + "tmp_sel.selection=0 and "
              + "d.cutoff<" + CUTOFF + " and "
              + "AFRICA_PC>" + PCPEMIN + " and AFRICA_PE>" + PCPEMIN + " ) "
              + "order by d.zieke,greatest(AFRICA_PC,AFRICA_PE) desc;";

      /*
      //overblijvende nrs (1ste tabel) nu niet nodig
      Db.runsql("delete from tmp_nrs");
      mysql = "insert into tmp_nrs (nrs) select distinct a.nrs "
              + "                 from assocdata a "
              + "join tmp_sel on a.id=tmp_sel.id "
              + "                       where a.nrz in (select nrz from tmp_did)"
              + "                  and tmp_sel.selection=0 " //overblijvende gerelateerd met alle diags
              + "                 and AFRICA_PC>" + PCPEMIN + " and AFRICA_PE>" + PCPEMIN;
      Db.runsql(mysql);
       */
   }
   
   public static Vector<Vector> getResponse(Vector<String> signs, String language){
		OC oc = new OC();
		try {
		    oc.selNrs1 = Integer.parseInt(signs.elementAt(0));
		    oc.selNrs2 = Integer.parseInt(signs.elementAt(1));
		    oc.selNrs3 = Integer.parseInt(signs.elementAt(2));
		    oc.selNrs4 = Integer.parseInt(signs.elementAt(3));
		    oc.language=language;
		} catch (ArrayIndexOutOfBoundsException e) {
		    System.out.println("ArrayIndexOutOfBoundsException caught");
		}
		oc.setup();
		Vector<Vector> result = oc.getListData();
		try {
			if(Db.conn!=null) Db.conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
   }
   ;

   public static Vector<Vector> getResponse(String[] signs, String language){
	    OC oc = new OC();
	    try {
	        oc.selNrs1 = Integer.parseInt(signs[0]);
	        oc.selNrs2 = Integer.parseInt(signs[1]);
	        oc.selNrs3 = Integer.parseInt(signs[2]);
	        oc.selNrs4 = Integer.parseInt(signs[3]);
	        oc.language=language;
        } catch (ArrayIndexOutOfBoundsException e) {
	        System.out.println("ArrayIndexOutOfBoundsException caught");
	    }
	    oc.setup();
	    Vector<Vector> result = oc.getListData();
		try {
			if(Db.conn!=null) Db.conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
   }
   ;

}
