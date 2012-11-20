module Main(main) where

import Control.Exception (bracket)
import Control.Monad (msum)
import qualified Data.Acid as A
import qualified Data.Acid.Local as AL
import qualified Happstack.Lite as S

import qualified Model.ItemList as IL
import qualified Page.Home

dispatch :: A.AcidState IL.ItemList -> S.ServerPart S.Response
dispatch acid =
	msum [
		Page.Home.render acid
	]

main :: IO ()
main = do
	let config = Just $ S.defaultServerConfig {S.port = 4444}
	bracket
		(A.openLocalState IL.initialItemList)
		(AL.createCheckpointAndClose)
		(\acid -> S.serve config $ dispatch acid)
