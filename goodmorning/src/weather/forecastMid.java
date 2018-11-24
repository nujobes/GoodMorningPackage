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
		case "����Ư����":
			sido = "11B00000";
			break;
		case "���ֱ�����":
			sido = "11F20000";
			break;
		case "�뱸������":
			sido = "11H10000";
			break;
		case "����������":
			sido = "11C20000";
			break;
		case "�λ걤����":
			sido = "11H20000";
			break;
		case "��걤����":
			sido = "11H20000";
			break;
		case "��õ������":
			sido = "11B00000";
			break;
		case "����Ư����ġ��":
			sido = "11G0000";
			break;
		case "��⵵":
			sido = "11B00000";
			break;
		case "��û�ϵ�":
			sido = "11C10000";
			break;
		case "��û����":
			sido = "11C20000";
			break;
		case "����ϵ�":
			sido = "11F10000";
			break;
		case "���󳲵�":
			sido = "11F20000";
			break;
		case "���ϵ�":
			sido = "11H10000";
			break;
		case "��󳲵�":
			sido = "11H20000";
			break;
		case "������":
			sido = "11D10000";
			break;
		case "����Ư����ġ��":
			sido = "11C20000";
			break;
		// �õ� ��� ó��
		case "����":
			sido = "11B00000";
			break;
		case "����":
			sido = "11F20000";
			break;
		case "�뱸":
			sido = "11H10000";
			break;
		case "����":
			sido = "11C20000";
			break;
		case "�λ�":
			sido = "11H20000";
			break;
		case "���":
			sido = "11H20000";
			break;
		case "��õ":
			sido = "11B00000";
			break;
		case "����":
			sido = "11G0000";
			break;
		case "���":
			sido = "11B00000";
			break;
		case "���":
			sido = "11C10000";
			break;
		case "�泲":
			sido = "11C20000";
			break;
		case "����":
			sido = "11F10000";
			break;
		case "����":
			sido = "11F20000";
			break;
		case "���":
			sido = "11H10000";
			break;
		case "�泲":
			sido = "11H20000";
			break;
		case "����":
			sido = "11D10000";
			break;
		case "����":
			sido = "11C20000";
			break;
		}
		
		/*case "����":
			sido = "11B00000";// ����, ��õ,��⵵
			break;
		case "����":
			sido = "11D10000";// ����������
			break;
		case "�泲":
			sido = "11C20000";// ����, ����, ��û����
			break;
		case "���":
			sido = "11C10000";// ��û�ϵ�
			break;
		case "����":
			sido = "11F20000";// ����, ���󳲵�
			break;
		case "����":
			sido = "11F10000";// ����ϵ�
			break;
		case "���":
			sido = "11H10000";// �뱸, ���ϵ�
			break;
		case "�泲":
			sido = "11H20000";// �λ�, ���, ��󳲵�
			break;
		case "����":
			sido = "11G0000";// ���ֵ�
			break;*/

		// ����ð� ���
		SimpleDateFormat nowFormat = new SimpleDateFormat("yyyyMMddHH");
		String now = nowFormat.format(new Date(System.currentTimeMillis()));

		String tmFcValue = ""; // 201810070600
		// �߱� ������ API �Ϸ� �ι� �� 06�ÿ� 18���̸�, 24�ð��� ����
		if (Integer.parseInt(now.substring(8)) < 6) {
			// 6�� ������ ��� 6�ð��� ��¥�� 18���� ���� ȣ��
			now = nowFormat.format(new Date(System.currentTimeMillis() - 60 * 60 * 1000 * 6));
			tmFcValue = now.substring(0, 8) + "1800";
		} else if (6 <= Integer.parseInt(now.substring(8)) && Integer.parseInt(now.substring(8)) < 18) {
			// 6�� ���� 18�� �� �� ���
			tmFcValue = now.substring(0, 8) + "0600";
		} else {
			tmFcValue = now.substring(0, 8) + "1800";
		}

		PrintWriter out = response.getWriter();
		parameter = parameter + "&" + "regId=" + sido;// ���������ڵ�
		parameter = parameter + "&" + "tmFc=" + tmFcValue;// ��ǥ �ð�
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

		InputStream in = url.openStream(); // location(ȣ��Ʈ)�� �����Ű�� InputStream ��ü����
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
