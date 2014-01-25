% include('header.tpl', title='CEDAR Harmonize')

	%if state == 'manage-ds':
	<p>Select a dataset:</p>
	  %for file in files["results"]["bindings"]:
	  %   ds = file["g"]["value"]
	  <a href="harm?ds={{ds}}">{{ds}}</a><br>
	  %end

	<br>
	<a href="/harmonize">Back</a>

	%elif state == 'manage-variables':
	<p>Listing variable and value mappings for dimensions in dataset {{ds}}</p>

	<table>
	  <tr><td class="ui-helper-center"><b>Dimension</b></td><td class="ui-helper-center"><b>Variable</b></td><td class="ui-helper-center"><b>Value</b></td><td><b>Save</b></td></tr>
	  %for line in dimvarval["results"]["bindings"]:
	  %  dim = line["dim"]["value"] if "dim" in line else ""
          <tr>
	    <td>{{dim}}</td>
	    <td>
	      <select id="ddVariable:{{line['dim']['value']}}" onchange="document.getElementById('formVariable:{{dim}}').value = this.value;">
		<option value="None">N/A</option>
		%for var in variables["results"]["bindings"]:
		<option {{"selected" if "var" in line and var['var']['value'] == line['var']['value'] else ""}} value="{{var['var']['value']}}">{{var["var"]["value"]}}</option>
		%end
	      </select>
	    </td>
	    <td>
	      <select id="ddValue:{{line['dim']['value']}}" onchange="document.getElementById('formValue:{{dim}}').value = this.value;">
		<option value="None">N/A</option>
		%for val in values["results"]["bindings"]:
		<option {{"selected" if "val" in line and val['val']['value'] == line['val']['value'] else ""}} value="{{val['val']['value']}}">{{val["val"]["value"]}}</option>
		%end
	      </select>
	    </td>
	    <td>
	      <form action="/harmonize/update" method="post">
		<input type="hidden" name="dim" value="{{dim}}">
		<input type="hidden" id="formVariable:{{dim}}" name="var" value="">
		<input type="hidden" id="formValue:{{dim}}" name="val" value="">
		<input type="hidden" name="ds" value="{{ds}}">
		<input value="Save" type="submit" />
	      </form>
	    </td>
	  </tr>
	  %end

	</table>


	<br>
	<a href="/harmonize">Back</a>

	%else:

	%end

% include('footer.tpl')