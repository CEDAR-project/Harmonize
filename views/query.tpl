% include('header.tpl', title='CEDAR Harmonize')

<p>Standard variable to query</p>

<form role="form" method="post" action="/harmonize/query">
<div class="form-group">
<label for="ddVariable">Variable</label>
<select name="ddVariable" id="ddVariable" class="form-control input-sm">
  %for variable in variables["results"]["bindings"]:
    <option value="{{variable['var']['value']}}">{{variable['var']['value']}}</option>
  %end
</select>
</div>
<div class="form-group">
<label for="ddValue">Value</label>
<select name="ddValue" class="form-control input-sm">
  %for value in values["results"]["bindings"]:
    <option value="{{value['val']['value']}}">{{value['val']['value']}}</option>
  %end
</select>
</div>

<div>
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
