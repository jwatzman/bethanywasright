module Page.Delete(render) where

import Control.Monad.Trans (lift)
import qualified Control.Monad.Trans.Error as E
import qualified Data.Acid as A
import qualified Data.Acid.Advanced as AA
import qualified Data.Text.Lazy.Read as R
import qualified Happstack.Server as S
import qualified Text.Blaze.Html5 as H

import qualified Model.Item as I
import qualified Model.ItemList as IL
import qualified StaticResource as SR

render :: A.AcidState IL.ItemList ->
	E.ErrorT String (S.ServerPartT IO) (SR.StaticResource H.Html)
render acid = do
	idstr <- lift $ S.lookText "id" -- TODO fail with error
	id <- case R.decimal idstr of
		Left err -> E.throwError err
		Right (i, _) -> return i
	updateResult <- AA.update' acid $ IL.DeleteItem $ I.ItemID id
	() <- case updateResult of
		Left err -> E.throwError err
		Right () -> return ()
	return $ return $ H.toHtml ""
