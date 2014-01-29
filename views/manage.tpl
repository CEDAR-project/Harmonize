% include('header.tpl', title='CEDAR Harmonize')

<h2>Manage harmonization layer</h2>


	%if state == 'manage-ds':
<p>To manage the harmonization mappings of a dataset / table, please select first one in the column at the left.</p>

	<table class="table table-hover table-condensed">
	  <tr><td class="ui-helper-center"><b>Dataset / Table</b></td><td class="ui-helper-center"><b>Description</b></td></tr>
	  %for file in files["results"]["bindings"]:
	  %   ds = file["g"]["value"]
	  %   title = file["ltitle"]["value"]
	  <tr>
	    <td>
	      <a href="harm?ds={{ds}}">{{ds}}</a><br>
	    </td>
	    <td>
	      {{title}}
	    </td>
	  </tr>
	  %end
	</table>

	<br>
	<a href="/harmonize">Back</a>

	%elif state == 'manage-variables':
	<h3>Mappings for dataset {{ds}}</h3>

	<p>To create a new mapping for one of the original dimensions, or modify an existing one, select the desired values in the <i>standard dimension</i> and <i>standard code</i> columns, and click Save. To remove a mapping, select N/A in both columns and cilck Save.</p>

	<table class="table table-hover table-condensed">
	  <tr><td class="ui-helper-center"><b>Original dimension</b></td><td class="ui-helper-center"><b>Standard dimension</b></td><td class="ui-helper-center"><b>Standard code</b></td><td></td></tr>
	  %for line in dimvarval["results"]["bindings"]:
	  %  dim = line["dim"]["value"] if "dim" in line else ""
	  %  ldim = line["ldim"]["value"] if "dim" in line else ""
          <tr>
	    <form role="form" action="/harmonize/update" method="post">
	    <td>{{ldim}}</td>
	    <td>
	      <select name="ddVariable" class="form-control input-sm">
		<option value="None">N/A</option>
		%for var in variables["results"]["bindings"]:
		<option {{"selected" if "var" in line and var['var']['value'] == line['var']['value'] else ""}} value="{{var['var']['value']}}">{{var["var"]["value"]}}</option>
		%end
	      </select>
	    </td>
	    <td>
	      <select name="ddValue" class="form-control input-sm">
		<option value="None">N/A</option>
		%for val in values["results"]["bindings"]:
		<option {{"selected" if "val" in line and val['val']['value'] == line['val']['value'] else ""}} value="{{val['val']['value']}}">{{val["val"]["value"]}}</option>
		%end
	      </select>
	    </td>
	    <td>
		<input type="hidden" name="dim" value="{{dim}}">
		<input type="hidden" name="ds" value="{{ds}}">
		<input value="Save" type="submit" class="btn btn-default" />
	      </form>
	    </td>
	  </tr>
	  %end

	</table>


	<br>
	<a href="/harmonize/harm">Back</a>

	%else:

	%end

% include('footer.tpl')
