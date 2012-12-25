JX.Stratcom.listen(
	"submit",
	["add"],
	function(e) {
		e.kill();
		var handler = function(payload) {
			JX.DOM.appendContent(JX.$('itemList'), payload.html);
		};
		new JX.Request('/save', handler)
			.addData({body: e.getNode('add').body.value})
			.setExpectCSRFGuard(false)
			.send();
	}
);
