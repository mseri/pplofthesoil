<jsp:include page="common.jsp"></jsp:include>
<jsp:include page="header.jsp"></jsp:include>
<body>
	<script type="text/javascript">
	var map;	
	
	function initializeMaps() {
		alert('hello');
		  var mapOptions = {
		    zoom: 8,
		    center: new google.maps.LatLng(-34.397, 150.644),
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		  };
		  map = new google.maps.Map(document.getElementById('MapCanvas'), mapOptions);
	};
	</script>
	<div data-role="page" data-theme="c" id="MapPage" style="height: 100%; width: 100%;">
		<jsp:include page="header.jsp"><jsp:param value="My Recent Readings" name="pageTitle"/></jsp:include>
		<div data-role="content" style="height: 100%; width: 100%;">
			<jsp:include page="navigation.jsp"></jsp:include>
			<div class="activeContHolder" style="width: 80%; height: 300px;">
				<div id="MapCanvas"></div>
			</div>
			<%--<div class="Reading">
				<div class="phReading">pH: 3.0</div>
				<div class="tempReading">temp: 15&#x2103;</div>
				<div class="moistureReading"></div>
			</div> --%>
		</div>
		<jsp:include page="footer.jsp"></jsp:include>
	</div>
		<script type="text/javascript">
    $(document).on("pageinit", "#MapPage", function() {
        initializeMaps();
    });
	</script>
</body>
<jsp:include page="footer.jsp"></jsp:include>