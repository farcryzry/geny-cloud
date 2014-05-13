

$(function(){
    ratePlans = $('.ratePlan');
    for(var i = 0; i < ratePlans.length; i++){
        ratePlan = ratePlans[i];
        if($(ratePlan).text() == "0"){
            $(ratePlan).html("<span class='badge alert-success'>On Demond</span>");
        }
        if($(ratePlan).text() == "1"){
            $(ratePlan).html("<span class='badge alert-success'>Flat Rate</span>");
        }
    }
    vmStatuses = $('.vmStatus');
    for(var i = 0; i < vmStatuses.length; i++){
        vmStatus = vmStatuses[i];
        if($(vmStatus).text() == "S"){
            $(vmStatus).text("Stop");
        }
        if($(vmStatus).text() == "A"){
            $(vmStatus).text("Active");
        }
    }

    $('#launchInstance').click(function(){
        $('#instancesTable').hide();
        $('#chooseImage').show();
    });

    $('#onDemond').click(function(e){
        e.preventDefault();
        $('#plan').val('0');

        $('#wellOnDemand').addClass('plan');
        $('#wellFlatRate').removeClass('plan');
    });

    $('#flatRate').click(function(e){
        e.preventDefault();
        $('#plan').val('1');

        $('#wellFlatRate').addClass('plan');
        $('#wellOnDemand').removeClass('plan');
    });
    $('.select').click(function(){
         $('#vmName').val($(this).attr('vmName'));
    });

    $('#launch').click(function(e){
        if($('#plan').val() == "" || $('#plan').val() == null){
            alert("Please Choose a plan");
            e.preventDefault();
        }

        $('#lauchInstanceForm').submit(function(e){
               e.preventDefault();
               $('.close').click();
               $('#instancesTable').show();
               $('#chooseImage').hide();
               blockScreen("Lauching, please wait...")
               form = $(this).serialize();
               $.ajax({
                   url:'/1/instances/launch',
                   type:'POST',
                   data:form,
                   timeout: 50000,
                   success:function(data){
                       $('#plan').val("");
                       console.log(data);
                       window.location.replace("/1/instances");
                   },
                   error:function(){
                      unBlock();
                      console.log("error");
                      alert("Network problem, please manully refresh page to syn data, thank you!");
                   }
               });
            });


    });

    $('#checkAll').click(function(){
         if($(this).prop('checked')){
             $('.checkbox').prop("checked", true);
             $('.vmOperation').removeClass("disabled");
         }else{
             $('.checkbox').prop("checked", false);
             $('.vmOperation').addClass("disabled");
         }
    });
    $('.checkbox').click(function(){
        noChecked = true;
        if(!$(this).prop('checked')){
            $('#checkAll').prop('checked', false);
            checkboxes = $('.checkbox');
            len = $('.checkbox').length;
            for(var i = 0; i <  len; i++){
                if($(checkboxes[i]).prop('checked')) {
                    noChecked = false;
                }
            }
            if(noChecked){
                $('.vmOperation').addClass("disabled");
                
            }
        }else{
            $('.vmOperation').removeClass("disabled");
        }
    });

    $('#powerOff').click(function(){
        idArray = setVmId();
        blockScreen("Powering off...");
        $.ajax({
           url:"/1/instances/"+idArray[0]+"/poweroff",
           type:'GET',
           timeout: 5000,
           success:function(data){
               console.log(data);
               $('input:checked').parent().siblings('.vmStatus').text("Stop")
               unBlock();
           },
           error:function(){
              unBlock();
              console.log("power-off error");
              alert("Network problem, please manully refresh page to syn data, thank you!");
           }
        });
    });

    $('#powerOn').click(function(){
        idArray = setVmId();
        blockScreen("Powering on...");
        $.ajax({
           url:"/1/instances/"+idArray[0]+"/poweron",
           type:'GET',
           timeout: 50000,
           success:function(data){
               console.log(data);
               $('input:checked').parent().siblings('.vmStatus').text("Active")
               unBlock();
           },
           error:function(){
              unBlock();
              console.log("power-on error");
              alert("Network problem, please manully refresh page to syn data, thank you!");
           }
        });
    });

    $('#terminate').click(function(){
        idArray = setVmId();
        blockScreen("Terminating...");
        $.ajax({
           url:"/1/instances/"+idArray[0]+"/terminate",
           type:'GET',
           timeout: 50000,
           success:function(data){
               console.log(data);
               $('input:checked').parent().parent().remove();
               unBlock();
           },
           error:function(){
              unBlock();
              console.log("terminate error");
              alert("Network problem, please manully refresh page to syn data, thank you!");
           }
        });
    });
});

function blockScreen(text){
  $.blockUI({ message: '<span style="font-size:27px;font-family: Arial " ><img style="padding-bottom:5px " src="../static/img/busy.gif" /> '+text+'</span>' });
}

function unBlock(){
    $.unblockUI();
}

function setVmId(){
    var vmId = new Array();
    checkboxes = $('.checkbox');
    len = $('.checkbox').length;
    for(var i = 0; i <  len; i++){
        if($(checkboxes[i]).prop('checked')) {
           vmId.push($(checkboxes[i]).attr('vmId'));
        }
    }
    return vmId;
}