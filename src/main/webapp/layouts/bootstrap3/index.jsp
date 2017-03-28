<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <%@include file="../head.jsp"%>
    <dandelion:bundle includes="bootstrap"/>
    <sitemesh:write property='head' />
  </head>

  <body>
    <link href="https://fonts.googleapis.com/css?family=Itim" rel="stylesheet">
    <style>
      body {
        font-family: 'Itim', cursive;
        font-size: 16px;
      }
    </style>

    <!-- Static navbar -->
    <nav class="navbar navbar-inverse navbar-static-top">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand text-uppercase" href="<%=request.getContextPath()%>/"><strong><%=application.getServletContextName()%></strong></a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <%@include file="../menu.jsp"%>
          </ul>
          <ul class="nav navbar-nav navbar-right">
            <%@include file="../toolbar.jsp"%>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>

    <ol class="breadcrumb" style="margin-top: -20px">
      <li><a href="<%=request.getContextPath()%>/">Página inicial</a></li>
      <sitemesh:write property="meta.previouspage" />
      <li class="active"><sitemesh:write property="meta.header" /></li>
    </ol>

    <div class="container">

      <%@include file="../body.jsp"%>
      <sitemesh:write property='body' />

    </div> <!-- /container -->

  </body>
</html>