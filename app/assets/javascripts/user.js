$(document).ready(function(){
    //new_task section
    var projects;
    var activities;
    var placeholder1='<option value="" disabled selected>Select the project...</option>';
    var placeholder2='<option value="" disabled selected>Select the activity...</option>';
    function disable_p_and_a(){
        $('#project').prop('disabled', true);
        $('#activity').prop('disabled', true);
        $('#project').html(placeholder1);
        $('#activity').html(placeholder2);
    }
    $('#client').change(function(){
        disable_p_and_a();
        var client_id=$('#client').val(); 
        $.post("ajax/get_projects", {task: {'client_id': client_id}})
            .success(function(data){
                projects=data;
                console.log(projects);
                html=placeholder1;
                for(i=0; i<projects.length; i++){
                    html+='<option value="'+projects[i].project_id+'">'+projects[i].name+'</option>';
                }
                $('#project').html(html);
                $('#project').prop('disabled', false);
        });
    });
    $('#project').change(function(){
        $('#activity').prop('disabled', true);
        $('#activity').html(placeholder2);
        var project_id=$('#project').val(); 
        $.post("ajax/get_activities", {task: {'project_id': project_id}})
            .success(function(data){
                activities=data
                console.log(activities);
                html=placeholder2;
                for(i=0; i<activities.length; i++){
                    html+='<option value="'+activities[i].activity_id+'">'+activities[i].name+'</option>';
                }
                $('#activity').html(html);
                $('#activity').prop('disabled', false);
                
                
        });
    });
    
    //record_time section
    //work timer
    if (typeof elapsed_time !== 'undefined') {
        var current_time=elapsed_time;
    }
    else{
        var current_time=0;
    }
    var end_time=0;
    var time_array=[0, 0, 0];
    var time_print;
    function timer(){
        var timer_var=setInterval(function(){
            if(time_flag==1){
                current_time++;
                time_array[0]=Math.floor(current_time/60/60);
                time_array[1]=Math.floor((current_time/60)-(time_array[0]*60));
                time_array[2]=current_time-(time_array[1]*60)-(time_array[0]*60*60);
                time_array.forEach(function(n, i){
                    if(n.toString().length==1){
                        time_print = "0" + n;
                        time_array[i]=time_print;
                    }
                });
                $('.task-time-recorded').html(time_array[0]+':'+time_array[1]+':'+time_array[2]);
            }
            else if(time_flag==0){
                clearInterval(timer_var);
            }
        }, 1000);
    }
    
    //execution
    
    
    
    
    $('.timer-ui').hide();
    $('.pause-btn').hide();
    $('.resume-btn').hide();
    
    if (typeof rec !== 'undefined' && rec){
      $('.breadcrumb-activity').html('<b>'+$('#client option:selected').text()+'</b>'+' > '+'<b>'+$('#project option:selected').text()+'</b>'+' > '+'<b>'+$('#activity option:selected').text()+'</b>');
      $('.input-form-task').hide();
      $('.timer-ui').show();
      $('.play-btn').hide();
      
      $('.temp-back').hide();
      if(tmr_sts==1){
        $('.pause-btn').show();
        $('.task-time-recorded').css('color', 'green');
        time_flag=1
        timer();
      }
      if(tmr_sts==2){
        $('.resume-btn').show();
        $('.task-time-recorded').css('color', 'orange');
        time_flag=0;
        current_time++;
        time_array[0]=Math.floor(current_time/60/60);
        time_array[1]=Math.floor((current_time/60)-(time_array[0]*60));
        time_array[2]=current_time-(time_array[1]*60)-(time_array[0]*60*60);
        time_array.forEach(function(n, i){
            if(n.toString().length==1){
                time_print = "0" + n;
                time_array[i]=time_print;
            }
        });
        $('.task-time-recorded').html(time_array[0]+':'+time_array[1]+':'+time_array[2]);
      }   
    }
    
    $('#activity').change(function(){
        $('.btn-start').attr('disabled', false);
        $('.breadcrumb-activity').html('<b>'+$('#client option:selected').text()+'</b>'+' > '+'<b>'+$('#project option:selected').text()+'</b>'+' > '+'<b>'+$('#activity option:selected').text()+'</b>');
    });
    $('.btn-start').click(function(){
        $('.input-form-task').slideUp('slow');
        $('.timer-ui').slideDown('slow');
        $('#body-id > div:nth-child(6) > div > div.alert.alert-success.alert-dismissible.fade.in').hide();
    });
    $('.play-btn').click(function(){
        $('.temp-back').hide();
        $.post('ajax/timer_start', {timer: {timer_activity: $('#activity').val()}})
        .success(function(data){
            console.log(data);
            $('.task-time-recorded').css('color', 'green');
            current_time=data.timer_elapsed_time;
            time_flag=1;
            timer();
            $('.play-btn').hide();
            $('.pause-btn').show();
            
        }).fail(function(){location.reload();});
    });
    $('.pause-btn').click(function(){
        $.post('ajax/timer_pause', {timer: {timer_activity: $('#activity').val()}})
        .success(function(data){
            console.log(data);
            current_time=data.timer_elapsed_time;
            time_flag=0;
            $('.task-time-recorded').css('color', 'orange');
            $('.pause-btn').hide();
            $('.resume-btn').show();
        }).fail(function(){location.reload();});
    })
    $('.stop-btn').click(function(){
        if(time_flag==0 && rec==false){
            
        }
        else{
            $.post('ajax/timer_stop', {timer: {timer_activity: $('#activity').val()}})
            .success(function(data){
                console.log(data);
                current_time=data.timer_elapsed_time;
                time_flag=0;
                $('.task-time-recorded').css('color', 'orange');
                $('.pause-btn').hide();
                $('.resume-btn').show();
                if (!$('.report-modal-form').html().includes('<input type="hidden" name="task[is_recorded]" value="true">')){
                    $('.report-modal-form').append(
                    '\
                        <input type="hidden" name="task[is_recorded]" value="true">\
                        <input type="hidden" name="task[client_id]" value="'+$('#client').val()+'">\
                        <input type="hidden" name="task[project_id]" value="'+$('#project').val()+'">\
                        <input type="hidden" name="task[activity_id]" value="'+$('#activity').val()+'">\
                        <input type="hidden" name="task[hours]" value="'+Math.ceil(((current_time/60/60)*4))/4+'">\
                        <h5> You are submiting a task for <b>'+$('#client option:selected').text()+'</b>'+' > '+'<b>'+$('#project option:selected').text()+'</b>'+' > '+'<b>'+$('#activity option:selected').text()+'</b>\
                        <br><br> You worked on it for '+time_array[0]+':'+time_array[1]+':'+time_array[2]+'\
                        <br><br><b> actual submition is: '+Math.ceil(((current_time/60/60)*4))/4+' hours </b> (rounded up in 15 min segements)</h5>\
                        <br>\
                        <div class="form-group">\
                          <label for="notes">Notes (optional):</label>\
                          <textarea name="task[notes]" class="form-control" id="notes" style="resize: none; height: 100px;" placeholder="Enter any task specific notes here..." cols="10"></textarea>\
                        </div>\
                    '
                    );
                }
                
                $('#myModal').modal('show');
            }).fail(function(){location.reload();});
        }
    });
    $('.resume-btn').click(function(){
        $.post('ajax/timer_resume', {timer: {timer_activity: $('#activity').val()}})
        .success(function(data){
            console.log(data);
            $('.task-time-recorded').css('color', 'green');
            current_time=data.timer_elapsed_time;
            time_flag=1;
            timer();
            $('.resume-btn').hide();
            $('.pause-btn').show();
        }).fail(function(){location.reload();});
    });
});



