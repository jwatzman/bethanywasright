$(document).ready(function () {
	// TODO wire this up to items ajax'd in
	$(".deleteLink").click(function (e) {
		e.preventDefault();
		$.ajax({
			type: 'POST',
			url: this.href,
			data: {id: this.getAttribute('data-itemid')},
			success: $.proxy(
				function () { $(this).parents('.item').remove(); },
				this
			)
		});
	});
});
