% include('header.tpl', title='CEDAR Harmonize')

<h2>Administration</h2>

<p>This is the harmonization administration page. From this page you can do the following:

<ul>
<li> The entire current harmonization layer can be deleted (use with caution!)
<li> The current harmonization layer (i.e. the saved mappings in the <a href="/harmonize/harm">harmonization management page</a>) can be saved to a file in your disk
<li> The current harmonization layer can be replaced with the contents of a provided harmonization file 
</ul>

</p>

<br>

<button type="button" class="btn btn-primary btn-md" onclick="makesure('clear')">Clear Harmonization Layer</button>
<button type="button" class="btn btn-primary btn-md" >Download Harmonization</button>
<button type="button" class="btn btn-primary btn-md" >Load Harmonization...</button>

<br>
<br>


<div class="row">
<p></p>
</div>

<a href="/harmonize">Back</a>

% include('footer.tpl')