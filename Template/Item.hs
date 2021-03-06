{-# LANGUAGE OverloadedStrings #-}

module Template.Item(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified Model.Item as I
import qualified StaticResource as SR
import qualified Template.LeftRight

render :: I.Item -> SR.StaticResource H.Html
render item = do
	SR.addCss "Item.css"
	lr <- Template.LeftRight.render
		[H.toHtml $ I.body item]
		[renderDeleteLink item]
	SR.addMeta (show $ I.getItemID $ I.itemID item) $ SR.addSigil "item" $
		H.li ! A.class_ "item" $ lr

renderDeleteLink :: I.Item -> H.Html
renderDeleteLink (I.Item { I.status = I.Deleted }) = H.i "Deleted"
renderDeleteLink _ = SR.addSigil "delete" $ H.a ! A.href "/delete" $ "Delete"
