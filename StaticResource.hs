{-# LANGUAGE RecordWildCards #-}

module StaticResource(
	SRData(..),
	StaticResource,
	addCss,
	addJs,
	newId,
	runSR
) where

import Control.Monad.State

data SRData = SRData { css :: [String], js :: [String], nextid :: Integer }
newtype StaticResource a = SR { getSR :: State SRData a }

instance Monad StaticResource where
	return = SR . return
	(SR a) >>= bgen = SR $ a >>= (getSR . bgen)

addCss :: String -> StaticResource ()
addCss newCss = do
	sr@SRData{..} <- SR get
	SR $ put $ sr { css = (newCss:css) }

addJs :: String -> StaticResource ()
addJs newJs = do
	sr@SRData{..} <- SR get
	SR $ put $ sr { js = newJs:js }

newId :: StaticResource String
newId = do
	sr@SRData{..} <- SR get
	SR $ put $ sr { nextid = succ nextid }
	return $ concat ["srid_", show nextid]

runSR :: StaticResource a -> (a, SRData)
runSR sr = runState (getSR sr) $ SRData { css = [], js = [], nextid = 1 }
