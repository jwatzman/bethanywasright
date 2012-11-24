{-# LANGUAGE OverloadedStrings #-}

module Template.ItemList(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified Model.Item as I
import qualified StaticResource as SR
import qualified Template.HorizList

render :: [I.Item] -> SR.StaticResource H.Html
render items = do
	SR.addJs "ItemList.js"
	SR.addCss "ItemList.css"
	renderedItems <- mapM renderItem items
	return $ H.ul $ sequence_ renderedItems

renderItem :: I.Item -> SR.StaticResource H.Html
renderItem item = do
	hl <- Template.HorizList.render
		[
			H.toHtml $ I.body item,
			H.a ! A.href "/stuff" ! A.class_ "deleteLink" $ "Delete"
		]
	return $ H.li ! A.class_ "item" ! A.id (itemID item) $ hl

itemID :: I.Item -> H.AttributeValue
itemID item = H.toValue $ "i_" ++ (show $ I.getItemID $ I.itemID item)
