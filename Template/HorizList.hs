{-# LANGUAGE OverloadedStrings #-}

module Template.HorizList(render) where

import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified StaticResource as SR

render :: [H.Html] -> SR.StaticResource H.Html
render items = do
	SR.addCss "HorizList.css"
	return $ H.ul ! A.class_ "horizList" $ mapM_ H.li items
