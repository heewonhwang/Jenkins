<%@page language="java" contentType="text/html; charset=utf-8"%> 
<%@ page import='java.util.* , java.io.*, java.lang.*'%>
<%@include file="MaFpsCommon.jsp"%>
<%
    String strParamSessionURL = request.getParameter("sessionurl");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
</head>
<body>
<script src="<%=strJsWebHome%>/MaVerCheck.js" charset="utf-8"></script> 
<script type="text/javascript">
function setCheckValue()
{
	window.opener.checkcustomurl = true;
	setCookie("sessionurl", src, 0);
} 
window.opener.focus();

var strBrowser = get_browser();

if( get_browser_version() > 10)
{
	//var src = window.localStorage['sessionurl'];
	var src = getCookie('sessionurl');
}
else
{
  var src = "<%=strParamSessionURL%>";
}
//alert(src);
var ifrm = document.createElement("iframe");
	    ifrm.src = src;
      ifrm.style.display = "none";
      document.body.appendChild(ifrm);   	  
	setTimeout(setCheckValue,100);
</script>
</body>
</html>

