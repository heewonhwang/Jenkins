<%@ page
	import="java.util.*,java.io.*, java.text.*,  java.lang.Integer, java.net.*"%>
<%@ page import="com.markany.EPageSafer.*"%>
<%@ page import="com.markany.aes.MaUrlRdBase64"%>
<%@ page import="com.markany.fps.*"%>
<%@ page import="com.markany.futils.*"%>
<%
	/**
	MaFpsCommon.jsp
	ePageSAFER의 서버, 클라이언트와 통신 및 옵션을 설정하기 위한 페이지입니다.
	각 연동의 설정, 미리보기 및 출력의 옵션을 설정 할 수 있습니다.
	추후 정책 및 환경이 변경될 경우 아래의 변수들을 변경하시면 됩니다.
	
	- 해당 페이지는 돋움체를 사용하여 정렬하였습니다. 
*/
MaUrlRdBase64 maEncUtil = new MaUrlRdBase64();
//#############################		common value set	###############################	
String strApp = "mareportsafer";
String strAppSign = "MARKANYREPORT";
String strPVersion = "25198"; //25198

//#############################		2D Bacode value set	###############################
String strMAServerIP = "127.0.0.1";
// OZ## , 18200   / RP4# , 18320   / RD## , 18300
int iMAServerPort = 18320;
String strFunctionFlag = "";
String strSignCompany = "NONE";
String strReportCompany = "RP4#";

int iCellBlockCount = 300;
int iCellBlockRow = 100;

//#############################		client value set	###############################	
String strProtocolName = request.getScheme() + "://";
String strServerName = request.getServerName();
int iServerPort = request.getServerPort();
//int iServerPort = 555;
String strDomain = strProtocolName + strServerName + ":" + iServerPort;

//#############################		setting the MA_FPSFM & setting the .matmp file  ############	
int iUseNas = 1; // 1: FM이 필요없는 경우 0:FM이 필요한 경우
int iUsePDF = 0; // 0: Meta 사용 1: PDF Meta 따로 2: PDF 만
int iQuickSet = 2; // 0 = 일반 설정 , 1 = QuickUrl 사용	, 2 = XHR 설치 체크 사용	

//iUseNas:0인 경우 아래 설정을 사용해야함. 사용안할 경우라도 변수는 임의의 값으로 설정해야 함
String strFileServerIp = InetAddress.getLocalHost().getHostAddress();
int iFileServerPort = 18430;

String strIDECheck = File.separator;
if (strIDECheck.equals("\\")) {
	// for Windows IDE
	strIDECheck = "\\\\";
} else {
	// for Unix IDE
	//out.println(strIDECheck);
}
//iUseNas:1인 경우 메타파일 임시폴더를 설정해야 함. 사용안할 경우라도 변수는 임의의 값으로 설정해야 함
//*** strDownFolder: 물리적 경로사용 예)/usr/local/apache/htdocs/FPS/ibuuni/markany_noax 
String strCurrentPath = pageContext.getServletContext().getRealPath("");
//String  	strCurrentPath 						= getServletContext().getRealPath("") ; 
String strDownFolder = strCurrentPath + File.separator + "fn"; //metafile location ex)/home/meta/fn
String strPrtDatDownFolder = strCurrentPath + File.separator + "bin" + File.separator; //dat 파일 웹 루트경로

//out.println("1번 strCurrentPath: "+pageContext.getServletContext().getRealPath("")+"<br>");
//out.println("2번 strCurrentPath: "+getServletContext().getRealPath("")+"<br>");

//#############################		setting the MA_FPSFM & setting the .matmp file  ############	
int iUseInstallPage = 0; //1: 수동설치 페이지 사용 0: exe 파일을 바로 다운로드

String strInstallFilePath = strCurrentPath + File.separator + "bin" + File.separator + "Setup_ePageSaferRT.exe";
String strInstallFileName = "Setup_ePageSaferRT.exe";

//#############################		setting the was file	###############################		
String strUrlHome = "/no_rt";
String strJspHome = strUrlHome + "/jsp";
String strDownFileUrl = strDomain + strJspHome + "/bin/Setup_ePageSaferRT.exe";
String strDownURL = strDomain + strJspHome + "/Mafndown.jsp?fn="; //metafile jsp 
String strPDFDownURL = strDomain + strJspHome + "/Mafndown.jsp?fnpdf="; //pdf
String strPrtDatDownURL = strDomain + strJspHome + "/Mafndown.jsp?prtdat=MaPrintInfoEPSmain";
String strSessionCheck = strDomain + strJspHome + "/MaSessionCheck.jsp";
String strInstallCheck = strDomain + strJspHome + "/MaSessionCheck_Install.jsp";
String strIePopupURL = strDomain + strJspHome + "/MaIePopup.jsp";
String strSessionURL = strDomain + strJspHome + "/MaSetInstall.jsp?param=MARKANYREPORT" + strPVersion;
String registerCookieArr[] = { "JSESSIONID" };

