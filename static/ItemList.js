JX.Stratcom.listen(
	"click",
	["item", "delete"],
	function (e) {
		e.kill();
		var handler = function() {
			JX.DOM.remove(e.getNode('item'));
		};
		new JX.Request('/delete', handler)
			.addData({id: e.getNodeData('item')})
			.setExpectCSRFGuard(false)
			.send();
	}
);
