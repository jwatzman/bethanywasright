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
	return $ sequence_ [ header, il, form, footer ]

header :: H.Html
header = H.h1 ! A.class_ "header" $ "Bethany was Right"

footerContents :: String
footerContents = "&hearts;, jwatzman"

footer :: H.Html
footer = H.div ! A.class_ "footer" $ H.preEscapedToMarkup footerContents

renderAddForm :: SR.StaticResource H.Html
renderAddForm = do
	SR.addJs "AddForm.js"
	return $ SR.addSigil "add" $
		H.form ! A.id "addItemForm" ! A.action "/save" ! A.method "POST" $ do
			"New Item: "
			H.input ! A.type_ "text" ! A.name "body"
			H.input ! A.type_ "submit" ! A.value "Add"
