<%@page import="be.openclinic.medical.*"%>
<%@page import="org.dom4j.io.SAXReader,
				java.awt.*,java.awt.image.*,be.openclinic.adt.*,
                java.net.URL,
                org.dom4j.Document,
                org.dom4j.Element,
                be.mxs.common.util.db.MedwanQuery,
                org.dom4j.DocumentException,
                java.net.MalformedURLException,java.util.*,
                be.openclinic.knowledge.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
try{

	if(activePatient==null || (request.getParameter("panorama")==null && request.getParameter("hints")==null)){
%>
	<form name='transactionForm' method='post'>
		<table width='100%'>
			<tr class='admin'><td colspan='2'><%=getTran(request,"ikirezi","panorama",sWebLanguage) %></td></tr>
			<tr>
				<td class='admin'><%= getTran(request,"ikirezi","disease.progress",sWebLanguage)%></td>
				<td class='admin2'>
					<select class='text' name='diseaseProgress' id='diseaseProgress'>
						<%=ScreenHelper.writeSelect(request, "disease.progress", "", sWebLanguage) %>
					</select>
				</td>
			</tr>
			<!-- Make a list of all valid complaints from the patient record and their onset dates -->
			<tr class='admin'><td colspan='2'><%=getTran(request,"ikirezi","principal.complaint",sWebLanguage) %></td></tr>
			<tr>
				<td class='admin'><%= getTran(request,"ikirezi","reasonsforencounter",sWebLanguage)%></td>
				<td class='admin2'>
					<select class='text' name='complaint1a' id='complaint1a' onchange='validateselects();'>
						<option/>
						<%
							System.out.println("1");
							Hashtable hMappings = new Hashtable();
							//First read all existing ICPC mappings from ikirezi.xml
							String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "ikirezi.xml";
							SAXReader reader = new SAXReader(false);
							Document document = reader.read(new URL(sDoc));
							Element element = document.getRootElement();
							Iterator mappings = element.elementIterator("mapping");
							while(mappings.hasNext()){
								Element mapping = (Element)mappings.next();
								hMappings.put(mapping.attributeValue("icpc"),mapping.attributeValue("id"));
							}
							//Then find all existing reasons for encounter with ICPC code
							Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
							HashSet activecodes = new HashSet();
							Vector rfes = new Vector();
							if(encounter!=null){
								rfes = ReasonForEncounter.getReasonsForEncounterByEncounterUid(encounter.getUid());
								for(int n=0;n<rfes.size();n++){
									ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
									if(rfe.getCodeType().equalsIgnoreCase("icpc") && hMappings.get(rfe.getCode())!=null && !activecodes.contains(hMappings.get(rfe.getCode()))){
										activecodes.add(hMappings.get(rfe.getCode()));
										String date = "";
										try{
											date=new SimpleDateFormat("yyyyMMdd").format(rfe.getDate());
										}
										catch(Exception e){}
										out.println("<option value='"+hMappings.get(rfe.getCode())+"."+date+"' "+(activecodes.size()==1?"selected":"")+">"+MedwanQuery.getInstance().getCodeTran("icpccode"+rfe.getCode(), sWebLanguage)+"</option>");
									}
								}
							}
							System.out.println("2");
						
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td class='admin'><%= getTran(request,"ikirezi","othercomplaints",sWebLanguage)%></td>
				<td class='admin2'>
					<select class='text' name='complaint1b' id='complaint1b' onchange='validateselects();'>
						<option/>
						<%
							activecodes = new HashSet();
							if(encounter!=null){
								for(int n=0;n<rfes.size();n++){
									ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
									if(rfe.getCodeType().equalsIgnoreCase("icpc") && hMappings.get(rfe.getCode())!=null && !activecodes.contains(hMappings.get(rfe.getCode()))){
										activecodes.add(hMappings.get(rfe.getCode()));
										String date = "";
										try{
											date=new SimpleDateFormat("yyyyMMdd").format(rfe.getDate());
										}
										catch(Exception e){}
										out.println("<option value='"+hMappings.get(rfe.getCode())+"."+date+"' "+(activecodes.size()==1?"selected":"")+">"+MedwanQuery.getInstance().getCodeTran("icpccode"+rfe.getCode(), sWebLanguage)+"</option>");
									}
								}
							}
						
						%>
					</select>
				</td>
			</tr>
		</table>
		<input class='button' type='submit' name='panorama' id='panorama' value='<%=getTranNoLink("web","viewpanorama",sWebLanguage) %>'/>
		<input class='button' type='submit' name='hints' id='hints' value='<%=getTranNoLink("web","showhints",sWebLanguage) %>'/>
	</form>
	
	<script>
		function validateselects(){
			var c1 = document.getElementById("complaint1a").value;
			if(c1==document.getElementById("complaint1b").value){
				document.getElementById("complaint1b").options[0].selected=true;
			}
			for(n=0;n<document.getElementById("complaint1b").options.length;n++){
				if(c1.length>0 && c1==document.getElementById("complaint1b").options[n].value){
					document.getElementById("complaint1b").options[n].selected=false;
					document.getElementById("complaint1b").options[n].disabled=true;
				}
				else{
					document.getElementById("complaint1b").options[n].disabled=false;
				}
			}
		}
        window.setTimeout('validateselects();',500);
	</script>
	
<%
	}
	else if (request.getParameter("hints")!=null){
		System.out.println("3");
		//Get base data from medical record
		Vector vSigns= new Vector();
		//1. First get person reference
		int age = activePatient.getAgeInMonths();
		if(age<12){
			vSigns.add("110");
		}
		else if(age<180){
			vSigns.add("98");
		}
		else if(activePatient.gender.toLowerCase().equalsIgnoreCase("m")){
			vSigns.add("136");
		}
		else{
			vSigns.add("81");
		}
		//2. Get type of encounter 
		vSigns.add(request.getParameter("diseaseProgress"));
		
		//3. Get main complaint
		if(request.getParameter("complaint1a")!=null){
			vSigns.add(((String)request.getParameter("complaint1a")).split("\\.")[0]);
		}
		
		//4. Get secondary complaint
		if(request.getParameter("complaint1b")!=null){
			vSigns.add(((String)request.getParameter("complaint1b")).split("\\.")[0]);
		}
		else{
			vSigns.add("0");
		}
		
		HashMap signs = new HashMap();
		HashMap signpowers = new HashMap();
		//Ikirezi interface
		//Make Ikirezi call
		HashSet diseases = new HashSet();
		Vector resp = Ikirezi.getDiagnoses(vSigns,sWebLanguage);
		for (int n=0;n<resp.size();n++){
			Vector v = (Vector)resp.elementAt(n);
			double power=-(Double.parseDouble((String)v.elementAt(5))+Double.parseDouble((String)v.elementAt(6)))/2;
			if(signpowers.get(v.elementAt(2))==null){
				signpowers.put(v.elementAt(2),power);
				signs.put(v.elementAt(2),((String)v.elementAt(4)).replaceAll("%","--pct--")+";"+v.elementAt(5)+";"+v.elementAt(6));
			}
			else{
				if(power<(Double)signpowers.get(v.elementAt(2))){
					signpowers.put(v.elementAt(2),power);
					signs.put(v.elementAt(2),((String)v.elementAt(4)).replaceAll("%","--pct--")+";"+v.elementAt(5)+";"+v.elementAt(6));
				}
			}
		}
		System.out.println("4");

		SortedMap sortedsignpowers = new TreeMap();
		Iterator i = signpowers.keySet().iterator();
		while(i.hasNext()){
			String key = (String)i.next();
			sortedsignpowers.put(signpowers.get(key),key);
		}
		out.println("<table width='100%'>");
		out.println("<tr class='admin'>");
		out.println("<th>"+getTran(request,"web","positive",sWebLanguage)+"</th>");
		out.println("<th>"+getTran(request,"web","negative",sWebLanguage)+"</th>");
		out.println("<th>"+getTran(request,"web","investigation",sWebLanguage)+"</th>");
		out.println("</tr>");
		i = sortedsignpowers.keySet().iterator();
		while(i.hasNext()){
			Double key=(Double)i.next();
			String sign=((String)signs.get(sortedsignpowers.get(key)));
			double confirmingPower = Double.parseDouble(sign.split(";")[1]);
			int confirmingcolor = new Double(255-confirmingPower*255/100).intValue();
			if(confirmingcolor<0){
				confirmingcolor=0;
			}
			double excludingPower = Double.parseDouble(sign.split(";")[2]);
			int excludingcolor = new Double(255-excludingPower*255/100).intValue();
			if(excludingcolor<0){
				excludingcolor=0;
			}
			out.println("<tr>");
			out.println("<td style='color: "+(confirmingcolor<122?"white":"black")+";background-color: rgb(255,"+confirmingcolor+","+confirmingcolor+");'><center><b>"+new DecimalFormat("#.0").format(confirmingPower)+"</b></center></td>");
			out.println("<td style='color: "+(excludingcolor<122?"white":"black")+";background-color: rgb(255,"+excludingcolor+","+excludingcolor+");'><center><b>"+new DecimalFormat("#.0").format(excludingPower)+"</b></center></td>");
			out.println("<td class='admin'>"+sign.split(";")[0]+"</td>");
			out.println("</tr>");
		}
		out.println("</table>");
		System.out.println("5");

	}
	else if (request.getParameter("panorama")!=null){
		System.out.println("6");

		//Get base data from medical record
		Vector vSigns= new Vector();
		//1. First get person reference
		int age = activePatient.getAgeInMonths();
		if(age<12){
			vSigns.add("110");
		}
		else if(age<180){
			vSigns.add("98");
		}
		else if(activePatient.gender.toLowerCase().equalsIgnoreCase("m")){
			vSigns.add("136");
		}
		else{
			vSigns.add("81");
		}
		//2. Get type of encounter 
		vSigns.add(request.getParameter("diseaseProgress"));
		
		//3. Get main complaint
		if(request.getParameter("complaint1a")!=null){
			vSigns.add(((String)request.getParameter("complaint1a")).split("\\.")[0]);
		}
		else{
			vSigns.add(((String)request.getParameter("complaint1b")).split("\\.")[0]);
		}
		
		//4. Get secondary complaint
		if(request.getParameter("complaint2a")!=null){
			vSigns.add(((String)request.getParameter("complaint2a")).split("\\.")[0]);
		}
		else if(request.getParameter("complaint2b")!=null){
			vSigns.add(((String)request.getParameter("complaint2b")).split("\\.")[0]);
		}
		else{
			vSigns.add("0");
		}
		
		String sAllSigns = "";
		for(int n=0;n<vSigns.size();n++){
			sAllSigns+=vSigns.elementAt(n)+";";
		}
		System.out.println("7");

		//Ikirezi interface
		//Make Ikirezi call
		HashSet diseases = new HashSet();
		System.out.println("7.0:"+vSigns);
		Vector resp = new Vector();
			resp = Ikirezi.getDiagnoses(vSigns,sWebLanguage);
		out.print("<script>");
		out.println(" var signs=[");
		System.out.println("7.1");
		for (int n=0;n<resp.size();n++){
			Vector v = (Vector)resp.elementAt(n);
			if(n>0){
				out.println(",");
			}
			out.print("'"+(v.elementAt(1)+";"+((String)v.elementAt(4)).replaceAll("%","--pct--")+";"+v.elementAt(5)+";"+v.elementAt(6)).replaceAll("'","´")+"'");
			diseases.add((v.elementAt(1)+";"+v.elementAt(3)).replaceAll("'","´")+";"+be.openclinic.medical.Diagnosis.getGravity("icd10",(String)v.elementAt(8),100));
		}
		System.out.println("7.2");
		out.println("];");
		out.println(" var disease=[");
		Iterator i = diseases.iterator();
		int n=0;
		while(i.hasNext()){
			if(n>0){
				out.println(",");
			}
			out.print("'"+i.next()+"'");
			n++;
		}
		out.println("];");
		out.println("</script>");
		System.out.println("7:"+diseases);

	%>
	
	<canvas id="ikirezi" width="800" height="600"></canvas>
	<script>
		var POINTS = <%=diseases.size()%>;
		if(POINTS>10){
			POINTS=10;
		}
		var radius = 200;
		var boxWidth=80;
		var boxHeight=80;
		var extraWidth=50*10/POINTS;
		if(extraWidth>170){
			extraWidth=170;
		}
		var extraHeight=20*10/POINTS;
		if(extraHeight>70){
			extraHeight=70;
		}
<%System.out.println("8");%>
	
		function draw(){
			var canvas = document.getElementById('ikirezi');
			canvas.addEventListener('mousemove', function(event) {
				var canvas=document.getElementById('ikirezi');
				var ctx=canvas.getContext('2d');
		       	var bSelected=false;
			    for (i = 0; i < POINTS; i++) {
	  	    	   	var rectangle = new Path2D();
			       	var centerX=(320 -extraWidth/2 + radius * Math.cos(2 * i * Math.PI / POINTS))*8/6;
			       	var centerY=300 -extraHeight/2 - radius * Math.sin(2 * i * Math.PI / POINTS);
			       	if(centerX-(boxWidth+extraWidth)/2<20){
			    		centerX=(boxWidth+extraWidth)/2+20;
			       	}
			       	rectangle.rect(centerX-(boxWidth+extraWidth)/2,centerY-boxHeight/2,boxWidth+extraWidth,boxHeight+extraHeight);
		       		//First clear the rectangle
			       	ctx.strokeStyle='white';
			    	ctx.setLineDash([]);
			       	ctx.stroke(rectangle);
			       	if(ctx.isPointInPath(rectangle,event.clientX,event.clientY)){
			       		ctx.strokeStyle='red';
				    	ctx.setLineDash([2,3]);
				    	bSelected=true;
					}
			       	else{
			       		ctx.strokeStyle='black';
				    	ctx.setLineDash([]);
			       	}
			       	if(bSelected){
				    	canvas.style.cursor="hand";
			       	}
			       	else{
				    	canvas.style.cursor="default";
			       	}
		       		ctx.stroke(rectangle);
			    }
			});
			<%System.out.println("9");%>
			canvas.addEventListener('click', function(event) {
				var canvas=document.getElementById('ikirezi');
				var ctx=canvas.getContext('2d');
			    for (i = 0; i < POINTS; i++) {
	  	    	   	var rectangle = new Path2D();
			       	var centerX=(320 -extraWidth/2 + radius * Math.cos(2 * i * Math.PI / POINTS))*8/6;
			       	var centerY=300 -extraHeight/2 - radius * Math.sin(2 * i * Math.PI / POINTS);
			       	if(centerX-(boxWidth+extraWidth)/2<20){
			    		centerX=(boxWidth+extraWidth)/2+20;
			       	}
			       	rectangle.rect(centerX-(boxWidth+extraWidth)/2,centerY-boxHeight/2,boxWidth+extraWidth,boxHeight+extraHeight);
			       	if(ctx.isPointInPath(rectangle,event.clientX,event.clientY)){
			       		showPanoramaTips(disease[i].split(";")[0]);
					}
			    }
			});
			<%System.out.println("10");%>
			if (canvas.getContext) {
			    var ctx = canvas.getContext('2d');
				//1. We berekenen de verschillende punten die er moeten verbonden worden
			    // Add points to the polygon list
			    for (i = 0; i < POINTS; i++) {
			       var centerX=(320 -extraWidth/2 + radius * Math.cos(2 * i * Math.PI / POINTS))*8/6;
			       var centerY=300 -extraHeight/2 - radius * Math.sin(2 * i * Math.PI / POINTS);
			       if(centerX-(boxWidth+extraWidth)/2<20){
			    	   centerX=(boxWidth+extraWidth)/2+20;
			       }
			       //Fill rectangle with color corresponding to disease weight
			       var MAXWEIGHT=300
				   var weight=disease[i].split(";")[2]*1;		
			       if(weight>MAXWEIGHT){
			    	   wheight=MAXWEIGHT;
			       }
			       ctx.fillStyle='rgb(255,'+(255-weight*1)+','+(255-weight*1)+')';
			       ctx.fillRect(centerX-(boxWidth+extraWidth)/2,centerY-boxHeight/2,boxWidth+extraWidth,boxHeight+extraHeight);
			       ctx.strokeRect(centerX-(boxWidth+extraWidth)/2,centerY-boxHeight/2,boxWidth+extraWidth,boxHeight+extraHeight);
		    	   ctx.fillStyle='black';
			       ctx.font='16px arial';
			       ctx.textBaseline='middle';
			       ctx.textAlign='center';
			       ctx.boxedFillText(centerX,centerY+20,boxWidth+extraWidth-10,boxHeight+extraHeight,disease[i].split(";")[1],true);
			    }
					
			}
		}
		<%System.out.println("11");%>

	    CanvasRenderingContext2D.prototype.textLines = function(x, y, w, h, text,
	            hard_wrap) {
	          var ctx = this;
	          var lines = Array();
	          var hard_lines = text.trim().split("\n");
	          hard_lines.forEach(function(hard_line) {
	            if(ctx.measureText(hard_line).width > w) {
	              var line = "";
	              var words = hard_line.split(" ");
	              words.forEach(function(word) {
	                var nline = line + word + " ";
	                if(ctx.measureText(nline).width > w) {
	                  lines.push(line);
	                  if(ctx.measureText(word).width > w && hard_wrap) {
	                    line = "";
	                    var chars = word.split("");
	                    chars.forEach(function(char) {
	                      var nline = line + char;
	                      if(ctx.measureText(nline).width > w) {
	                        lines.push(line);
	                        line = char;
	                      } else {
	                        line = nline;
	                      }
	                    });
	                    line += " ";
	                  } else {
	                    line = word + " ";
	                  }
	                } else {
	                  line = nline;
	                }
	              });
	              lines.push(line);
	            } else {
	              lines.push(hard_line);
	            }
	          });
	          return lines;
	        };
	        CanvasRenderingContext2D.prototype.boxedFillText = function(x, y, w, h, text,
	            hard_wrap) {
	          var ctx = this;
	          var lines = ctx.textLines(x, y, w, h, text, hard_wrap);
	          var lineHeight = parseInt(ctx.font.split("px")[0]) * 1.2;
	          var min_y = y;
	          var max_y = y + h;
	          var ll = lines.length - 1;
	          switch(ctx.textBaseline.toLowerCase()) {
	            case "bottom":
	              min_y = y - h + lineHeight;
	              max_y = y;
	              y -= ll * lineHeight;
	              if(y < min_y)
	                y = min_y;
	              break;
	            case "middle":
	              min_y = y - h / 2 + lineHeight / 2;
	              max_y = y + h / 2 - lineHeight / 2;
	              y -= (ll / 2) * lineHeight;
	              if(y < min_y)
	                y = min_y;
	              break;
	            default:
	              break;
	          }
	          console.log(ctx.textBaseline);
	          lines.forEach(function(line) {
	            if(y <= max_y) {
	              ctx.fillText(line, x, y);
	            }
	            y += lineHeight;
	          });
	        };
	
	        function showPanoramaTips(diseaseid){
	        	//Concatenate the signs to show so they can be passed to the Modal box
	        	var s = "";
	        	for(n=0;n<signs.length;n++){
	        		if(signs[n].split(";")[0]==diseaseid){
	        			s=s+signs[n]+"$";
	        		}
	        	}
	    	    var url = "<c:url value="/ikirezi/showPanoramaTips.jsp"/>?signs="+s+"&ts="+new Date().getTime();
	    	    Modalbox.show(url,{title:'<%=getTranNoLink("ikirezi","panorama",sWebLanguage)%>',width:400, height:500});
	   	  	}
	
	        window.setTimeout('draw();',500);
	</script>
	<%
	}
		}
		catch(Exception e){
			e.printStackTrace();
		}
%>
</body>