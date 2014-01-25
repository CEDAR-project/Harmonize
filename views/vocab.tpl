% include('header.tpl', title='CEDAR Harmonize')

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

% include('footer.tpl')