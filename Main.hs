module Main(main) where

import Control.Exception (bracket)
import Control.Monad (msum)
import qualified Data.Acid as A
import qualified Data.Acid.Local as AL
import qualified Happstack.Lite as S

import qualified Model.ItemList as IL
import qualified Page.Delete
import qualified Page.Home
import qualified Page.Save

dispatch :: A.AcidState IL.ItemList -> S.ServerPart S.Response
dispatch acid =
	msum [
		S.nullDir >> Page.Home.render acid,
		S.dir "delete" $ do S.method S.POST ; Page.Delete.render acid,
		S.dir "save" $ do S.method S.POST ; Page.Save.render acid,
		S.dir "static" $ S.serveDirectory S.DisableBrowsing [] "./static"
	]

main :: IO ()
main = do
	let config = Just $ S.defaultServerConfig {S.port = 4444}
	bracket
		(A.openLocalState IL.initialItemList)
		(AL.createCheckpointAndClose)
		(\acid -> S.serve config $ dispatch acid)
