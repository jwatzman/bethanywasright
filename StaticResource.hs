{-# LANGUAGE GeneralizedNewtypeDeriving, OverloadedStrings, RecordWildCards #-}

module StaticResource(
	StaticResource,
	SRResult(..),
	addCss,
	addJs,
	addSigil,
	runSR
) where

import Control.Monad.State
import qualified Data.Set as S
import Text.Blaze ((!))
import qualified Text.Blaze as B
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

data SRData = SRData { cssSet :: S.Set String, jsSet :: S.Set String }
data SRResult = SRResult { css :: [String], js :: [String] }
newtype StaticResource a = SR { getSR :: State SRData a }
	deriving (Monad)

addCss :: String -> StaticResource ()
addCss newCss = do
	sr@SRData{..} <- SR get
	SR $ put $ sr { cssSet = S.insert newCss cssSet }

addJs :: String -> StaticResource ()
addJs newJs = do
	sr@SRData{..} <- SR get
	SR $ put $ sr { jsSet = S.insert newJs jsSet }

addSigil :: String -> H.Html -> H.Html
addSigil sigil h = h ! (B.dataAttribute "sigil" $ H.toValue sigil)

runSR :: StaticResource a -> (a, SRResult)
runSR sr =
	let (r, SRData{..}) =
		runState (getSR sr) $ SRData { cssSet = S.empty, jsSet = S.empty }
	in (r, SRResult { css = S.toList cssSet, js = S.toList jsSet })
