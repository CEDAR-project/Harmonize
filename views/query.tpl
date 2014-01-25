% include('header.tpl', title='CEDAR Harmonize')

<p>Standard variable to query</p>

<form method="post" action="/harmonize/query">
<select name="ddVariable">
  %for variable in variables["results"]["bindings"]:
    <option value="{{variable['var']['value']}}">{{variable['var']['value']}}</option>
  %end
</select>
<select name="ddValue">
  %for value in values["results"]["bindings"]:
    <option value="{{value['val']['value']}}">{{value['val']['value']}}</option>
  %end
</select>
<br><br>
<div>
  <input type="submit" value="Harmonized Search">
</div>
</form>

%if state == 'results':
<br>
<center>
<table>
  <tr><td class="ui-helper-center"><b>Dataset</b></td><td class="ui-helper-center"><b>Cell</b></td><td class="ui-helper-center"><b>Variable</b></td><td><b>Population</b></td></tr>
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
