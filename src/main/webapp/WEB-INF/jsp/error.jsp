<html>

<head>
  <title>Erro no processamento</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"></link>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"></link>
</head>

<body>

  <br/>
  <div class="container">
    <div class="text-center">
      <i class="fa fa-exclamation-triangle fa-4x"></i>
      <h2>Erro no processamento</h2>
      <p>Sua requisição não foi processada corretamente pelo servidor.</p>
      <br/>
      <a href="<%=request.getContextPath()%>/" class="btn btn-primary"><i class="fa fa-home"></i> Página Inicial</a>
    </div>
  </div>

</body>

</html>

<!--
  Exception:  ${exception}
-->