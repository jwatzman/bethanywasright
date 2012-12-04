{-# LANGUAGE GeneralizedNewtypeDeriving, OverloadedStrings, RecordWildCards #-}

module StaticResource(
	StaticResource,
	SRResult(..),
	addCss,
	addJs,
	addMeta,
	addSigil,
	runSR
) where

import Control.Monad.State
import qualified Data.Set as S
import Text.Blaze ((!))
import qualified Text.Blaze as B
import qualified Text.Blaze.Html5 as H

data SRData = SRData {
	cssSet :: S.Set String,
	jsSet :: S.Set String,
	nextMeta :: Int,
	reversedMeta :: [String] -- TODO this should really be some sort of map
}

data SRResult = SRResult { css :: [String], js :: [String], meta :: [String] }
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

addMeta :: String -> H.Html -> StaticResource H.Html
addMeta meta h = do
	sr@SRData{..} <- SR get
	SR $ put $ sr { nextMeta = succ nextMeta, reversedMeta = meta:reversedMeta }
	return $ h ! (B.dataAttribute "meta" $ H.toValue $ "0_" ++ (show nextMeta))

addSigil :: String -> H.Html -> H.Html
addSigil sigil h = h ! (B.dataAttribute "sigil" $ H.toValue sigil)

emptySRData :: SRData
emptySRData = SRData {
	cssSet = S.empty,
	jsSet = S.empty,
	nextMeta = 0,
	reversedMeta = []
}

runSR :: StaticResource a -> (a, SRResult)
runSR sr =
	let
		(r, SRData{..}) = runState (getSR sr) emptySRData
		result = SRResult {
			css = S.toList cssSet,
			js = S.toList jsSet,
			meta = reverse reversedMeta
		}
	in (r, result)
