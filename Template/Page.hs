{-# LANGUAGE RecordWildCards, OverloadedStrings #-}

module Template.Page(render, prependPath) where

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
			renderDevMode
			renderJs "init.dev.js"
			renderJs "javelin.dev.js"
			renderMeta meta
			mapM_ renderJs js
			renderCss "Page.css"
			mapM_ renderCss css
			-- NB: the order is important here -- resource needs to be last
			-- so it can pick up on all the other files we've loaded
			renderJs "javelin-resource.dev.js"
		H.body $ do
			bodyMarkup

prependPath :: String -> String
prependPath = (++) "/static/"

renderJs :: String -> H.Html
renderJs js = H.script ! (A.type_ "text/javascript") !
	(A.src $ H.toValue $ prependPath js) $ ""

renderCss :: String -> H.Html
renderCss css = H.link ! (A.rel "stylesheet") ! (A.type_ "text/css") !
	(A.href $ H.toValue $ prependPath css)

renderDevMode :: H.Html
renderDevMode = H.script "window['__DEV__'] = 1;"

renderMeta :: [String] -> H.Html
renderMeta meta = H.script $ H.toHtml $ "JX.Stratcom.mergeData(0, " ++ show meta ++ ");"