//out.println("3번 strUrlHome : "+strUrlHome+"<br>");
// ksk 
String str2DGenUrl = strDomain + strJspHome + "/MaFps.jsp?DataPath="; //meta
String strWriteSession = strDomain + strJspHome + "/InstallCheck/MaSetSession.jsp";
String strGetSession = strDomain + strJspHome + "/InstallCheck/MaSessionCheck_Install.jsp";
String strGetSession_10s = strDomain + strJspHome + "/InstallCheck/MaSessionCheck_Install_10s.jsp";
String strLaunchApp = strDomain + strJspHome + "/InstallCheck/MaLaunchApp.jsp";

//#############################		setting the web file	###############################
String strWebHome = strUrlHome;
String strJsWebHome = strWebHome + "/js"; //js 파일 웹 루트경로
String strImagePath = strWebHome + "/images"; //imamge 파일 웹 루트경로
String strSudongInstallURL = strWebHome + "/html/MaInstallPage.html"; //수동설치파일경로

String strPrintURL = "";
String strPrintParam = "";
String strSilentOption = ""; //silent
String strDataFileName = "";

//#############################		Client option set	###############################	
String FAQURL = "1";
String PSSTRING = "";
String PSSTRING2 = "";
//String	CP2PARAM							= "1^100^50";
String WMPARAM = "0^150^170^100";
String TITLE = "MarkAny Client";
String PRINTERDAT = ""; //"MaPrintInfoEPSetc.dat");
String PRINTERVER = "20130526";
String PRINTERUPDATE = MaBase64Utils.base64Encode(strPrtDatDownURL.getBytes("utf-8"));
String HIDEPRTBUTTON = "0"; //0 or default : show,  1 : hide //미리보기만[밖으로]
String DEFAULTPRT = "0"; //0 or default : printer select,  1 : default print//기본프린터 프린터선택창x[밖으로]
String HIDEFRAME = "0"; //0 or default : show,  1 : hide //미리보기 없이 출력할 경우 미리보기 안보임 처리[밖으로]
String AUTOPRINT = "0"; //0 or default : manual print,  1 : auto print  //HIDEFRAME 사용할경우 출력(세트옵션)[밖으로]
String VIRTUAL = ""; //허용 가상 프로그램	all 허용 : Vk1fQUxMT1dBTEw=

//String		strIcpParam						= "1^PREVIEW^Wide Latin^3^30^40^20^50^0^0^0^0^";
//String		ICP					      		= MaBase64Utils.base64Encode( strIcpParam.getBytes("utf-8") ); //ICP Setting
//#############################		Add option set	###############################	
String PRINTCNT = "10"; // 출력 제한[뷰어가 로드된 이후 출력이 가능한 횟수]
String AUTOCLOSE = "0";
String HIDECD = ""; //복사방지마크 없이
String PAPERSIZE = "9"; //Paper Size  9 : A4    ,  1 : Letter   //출력 용지 설정 (기본은 A4)
String RENDEROPTION = "3"; //Renderer Option  0 : Renderer 안씀  3 : Renderer 사용(기본)
String PRTTYPE = "0"; // 출력을 위한 옵션 - 0 : 기본 출력[Debunu], 1 : PDF --> BMP로 변환해서 출력[BMP 출력], 2 : PDF -> tiff 변환 --> PDF 변환 후 출력[Debenu]
String PRTDLGOPT = "2"; // 다이얼로그 이미지 뺀거로 변경 // 이미지 사용O : 0(default), 이미지 사용X : 1, 이미지 사용X/CloseX : 2, 부분출력 : 5
String CPFONTNAME = ""; //"yN641bjFwffDvA==";//휴먼매직체 //"yN641bXVsdnH7LXltvPAzg=="; //휴먼둥근헤드라인 "SFmw37DttfE="; //HY견고딕
String TRANSPARENCYIMG = "0"; //투명이미지를 항상 체크하도록 되어 있는데... 장수가 많을 경우 시간이 오래 걸려서 옵션처리 함  투명이미지 처리 : 0(default), 투명이미지 체크안함 : 1
String strMAConfigData = "";
String strConfingEncodeData = ""; //공통 복사방지마크 설정 변수
String PRINTCOPIES = "1"; // 인쇄 한번에 출력되는 수  
String MAXPRTCOPIES = "10"; // 사용자가 선택할 수 있는 최대 출력 매수( 사용하려면 2 이상이어야 사용할 수 있음 )
String PRINTSTATUSDLG = "1";  
String SUPPORTPRTPORT ="UE9SVFBST01QVA==";

