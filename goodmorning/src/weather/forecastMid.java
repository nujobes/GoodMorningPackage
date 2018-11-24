package weather;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.sql.Date;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.IOUtils;

/**
 * Servlet implementation class forecastMid
 */
@WebServlet("/forecastMid.do")
public class forecastMid extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset = utf-8");

		String addr = "http://newsky2.kma.go.kr/service/MiddleFrcstInfoService/getMiddleLandWeather?serviceKey=";
		String serviceKey = "fT61wS9nZupy6InKetz3nbTs9v1yCJ63wToTfPN6ayob6DIzd4hbkYQtBKWqbVxKcSqBAuojTENmFYexxOVw7Q%3D%3D";
		// "&regId=11B00000&tmFc=201810060600&numOfRows=10&pageSize=10&pageNo=1&startPage=1";
		String sido = (String) request.getParameter("sido");
		String parameter = "";

		switch (sido) {
		case "서울특별시":
			sido = "11B00000";
			break;
		case "광주광역시":
			sido = "11F20000";
			break;
		case "대구광역시":
			sido = "11H10000";
			break;
		case "대전광역시":
			sido = "11C20000";
			break;
		case "부산광역시":
			sido = "11H20000";
			break;
		case "울산광역시":
			sido = "11H20000";
			break;
		case "인천광역시":
			sido = "11B00000";
			break;
		case "제주특별자치도":
			sido = "11G0000";
			break;
		case "경기도":
			sido = "11B00000";
			break;
		case "충청북도":
			sido = "11C10000";
			break;
		case "충청남도":
			sido = "11C20000";
			break;
		case "전라북도":
			sido = "11F10000";
			break;
		case "전라남도":
			sido = "11F20000";
			break;
		case "경상북도":
			sido = "11H10000";
			break;
		case "경상남도":
			sido = "11H20000";
			break;
		case "강원도":
			sido = "11D10000";
			break;
		case "세종특별자치시":
			sido = "11C20000";
			break;
		// 시도 축어 처리
		case "서울":
			sido = "11B00000";
			break;
		case "광주":
			sido = "11F20000";
			break;
		case "대구":
			sido = "11H10000";
			break;
		case "대전":
			sido = "11C20000";
			break;
		case "부산":
			sido = "11H20000";
			break;
		case "울산":
			sido = "11H20000";
			break;
		case "인천":
			sido = "11B00000";
			break;
		case "제주":
			sido = "11G0000";
			break;
		case "경기":
			sido = "11B00000";
			break;
		case "충북":
			sido = "11C10000";
			break;
		case "충남":
			sido = "11C20000";
			break;
		case "전북":
			sido = "11F10000";
			break;
		case "전남":
			sido = "11F20000";
			break;
		case "경북":
			sido = "11H10000";
			break;
		case "경남":
			sido = "11H20000";
			break;
		case "강원":
			sido = "11D10000";
			break;
		case "세종":
			sido = "11C20000";
			break;
		}
		
		/*case "서울":
			sido = "11B00000";// 서울, 인천,경기도
			break;
		case "강원":
			sido = "11D10000";// 강원도영서
			break;
		case "충남":
			sido = "11C20000";// 대전, 세종, 충청남도
			break;
		case "충북":
			sido = "11C10000";// 충청북도
			break;
		case "전남":
			sido = "11F20000";// 광주, 전라남도
			break;
		case "전북":
			sido = "11F10000";// 전라북도
			break;
		case "경북":
			sido = "11H10000";// 대구, 경상북도
			break;
		case "경남":
			sido = "11H20000";// 부산, 울산, 경상남도
			break;
		case "제주":
			sido = "11G0000";// 제주도
			break;*/

		// 현재시간 계산
		SimpleDateFormat nowFormat = new SimpleDateFormat("yyyyMMddHH");
		String now = nowFormat.format(new Date(System.currentTimeMillis()));

		String tmFcValue = ""; // 201810070600
		// 중기 예보의 API 하루 두번 각 06시와 18시이며, 24시간만 제공
		if (Integer.parseInt(now.substring(8)) < 6) {
			// 6시 이전일 경우 6시간전 날짜의 18시의 값을 호출
			now = nowFormat.format(new Date(System.currentTimeMillis() - 60 * 60 * 1000 * 6));
			tmFcValue = now.substring(0, 8) + "1800";
		} else if (6 <= Integer.parseInt(now.substring(8)) && Integer.parseInt(now.substring(8)) < 18) {
			// 6시 이후 18시 전 일 경우
			tmFcValue = now.substring(0, 8) + "0600";
		} else {
			tmFcValue = now.substring(0, 8) + "1800";
		}

		PrintWriter out = response.getWriter();
		parameter = parameter + "&" + "regId=" + sido;// 예보구역코드
		parameter = parameter + "&" + "tmFc=" + tmFcValue;// 발표 시각
		// parameter = parameter + "&" + "eventEndDate=20181231";
		parameter = parameter + "&" + "pageNo=1&numOfRows=100";
		// parameter = parameter + "&" + "MobileOS=ETC";
		// parameter = parameter + "&" + "MobileApp=aa";
		parameter = parameter + "&" + "_type=json";

		addr = addr + serviceKey + parameter;

		URL url = new URL(addr);
		System.out.println(addr);

		// BufferedReader in = new BufferedReader(new
		// InputStreamReader(url.openStream(), "UTF-8"));

		InputStream in = url.openStream(); // location(호스트)과 연결시키는 InputStream 객체생성
		// CachedOutputStream bos = new CachedOutputStream();
		ByteArrayOutputStream bos1 = new ByteArrayOutputStream();
		IOUtils.copy(in, bos1);
		in.close();
		bos1.close();

		String mbos = bos1.toString("UTF-8");
		System.out.println("mbos: " + mbos);

		byte[] b = mbos.getBytes("UTF-8");
		String s = new String(b, "UTF-8");
		out.println(s);

		JSONObject json = new JSONObject();

		json.put("data", s);
	}
}
