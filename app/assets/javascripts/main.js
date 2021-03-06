$(document).ready(function() {
  //Instantiates select menu
  $('.materialize-select').material_select();

  $('.collapsiblez:not(.lever)').collapsible({
    accordion: true, // A setting that changes the collapsible behavior to expandable instead of the default accordion style
    onOpen: function(el) { }, // Callback for Collapsible open
    onClose: function(el) { } // Callback for Collapsible close
  });

  //Instantiates modal menu
  // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
  $('.modal').modal({
    opacity: .1
  });

  var resizing_select = "#language-select .select-wrapper";
  var temp_select = "#width_tmp_select";

  $(resizing_select + " li:first").addClass("disabled");

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
    // var selected_option_text = $(resizing_select + ' .active.selected').text();
    var selected_option_text = $(".materialize-select.initialized :selected").text();


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

  //initializes the error modal
  $('.error-modal').modal('open');

  //initializes the sync modal
  $('.sync-modal').modal({
      dismissible: true, // Modal can be dismissed by clicking outside of the modal
      opacity: .7, // Opacity of modal background
      inDuration: 300, // Transition in duration
      outDuration: 200, // Transition out duration
      startingTop: '4%', // Starting top style attribute
      endingTop: '10%' // Ending top style attribute
    }
  );

  $(".sync-button .material-icons").click(function(){
    $('.sync-modal').modal('open');
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

  //all input is disabled, until not empty remains disabled

  //Select the first language and make it active
  $(".language").first().addClass("active");

  //when language button is clicked switch active textareas
  $(".language").click(function(){
    var selectedLanguage = $(this).children("img[data-language]").attr("data-language");
    $(".ace_editor").hide();//Hide all editors
    //var activeAceEditor = $(".ace_editor").find("[data-language='" + selectedLanguage + "']");
    var activeAceEditor = $(".ace_editor[data-language='" + selectedLanguage + "']");
    activeAceEditor.show();

    $(".language").removeClass("active");
    $(this).addClass("active");
  });


  required_inputs = ['#quiz_language_id'];
  disable_submit("#new-quiz-submit-btn", required_inputs);
  // disable submit until language_id has been chosen
  $.each(required_inputs, function(index){
    $(required_inputs[index]).change(function(){
      disable_submit("#new-quiz-submit-btn", ['#quiz_language_id']);
    });
  });

  // $(".question-navigation .nav-item").first().addClass("active");
  navigate(0);
  $(".left-nav-arrow, .right-nav-arrow, .nav-item, .next-item, .previous-item").click(function(){
    instantiate_navigation(this);
  });
});

function instantiate_navigation(nav_link){
  var active_index = $(".nav-item.active").data("question");
  if($(nav_link).hasClass("nav-item")){
    navigate($(nav_link).data("question"));
  }else if (($(nav_link).hasClass("next-item") || $(nav_link).hasClass("right-nav-arrow")) && !out_of_bounds(active_index, "right")) {
    navigate(active_index + 1);
  }else if (($(nav_link).hasClass("previous-item") || $(nav_link).hasClass("left-nav-arrow")) && !out_of_bounds(active_index, "left")){
    navigate(active_index - 1);
  }
}

function navigate(index) {
  var first_item_index = $(".question-navigation .nav-item").first().data("question");
  var last_item_index =  $(".question-navigation .nav-item").last().data("question");
  $(".nav-item").removeClass("active");
  $(".nav-item[data-question='" + index + "']").addClass("active");
  $(".question, .answer").hide();
  $("#question-" + index).show();
  $("#answer-" + index).show();
  $(".left-nav-arrow, .right-nav-arrow, .nav-item, .next-item, .previous-item").removeClass("disabled");
  hide_finish();
  if($(".nav-item.active").data("question") == first_item_index){
    $(".left-nav-arrow, .previous-item").addClass("disabled");
  }
  if($(".nav-item.active").data("question") == last_item_index){
    $(".right-nav-arrow, .next-item").addClass("disabled");
    show_finish();
  }
}

function show_finish(){
  $(".next-item").hide();
  $(".finish-button").css('display', 'inline-block');;
}

function hide_finish(){
  $(".finish-button").hide();
  $(".next-item").css('display', 'inline-block');
}

function out_of_bounds(index, direction){
  var first_item_index = $(".question-navigation .nav-item").first().data("question");
  var last_item_index =  $(".question-navigation .nav-item").last().data("question");
  if ((index - 1 < first_item_index) && direction == "left"){
    return true;
  }else if(index + 1 > last_item_index && direction == "right"){
    return true;
  }
  return false;
}

function disable_submit(button, required_inputs){
  $.each(required_inputs, function(index){

    if($(required_inputs[index]).val() ==  "")
      $(button).attr('disabled', true);

    // $(required_inputs[index]).keyup(function(){
      if($(required_inputs[index]).val() !=  "")
        $(button).attr('disabled', false);
      else
        $(button).attr('disabled', true);
    // });
  });
}


//Will add the image preview of selected file to upload
function readURL(input) {
 if (input.files && input.files[0]) {
   var reader = new FileReader();

   reader.onload = function (e) {
     $('#preview_logo, #preview_logo_unloaded').attr('src', e.target.result).show();
   };

   reader.readAsDataURL(input.files[0]);
 }
}

function initializeEditor(aceEditor, index, language){
  determineDisabled(aceEditor, index);

  aceEditor.getSession().on('change', function(e) {
    //update rails form on ace editor change
    $("#editor-" + index).text(aceEditor.getValue());

    determineDisabled(aceEditor, index);
  });

  aceEditor.setTheme("ace/theme/dawn");

  //TODO: Get the language syntax-highlighter
  switch(language.toLowerCase()){
    case "c":
        aceEditor.getSession().setMode("ace/mode/c_cpp");
      break;
    case "c++":
        aceEditor.getSession().setMode("ace/mode/c_cpp");
      break;
    case "java":
        aceEditor.getSession().setMode("ace/mode/c_cpp");
      break;
    case "javascript":
        aceEditor.getSession().setMode("ace/mode/javascript");
      break;
    case "php":
        aceEditor.getSession().setMode("ace/mode/php");
      break;
    case "python":
        aceEditor.getSession().setMode("ace/mode/python");
      break;
    case "ruby":
        aceEditor.getSession().setMode("ace/mode/ruby");
      break;
    default:
      // debugger;
      // aceEditor.getSession().setMode("ace/mode/" + language.toLowerCase());
    break;
  }
}


//add and remove disabled class for empty code snippet-back-link
function determineDisabled(aceEditor, index){
  var languageTab = "#language-tab-" + index;
  if(!aceEditor.getValue()){
    $(languageTab).addClass("disabled");
  }else{
    $(languageTab).removeClass("disabled");
  }
}

function imgIndexError(image) {
  $(image).onerror = "";
  var lang_id = $(image).data("langid");
  var abr = $(".logo[data-langid='" + lang_id + "']");
  abr.show();
  $(image).hide();
  abr.removeClass("has-image");
  abr.addClass("no-image");
  // image.src = "/images/noimage.gif";
  return true;
  // #034468
}

function imgError(image) {
  $(image).onerror = "";
  // $(".has-image img").hide();
  var lang_id = $(image).data("langid");
  var abr = $(".language[data-langid='" + lang_id + "']");
  abr.removeClass("has-image");
  abr.addClass("no-image");
  // image.src = "/images/noimage.gif";
  return true;
  // #034468
}
