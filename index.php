<!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0"/>
  <title>Starter Template - Materialize</title>

  <!-- CSS  -->
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <link href="css/materialize.css" type="text/css" rel="stylesheet" media="screen,projection"/>
</head>
<body>
  <nav class="light-blue lighten-1" role="navigation">
    <div class="nav-wrapper container"><a id="logo-container" href="#" class="brand-logo">Hello Around the World!</a>
      <ul class="right hide-on-med-and-down">
        <li><a href="#">Test</a></li>
        <li><a href="#">Study</a></li>
        <li><a href="#">Log In</a></li>
      </ul>
      <ul id="nav-mobile" class="side-nav">
        <li><a href="#">Navbar Link</a></li>
      </ul>
      <a href="#" data-activates="nav-mobile" class="button-collapse"><i class="material-icons">menu</i></a>
    </div>
  </nav>
  <div class="section no-pad-bot main-section test" id="index-banner">
    <div class="container" id="content">

      <?php include("inc/test-list.php"); ?>

    </div>
  </div>

  <footer class="page-footer blue lighten-1">
    <div class="footer-copyright">
      <div class="container">
      Made by <a class="blue-text text-lighten-3" href="https://github.com/Zarkana">Joseph Campbell</a>
      <a class="blue-text text-lighten-3 right" href="https://github.com/Zarkana">What is, Hello Around The World?</a>
      </div>
    </div>
  </footer>

  <!--  Scripts-->
  <script src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
  <script src="materialize-src/js/materialize.js"></script>
  <script src="materialize-src/js/init.js"></script>
  <script src="scripts/main.js"></script>

  </body>
</html>
