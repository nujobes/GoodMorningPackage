<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
<!-- JQUERY -->
<!-- 정은언니서비스키 4636b4674c85540b39adefb0d156833b -->
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<!-- 다음 지도 라이브러리, 라이브러리를 맨 위로 -->
<script type="text/javascript"
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bf145413c07aa033a858c5aa9971119a&libraries=services"></script>
<!-- 다음 지도 API -->
<script type="text/javascript"
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bf145413c07aa033a858c5aa9971119a"></script>
<!-- 구글 폰트 -->
<link
   href="https://fonts.googleapis.com/css?family=Kaushan+Script|Nanum+Gothic|Nanum+Myeongjo|Yeon+Sung"
   rel="stylesheet">
<!-- 기본 CSS -->
<link href="css/style.css" rel="stylesheet">
<title>굿모닝 패키지</title>
<meta charset="UTF-8">
</head>
<body>
   <!-- 화면 : 메뉴 부분 시작 -->
   <div id="menu">
      <h1 class="title">
         <span class="color1">Goo</span><span class="color2">d mor</span><span
            class="color3">ning</span>
      </h1>
      <!-- 카카오 로그인 계정의 nickName 표출 -->
      <h1>
         <span id="nickName"></span>님,
      </h1>
      <h1>안녕하세요!</h1>
      <!-- 미세먼지 출력 부분 -->
      <span id="forecastMise"></span>
      <!-- 단기 예보 출력 부분 -->
      <span id="forecastRs"></span> <span id="busStopLoc"></span>
      <!-- 중기 예보 출력 부분 -->
      <span id="forecastMidRs"></span>
      <!-- 주소 검색 부분 시작 -->
      <input type="button" class="btn green" onclick="openDaumPostcode();"
         value="주소 검색"> <input type="button" class="btn green"
         onclick="subway();" value="주변역 검색"> <input type="button"
         class="btn green" onclick="movieClick();" value="오늘의 영화"> <br>
   </div>
   <!-- 화면 : 메뉴 부분 끝 -->
   <!-- 화면 : 지도 부분 시작 -->
   <div id="map">
      <div id="locHistory"></div>
   </div>
   <!-- 화면 : 지도 부분 끝 -->
   <!-- 스크립트 시작 -->
   <script>
      //카카오로그인관련
      $(document).ready(function () {
         var val = location.href.substr(
                location.href.lastIndexOf('=') + 1
               );
         //console.log('val : ' + decodeURIComponent(val));
         document.getElementById("nickName").innerHTML = decodeURIComponent(val);
      });
      //영화
      function movieClick(){
         location.href="./movie.jsp";
      } 
      // 지도의 출력 사이즈 계산
      // 지도의 가로 사이즈 : 전체 화면 - 화면의 좌측 [menu]의 가로 너비
      $("#map").width($(document).width() - $("#menu").width());
      $("#map").height($(document).height());
      // 위도 경도 초기값
      var lat = 33.450701; // 위도 초기값 - 비트캠프 신촌 센터
      var lon = 126.570667; // 경도 초기값 - 비트캠프 신촌 센터
      var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
      mapOption = {
         center : new daum.maps.LatLng(lat, lon), // 지도의 중심좌표
         // 지도의 확대 레벨 
         level : 3
      };
      //주소-좌표 변환 객체를 생성
      var geocoder = new daum.maps.services.Geocoder();
      // 지도 생성
      var map = new daum.maps.Map(mapContainer, mapOption);
      // 일반 지도-스카이뷰 모드 전환 컨트롤
      var mapTypeControl = new daum.maps.MapTypeControl();
      map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);
      // 줌 컨트롤
      var zoomControl = new daum.maps.ZoomControl();
      map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
      // 처음 화면 실행시 현재 위치를 기반으로 작동시키기 위해
      // HTML5의 GeoLocation 사용 가능 여부 확인
      if (navigator.geolocation) {
         // GeoLocation로 접속 위치 얻기
         navigator.geolocation.getCurrentPosition(function(position) {
            lat = position.coords.latitude; // 위도
            lon = position.coords.longitude; // 경도
            // 마커가 표시될 위치를 얻은 좌표로 변환
            var curPosition = new daum.maps.LatLng(lat, lon); 
            
            // 여기부터 기능
            pickLocation(curPosition); // 
            addHisBtn(lat, lon, "현재 위치"); // 위치 검색 기록에 버튼 부착
            forecast(lat, lon); // 현재 위치의 일기 예보를 반환
            // forecast_mise();
            forecastMMLatLon(lat, lon);  // 현재 위치의 미세먼지를 반환
         });
      } else { // HTML5의 GeoLocation을 사용할 수 없을때
      }
      
      // 이미지 마커 생성  및 부착 , 지도 위치를 현재 위치로 이동
      function pickLocation(curPosition) {
         // 다음 PIN 주소
         // var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png', // 다음 마커이미지
         // 다음 PIN 크기
         // imageSize = new daum.maps.Size(64, 69), // 마커이미지의 크기
         
         var imageSrc = 'images/pin.png', // 마커이미지의 주소 
         imageSize = new daum.maps.Size(60, 34), // 마커이미지의 크기
         
         imageOption = {
            offset : new daum.maps.Point(30, 34) // 마커이미지의 옵션, 마커와 좌표 일치시킬 좌표 설정
         };
         // 마커의 이미지정보를 가지고 있는 마커이미지를 생성
         var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize,
               imageOption), curPosition; // 마커 위치
         // 마커를 생성
         var marker = new daum.maps.Marker({
            position : curPosition,
            // 마커이미지 설정 
            image : markerImage
         });
         // 지도 해당 위치로 이동
         map.setCenter(curPosition);
         // 마커 지도에 부착
         marker.setMap(map);
      };
      // 위치 검색 기록의 핀으로 이동
      var pickLoc;
      function moveToPicker(posStr) {
         pickLoc = posStr.value.split('||');
         var pickLocation = new daum.maps.LatLng(pickLoc[0], pickLoc[1]);
         forecast(pickLoc[0], pickLoc[1]);
         forecastMMLatLon(pickLoc[0], pickLoc[1]);
         map.setCenter(pickLocation);
      }
      
      // 위치 검색 기록에 버튼을 추가
      function addHisBtn(lat, lon, fullAddr) {
         $("#locHistory").html(
               $("#locHistory").html()
                     + "<button class=\"btn blue\" value='" + lat + "||"
                     + lon + "' onclick='moveToPicker(this);'>"
                     + fullAddr + "</button><br>");
      }
      
      // ---------- 다음 주소 API 검색 시작 ----------
      function openDaumPostcode() {
         // 현재 scroll 위치 저장
         var currentScroll = Math.max(document.body.scrollTop,
               document.documentElement.scrollTop);
         new daum.Postcode({
            // theme : themeObj,
            oncomplete : function(data) {
               // 각 주소의 노출 규칙에 따라 주소를 조합
               // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기
               var fullAddr = data.address; // 최종 주소 변수
               var extraAddr = ''; // 조합형 주소 변수
               // 기본 주소가 도로명 타입일때 조합
               if (data.addressType === 'R') {
                  //법정동명이 있을 경우 추가
                  if (data.bname !== '') {
                     extraAddr += data.bname;
                  }
                  // 건물명이 있을 경우 추가
                  if (data.buildingName !== '') {
                     extraAddr += (extraAddr !== '' ? ', '
                           + data.buildingName : data.buildingName);
                  }
                  // 조합형 주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만듦
                  fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')'
                        : '');
               }
               
               // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌림
               document.body.scrollTop = currentScroll;
               // 주소로 상세 정보를 검색
               geocoder.addressSearch(data.address, function(results,
                     status) {
                  // 정상적으로 검색이 완료됐으면
                  if (status === daum.maps.services.Status.OK) {
                     var result = results[0]; //첫번째 결과의 값을 활용
                     // 해당 주소에 대한 좌표를 받아서
                     var resultLoc = new daum.maps.LatLng(result.y,
                           result.x);
                     
                     // 위치 검색 기록 추가
                     addHisBtn(result.y, result.x, fullAddr);
                     // 마커 표시, 지도 이동
                     pickLocation(resultLoc);
                     // 해당 위치의 단기 예보 로드
                     forecast(result.y, result.x);
                     // 미세먼지 데이터
                     forecast_mise(data.sido, data.sigungu);
                  }
               });
            },
         }).open();
      }
       // ---------- 다음 주소 API 검색 끝 ----------
       // ---------- 공공데이터 단기 예보 부분 시작 ----------
      function forecast(lat, lon) {
         $.ajax({
            url : './forecastWeather.do?nx=' + latlon_to_xy(lat, lon).x + '&ny=' + latlon_to_xy(lat, lon).y,   
            type : 'get',
            data: { get_param: 'value'}, 
            dataType : 'json',
            success : function(data) {
               console.log("단기 예보 로드 성공: " + data);
               
               var outFrcs='';
               // 한 시각의 데이터가 10세트이므로, 몇 시각의 데이터셋이 있는지 계산
               // (발표시각이 현재시각보다 이전일 경우 이전 시각의 예보는 삭제되므로 유동적)
               var dsSetCnt = (data['response']['body']['items']['item'].length) / 10; 
               
               // 단기 예보 정보 : 표 출력 시작 --
               outFrcs = '<table class="frcsTb"><tr><td>예측<br>시간</td>';
               // 단기 예보 시각 행 출력
               for (var i = 0; i < dsSetCnt; i++) {
                  outFrcs+='<td>'+data['response']['body']['items']['item'][i].fcstTime+'</td>';
               };
               outFrcs += '</tr><tr>';
               // 단기 하늘 상태 행 출력
               outFrcs += '<td>하늘<br>상태</td>';
               for (var i = 0; i < dsSetCnt * 10; i++) {
                  if(data['response']['body']['items']['item'][i].category=='SKY'){
                     outFrcs += '<td><img src="images/sky';
                     switch(data['response']['body']['items']['item'][i].fcstValue){
                        case 1 : outFrcs += '1'; break;
                        case 2 : outFrcs += '2'; break;
                        case 3 : outFrcs += '3'; break;
                        case 4 : outFrcs += '4'; break;
                     }
                     outFrcs += '.png"></td>';
                  }
               }
               outFrcs += '</tr><tr>';
               // 단기 기온 행 출력
               outFrcs += '<td>기온</td>';
               for (var i = 0; i < dsSetCnt*10; i++) {
                  if(data['response']['body']['items']['item'][i].category=='T1H'){
                     outFrcs += '<td>'+data['response']['body']['items']['item'][i].fcstValue+'℃</td>'
                  }
               };
               outFrcs += '</tr><tr>';
               // 단기 강수 형태 행 출력
               outFrcs += '<td>강수<br>형태</td>';
               for (var i = 0; i < dsSetCnt*10; i++) {
                  if(data['response']['body']['items']['item'][i].category=='PTY'){
                     outFrcs += '<td><img src="images/pty';
                     switch(data['response']['body']['items']['item'][i].fcstValue){
                        case 0 : outFrcs += '0'; break;
                        case 1 : outFrcs += '1'; break;
                        case 2 : outFrcs += '2'; break;
                        case 3 : outFrcs += '3'; break;
                     }
                     outFrcs += '.png"></td>';
                  }
               }
               outFrcs += '</tr><tr>';
               // 단기 강수량 행 출력
               outFrcs += '<td class="th_RN1">강수량</td>';
               for (var i = 0; i < dsSetCnt*10; i++) {
                  if(data['response']['body']['items']['item'][i].category=='RN1'){
                     outFrcs += '<td>'+data['response']['body']['items']['item'][i].fcstValue+'mm</td>'
                  }
               };
               outFrcs += '</tr><tr>';
               // 단기 습도 행 출력
               outFrcs += '<td>습도</td>';
               for (var i = 0; i < dsSetCnt*10; i++) {
                  if(data['response']['body']['items']['item'][i].category=='REH'){
                     outFrcs += '<td>'+data['response']['body']['items']['item'][i].fcstValue+'%</td>'
                  }
               };
               outFrcs += '</tr></table>';
               // 단기 예보 정보 : 표 출력 끝 --
               // 단기 예보 정보 output 부착
               $('#forecastRs').html(outFrcs);
            },
            error: function(){
                  alert('단기 예보 정보를 가져오는데 실패하였습니다.');
              }
         });
      }
      
       // ---------- 기상청 좌표 변환 부분 (위경도 -> grid_XY) 시작 ----------
       // 기상청 홈페이지에서 발췌한 변환 함수 - LCC DFS 좌표변환을 위한 기초 자료
       // https://javaking75.blog.me/220089575454
      function latlon_to_xy(lat, lon){
          var RE = 6371.00877; // 지구 반경(km)
          var GRID = 5.0; // 격자 간격(km)
          var SLAT1 = 30.0; // 투영 위도1(degree)
          var SLAT2 = 60.0; // 투영 위도2(degree)
          var OLON = 126.0; // 기준점 경도(degree)
          var OLAT = 38.0; // 기준점 위도(degree)
          var XO = 43; // 기준점 X좌표(GRID)
          var YO = 136; // 기1준점 Y좌표(GRID)
       
          var rs = {};
          rs['lat'] = lat;
          rs['lon'] = lon;
          
         var DEGRAD = Math.PI / 180.0;
           var RADDEG = 180.0 / Math.PI;
           
           var re = RE / GRID;
           var slat1 = SLAT1 * DEGRAD;
           var slat2 = SLAT2 * DEGRAD;
           var olon = OLON * DEGRAD;
           var olat = OLAT * DEGRAD;
           var sn = Math.tan(Math.PI * 0.25 + slat2 * 0.5) / Math.tan(Math.PI * 0.25 + slat1 * 0.5);
           sn = Math.log(Math.cos(slat1) / Math.cos(slat2)) / Math.log(sn);
           var sf = Math.tan(Math.PI * 0.25 + slat1 * 0.5);
           sf = Math.pow(sf, sn) * Math.cos(slat1) / sn;
           
           var ro = Math.tan(Math.PI * 0.25 + olat * 0.5);
           ro = re * sf / Math.pow(ro, sn);
           
           var ra = Math.tan(Math.PI * 0.25 + (lat) * DEGRAD * 0.5);
            ra = re * sf / Math.pow(ra, sn);
            var theta = lon * DEGRAD - olon;
            if (theta > Math.PI) theta -= 2.0 * Math.PI;
            if (theta < -Math.PI) theta += 2.0 * Math.PI;
            theta *= sn;
           
           rs['x'] = Math.floor(ra * Math.sin(theta) + XO + 0.5);
           rs['y'] = Math.floor(ro - ra * Math.cos(theta) + YO + 0.5);
           
           return rs;
      }
       // ---------- 기상청 좌표 변환 부분 (위경도 -> grid_XY) 끝 ----------
       // ---------- 공공데이터 단기 예보 부분 끝 ----------
       // ---------- 공공데이터 미세먼지 부분 시작 ----------
      function forecast_mise(sido, sigungu) {
          $.ajax({
            // url : './misemise.do?sigungu='+sigungu, // 웹에서 가져오기
            url : './forecastMise.do?sido='+sido, // 웹에서 가져오기
            type : 'get',
            data: { get_param: 'value'}, 
            dataType : 'json',
            success : function(data) {
               console.log("미세먼지 로드 성공: " + data);
               
               var miseValue = '정보없음'; // 미세먼지 수치
               var chomiseValue = '정보없음'; // 초미세먼지 수치
               
               var miseGrade = '정보없음'; // 미세먼지 등급 - 네이버 미세먼지 지도 기준
               var chomiseGrade = '정보없음'; // 초미세먼지 등급 - 네이버 초미세먼지 지도 기준
               
               for(i=0; i<data['list'].length; i++){
                  if(data['list'][i].cityName==sigungu){
                     miseValue = data['list'][i].pm10Value;
                     chomiseValue = data['list'][i].pm25Value;
                  }
               }
               
               if(0 < miseValue && miseValue <= 30) {
                  miseGrade = 1;
               } else if(30 < miseValue && miseValue <= 80){
                  miseGrade = 2;
               } else if(80 < miseValue && miseValue <= 150){
                  miseGrade = 3;
               } else if(150 < miseValue && miseValue <= 1000){
                  miseGrade = 4;
               } else {
                  miseGrade = 5;
               }
               
               if(0 < chomiseValue && chomiseValue <= 15) {
                  chomiseGrade = 1;
               } else if(15 < chomiseValue && chomiseValue <= 35){
                  chomiseGrade = 2;
               } else if(35 < chomiseValue && chomiseValue <= 75){
                  chomiseGrade = 3;
               } else if(75 < chomiseValue && chomiseValue <= 500){
                  chomiseGrade = 4;
               } else {
                  chomiseGrade = 5;
               }
               // 미세먼지 테이블 출력 시작
                var drawT = '';
               drawT= '<table class="forecast_m"><tr><td>미세먼지</td><td>초미세먼지</td></tr><tr><td>';
               // 미세먼지 부분 출력
               if(miseGrade == 1){ 
                       drawT += '<img src="images/1_good.png">' + miseValue + '㎍/m³';
                  } else if(miseGrade == 2){
                     drawT += '<img src="images/2_soso.png">' + miseValue + '㎍/m³';
                  } else if(miseGrade == 3){
                     drawT += '<img src="images/3_bad.png">' + miseValue + '㎍/m³';
                  } else if(miseGrade == 4) {
                     drawT += '<img src="images/4_worst.png">' + miseValue + '㎍/m³';
                  } else {
                     drawT += '<img src="images/5_nodata.png">' + miseValue;
                  }
                    // 초미세먼지 부분
                    drawT += '</td><td>';
                    if(chomiseGrade == 1){
                       drawT += '<img src="images/1_good.png">';
                  } else if(chomiseGrade == 2){
                     drawT += '<img src="images/2_soso.png">';
                  } else if(chomiseGrade == 3){
                     drawT += '<img src="images/3_bad.png">';
                  } else if(chomiseGrade == 4) {
                     drawT += '<img src="images/4_worst.png">';
                  } else {
                     drawT += '<img src="images/5_nodata.png">';
                  }
                  // 미세먼지 테이블 출력 끝
                    drawT += chomiseValue + '㎍/m³</td></tr></table>';
                  // 미세먼지 테이블 부착
                  $('#forecastMise').html(drawT);
      
            }, error: function(){
                 alert('미세먼지 정보를 가져오는데 실패하였습니다.');
            }
         });
      }
       
      // 좌표로 행정동 주소 정보 얻기
      function forecastMMLatLon(lat, lon) {
          // 다음 주소 API 제공
          geocoder.coord2RegionCode(lon, lat, forecastMMAddr);         
      }
      
      // 좌표로 얻은 행정동 주소를 기반으로 미세먼지 출력
      // 좌표로 얻은 행정동 주소를 기반으로 중기예보 출력
      function forecastMMAddr(result, status) {
         var rs = {};
          if (status == daum.maps.services.Status.OK) {
              for(var i = 0; i < result.length; i++) {
                  // 행정동의 region_type 값은 'H' 이므로
                  if (result[i].region_type === 'H') {
                    rs['sido'] = result[i].region_1depth_name;
                    rs['sigungu'] = result[i].region_2depth_name;
                  break;
                  } 
              }
          }
         forecast_mise(rs['sido'], rs['sigungu']);
         forecast_mid(rs['sido']);
      }
       // ---------- 공공데이터 미세먼지 부분 끝 ----------
       
       
       // ------------------ 지하철 시작 ------------//
       var infowindow = new daum.maps.InfoWindow({zIndex:1});
       function subway() {
            var wtm = []; // wtm형식 좌표
            var wgs = []; // wgs84형식 좌표
            var stationName = []; // 지하철 역이름
            var stationNum = []; // 지하철 코드
            var uniqNum = []; // 지하철 코드 중복 제거 변수
            var time = []; // 지하철 시간
            var x; //임시 좌표 저장 변수 
            var y; //임시 좌표 저장 변수
            var index = 0;
            var position = infowindow.getPosition();
            
            var center = map.getCenter(); //가운데 좌표 겟또
            var geocoder = new daum.maps.services.Geocoder(),
                wtmX = center.ib,
                wtmY = center.jb; // wgs84 -> wtm좌표 변환
            var callback = function(result, status) {
                if (status === daum.maps.services.Status.OK) {
                    x = result[0].x;
                    y = result[0].y;
                    nearStation(x, y); // wtm좌표로 변환 후 메소드 호출
                }
            };
            // WGS84 좌표를 WTM 좌표계의 좌표로 변환한다
            geocoder.transCoord(wtmX, wtmY, callback, {
                input_coord: daum.maps.services.Coords.WGS84,
                output_coord: daum.maps.services.Coords.WTM
            });
            var callback2 = function(result, status) { // 마커 생성.
                console.log(index);
                if (status === daum.maps.services.Status.OK) {
                    var imageSrc = "http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";
                    var imageSize = new daum.maps.Size(24, 35);
                    // 마커 이미지를 생성합니다    
                    var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize);
                    // 마커를 생성합니다
                    var marker = new daum.maps.Marker({
                        map: map, // 마커를 표시할 지도
                        position: new daum.maps.LatLng(result[0].y, result[0].x),
                        image: markerImage, // 마커 이미지 
                    });
                    
                    var infowindow = new daum.maps.InfoWindow({
                        content: '<div style="padding:5px;">'+time[index++]+'</div>' // 지하철 시간표 차례로 넣어줌.
                    });
                    // 마커에 마우스오버 이벤트를 등록합니다
                    daum.maps.event.addListener(marker, 'mouseover', function() {
                        // 마커에 마우스오버 이벤트가 발생하면 인포윈도우를 마커위에 표시합니다
                        infowindow.open(map, marker);
                    });
                    // 마커에 마우스아웃 이벤트를 등록합니다
                    daum.maps.event.addListener(marker, 'mouseout', function() {
                        // 마커에 마우스아웃 이벤트가 발생하면 인포윈도우를 제거합니다
                        infowindow.close();
                    });
                }
            };
            var trans = function() { // wtm->wgs84로 변경.
                $(wtm).each(function(index, item) {
                    geocoder = new daum.maps.services.Geocoder(), wtmX = item.subwayX, wtmY = item.subwayY;
                    geocoder.transCoord(wtmX, wtmY, callback2, {
                        input_coord: daum.maps.services.Coords.WTM,
                        output_coord: daum.maps.services.Coords.WGS84
                    });
                });
            }
            var stationId = function(stationName) { // 주변역 찾기 api에는 역코드 정보가 없어 서울시가 제공하는 데이터 api를 이용
                $.ajax({
                    async: false,
                    url: 'subway.json',
                    success: function(data) {
                        $(stationName).each(function(index, item) {
                            $(data.DATA).each(function(key, value) {
                                if (item.name == value.station_nm && item.line == value.line_num) { // 역이름과 호선이 동일할때 역코드를 푸시해줌.
                                    stationNum.push(value.station_cd)
                                }
                            });
                        });
                        $.each(stationNum, function(i, el) { //중복요소 제거
                            if ($.inArray(el, uniqNum) === -1) uniqNum.push(el);
                        });
                        stationTime(uniqNum);
                    }
                });
            };
            var nearStation = function(x, y) {
                $.ajax({
                    async: false,
                    url: 'http://swopenAPI.seoul.go.kr/api/subway/6a63575061646a61383142424a574d/json/nearBy/0/5/' + x + '/' + y, // 변환 좌표 넣어줌   
                    success: function(data) {
                        $(data.stationList).each(function(key, value) {
                            wtm.push({
                                subwayX: value.subwayXcnts, // wtm 역좌표
                                subwayY: value.subwayYcnts, // wtm 역좌표
                                name: value.statnNm //역이름
                            });
                            stationName.push({
                                name: value.statnNm, //역이름
                                line: value.subwayNm //호선
                            })
                        });
                        stationId(stationName); //역코드
                    }
                });
            }
            var stationTime = function(item) { // 지하철 역코드를 이용하여 해당 지하철의 실시간 시간을 받아옴.
                for (i = 0; i < item.length; i++) {
                    $.ajax({
                        async: false,
                        url: 'http://openapi.seoul.go.kr:8088/4f6d7a7746646a613933646d556941/json/SearchArrivalInfoByIDService/0/1/' + item[i] + '/1/3/',
                        success: function(data) {
                            time.push(data.SearchArrivalInfoByIDService.row[0].SUBWAYNAME + '행 열차 ' + data.SearchArrivalInfoByIDService.row[0].ARRIVETIME + ' 도착');
                        }
                    });
                }
                trans(); // wtm->wgs84로 변경.
            }
       }
      // ------------------ 지하철  ------------//
    

       // ---------- 공공데이터 중기 예보 부분 시작 ----------
         function forecast_mid(sido) {
         $.ajax({        
            url: 'forecastMid.do?sido=' + sido,
            type: 'get',
            dataType: 'json',
            success: function(data){
               console.log("중기 예보 로드 성공: " + data);
               var myItem = data['response']['body']['items']['item'];
                 
               var output = '<table class="frcsTb"><tr><td>';
                     switch(myItem.regId){
                        case '11B00000' : output+='서울'; break; 
                    case '11D10000' : output+='강원'; break;
                    case '11C20000' : output+='충남'; break;
                    case '11C10000' : output+='충북'; break;
                    case '11F20000' : output+='전남'; break;
                    case '11F10000' : output+='전북'; break;
                    case '11H10000' : output+='경북'; break;
                    case '11H20000' : output+='경남'; break;
                    case '11G0000' : output+='제주'; break;
                 }
               output += '</td><td>3일후</td><td>4일후</td><td>5일후</td><td>6일후</td></tr><tr>';
                     output += '<td>오전</td>';
                     output += '<td><img src="images/';
                 switch(myItem.wf3Am){
                     case '구름많음' : output+='cloud2'; break;
                     case '구름조금' : output+='cloud1'; break; 
                     case '맑음' : output+='sun'; break;
                     case '흐림' : output+='wind'; break;
                     case '비' : output+='rain'; break;
                   }
                 output += '.png"></td><td><img src="images/';
                   switch(myItem.wf4Am){
                     case '구름많음' : output+='cloud2'; break;
                     case '구름조금' : output+='cloud1'; break; 
                     case '맑음' : output+='sun'; break;
                     case '흐림' : output+='wind'; break;
                     case '비' : output+='rain'; break;
                   }
                 output += '.png"></td><td><img src="images/';
                   switch(myItem.wf5Am){
                     case '구름많음' : output+='cloud2'; break;
                     case '구름조금' : output+='cloud1'; break; 
                     case '맑음' : output+='sun'; break;
                     case '흐림' : output+='wind'; break;
                     case '비' : output+='rain'; break;
                   }
                   output += '.png"></td><td><img src="images/';
                   switch(myItem.wf6Am){
                     case '구름많음' : output+='cloud2'; break;
                     case '구름조금' : output+='cloud1'; break; 
                     case '맑음' : output+='sun'; break;
                     case '흐림' : output+='wind'; break;
                     case '비' : output+='rain'; break;
                   }
                 output += '.png"></td></tr><tr><td>오후</td><td><img src="images/';
                   switch(myItem.wf3Pm){
                     case '구름많음' : output+='cloud2'; break;
                     case '구름조금' : output+='cloud1'; break; 
                     case '맑음' : output+='sun'; break;
                     case '흐림' : output+='wind'; break;
                     case '비' : output+='rain'; break;
                   }
                   output += '.png"></td><td><img src="images/';
                   switch(myItem.wf4Pm){
                     case '구름많음' : output+='cloud2'; break;
                     case '구름조금' : output+='cloud1'; break; 
                     case '맑음' : output+='sun'; break;
                     case '흐림' : output+='wind'; break;
                     case '비' : output+='rain'; break;
                   }
                   output += '.png"></td><td><img src="images/';
                   switch(myItem.wf5Pm){
                     case '구름많음' : output+='cloud2'; break;
                     case '구름조금' : output+='cloud1'; break; 
                     case '맑음' : output+='sun'; break;
                     case '흐림' : output+='wind'; break;
                     case '비' : output+='rain'; break;
                   }
                 output += '.png"></td><td><img src="images/';
                   switch(myItem.wf6Pm){
                     case '구름많음' : output+='cloud2'; break;
                     case '구름조금' : output+='cloud1'; break; 
                     case '맑음' : output+='sun'; break;
                     case '흐림' : output+='wind'; break;
                     case '비' : output+='rain'; break;
                   }
                   output += '.png"></td></tr></table>';

                   // 중기 예보 값을 반환
               $('#forecastMidRs').html(output);
               }, error: function(){
                     alert('중기 예보 정보를 가져오는데 실패하였습니다.');
               }

         });
      }
      // 위경도에 따른 중기예보 값의 반환은
      // 위경도에 따른 미세먼지 값을 반환하는 함수와 동일한 함수를 통해 호출
      
       // ---------- 공공데이터 중기 예보 부분 끝 ----------
   </script>
</body>
</html>