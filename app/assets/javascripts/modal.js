$('#modal_new_entry').on('show',function(){
	$('#modal_new_entry').on('click',function(e){
		$('#modal_new_entry').modal('hide');
	});
});

$('#modal_new_entry').on('hide',function(){
	$('#modal_new_entry').off('click');
});

$('#modal_new_entry').on('hidden',function(){
	$('#modal_new_entry').remove();
});

$('#modal_new_entry').modal({
	"backdrop" : "static"
	"keyboard" : true,
	"show"	: true
});