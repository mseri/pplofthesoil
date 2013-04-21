<jsp:include page="common.jsp"></jsp:include>
<body>
<div data-role="page" data-theme="c">
	<%--<div data-role="header"><jsp:include page="header.jsp"></jsp:include></div>--%>
	<div data-role="content">
		<form action="readings.jsp">
    		<label for="textinput-s">Email:</label>
    		<input type="text" name="textinput-s" id="textinput-s" placeholder="Login" value="" data-clear-btn="true"><br />
    		<label for="textinput-s">Password:</label>
    		<input type="password" name="textinput-s" id="textinput-s" placeholder="Password" value="" data-clear-btn="true">
    		<input type="submit" value="Login"></input>    		
 		</form>
	</div>
	<%--<div data-role="footer"><jsp:include page="footer.jsp"></jsp:include></div> --%>
</div>
</body>
<jsp:include page="trailer.jsp"></jsp:include>