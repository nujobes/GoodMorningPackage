<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport"
	content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
<title>Login Demo - Kakao JavaScript SDK</title>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
	<div id="kakao-login-btn">
	
	</div>
	<a href="http://developers.kakao.com/logout"></a>
	
	<script type='text/javascript'>
	//로그인 관련하여 쿠키 생성
	function setCookie(name, value, expired){
		var date = new Date();
		date.setHours(date.getHours()+expired);
		var expired_set = "expires= "+date.toGMTString();
		document.cookie = name+"="+value+"; path=/;"+expired_set+";"
	}
	//키설정
    Kakao.init('bf145413c07aa033a858c5aa9971119a');/* bf145413c07aa033a858c5aa9971119a */
	//카카오 로그인 버튼 생성
 	Kakao.Auth.createLoginButton({
		container: '#kakao-login-btn',
		success: function(authObj) {
			 // 로그인 성공시, API를 호출합니다.
			Kakao.API.request({
				url: '/v1/user/me',
				success: function(res) {

					console.log(res);
					
					var userID = res.id;						//유저의 카카오톡 고유 id
					var userEmail = res.kaccount_email;			//유저의 이메일
					var userNickName = res.properties.nickname;	//유저가 등록한 별명
					console.log(authObj.access_token);//토큰출력
					
					location.href="./index.jsp?userNickName="+encodeURIComponent(userNickName);
					//setCookie("kakao_login","done",1);
					
				},
				fail: function(error) {
					alert(JSON.stringify(error));
				}
			});
		},

      	fail: function(err) {
         	alert(JSON.stringify(err));
      	}
    });
  //]]>
  
 	
</script>
</body>
</html>