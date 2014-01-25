      </div>

    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="//code.jquery.com/jquery.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="/js/bootstrap.min.js"></script>
    <script type="text/javascript">
      function updateRow(r) {
        console.log(r);
        var variable = document.getElementById("ddVariable:" + r);
        var variableUser = variable.options[variable.selectedIndex].value;
        var value = document.getElementById("ddValue:" + r);
        var valueUser = value.options[value.selectedIndex].value;
        var updateURL = "/harmonize/update?dim=" + r + "&var=" + variableUser + "&val=" + valueUser + "";

        console.log(updateURL);
 
        window.location.href = updateURL;
      }

      function getDimVariable(d) {
        var e = document.getElementById("ddVariable:" + d);
        return e.options[e.selectedIndex].value;
      }

      function getDimValue(d) {
        var e = document.getElementById("ddValue:" + d);
        return e.options[e.selectedIndex].value;
      }
    </script>

  </body>
</html>
