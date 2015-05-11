<%
java.util.Date birth=new java.text.SimpleDateFormat("dd/MM/yyyy").parse("23/08/1963");
java.util.Date vaccin=new java.text.SimpleDateFormat("dd/MM/yyyy").parse("12/09/1963");
long age=new java.util.Date().getTime()-birth.getTime();
long week=7*24*3600*1000;
out.println((vaccin.getTime()-new java.util.Date().getTime()+age)/week);
System.out.println("age="+age);
System.out.println("vaccin="+vaccin.getTime());
System.out.println("week="+week);

	
%>