//#############################		RD Reporting value	###############################		
//Pattern Image...
String strPatternImagePos = "";
String strPatternImagePath = "";
String strParamPatternImagePath = "";
String strConfigFilePath = "";

//#############################		미사용 ConfigData 	###############################	 
// 가로 세로 문서 설정.
String strMAConfigData_Port = ""; // 세로문서 
String strConfingEncodeData_Port = ""; // 세로문서 복사방지마크 설정 변수
String strMAConfigData_Land = ""; // 가로문서
String strConfingEncodeData_Land = ""; // 가로문서 복사방지마크 설정 변수 
//2D바코드x좌표^2D바코드 y좌표^복사방지 x좌표^복사방지 y좌표^
strMAConfigData_Port = "35^245^7^245^528^264^인터넷발급^사본^4^280^70^0^0^3^"; // 세로문서
strConfingEncodeData_Port = MaBase64Utils.base64Encode(strMAConfigData_Port.getBytes("euc-kr")); // 세로문서
strMAConfigData_Land = "35^175^7^175^528^264^인터넷발급^사본^4^280^70^0^0^3^"; // 가로문서
strConfingEncodeData_Land = MaBase64Utils.base64Encode(strMAConfigData_Land.getBytes("euc-kr")); // 가로문서

//#############################		Reporting value	Set	###############################	
if (strReportCompany.equals("RD##")) {

	strPatternImagePos = "35^88^";
	strPatternImagePath = "D:\\MarkAny\\e-PageSAFER\\NOAX\\kosef.bmp";
	strParamPatternImagePath = strPatternImagePos + strPatternImagePath;
	strConfigFilePath = "";
}

// strConfingEncodeData 값을 강제로 정의하려면 1, mrd 파마레터를 사용하려면 0
int iRdConfigDataUse = 1;
//2D바코드x좌표^2D바코드 y좌표^복사방지 x좌표^복사방지 y좌표^
strMAConfigData = "31^250^6^250^528^264^internet^copy^1^82^82^0^0^1^"; // 가로 //1
//72^186^20^186^706^262^인터넷발급^사본^0^280^82^10^0^0^51^186^226^132^
strConfingEncodeData = MaBase64Utils.base64Encode(strMAConfigData.getBytes("euc-kr"));
//out.println(strConfingEncodeData);
/*
//가로
31^265^6^265^528^264^인터넷발급^사본^4^280^82^0^0^0^ //1단
31^254^6^254^528^264^인터넷발급^사본^4^280^82^0^0^0^ //2단
//세로
31^177^6^177^528^264^인터넷발급^사본^4^280^70^0^0^0^
*/

//#############################		멀티캠퍼스 옵션		###############################	
String PRINTCALLURLOPT = "0"; // Print CALL URL 옵션 ( 0(default) : 출력 후 CALL , 1 : 출력 전 CALL, 2 : 출력 전 CALL 및 리턴값 확인 )
//#############################		PDF 이미지 처리 옵션		###############################	
String CONVERTIMAGEPRINT = "0";
//#############################		Current Not USE		###############################	
//Mobile
int iMobileCodeFlag = 0; // 0 - 각페이지별 적용, 1 - 모든 페이지에 동일 적용
int iMobileCodePosX = 30; // MobileCode 위치 X
int iMobileCodePosY = 40; // MobileCode 위치 Y
int iMobileCodeMargin = 50; // MobileCode 외부 Margin
String strMobileCodeUrl = "http://192.168.3.11/test/test.jsp?fn="; // 원본 최상위 URL
String strMobileCodeData = "";
// 공통 Flag^MobileCode Margin^MobileCode PosX^MobileCode PosY
//String		strMobileCodeConfig = iMobileCodeFlag + "^" + iMobileCodeMargin + "^" + iMobileCodePosX + "^" + iMobileCodePosY+ "^";
String strMobileCodeConfig = "";
%>
