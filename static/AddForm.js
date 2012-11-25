$(document).ready(function() {
	$("#addItemForm").submit(function(e) {
		e.preventDefault();
		$.ajax({
			type: this.method,
			url: this.action,
			data: $(this).serialize(),
			success: function (html) { $('#itemList').append(html); }
		});
	});
});
