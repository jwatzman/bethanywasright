{-# LANGUAGE OverloadedStrings #-}

module Template.ItemList(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified Model.Item as I
import qualified StaticResource as SR
import qualified Template.Item

render :: [I.Item] -> SR.StaticResource H.Html
render items = do
	SR.addJs "ItemList.js"
	renderedItems <- mapM Template.Item.render items
	return $ H.ul ! A.id "itemList" $ sequence_ renderedItems
