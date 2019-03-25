$(document).ready(function(){
    var location=window.location.hash;
    if (location){
        var parsed=/#(\D*)\d*/.exec(location)[1];
    
        if (parsed=='project'){
            $(location+' > .well > .collapse').attr('class', 'in');
            
            $(location+' > .well > .row .exButton').first().attr('class', 'glyphicon glyphicon-chevron-up exButton');
        }
        else if (parsed=='activity'){
            $(location).parent().parent().attr('class', 'in');
            $(location+' > .well > .collapse').attr('class', 'in');
            
            $(location+' > .well > .row .exButton').first().attr('class', 'glyphicon glyphicon-chevron-up exButton');
            $('.exButton', $(location).parent().parent().parent()).first().attr('class', 'glyphicon glyphicon-chevron-up exButton');
        }
        else if (parsed=='ass'){
            $(location).parent().parent().parent().parent().parent().parent().attr('class', 'in');
            $(location).parent().parent().attr('class', 'in');
            
            $('.exButton', $(location).parent().parent().parent().parent().parent().parent().parent()).first().attr('class', 'glyphicon glyphicon-chevron-up exButton');
            $('.exButton', $(location).parent().parent().parent()).first().attr('class', 'glyphicon glyphicon-chevron-up exButton');
            
        }
    
        $(document).scrollTop( $(location).offset().top ); 
    }
    
    
    
    $('#inputEmail').first().keyup(function(){
        if ($(this).val()==''){
            $('#user_new > div > div > div.modal-body > div.row > div.col-xs-4 > label > input[type="checkbox"]').first().attr('disabled', true);
            $('#user_new > div > div > div.modal-body > div.row > div.col-xs-4 > label').first().attr('class', 'checkbox disabled');
        }
        else{
            $('#user_new > div > div > div.modal-body > div.row > div.col-xs-4 > label > input[type="checkbox"]').first().attr('disabled', false);
            $('#user_new > div > div > div.modal-body > div.row > div.col-xs-4 > label').first().attr('class', 'checkbox');
        }
    });
    
    $('.exButton').parent().click(function(){
      if($('.exButton', $(this)).first().attr('class')=='glyphicon glyphicon-chevron-up exButton'){
        $('.exButton', $(this)).first().attr('class', 'glyphicon glyphicon-chevron-down exButton');
      }
      else{
        $('.exButton', $(this)).first().attr('class', 'glyphicon glyphicon-chevron-up exButton');
      }
    });
    
});
