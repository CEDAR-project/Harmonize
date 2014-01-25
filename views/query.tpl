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
<table>
  <tr><td class="ui-helper-center"><b>Dataset</b></td><td class="ui-helper-center"><b>Cell</b></td><td class="ui-helper-center"><b>Variable-Value</b></td><td><b>Population</b></td></tr>
%for result in numbers["results"]["bindings"]:
%  dataset = result["g"]["value"]
%  cell = result["cell"]["value"]
%  value = result["dim"]["value"]
%  population = result["population"]["value"]
  <tr>
    <td>{{dataset}}</td>
    <td>{{cell}}</td>
    <td>{{value}}</td>
    <td>{{population}}</td>
  </tr>
%end
</table>
%end

% include('footer.tpl')