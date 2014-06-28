function back() {
	window.location = sessionStorage.returnUrl;
}

function loadDetail(id) {
	var params = 'item=' + id;
	//localStorage.returnUrl = window.location;
	sessionStorage.setItem("returnUrl", window.location);
	$('.contextual').find('.icon-cancel').delay(400).remove();
	
	$.ajax({
		dataType: "text",
		url: DETAIL_REQUEST,
		data: params,
		type: 'POST',
		success: function(data) {
			// BUILD JS OBJECT FOR DETAIL PAGE
			var obj = jQuery.parseJSON(data);
			var html = '<div id="detail">' 
				+ '<div class="type">'
					+ '<div class="codetype"><div class="' + obj.codetype + '">' + obj.codetype + '</div></div>'
					+ '<div class="codetype">' + obj.codetype + '</div>'
					+ '<div class="author">' + obj.author + '</div>'
				+ '</div>'
				+ '<h2 class="name"><a href="?item=' + obj.id +'">' + obj.name + '</a><a href="' + EDIT_URL + '?item=' + obj.id +'" id="edit"></a></h2>'
				+ '<div class="description">' + obj.description + '</div>'
				+ '<div class="tag">' + obj.tag + '</div>'
				+ '<div class="clear"></div>'
				+ '<h3>Code</h3>'
				+ '<div class="codeBlock"><pre class="brush: ' + obj.codetype + ';">' + obj.code + '</pre></div>';
		
			$('.contextual').prepend('<a class="icon icon-cancel" href="#">Zurück</a>');				

			
			$('#snipContent').html(html);

			$('.contextual .icon-cancel').on('click', function() {
				back();
			});

			// TAKING CARE OF URL BUILDING
			var title = $('title').text() + ' : ' + obj.name;
			var currentUrl = document.URL.split('?');
			var url = currentUrl[0] + '?item=' + obj.id;			
			window.history.pushState(null, title, url);

			SyntaxHighlighter.highlight();
		},
		error: function(data) {
			alert('Error: Please reload!');
		}
	});
}

$(function() {
	$('#snipContent .pagination a').button();
	$('#snipContent .pagination > span, #snipContent .pagination .current').button({ disabled: true });

	$("#snipContent table a, #sidebar .latest a").on('click', function(e) {
		e.preventDefault();
		var id = $(this).attr('href');
		loadDetail(id);
		$('.contextual').find('.icon-cancel').delay(400).remove();
	});

	$(".codetype div").tooltip({position: { my: "left+15 center", at: "right center" } });
 	$("#snipSearch").autocomplete({
 		source: SEARCH_REQUEST,
 		open: function() { 
	        $('#snipSearch').autocomplete("widget").css('width', $('#snipSearch').outerWidth() - 6)
	    },
 		minLength: 2,
		focus: function( event, ui ) {
			$( "#snipSearch" ).val( ui.item.label );
			return false;
		},
		select: function( event, ui ) {
			$("#snipSearch").val( ui.item.label );
			$("#snipSearch-id").val( ui.item.value );
			$("#snipSearch-description").html( ui.item.desc );
			//alert(ui.item.value);
			loadDetail(ui.item.id);
			
			return false;
		}
 	}).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
		return $( "<li>" )
			.append( "<a>" + "<b>" + item.label + "</b><span class='type'>" + item.type + "</span><br><span class='description'>" + item.desc + "</span></a>" )
			.appendTo( ul );
		};
});