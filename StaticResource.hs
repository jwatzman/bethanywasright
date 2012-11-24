{-# LANGUAGE GeneralizedNewtypeDeriving, RecordWildCards #-}

module StaticResource(
	StaticResource,
	SRResult(..),
	addCss,
	addJs,
	runSR
) where

import Control.Monad.State
import qualified Data.Set as S

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

runSR :: StaticResource a -> (a, SRResult)
runSR sr =
	let (r, SRData{..}) =
		runState (getSR sr) $ SRData { cssSet = S.empty, jsSet = S.empty }
	in (r, SRResult { css = S.toList cssSet, js = S.toList jsSet })
