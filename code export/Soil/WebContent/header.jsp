<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div data-role="header" class="pageHeader" data-theme="c">
<a href="#left-panel" id="MenuIcon" data-icon="bars" data-iconpos="notext" data-shadow="false" data-iconshadow="false">Menu</a>
<img src="images/soil-logo-small.png" id="SiteLogo"></img>
<%--<c:if test="${!empty param.pageTitle}">
	<c:out value="${param.pageTitle}" />
</c:if>&nbsp;--%>
<div data-role="panel" id="left-panel" data-display="overlay" data-position="left" data-theme="c">
       <ul data-role="listview" data-theme="d" data-icon="false">
       	<li data-icon="delete"><a href="#" data-rel="close">Close</a></li>
        <li><a href="#">akhenry@gmail.com</a></li>
        <li><a href="#">About</a></li>
        <li><a href="#">Encylopedia</a></li>
        <li><a href="#">Help</a></li>
        <li><a href="#">Logout</a></li>
       </ul>
 </div>
 </div>