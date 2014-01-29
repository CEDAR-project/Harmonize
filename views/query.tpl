% include('header.tpl', title='CEDAR Harmonize')

<h2>Query interface</h2>

<p>To query the harmonized census variables, please select a dimension, and optionally one or more codes to get all the macthing census observations. To aggregate the results, tick the apropriate checkbox.</p>

<form class="form-horizontal" role="form" method="post" action="/harmonize/query">
<div class="row">
<div class="form-group col-md-6">
<label for="ddVariable" class="col-md-2 control-label">Dimension</label>
<div class="col-md-10">
<select name="ddVariable" id="ddVariable" class="form-control input-sm">
  %for variable in variables["results"]["bindings"]:
    <option {{"selected" if prevvar == variable["var"]["value"] else ""}} value="{{variable['var']['value']}}">{{variable['var']['value']}}</option>
  %end
</select>
</div>
</div>
<div class="form-group col-md-6">
<label for="ddValue" class="col-md-2 control-label">Code</label>
<div class="col-md-10">
<select name="ddValue" class="form-control input-sm">
  %for value in values["results"]["bindings"]:
    <option {{"selected" if prevval == value["val"]["value"] else ""}} value="{{value['val']['value']}}">{{value['val']['value']}}</option>
  %end
</select>
</div>
</div>
</div>
<div class="row checkbox col-md-12">
  <label for="sum" class="col-md-2 col-md-offset-5 control-label">
    <input id="sum" type="checkbox" name="sum" value="sum">Aggregate results</label>
</div>
<div class="row form-group">
</div>
<div class="row form-group">
  <input type="submit" value="Harmonized Search" class="btn btn-primary">
</div>
</form>

%if state == 'results':
<br>
<center>
<table class="table table-hover table-condensed">
  <tr><td class="ui-helper-center"><b>Dataset / Table</b></td><td class="ui-helper-center"><b>Cell</b></td><td class="ui-helper-center"><b>Variable</b></td><td><b>Population</b></td></tr>
%for result in numbers["results"]["bindings"]:
%  dataset = result["g"]["value"]
%  lcell = result["lcell"]["value"]
%  value = result["ldim"]["value"]
%  population = result["population"]["value"]
  <tr>
    <td>{{dataset}}</td>
    <td>{{lcell}}</td>
    <td>{{value}}</td>
    <td>{{population.split(".")[0]}}</td>
  </tr>
%end
</table>
</center>
%end

% include('footer.tpl')
