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
		case "����Ư����":
			sido = "����";
			break;
		case "���ֱ�����":
			sido = "����";
			break;
		case "�뱸������":
			sido = "�뱸";
			break;
		case "����������":
			sido = "����";
			break;
		case "�λ걤����":
			sido = "�λ�";
			break;
		case "��걤����":
			sido = "���";
			break;
		case "��õ������":
			sido = "��õ";
			break;
		case "����Ư����ġ��":
			sido = "����";
			break;
		case "��⵵":
			sido = "���";
			break;
		case "��û�ϵ�":
			sido = "���";
			break;
		case "��û����":
			sido = "�泲";
			break;
		case "����ϵ�":
			sido = "����";
			break;
		case "���󳲵�":
			sido = "����";
			break;
		case "���ϵ�":
			sido = "���";
			break;
		case "��󳲵�":
			sido = "�泲";
			break;
		case "������":
			sido = "����";
			break;
		case "����Ư����ġ��":
			sido = "����";
			break;
		}
		// �ѱ� �ּ� ��û�� �ڵ����� �����ڵ�� ��ȯ�Ǵ� ������ �־�, ���ڵ� ����
		sido = URLEncoder.encode(sido, "UTF-8");

		// �̼����� �ñ����� �ǽð� ������� ��ȸ
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

		// url ��û�� ���� Ŀ�ؼ� �ΰ� ��ü ����
		URL url = new URL(frctMiseUrl);
		System.out.println(frctMiseUrl);

		URLConnection connection = url.openConnection();
		connection.setRequestProperty("CONTENT-TYPE", "text/html");

		// inputStream ������ bufferReader�� �ְ� line�� ���������� ����
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
