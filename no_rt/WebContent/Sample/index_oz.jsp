<%@ page import="java.io.*"%>
<%@ page import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*"%>
<%@ page import="com.markany.futils.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="../jsp/MaFpsCommon.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>MarkAny Inc.</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script src="<%=strJsWebHome%>/MaVerCheck.js" charset="euc-kr"></script> 
	<script>
	function checkOption(){

		var strPrintOptions = getSelectedValue('strPrintOptions');
		var reporting = 1;		
		var strPdfDataType = 0; //세로
		//var strBrokerOptions = getSelectedValue('strBrokerOptions');
		
		var src = "./Sample_OZ.jsp";
		
		//var param = '?strPrintOptions=' + strPrintOptions + "&strPdfDataType=" + strPdfDataType +  "&strBrokerOptions=" + strBrokerOptions;
		var param = '?strPrintOptions=' + strPrintOptions + "&strPdfDataType=" + strPdfDataType;
		win_open(src + param)
	}
		
	function win_open(xxx) 
	{ 
		//새창의 크기
		cw = 450;
		//스크린의 크기
		sw = screen.availWidth;
		sh = screen.availHeight;
		ch = 450;
		//열 창의 포지션
		winPosLeft=(sw-cw)/2;
		winPosTop=10;
		
		window.open(xxx,'popWinC','width='+cw+',height='+ch+',top='+winPosTop+',left='+winPosLeft+',toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no')
		
	}
	
	 function getSelectedValue(chkName)
    {
		var check = document.getElementById(chkName);
        for(var i=0; i < check.length; i++)
        {
            if( check[i].selected == true ){
				return check[i].value;
            }
        }
    } 
	</script>
	
	<style>
		.sel{
			height:30px;
			font-size : 15px;
		}
	</style>
	
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
	<table class="mook" width="100%" border="0" cellspacing="0" cellpadding="5" height="100%">
	  <tr bgcolor="#6A645B"> 
	    <td height="7" colspan="2"></td>
	  </tr>
	  <tr> 
	    <td width="65%" height="111">&nbsp;</td>
	    <td width="75" valign="bottom" height="111"><img src="<%=strImagePath%>/title_logo.gif"></td>
	  </tr>
	  <tr bgcolor="#A69F97"> 
	    <td height="1" colspan="2">  </td>
	  </tr>
	  <tr> 
	    <td background="<%=strImagePath%>/bg01.gif" height="409" align="left" valign="top"><br> 
			#마크애니 뷰어 옵션 안내<br>
			<ul>
				<li>
					0 -	미리보기 후 인쇄버튼을 누르면 프린터 선택창이 나오며 프린터 선택하여 출력<br>
				</li>
				<li>
					1 -	미리보기 후 인쇄버튼을 누르면 설정된 기본 프린터로 바로 출력<br>
				</li>
				<li>
					2 -	미리보기 후 자동으로 프린터선택창이 나오며 프린터 선택하여 출력<br>
				</li>
				<li>
					3 -	미리보기 후 자동으로 설정된 기본 프린터로 바로 출력<br>
				</li>
				<li>
					4 -	미리보기만 지원<br>
				</li>
				<li>
					10 - 미리보기 없이 프린터 선택창이 나오며 프린터 선택하여 출력<br>
				</li>
				<li>
					11 - 미리보기 없이 설정된 기본 프린터로 바로 출력<br>
				</li>
			</ul>
			
	        <table CLASS="MOOK" width="85%" border="0" cellspacing="0" cellpadding="0">        
	        <tr>
	          <td>
	          	<br><br>
				
				<br><br>
					
				<br><br>
			  </td>		  
	        </tr>
	      </table>       
	      
	    <br>
	      <br>
		</td> 
		
			<td background="<%=strImagePath%>/bg01.gif" height="409" valign="top"><br>
			<!-- <form action="" method="post" name="frm1" id="frm1" target="_blank">
			리포팅 연동
			<select name="reporting" id="reporting" class="sel">
					<option value="0">0 - RD</option>
					<option value="1" selected="selected">1 - ETC</option>
			</select> -->
				
			뷰어 옵션 선택 
			<select name="strPrintOptions" id="strPrintOptions" class="sel">
					<option value="0">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="10">10</option>
					<option value="11">11</option>
			</select>
			<br>
			<!-- 브로커 사용여부
			<select name="strBrokerOptions" id="strBrokerOptions" class="sel">
					<option value="1">미사용</option>
					<option value="2" selected="selected">시용</option>
			</select> -->
			<br>
				오즈 연동 <input type="button" onclick="checkOption();" value="문서발급">
			<br>
			<br>
			<a href="../installCheck/index.html">설치체크</a> / <a href="../jsp/GetInstall.jsp">GetInstall</a>
	      <br>
	      <br>
	      <br>
	      <table CLASS="MOOK" width="85%" border="0" cellspacing="0" cellpadding="0">        
	        <tr>
	          <td>

			  </td>

	        </tr>
	      </table>
	      <br>
	      <br>
	    </td>
	  </tr>
	  <tr bgcolor="#35455E"> 
	    <td width="125">&nbsp;</td>
	    <td CLASS="MIKI" valign="top"><br>
	      <font color="#FFFFFF">Copyright 2016 <a href="http://www.markany.com"><font color="#FFFFCC"><b>MarkAny</b></font></a> 
	      INC.</font><br>
	    </td>
	  </tr>
	</table>

</body>
</html>
