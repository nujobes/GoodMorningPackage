package transportation;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//주어진 좌표(gpsLati, pgsLong)의 버스정류장 보기 
@WebServlet("/buStopLocation.do")
public class buStopLocation extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		String gpsLati = request.getParameter("lat");
		String gpsLong = request.getParameter("lon");

		
		//http://openapi.tago.go.kr/openapi/service/BusSttnInfoInqireService/getCrdntPrxmtSttnList?ServiceKey=
		String addr = "http://openapi.tago.go.kr/openapi/service/BusSttnInfoInqireService/getCrdntPrxmtSttnList?ServiceKey=";
		String serviceKey = "fT61wS9nZupy6InKetz3nbTs9v1yCJ63wToTfPN6ayob6DIzd4hbkYQtBKWqbVxKcSqBAuojTENmFYexxOVw7Q%3D%3D&_type=json";

		String parameter = "";
		
		//System.out.println("java "+gpsLati);
		PrintWriter out = response.getWriter();
		parameter = parameter + "&" + "gpsLati="+gpsLati;
		parameter = parameter + "&" + "gpsLong="+gpsLong;
		/*parameter = parameter + "&" + "gpsLati="+37.551169;
		parameter = parameter + "&" + "gpsLong="+126.937936;*/

		addr = addr+serviceKey+parameter;
		System.out.println(addr);
		URL url = new URL(addr);
		URLConnection connection = url.openConnection();
		connection.setRequestProperty("CONTENT-TYPE", "text/html");
		
		BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(), "utf-8"));
		
		String inputLine;
		String buffer = "";
		
		while((inputLine=in.readLine())!=null) {
			buffer += inputLine.trim();
			System.out.println("buffer: "+buffer);
		}
		
		/*//Json parser를 만들어 만들어진 문자열 데이터를 객체화 함
		JSONParser parser = new JSONParser();
		try {
			JSONObject obj = (JSONObject) parser.parse(buffer);
			//Top레벨단계인 response키를가지고 데이터를 파싱한다.
			JSONObject parse_response=(JSONObject) obj.get("response");
			//response로부터 body 찾음
			JSONObject parse_body=(JSONObject)parse_response.get("body");
			//body로부터 items 받음
			JSONObject parse_items=(JSONObject)parse_body.get("items");
			//items로부터 itemlist를 받아오기
			JSONArray parse_item=(JSONArray)parse_items.get("item");

			System.out.println(parse_item);
			
			
					
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		in.close();
		response.getWriter().write(buffer);
		
		//request.setAttribute("gpsLati", gpsLati);
		//request.setAttribute("gpsLong", gpsLong);
		
		/*RequestDispatcher dispatcher = request.getRequestDispatcher("/NewFile.jsp");
		dispatcher.forward(request,  response);*/
	}
 
}