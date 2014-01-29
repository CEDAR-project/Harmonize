% include('header.tpl', title='CEDAR Harmonize')

<h2>Harmonization vocabulary</h2>

<p>The following shows a list of the current contents in the <i>harmonization vocabulary</i>. Such contents consist of dimensions, and their associated concepts, ranges, code lists and codes. These dimensions and codes are the ones available in the <a href="/harmonize/harm">harmonization layer manager</a>.</p>

<p>Dimensions, concepts, ranges, code lists and codes can be added, modified or deleted.</p>

<center>
<table class="table table-hover tablee-condensed">
  <tr><td class="ui-helper-center"><b>Dimension</b></td><td class="ui-helper-center"><b>Concept</b></td><td class="ui-helper-center"><b>Range</b></td><td class="ui-helper-center"><b>Code List</b></td><td class="ui-helper-center"><b>Code</b></td></tr>
  %for result in results["results"]["bindings"]:
  %   dimension = result["dimension"]["value"]
  %   concept = result["concept"]["value"]
  %   range = result["range"]["value"]
  %   codelist = result["codelist"]["value"] if "codelist" in result else ""
  %   code = result["code"]["value"] if "code" in result else ""
  <tr><td>{{dimension}}</td><td>{{concept}}</td><td>{{range}}</td><td>{{codelist}}</td><td>{{code}}</td></tr>
  %end
</table>
</center>
<br>
<a href="/harmonize">Back</a>

% include('footer.tpl')
