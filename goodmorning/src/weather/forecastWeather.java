package weather;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.sql.Date;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class forecastWeather
 */
@WebServlet("/forecastWeather.do")
public class forecastWeather extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");

		String serviceKey = "fT61wS9nZupy6InKetz3nbTs9v1yCJ63wToTfPN6ayob6DIzd4hbkYQtBKWqbVxKcSqBAuojTENmFYexxOVw7Q%3D%3D";
		// String serviceKey =
		// "xoSdIgdKcuY1rRI%2FL%2B1pRx5PIQ3AwcCt%2BX7qE%2BAvCJR%2FdFZsJFNj1xnfyNIBujNRitrpweeEzzGOZukTwGIKpQ%3D%3D";

		// 2) 초단기예보조회 - 5p
		// String base_date = "20181005"; // 발표일자 - 필수
		// String base_time = "0500"; // 발표시각 - 필수
		String base_date = ""; // 발표일자 - 필수
		String base_time = ""; // 발표시각 - 필수
		// int nx = 50; // 예보지점 X 좌표 - 필수
		// int ny = 127; // 예보지점 Y 좌표 - 필수

		int nx = Integer.parseInt(request.getParameter("nx"));
		int ny = Integer.parseInt(request.getParameter("ny"));

		int numOfRows = 1000; // 한 페이지 결과 수, 단기 일기 예보의 경우 최대 4*10
		int pageNo = 1; // 페이지 번호
		String _type = "json"; // xml(기본값)/json

		// 현재시간 계산
		SimpleDateFormat nowFormat = new SimpleDateFormat("yyyyMMddHHmm");
		String now = nowFormat.format(new Date(System.currentTimeMillis()));

		// 초단기 예보의 API 제공시각은 45분, 각 예보의 발표 시각은 각 시각의 30분
		if (Integer.parseInt(now.substring(10)) > 45) {
			base_date = now.substring(0, 8);
			base_time = now.substring(8, 10) + "30";
		} else {
			// 45분 이전일 경우 1시각 전 30분의 시각을 base_time으로 함
			now = nowFormat.format(new Date(System.currentTimeMillis() - 60 * 60 * 1000));
			base_date = now.substring(0, 8);
			base_time = now.substring(8, 10) + "30";
		}

		String forecastUrl = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/ForecastTimeData?serviceKey="
				+ serviceKey + "&base_date=" + base_date + "&base_time=" + base_time + "&nx=" + nx + "&ny=" + ny
				+ "&numOfRows=" + numOfRows + "&_type=" + _type;

		BufferedReader brReader = null;

		try {

			System.out.println(forecastUrl);

			URL url = new URL(forecastUrl);

			InputStreamReader isr = new InputStreamReader(url.openStream(), "UTF-8"); // 입력 스트림 생성
			brReader = new BufferedReader(isr);
			String inLine = null;

			String output = "";

			while ((inLine = brReader.readLine()) != null) { // 라인 단위로 읽어들임
				output += inLine.trim();
				response.getWriter().write(output);
			}

		} catch (Exception e) {

		} finally {
			brReader.close();
		}
	}
}
