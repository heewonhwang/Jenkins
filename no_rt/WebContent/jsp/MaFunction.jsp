<%@page import="java.io.File"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%!public static String replaceAll(String dest, String src, String rep) {
		String retstr = "";
		String left = "";
		int pos = 0;
		if (dest == null)
			return retstr;
		while (true) {
			if ((pos = dest.indexOf(src)) != -1) {
				left = dest.substring(0, pos);
				dest = dest.substring(pos + src.length(), dest.length());
				retstr = retstr + left + rep;
				pos = pos + src.length();
			} else {
				retstr = retstr + dest;
				break;
			}
		}
		return retstr;
	}

	/**
	 *	20151008_hcchoi<br>
	 *	사용자 브라우져 정보가져오기<br>
	 *	{Sring[{브라우져명, 브라우져 버전}]}
	 */
	public static String[] getBrowserInfo(String info) {
		String[] otherBrowsers = { "Firefox", "Opera", "OPR", "Chrome", "Safari" };
		String browsername = "";
		String browserversion = "";
		String browserInfoArr[] = new String[2];

		if ((info.indexOf("MSIE") < 0) && (info.indexOf("Trident") < 0)) {
			for (int i = 0; i < otherBrowsers.length; i++) {
				if (info.indexOf(otherBrowsers[i]) >= 0) {
					browsername = otherBrowsers[i];
					break;
				}
			}
			String subsString = info.substring(info.indexOf(browsername));
			String Info[] = (subsString.split(" ")[0]).split("/");
			browsername = Info[0];
			browserversion = Info[1];

			if (browsername.indexOf("OPR") >= 0)
				browsername = "Opera";
		} else {
			if (info.indexOf("MSIE") >= 0) {
				String tempStr = info.substring(info.indexOf("MSIE"), info.length());
				browserversion = tempStr.substring(4, tempStr.indexOf(";"));
			} else if (info.indexOf("Trident") >= 0) {
				String tempStr = info.substring(info.indexOf("Trident"), info.length());
				if (tempStr.substring(7, tempStr.indexOf(";")).indexOf("7") >= 0)
					browserversion = "11";
				else
					browserversion = "0";
			}
			browsername = "IE";
		}

		if (browserversion != null && browserversion.indexOf(".") >= 0) {
			String[] sArray1 = browserversion.split("[.]");
			if (sArray1.length > 0)
				browserversion = sArray1[0];
		}

		browserInfoArr[0] = browsername;
		browserInfoArr[1] = browserversion;

		return browserInfoArr;
	}

	/**
	 *	20160504_hcchoi<br>
	 *	파라미터로 받은 파일 삭제
	 *	삭제 여부 리턴
	 */
	public boolean deleteFile(String filePath) {
		boolean deleteFlag = false;

		try {
			File file = new File(filePath);

			if (file.length() > 0 && file.exists()) {
				//file.delete();
				deleteFlag = true;
			}
		} catch (NullPointerException e) {
			System.out.println("## deleteFile() NullPointerException ");
			//e.printStackTrace();
		} catch (Exception e) {
			System.out.println("## Ma File Delete Fail... ");
			//e.printStackTrace();
		} finally {
			
		}
		return deleteFlag;
	}

	public String Hash(String str, String hashtype) {
		java.security.MessageDigest sh = null;
		String SHA = "";
		try {
			sh = java.security.MessageDigest.getInstance(hashtype);
			sh.update(str.getBytes());
			byte byteData[] = sh.digest();
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < byteData.length; i++) {
				sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
			}
			SHA = sb.toString();
		} catch (IndexOutOfBoundsException e) {
			System.out.println("## Hash() IndexOutOfBoundsException");
		} catch (Exception e) {
			SHA = e.toString();
		}
		return SHA;

	}

	/**
	 *	20161221_hcchoi<br>
	 *	파일명 변수 경로 구분자 제거 리턴
	 */
	public String safetyFileNameCheck(String filePath) {

		if (filePath != null && !"".equals(filePath)) {
			filePath = filePath.replaceAll("/", "");
			filePath = filePath.replaceAll("\\\\", "");
			filePath = filePath.replaceAll("\\..", "");
			filePath = filePath.replaceAll("&", "");
			// XSS Script
			filePath = filePath.replaceAll("<", "& lt;").replaceAll(">", "& gt;"); 
			filePath = filePath.replaceAll("\\(", "& #40;").replaceAll("\\)", "& #41;");
			filePath = filePath.replaceAll("'", "& #39;"); 
			filePath = filePath.replaceAll("eval\\((.*)\\)", "");
			filePath = filePath.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
			filePath = filePath.replaceAll("script", "");    
			filePath = filePath.replaceAll("\r", "");  
			filePath = filePath.replaceAll("\n", "");  
		} else {
			filePath = "fileNameErr";
		}
		return filePath;
	}

	/**
	 *	20161221_hcchoi<br>
	 *	상대경로 문자열 제거한 경로 리턴
	 */
	public String relativePathCheck(String filePath) {

		if (filePath != null && !"".equals(filePath)) {
			filePath = filePath.replaceAll("\\..", "");
		} else {
			filePath = "PathErr";
		}
		return filePath;
	}

	/**
	 *	20161221_hcchoi<br>
	 *	개행문자 제거 함수
	 */
	public String lineCarriageEraser(String str) {

		if (str != null && !"".equals(str)) {
			str = str.replaceAll("\r", " ").replaceAll("\n", " ");
		} else {
			str = "stringErr";
		}
		return str;
	}%>

