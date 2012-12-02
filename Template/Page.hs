{-# LANGUAGE RecordWildCards, OverloadedStrings #-}

module Template.Page(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified StaticResource as SR

render :: String -> SR.StaticResource H.Html -> H.Html
render title body =
	let (bodyMarkup, SR.SRResult{..}) = SR.runSR body in
	H.docTypeHtml $ do
		H.head $ do
			H.title $ H.toHtml title
			renderJs "init.min.js"
			renderJs "javelin.min.js"
			mapM_ renderJs js
			mapM_ renderCss css
		H.body $ do
			bodyMarkup

prependPath :: String -> String
prependPath = (++) "/static/"

renderJs :: String -> H.Html
renderJs js = H.script ! (A.src $ H.toValue $ prependPath js) $ ""

renderCss :: String -> H.Html
renderCss css = H.link ! (A.rel "stylesheet") !
	(A.href $ H.toValue $ prependPath css)
