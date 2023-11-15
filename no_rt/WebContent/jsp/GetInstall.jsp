<%@ page import='java.util.* , java.io.*'%>
<%!
%>
<%
	String strPversion = (String)session.getAttribute("productversion");
	out.println("<br>product version : " + strPversion + "<hr>");

	//sjlim - add (세션에서 쿠키값으로 변경)
	String strNewCookie = request.getHeader("Cookie"); 
	out.println("<br> Cookie : " + strNewCookie + "<hr>");

%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<style>
td{border: 1px solid #000;}
</style>
</head>

<body>
Session -
	<table>
		<%
		
			String ls_name;
			String ls_value;
			
			Enumeration enum_app=session.getAttributeNames();
			if(enum_app != null)
			{
				while(enum_app.hasMoreElements()){
					ls_name=enum_app.nextElement().toString();
					ls_value=session.getAttribute(ls_name).toString();
		%>
	
		<tr>
			<td><%=ls_name%></td>
			<td><%=ls_value%></td>
		</tr>
		
		<%
				}
			}
		%>
	</table>
<hr>
Cookie -
	<table>
		<%
			String cookieName = "";
			String cookieValue = "";
			Cookie[] cookies = request.getCookies();   

			if(cookies != null)
			{
				for(int i = 0 ; i<cookies.length; i++){              
					cookieName =  cookies[i].getName();
					cookieValue = cookies[i].getValue();
		%>
		<tr>
			<td><%=cookieName%></td>
			<td><%=cookieValue%></td>
		</tr>
		
		<%
				}
			}
		%>
	</table>
</body>
</html>