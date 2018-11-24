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

		// 2) �ʴܱ⿹����ȸ - 5p
		// String base_date = "20181005"; // ��ǥ���� - �ʼ�
		// String base_time = "0500"; // ��ǥ�ð� - �ʼ�
		String base_date = ""; // ��ǥ���� - �ʼ�
		String base_time = ""; // ��ǥ�ð� - �ʼ�
		// int nx = 50; // �������� X ��ǥ - �ʼ�
		// int ny = 127; // �������� Y ��ǥ - �ʼ�

		int nx = Integer.parseInt(request.getParameter("nx"));
		int ny = Integer.parseInt(request.getParameter("ny"));

		int numOfRows = 1000; // �� ������ ��� ��, �ܱ� �ϱ� ������ ��� �ִ� 4*10
		int pageNo = 1; // ������ ��ȣ
		String _type = "json"; // xml(�⺻��)/json

		// ����ð� ���
		SimpleDateFormat nowFormat = new SimpleDateFormat("yyyyMMddHHmm");
		String now = nowFormat.format(new Date(System.currentTimeMillis()));

		// �ʴܱ� ������ API �����ð��� 45��, �� ������ ��ǥ �ð��� �� �ð��� 30��
		if (Integer.parseInt(now.substring(10)) > 45) {
			base_date = now.substring(0, 8);
			base_time = now.substring(8, 10) + "30";
		} else {
			// 45�� ������ ��� 1�ð� �� 30���� �ð��� base_time���� ��
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

			InputStreamReader isr = new InputStreamReader(url.openStream(), "UTF-8"); // �Է� ��Ʈ�� ����
			brReader = new BufferedReader(isr);
			String inLine = null;

			String output = "";

			while ((inLine = brReader.readLine()) != null) { // ���� ������ �о����
				output += inLine.trim();
				response.getWriter().write(output);
			}

		} catch (Exception e) {

		} finally {
			brReader.close();
		}
	}
}
