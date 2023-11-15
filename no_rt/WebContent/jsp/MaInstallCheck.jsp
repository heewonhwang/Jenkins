<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="MaFpsCommon.jsp"%>
<%@include file="MaFunction.jsp"%>
<div id='markanybody'></div>
<%
	try
	{			
		String osversion = "";
		String strPath = "";
		String strAddData = "";
		int iRetBro = 0;
		String browsername = "";
		String browserversion = "";
		int iBrowserVer = 0;
	
		String info = request.getHeader("User-Agent");
		if (info != null) {
			String browserInfoArr[] = getBrowserInfo(info);
			browsername = browserInfoArr[0];
			browserversion = browserInfoArr[1];
			iBrowserVer = Integer.parseInt(browserversion.trim());
		}
      
      HttpSession session1 = request.getSession(false);
      if(session1 == null) {
          session1 = request.getSession(true);
      }
      else
      {
        out.println("기존세션존재");
      }
      
		String strCookie = request.getHeader("Cookie"); //sjlim - 세션에서 쿠키값으로 변경      
		//out.println("strCookie" + strCookie);
	  			
		int iSessionCheck = 0;
		 
		String pversion = (String)session.getAttribute("productversion");    
		//out.println("pversion" + pversion);
  	     
    if(pversion != null && pversion.indexOf("MARKANYREPORT") >= 0)
    {
      String	strVersion = replaceAll( pversion, "MARKANYREPORT", "");
      int iCurrent = Integer.parseInt(strPVersion);
      int iSession = Integer.parseInt(strVersion);
    	  
      if(iSession >= iCurrent)
        iSessionCheck = 1;
    }
  	
  	//out.println("iSessionCheck" + iSessionCheck);
  	//out.println("strJsWebHome" + strJsWebHome);

		if(iSessionCheck == 0)
	    {
%>
			<HTML>
			<HEAD>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<TITLE>::: 전자확인증 발급 :::</TITLE>

				<style type="text/css">
				body, td {  line-height: 11pt}
				body, td { font-size: 9pt; font-family: 돋움,Arial; color: #6D6D6D}
				A:link { text-decoration: none ; color: #0000FF }
				A:visited { text-decoration: none ; color: #989A9A }
				A:active { text-decoration: none ; color: #000000 }
				A:hover { text-decoration: none; color:#989A9A }
				font {font-size: 8pt;text-decoration: none;}
				.sub_font {font-family:"굴림체";color:000000;font-size:9pt;text-decoration:none}
				</style>
			</HEAD>
			<BODY LEFTMARGIN="0" TOPMARGIN="0" RIGHTMARGIN="0" bottommargin="0" marginwidth="0" marginheight="0"   >
			<!--iframe id ="hidpopWinC" name="hidpopWinC" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=auto></iframe-->
			<div id="loadingBar" style="background-color:#ffffff;width:100%;">
			  <table align="center" border="0" width="400" style="margin-top:130px">
			  <tr>
				<td width="450" height="400" colspan="4" bgcolor="#FFFFFF">
					<p align="center"><span class="sub_font">문서 출력을 위한 환경을 점검하고 있습니다.<br><br></p>
					<p align="center"><span class="sub_font">* Microsoft Internet Explorer 8 이하 버전인 경우 팝업 항상 허용을 눌러주십시오.</p>
				</td>
			  </tr>
			</table>
			</div>
				<script language="javascript">
				  document.oncontextmenu = document.body.oncontextmenu = function() {return false;}
				  var vstrSessionURL         = "<%=strSessionURL%>";
				  var vstrSudongInstallURL  = "<%=strSudongInstallURL%>";
				  var vstrCookie 				    = "<%=strCookie%>";
				  var iVersion              = "<%=strPVersion%>";
				  var vstrSessionCheck      = "<%=strInstallCheck%>";
				  var vstrJsWebHome         = "<%=strJsWebHome%>";
			  </script>
			  <script src="<%=strJsWebHome%>/MaVerCheck.js" charset="utf-8"></script> 
			  <script language="javascript">
				  var vstrApp               = "<%=strApp%>"; 
				  var vstrIePopupURL        = "<%=strIePopupURL%>";
				  LaunchRegistApp(vstrApp, "installcheck", vstrIePopupURL ); 
				  
			  </script>
			  </BODY>
			</HTML>
<%          
        }
        else if(iSessionCheck == 1)
        {
%>
			<html xmlns="http://www.w3.org/1999/xhtml">
			<html>
				<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<title> E - Certification </title>  
				<style>
				.container {
					position: relative;
					margin: 0 auto;
				}
				#content{
					display: block;
					font-size: 11px;
					margin-top: 40px;
					text-align: center;
				}

				img{
					margin: 0 auto;
					display: block;
				}
				</style>
				<script language="javascript">
					var vbrowsername = "<%=browsername%>";
					alert("설치 되어 있습니다.");
					//window close
					if ( vbrowsername == 'Firefox') {
						var win = window.open('about:blank', '_self');
						win.close();
					} else if (vbrowsername == 'Chrome') {
						window.open('', '_self');
						window.close();
					} else {
						window.open('about:blank', '_self').close();
					}
				</script> 
				</head>
				<body>
				  <!--iframe id ="hidpopWinC" name="hidpopWinC" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=auto></iframe-->
					<div class="container">
						<div id="content">
							설치 되어 있습니다.
						</div>
					</div>
				</body>
			</html>
<%
        }
	}
	catch( Exception e )
	{}
	finally 
	{}	
%>
<script>
function resize_window(){
      window.resizeTo(450, 450);
  }

   resize_window();

</script>
