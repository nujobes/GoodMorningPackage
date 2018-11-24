package weather;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class forecastMise
 */
@WebServlet("/forecastMise.do")
public class forecastMise extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset = utf-8");

		String sido = request.getParameter("sido");
		switch (sido) {
		case "서울특별시":
			sido = "서울";
			break;
		case "광주광역시":
			sido = "광주";
			break;
		case "대구광역시":
			sido = "대구";
			break;
		case "대전광역시":
			sido = "대전";
			break;
		case "부산광역시":
			sido = "부산";
			break;
		case "울산광역시":
			sido = "울산";
			break;
		case "인천광역시":
			sido = "인천";
			break;
		case "제주특별자치도":
			sido = "제주";
			break;
		case "경기도":
			sido = "경기";
			break;
		case "충청북도":
			sido = "충북";
			break;
		case "충청남도":
			sido = "충남";
			break;
		case "전라북도":
			sido = "전북";
			break;
		case "전라남도":
			sido = "전남";
			break;
		case "경상북도":
			sido = "경북";
			break;
		case "경상남도":
			sido = "경남";
			break;
		case "강원도":
			sido = "강원";
			break;
		case "세종특별자치시":
			sido = "세종";
			break;
		}
		// 한글 주소 요청시 자동으로 유니코드로 변환되는 문제가 있어, 인코딩 해줌
		sido = URLEncoder.encode(sido, "UTF-8");

		// 미세먼지 시군구별 실시간 평균정보 조회
		String addr = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?serviceKey=";
		String serviceKey = "fT61wS9nZupy6InKetz3nbTs9v1yCJ63wToTfPN6ayob6DIzd4hbkYQtBKWqbVxKcSqBAuojTENmFYexxOVw7Q%3D%3D";
		// String serviceKey =
		// "xoSdIgdKcuY1rRI%2FL%2B1pRx5PIQ3AwcCt%2BX7qE%2BAvCJR%2FdFZsJFNj1xnfyNIBujNRitrpweeEzzGOZukTwGIKpQ%3D%3D";
		String sidoName = "&sidoName=" + sido;
		String searchCondition = "&searchCondition=" + "HOUR"; // HOUR/DAILY
		String PageNRows = "&numOfRows=100&pageNo=1";
		String returnType = "&_returnType=json";

		PrintWriter out = response.getWriter();

		String frctMiseUrl = addr + serviceKey + sidoName + searchCondition + PageNRows + returnType;

		// url 요청을 위한 커넥션 맺고 객체 생성
		URL url = new URL(frctMiseUrl);
		System.out.println(frctMiseUrl);

		URLConnection connection = url.openConnection();
		connection.setRequestProperty("CONTENT-TYPE", "text/html");

		// inputStream 내용을 bufferReader에 넣고 line이 끝날때까지 저장
		BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(), "utf-8"));

		String inputLine;
		String buffer = "";

		while ((inputLine = in.readLine()) != null) {
			buffer += inputLine;
		}
		in.close();

		response.getWriter().write(buffer);
		// System.out.println(buffer);
	}
}
