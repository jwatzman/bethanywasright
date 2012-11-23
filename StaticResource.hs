{-# LANGUAGE RecordWildCards #-}

module StaticResource(addCss, addJs, runSR, StaticResource, SRData(..)) where

import Control.Monad.State

data SRData = SRData { css :: [String], js :: [String] }
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

runSR :: StaticResource a -> (a, SRData)
runSR sr = runState (getSR sr) $ SRData { css = [], js = [] }
