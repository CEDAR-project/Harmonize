% include('header.tpl', title='CEDAR Harmonize')

<h2>Harmonization vocabulary</h2>

<h3>Details for dimension {{dim}}</h3>

<p></p>

<center>
<table class="table table-hover tablee-condensed">
  <tr><td class="ui-helper-center"><b>Concept</b></td><td class="ui-helper-center"><b>Range</b></td><td class="ui-helper-center"><b>Code List</b></td><td class="ui-helper-center"><b>Code</b></td></tr>
  %for detail in details["results"]["bindings"]:
  %   concept = detail["concept"]["value"]
  %   range = detail["range"]["value"]
  %   codelist = detail["codelist"]["value"] if "codelist" in detail else ""
  %   code = detail["code"]["value"] if "code" in detail else ""
  <tr>
    <td>
      {{concept}}
    </td>
    <td>
      {{range}}
    </td>
    <td>
      {{codelist}}
    </td>
    <td>
      {{code}}
    </td>
  </tr>
  %end
</table>
</center>
<br>
<a href="/harmonize/vocab">Back</a>


% include('footer.tpl')
