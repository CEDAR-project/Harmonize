% include('header.tpl', title='CEDAR Harmonize')

<h2>Harmonization vocabulary</h2>

<p>The following shows a list of the current contents in the <i>harmonization vocabulary</i>. Such contents consist of dimensions, and their associated concepts, ranges, code lists and codes. These dimensions and codes are the ones available in the <a href="/harmonize/harm">harmonization layer manager</a>.</p>

<p>Dimensions, concepts, ranges, code lists and codes can be added, modified or deleted. Click on a dimension for further details.</p>

<center>
<table class="table table-hover tablee-condensed">
  <tr><td class="ui-helper-center"><b>Dimension</b></td><td class="ui-helper-center"><b>Description</b></td></tr>
  %for result in results["results"]["bindings"]:
  %   dimension = result["dimensionu"]["value"]
  %   label = result["dimension"]["value"]
  %   ncodes = int(result["ncodes"]["value"])
  <tr {{"class=success" if ncodes > 0 else "class=danger"}}>
    <td>
      <form name="edit{{dimension}}" action="/harmonize/vocab/detail" method="post">
	<input type="hidden" name="dim" value="{{dimension}}">
      <a href="javascript:document.forms['edit{{dimension}}'].submit();">{{dimension}}</a>
      </form>
    </td>
    <td>
      {{label}}
    </td>
  </tr>
  %end
</table>
</center>

<div class="row">
<a href="/harmonize/vocab/alldetails">
  <button type="button" class="btn btn-primary btn-md">View All Details</button>
</a>
</div>

<div class="row">
<a href="/harmonize">Back</a>
</div>


% include('footer.tpl')
