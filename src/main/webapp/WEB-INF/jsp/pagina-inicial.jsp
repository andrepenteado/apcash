<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>

<html>
<head>
  <meta name="header" content="Bem-vindo" />
  <title>Página Inicial</title>
</head>
<body>

  <div class="text-center">
    <i class="fa fa-home fa-4x"></i>
    <h2>Página Inicial</h2>
    <p>Você está conectado em <strong><%=application.getServletContextName()%></strong> através do IP <strong><%=request.getRemoteAddr()%></strong></p>
  </div>

</body>
</html>
