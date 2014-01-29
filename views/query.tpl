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
  %if "dimension" in variable:
    <option {{"selected" if prevvar == variable["dimensionu"]["value"] else ""}} value="{{variable['dimensionu']['value']}}">{{variable['dimension']['value']}}</option>
  %end
  %end
</select>
</div>
</div>
<div class="form-group col-md-6">
<label for="ddValue" class="col-md-2 control-label">Code</label>
<div class="col-md-10">
<select name="ddValue" class="form-control input-sm">
  %for value in values["results"]["bindings"]:
  %if "code" in value:
    <option {{"selected" if prevval == value["codeu"]["value"] else ""}} value="{{value['codeu']['value']}}">{{value['code']['value']}}</option>
  %end
  %end
</select>
</div>
</div>
</div>
<div class="row checkbox col-md-12">
  <label for="sum" class="col-md-2 col-md-offset-5 control-label">
    <input id="sum" type="checkbox" name="sum" value="sum" {{"checked" if sumcheck else ""}}>Aggregate results</label>
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
  <tr>
    <td class="ui-helper-center"><b>Dataset / Table</b></td>
    %if not sumcheck:
    <td class="ui-helper-center"><b>Cell</b></td>
    %end
    <td class="ui-helper-center"><b>Variable</b></td>
    <td><b>Population</b></td>
  </tr>
%for result in numbers["results"]["bindings"]:
%  dataset = result["g"]["value"]
%  lcell = result["lcell"]["value"] if not sumcheck else None
%  value = result["ldim"]["value"]
%  population = result["population"]["value"]
  <tr>
    <td>{{dataset}}</td>
    %if not sumcheck:
    <td>{{lcell}}</td>   
    %end
    <td>{{value}}</td>
    <td>{{population}}</td>
  </tr>
%end
</table>
<a href="{{url}}">
<button type="button" class="btn btn-primary btn-lg">Download Table</button>
</a>
</center>
%end

% include('footer.tpl')
