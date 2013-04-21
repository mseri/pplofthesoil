<jsp:include page="common.jsp"></jsp:include>
<jsp:include page="header.jsp"></jsp:include>
<%
	int SHOW_DATES = 20;
%>
<body>
	<script type="text/javascript">
	var map;
	var dateBoxes = {};
	var lastClicked;
	var markers =[];
	//var deviceId = '$LW10006';
	var deviceId = '1234';
	
	function clearAllMarkers(){
		for (var i=0; i< markers.length; i++){
			markers[i].setMap(null);
		}
		markers=[];
	}
	
	function showMyReadings(){
		clearAllMarkers();
		loadData(deviceId);
		$('#AllReadingsTab').removeClass('active');
		$('#MyReadingsTab').addClass('active');
	}
	
	function showAllReadings(){
		clearAllMarkers();
		loadData();
		$('#MyReadingsTab').removeClass('active');
		$('#AllReadingsTab').addClass('active');	
	}
	
	function textBlur(e){
		if (!e.target.value){
			e.target.value='Add Notes...';
		}
		var el = $(e.target);
		$(e.target).removeClass('activeNotes');
		$(e.target).addClass('inactiveNotes');
	}
	
	function editNotes(e){
		if (e.target.value=='Add Notes...')
			e.target.value='';
		var el = $(e.target);
		el.closest('form').find('.submitBtnHolder').show();
		$(e.target).addClass('activeNotes');
		$(e.target).removeClass('inactiveNotes');
	}
	
	function submitForm(form){
		//var el = $(e.target);
		//var form = el.closest('form');
		//form.action+='/' + form.elements['id'].value;
		var now = new Date();
		form.elements['soil_sample[updated_at]'].value=now.getYear() + '-' + now.getMonth() + '-' + now.getDay() + 'T' + now.getHours() + ':' + now.getMinutes() + ':' + now.getSeconds() + 'Z';
		if (form.elements['soil_sample[comments]'].value=='Add Comments...'){
			form.elements['soil_sample[comments]'].value='';
		}
		$.ajax({
			  type: "PUT",
			  url: form.action,
			  data: $(form).serialize(),
			  success: function(data, textStatus, jqXHR) {
			    alert('everything was OK');
			  }
			});
		$('.submitBtnHolder').hide();
		return false;
	}
	
	function addReading(data){
		var createdTime = new Date(data['created_at']);
		var notesVal = data['comments'];
		
		var html =
		'<div class="siteReading"> ' +
		'	<form action="http://soil-sample-api.herokuapp.com/soil_samples/' + data['id'] + '" onSubmit=" return submitForm(this)" method="POST" > ' +
		'	<input type="hidden" name="soil_sample[created_at]" value="' + data['created_at'] + '" /> ' +
		'	<input type="hidden" name="soil_sample[id]" value="' + data['id'] + '" /> ' +
		'	<input type="hidden" name="soil_sample[lat]" value="' + data['lat'] + '" /> ' +
		'	<input type="hidden" name="soil_sample[long]" value="' + data['long'] + '" /> ' +
		'	<input type="hidden" name="soil_sample[moisture]" value="' + data['moisture'] + '" /> ' +
		'	<input type="hidden" name="soil_sample[pH]" value="' + data['pH'] + '" /> ' +
		'	<input type="hidden" name="soil_sample[temperature]" value="' + data['temperature'] + '" /> ' +
		'	<input type="hidden" name="soil_sample[time]" value="' + data['time'] + '" /> ' +
		'	<input type="hidden" name="soil_sample[updated_at]" value="' + data['updated_at'] + '" /> ' +
		'<div> ' +
		'	<img class="myReadImage" src="images/leaf.png"></img> ' +
		'	<h2 class="readingName">Soil Reading ' + data.id + '</h2> ' +
		'	 ' +
		'	<div class="readingDate"> ' +
		'		<ul class="readingTS"> ' +
		'			<li class="readingTime">' + createdTime.getHours() + ':' + createdTime.getMinutes() + '</li> ' +
		'			<li class="readingDate">20/04/2013</li> ' +
		'		</ul> ' +
		'	</div> ' +
		'</div> ' +
		'<div class="readingValues"> ' +
		'	<ul> ' +
		'		<li class="moistureValue">Moisture <span class="readVal">' + data.moisture + '%</span></li> ' +
		'		<li class="tempValue">Temperature <span class="readVal">' + data.temperature + '&deg;C</span></li> ' +
		'		<li class="phValue">pH <span class="readVal">' + data.pH + '</span></li> ' +
		'		<li class="notesVal"><div data-role="fieldcontain">';
		if (notesVal){
			html+='<textarea name="soil_sample[comments]" class="soilNotes activeNotes">' + notesVal + '</textarea>';
		} else {
			html+='<textarea name="soil_sample[comments]" class="soilNotes inactiveNotes">Add Notes...</textarea>';
		}
		html+=
		'		<div class="submitBtnHolder"> ' +			
		'			<input name="submitBtn" class="submitBtn" value="Save" type="submit" />' +
		'		</div>' +
		'		</li>' +
		'	</ul> ' +
		'</div> ' +	
		'	</form>' +
		'</div>';
		$('#ReadingsHolder').append(html);
		$('#ReadingsHolder').trigger('create');
		$('.soilNotes').click(editNotes);
		//$('.soilNotes').blur(textBlur);
	}
	
	function dateClick(event){
		if ($(event.target).hasClass('dateBox')){
			if (!lastClicked){
				lastClicked=$('#DateBox<%= SHOW_DATES-1 %>');
			}
			lastClicked.removeClass('active');
			lastClicked.addClass('inactive');
				
			$(event.target).removeClass('inactive');
			$(event.target).addClass('active');
			lastClicked = $(event.target);
		}
	}
	
	function initElements(){
		var container = $('#DateRange');
	    var scrollTo = $('#EndDiv');

		container.scrollLeft(
		    scrollTo.offset().left - container.offset().left + container.scrollLeft());
		dateBoxes = $('.dateBox');
		dateBoxes.click(dateClick);
	}
	function addMarker(opts, soilData, mine) {
		var contentStr = 
			'<div>' +
			'<div>pH: ' + soilData.pH + '</div>' +
			'<div>Temperature: ' + soilData.temperature + '</div>' +
			'<div>Moisture: ' + soilData.moisture + '</div>' +
			'</div>';
		var infowindow = new google.maps.InfoWindow({
		    content: contentStr
		});
		var markerOpts = {
			      position: opts.position,
			      map: map,
			      title:'Site reading'
		};
		if (mine){
			markerOpts['icon']='images/leaf-small.png';
		} else {
			markerOpts['icon']='images/leaf-small-all.png';
		}
		 
		var marker = new google.maps.Marker(markerOpts);
		google.maps.event.addListener(marker, 'click', function() {
			  infowindow.open(map,marker);
			});
		markers.push(marker);
	}
	
	function initializeMaps(lat, lon) {
		  var mapOptions = {
		    zoom: 5,
		    center: new google.maps.LatLng(lat, lon),
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		  };
		  map = new google.maps.Map(document.getElementById('MapCanvas'), mapOptions);
		  
	};
	
	function loadData(l_deviceId){
		var queryString = 'http://soil-sample-api.herokuapp.com/soil_samples.json';
		if (l_deviceId){
			queryString = 'http://soil-sample-api.herokuapp.com/soil_samples.json?device_id=' + l_deviceId;
		}
		var data = jQuery.getJSON(queryString, function(data) {
			  $.each(data, function(index, val) {
			    var opts = {position: new google.maps.LatLng(val['lat'], val['long']), title:'Location' + val.id };
			    var place = {id:val.id};
			    var mine = (val['device_id'] == deviceId);
			    addMarker(opts, val, mine);
			    if (index <= 5){
			    	addReading(val);
			    }
			  });
			});
	}
	
	function locError(error) {
        // initialize map with a static predefined latitude, longitude
       initialize(59.3426606750, 13.41);
    }

    function locSuccess(position) {
        //initializeMaps(position.coords.latitude, position.coords.longitude);
        initializeMaps(52.52, 13.41);
        loadData(deviceId);
		initElements();
    }
    
	</script>
	<div data-role="page" id="Thing" data-theme="c" >
		<jsp:include page="header.jsp"><jsp:param value="My Recent Readings" name="pageTitle"/></jsp:include>
		<div data-role="content">
			<jsp:include page="navigation.jsp"></jsp:include>
			<div class="activeContHolder" style="padding: 10px 10px;">
				<div id="MapCanvas" style="width: 100%; height: 300px;"></div>
			</div>
			<%--<div class="Reading">
				<div class="phReading">pH: 3.0</div>
				<div class="tempReading">temp: 15&#x2103;</div>
				<div class="moistureReading"></div>
			</div> --%>
			<div id="DateRange">
				<div id="DateHolder">
				<%
				java.util.Calendar cal = java.util.Calendar.getInstance();
				cal.add(cal.DAY_OF_YEAR, -20);
				java.text.SimpleDateFormat ord = new java.text.SimpleDateFormat("dd");
				java.text.SimpleDateFormat fmt = new java.text.SimpleDateFormat("EEE");
				for (int i=0; i< SHOW_DATES; i++){
					%>
					<div id="DateBox<%= i %>" class="dateBox <%= (i+1) == SHOW_DATES ? "active" : "inactive" %>">
						<div><%= ord.format(cal.getTime()) %></div>
						<div><%= fmt.format(cal.getTime()) %></div>
					</div>
					<%
					cal.add(java.util.Calendar.DAY_OF_YEAR, 1);
				}
				
				%>
					<div id="EndDiv"></div>
				</div>
			</div>
			<div id="ReadingsHolder">
			</div>
		</div>
		<jsp:include page="footer.jsp"></jsp:include>
	</div>
	<script type="text/javascript">
		$(document).on("pagebeforeshow", "#Thing", function() {
        	navigator.geolocation.getCurrentPosition(locSuccess, locError);
    	});
		$(document).on('pageinit', '#Thing', function(event, ui){
			  initializeMaps();
		});
	</script>
</body>
<jsp:include page="trailer.jsp"></jsp:include>