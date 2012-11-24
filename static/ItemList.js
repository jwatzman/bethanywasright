$(document).ready(function () {
	$(".deleteLink").click(function (e) {
		e.preventDefault();
		alert("hi delete");
		console.log(this);
	});
});
