// TODO move this into proper location
JX.Stratcom.mergeData(0, []);

JX.Stratcom.listen(
	"click",
	["item", "delete"],
	function (e) {
		e.kill();
		console.log(e);
	}
);
