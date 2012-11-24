{-# LANGUAGE OverloadedStrings #-}

module Template.Home(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified Model.Item as I
import qualified StaticResource as SR
import qualified Template.ItemList

render :: [I.Item] -> SR.StaticResource H.Html
render items = do
	il <- Template.ItemList.render items
	form <- renderAddForm
	return $ H.div $ do
		il
		form

renderAddForm :: SR.StaticResource H.Html
renderAddForm = return $
	H.form $ do
		"New Item:"
		H.input ! A.type_ "text" ! A.name "item"
		H.input ! A.type_ "submit" ! A.value "Add"
