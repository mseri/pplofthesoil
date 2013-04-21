<!DOCTYPE html>
<html>
<head>
	<title>Soil</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="script/jquery/jquery.mobile-1.3.1.min.css" />
	<link rel="stylesheet" href="script/jquery/jquery.mobile.theme-1.3.1.min.css" />
	<link rel="stylesheet" href="script/jquery/jquery.mobile.structure-1.3.1.min.css" />
	<link rel="stylesheet" href="style/mobile.css" />
	<script src="script/jquery/jquery-1.9.1.min.js"></script>
	<script src="script/jquery/jquery.mobile-1.3.1.min.js"></script>
	<script src="http://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyCFL2SQ5mUgiRk0BU1kyci7R8MO940ANrs&sensor=false"></script>
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
</head>