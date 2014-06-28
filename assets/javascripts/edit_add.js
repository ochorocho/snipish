$(function(){
	$("#snipContent table a, #sidebar .latest a").on('click', function(e) {
		e.preventDefault();
		var id = $(this).attr('href');
		window.location = LIST_URL + '?item=' + id;
	});

	
	
	$("#myTags").tagit({
		tagSource: function( request, response ) {
            //console.log("1");
            $.ajax({
                url: TAG_URL, 
                data: { term:request.term },
                dataType: "json",
                success: function( data ) {
                    response( $.map( data, function( item ) {
                        return {
                            label: item.label,
                            value: item.label
                        }
                    }));
                }
            });
        },
		singleField: true,
		singleFieldNode: $('#myTags')
	});

	$("#snip_ref").tagit({
		autocomplete: {
			delay: 0,
			minLength: 2,
			source : REF_URL,
	        create: function () {			     
				$(this).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
					return $( "<li>" )
						.append( "<a>" + "<b>#" + item.value + "</b><span class='comitter'>" + item.committer + "</span><div class='comment'>" + item.comment + "</div></a>" )
						.appendTo( ul );
				};
	        }
        },
		beforeTagAdded: function(event, ui) {

        },
		caseSensitive: false,
		requireAutocomplete: true,
        allowSpaces: true,
		singleField: true,
		singleFieldNode: $('#snip_ref')
	});


/*
    $('.ref .tagit-new input').keyup(function(e) {
	    //alert(e.keyCode);
	    if(e.keyCode == 13) {
			alert('Enter key was pressed.');
	    }
	});
*/


});