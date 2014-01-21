<!DOCTYPE html>
<html>
  <head>
    <title>CEDAR Harmonize</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="/img/favicon.ico">
    <!-- Bootstrap -->
    <link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <!-- Bootstrap core CSS -->
    <link href="/css/bootstrap.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="/css/starter-template.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="../../assets/js/html5shiv.js"></script>
      <script src="../../assets/js/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="/harmonize">CEDAR Harmonize</a>
        </div>
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="/harmonize">Home</a></li>
            <li><a href="https://github.com/CEDAR-project/Harmonize" target="_blank">GitHub</a></li>
            <li><a href="mailto:cedar@cedar-project.nl">Contact</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>

    <div class="container">

      <div class="starter-template">

	<img align="center" src="/img/cedar_150x150.jpg">
	<h1>CEDAR Harmonize</h1>
	<p>CEDAR Harmonize is an RDF harmonization layer generator for non-aligned statistical datasets.</p>

	%if state == 'start':
	<a href="/harmonize/vocab">RDF Harmonization vocabulary</a><br>
	<a href="/harmonize/harm">Manage harmonization layer</a>

	%elif state == 'vocab':
	<p>Variables and values currently in the RDF Harmonization vocabulary</p>
	<center>
	<table>
	  <tr><td class="ui-helper-center"><b>Variable</b></td><td class="ui-helper-center"><b>Value</b></td></tr>
	  %for result in results["results"]["bindings"]:
	  %   var = result["var"]["value"]
	  %   value = result["value"]["value"]
	  <tr><td>{{var}}</td><td>{{value}}</td></tr>
	  %end
	</table>
	</center>

	<br>
	<a href="/harmonize">Back</a>

	%elif state == 'manage-ds':
	<p>Select a dataset:</p>
	  %for file in files["results"]["bindings"]:
	  %   ds = file["g"]["value"]
	  <a href="harm?ds={{ds}}">{{ds}}</a><br>
	  %end

	<br>
	<a href="/harmonize">Back</a>

	%elif state == 'manage-variables':
	<p>Listing variable and value mappings for dimensions in dataset {{ds}}</p>

	<table>
	  <tr><td class="ui-helper-center"><b>Dimension</b></td><td class="ui-helper-center"><b>Variable</b></td><td class="ui-helper-center"><b>Value</b></td><td><b>Save</b></td></tr>
	  %for line in dimvarval["results"]["bindings"]:
          <tr>
	    <td>{{line["dim"]["value"] if "dim" in line else ""}}</td>
	    <td>
	      <select id="ddVariable">
		<option value="None">N/A</option>
		%for var in variables["results"]["bindings"]:
		<option {{"selected" if "var" in line and var['var']['value'] == line['var']['value'] else ""}} value="{{var['var']['value']}}">{{var["var"]["value"]}}</option>
		%end
	      </select>
	    </td>
	    <td>
	      <select id="ddValue">
		<option value="None">N/A</option>
		%for val in values["results"]["bindings"]:
		<option {{"selected" if "val" in line and val['val']['value'] == line['val']['value'] else ""}} value="{{val['val']['value']}}">{{val["val"]["value"]}}</option>
		%end
	      </select>
	    </td>
	    <td>
	      <a href="#" onclick="updateParameters();return false;">Save</a>
	    </td>
	  </tr>
	  %end

	</table>


	<br>
	<a href="/harmonize">Back</a>

	%else:

	%end
    
      </div>

    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="//code.jquery.com/jquery.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="/js/bootstrap.min.js"></script>

  </body>
</html>
