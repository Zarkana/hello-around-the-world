$(document).ready(function() {
  //Instantiates select menu
  $('.materialize-select').material_select();


  //Instantiates modal menu
  // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
  $('.modal').modal({
    opacity: .1
  });

  var resizing_select = "#language-select .select-wrapper";
  var temp_select = "#width_tmp_select";

  //Call once to initialize size
  resizeSelect(resizing_select, temp_select);

  //Resizes select menu based upon selected option
  $("#language-select select").change(function(){
    resizeSelect(resizing_select, temp_select);
  });

  //Resize language select menu size
  function resizeSelect(resizing_select, temp_select)
  {
    //Set the text with the visible selected option
    var selected_option_text = $(resizing_select + ' .active.selected').text();

    //If still not initialized set the text to the disabled option text
    if(selected_option_text == "")
      selected_option_text = $(resizing_select + ' .disabled').text();

    //Set the html of the hidden selects only option to be the stored text from before
    $(temp_select + " #width_tmp_option").html(selected_option_text);

    //store the size of the width of the hidden select
    var new_size = $(temp_select).width() + "px";
    //set the visible select to now use the new width
    $(resizing_select).width(new_size);
  }


  //Detect if attempt to Ctrl + s
  var ctrlDown = false,
      ctrlKey = 17,
      sKey = 83,
      cmdKey = 91,
      vKey = 86,
      cKey = 67;

  $(document).keydown(function(e) {
      if (e.keyCode == ctrlKey || e.keyCode == cmdKey) ctrlDown = true;
  }).keyup(function(e) {
      if (e.keyCode == ctrlKey || e.keyCode == cmdKey) ctrlDown = false;
  });

  $(document).keydown(function(e) {
      if (ctrlDown && e.keyCode == sKey)
      {
        $('#save-modal').modal('open');
        return false;
      }
  });

  $("input[type='file']").change(function(){
    readURL(this);
  });
});

function readURL(input) {
   if (input.files && input.files[0]) {
     var reader = new FileReader();

     reader.onload = function (e) {
       $('#preview_logo, #preview_logo_unloaded').attr('src', e.target.result).show();       
     };

     reader.readAsDataURL(input.files[0]);
   }
 }
