module Page.Delete(render) where

import Control.Monad (mzero)
import qualified Data.Acid as A
import qualified Data.Acid.Advanced as AA
import qualified Data.Text.Lazy.Read as R
import qualified Happstack.Lite as S

import qualified Model.Item as I
import qualified Model.ItemList as IL

render :: A.AcidState IL.ItemList -> S.ServerPart S.Response
render acid = do
	idstr <- S.lookText "id"
	id <- case R.decimal idstr of
		Left err -> mzero -- TODO make this return a proper javelin error
		Right (i, _) -> return i
	updateResult <- AA.update' acid $ IL.DeleteItem $ I.ItemID id
	() <- case updateResult of
		Left err -> mzero
		Right () -> return ()
	S.ok $ S.toResponse $ "{}"
