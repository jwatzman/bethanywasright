{-# LANGUAGE OverloadedStrings #-}

module Template.Item(render) where

import Text.Blaze ((!))
import qualified Text.Blaze as B
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified Model.Item as I
import qualified StaticResource as SR
import qualified Template.HorizList

render :: I.Item -> SR.StaticResource H.Html
render item = do
	hl <- Template.HorizList.render
		[
			H.toHtml $ I.body item,
			H.a ! A.href "/delete" ! A.class_ "deleteLink" ! dataitemID item $
				"Delete"
		]
	return $ H.li ! A.class_ "item" $ hl

dataitemID :: I.Item -> B.Attribute
dataitemID item = B.dataAttribute "itemid" $
	H.toValue $ show $ I.getItemID $ I.itemID item
