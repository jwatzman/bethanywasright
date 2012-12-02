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
			SR.addSigil "delete" $ H.a ! A.href "/delete" $ "Delete"
		]
	SR.addMeta (show $ I.getItemID $ I.itemID item) $ SR.addSigil "item" $
		H.li ! A.class_ "item" $ hl
