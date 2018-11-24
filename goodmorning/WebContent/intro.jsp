<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<link href="css/intro_style.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Kaushan+Script|Nanum+Gothic|Nanum+Myeongjo|Yeon+Sung" rel="stylesheet">
<title>굿모닝 패키지</title>
<meta charset="UTF-8">
</head>
<body>
	<!--카카오계정 로그인 -->
	<div id="content">
		<h1 class="title">
			<span class="color1">Goo</span><span class="color2">d mor</span><span
				class="color3">ning</span>
		</h1>
		<h3 class="hello">당신을 위한 생활밀착형 정보제공 서비스</h3>
	
		<%@ include file="kakaoLogin.jsp" %>
	
	</div>
</body>
</html>