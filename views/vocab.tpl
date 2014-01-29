% include('header.tpl', title='CEDAR Harmonize')

<h2>Harmonization vocabulary</h2>

<p>The following shows a list of the current contents in the <i>harmonization vocabulary</i>. Such contents consist of dimensions, and their associated concepts, ranges, code lists and codes. These dimensions and codes are the ones available in the <a href="/harmonize/harm">harmonization layer manager</a>.</p>

<p>Dimensions, concepts, ranges, code lists and codes can be added, modified or deleted.</p>

<center>
<table class="table table-hover tablee-condensed">
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