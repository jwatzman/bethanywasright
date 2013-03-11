{-# LANGUAGE OverloadedStrings #-}

module Template.LeftRight(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified StaticResource as SR

render :: [H.Html] -> [H.Html] -> SR.StaticResource H.Html
render lefts rights = do
	SR.addCss "LeftRight.css"
	return $ sequence_
		[
			H.div ! A.class_ "left" $ sequence_ lefts,
			H.div ! A.class_ "right" $ sequence_ rights
		]
