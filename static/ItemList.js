JX.Stratcom.listen(
	"click",
	["item", "delete"],
	function (e) {
		e.kill();
		console.log(e.getNodeData("item"));
	}
);
