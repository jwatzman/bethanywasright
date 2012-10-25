module Main(main) where

import Control.Monad (msum)
import qualified Happstack.Lite as S

import qualified Page.Home

dispatch :: S.ServerPart S.Response
dispatch =
	msum [
		Page.Home.render
	]

main :: IO ()
main = S.serve (Just $ S.defaultServerConfig {S.port = 4444}) dispatch
