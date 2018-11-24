<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- JQUERY -->
<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>

<!-- 기본 CSS -->
<link href="css/movie_style.css" rel="stylesheet">
<!-- 구글 폰트 -->
<link
	href="https://fonts.googleapis.com/css?family=Kaushan+Script|Nanum+Gothic|Nanum+Myeongjo|Yeon+Sung"
	rel="stylesheet">
<meta charset="utf-8">
<title>오늘의 영화</title>
</head>
<body>
	<script>
/* 	
	//카카오로그인관련
    $(document).ready(function () {
       var val = location.href.substr(
              location.href.lastIndexOf('=') + 1
             );
       //console.log('val : ' + decodeURIComponent(val));
       document.getElementById("nickName").innerHTML = decodeURIComponent(val);
    }); */
		$(document).ready(
			function() {
				//영화정보 출력
				$.ajax({
					url : './movie.do',
					type : 'get',
					data : {get_param : 'value'},
					dataType : 'json',
					success : function(data) {
					console.log("성공: " + data);

					var out = '';

					out = '<table><tr><td>순위</td><td>영화제목</td><td>관람객수</td><td>-</td></tr>';
					console.log(data['boxOfficeResult']['dailyBoxOfficeList'][0].movieNm);

					for (var i = 0; i < data['boxOfficeResult']['dailyBoxOfficeList'].length; i++) {
						out += '<tr><td>'
								+ data['boxOfficeResult']['dailyBoxOfficeList'][i].rank
								+ '</td><td>'
								+ data['boxOfficeResult']['dailyBoxOfficeList'][i].movieNm
								+ '</td><td>'
								/*+data['boxOfficeResult']['dailyBoxOfficeList'][i].openDt+'</td><td>' */
								+ data['boxOfficeResult']['dailyBoxOfficeList'][i].audiCnt
								+ '</td><td>'
								+ '<input type="button" class="btn green" onclick="movieDetail('
								+ data['boxOfficeResult']['dailyBoxOfficeList'][i].movieCd
								+ ');" value="상세보기"></td><tr>';
					}
					$('#movieList').html(out);
					},
					error : function() {
							alert('실패');
					}
			});
		});

		function movieDetail(movieCd) {
			$.ajax({
						url : './movieDetail.do?movieCd=' + movieCd,
						type : 'get',
						dataType : 'json',
						success : function(data) {
							var out = '';

							out = '<table class="movieInfo"><tr><td>영화제목</td>';
							out += '<td>'
									+ data['movieInfoResult']['movieInfo'].movieNm
									+ '<br>'
									+ data['movieInfoResult']['movieInfo'].movieNmEn
									+ '</td></tr>';
							out += '<tr><td>개봉일</td><td>'
									+ data['movieInfoResult']['movieInfo'].openDt
									+ '</td></tr>';
							out += '<tr><td>장르</td><td>'
									+ data['movieInfoResult']['movieInfo']['genres'][0].genreNm
									+ '</td></tr>';
							out += '<tr><td>감독</td><td>'
									+ data['movieInfoResult']['movieInfo']['directors'][0].peopleNm
									+ '</td></tr>';
							out += '<tr><td>배우</td><td>';
							for (var i = 0; i < data['movieInfoResult']['movieInfo']['actors'].length; i++) {
								out += data['movieInfoResult']['movieInfo']['actors'][i].peopleNm
										+ '<br>';
							}
							out += '</td><tr><td>관람가</td><td>'
									+ data['movieInfoResult']['movieInfo']['audits'][0].watchGradeNm
									+ '</td></tr></table>';

							$('#h4').html('<h4>영화 상세 정보</h4>');
							$('#movieDetail').html(out);
							$('#poster')
									.html(
											'<img src="images/venom.jpg" height="300px" width="220px">');
						},
						error : function() {
							console.log("실패");
						}
					});
		}
	</script>
	<div id="menu">
		<!-- 화면 : 메뉴 부분 시작 -->
			<h1 class="title">
				<span class="color1">Goo</span><span class="color2">d mor</span><span
					class="color3">ning</span>
			</h1>
			<!-- 카카오 로그인 계정의 nickName 표출 -->
<!-- 			<h1>
				<span id="nickName"></span>님,
			</h1>
			<h1>안녕하세요!</h1> -->
			<h1>오늘의 영화</h1>
			<span id="movieList"></span>
		</div>

		<div id="content">
			<h1 id="h4"></h1>
			<div id="poster"></div>
			<span id="movieDetail"></span>
		</div>
</body>
</html>