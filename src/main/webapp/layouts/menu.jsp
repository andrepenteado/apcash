<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>

<dandelion:bundle includes="font-awesome5"/>

<li><a href="<c:url value="/clientes"/>"><i class="fas fa-address-book"></i> <spring:eval expression="@environment.getProperty('label.cliente')"/>s</a></li>