$(document).ready(function() {
  //Instantiates select menu
  $('.materialize-select').material_select();

  var resizing_select = "#language-select .select-wrapper";
  var temp_select = "#width_tmp_select";

  //Call once to initialize size
  resizeSelect(resizing_select, temp_select);

  //Resizes select menu based upon selected option
  $("#language-select select").change(function(){
    resizeSelect(resizing_select, temp_select);
  });

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
});
