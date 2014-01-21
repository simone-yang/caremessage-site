$(function () {
  $("form#form1.wufoo").submit(function() {
      var url = "https://caremessageform.wufoo.com/forms/zde0sea12i09ox/#public";
      $.ajax({
            statusCode: {
                302: function(jqXHR) {
                    $("#message_sent").show();
                }
              },
             type: "POST",
             url: url,
             data: $("form#form1.wufoo").serialize(),
             success: function(data)
             {
                 $("#message_sent").show();
             }
           });
      return false;
  });
});