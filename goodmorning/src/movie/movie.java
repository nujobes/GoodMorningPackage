package movie;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/movie.do")
public class movie extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		String addr="http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=";
		String serviceKey="b64c4f9b64a04e6a60271570228c8dc2";
		/*Date now = new Date(); 
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String targetDt=sdf.format(now);*/
		/*SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1);
        String targetDt=sdf.format(cal);*/
		String targetDt="20181007";
		
		addr = addr+serviceKey+"&targetDt="+targetDt+"&itemPerPage=10";
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
		
		in.close();
		response.getWriter().write(buffer);
	}
}