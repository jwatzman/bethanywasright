{-# LANGUAGE OverloadedStrings #-}

module Template.ItemList(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified Model.Item as I
import qualified StaticResource as SR

render :: [I.Item] -> SR.StaticResource H.Html
render items = do
	SR.addJs "ItemList.js"
	SR.addCss "ItemList.css"
	return $ H.ul $ mapM_ renderItem items

renderItem :: I.Item -> H.Html
renderItem item = H.li ! A.id (itemID item) $ H.ul ! A.class_ "item" $ do
	H.li $ H.toHtml $ I.body item
	H.li $ H.a ! A.href "/stuff" ! A.class_ "deleteLink" $ "Delete"

itemID :: I.Item -> H.AttributeValue
itemID item = H.toValue $ "i_" ++ (show $ I.getItemID $ I.itemID item)
