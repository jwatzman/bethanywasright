module Page.Delete(render) where

import qualified Control.Monad.Trans.Error as E
import qualified Data.Acid as A
import qualified Data.Acid.Advanced as AA
import qualified Data.Text.Read as R
import qualified Text.Blaze.Html5 as H

import qualified Model.Item as I
import qualified Model.ItemList as IL
import qualified Page.Util

render :: A.AcidState IL.ItemList -> Page.Util.Response
render acid = do
	idstr <- Page.Util.queryParamWithError "id"
	itemID <- Page.Util.textToDecimalWithError idstr
	updateResult <- AA.update' acid $ IL.DeleteItem $ I.ItemID itemID
	() <- case updateResult of
		Left err -> E.throwError err
		Right () -> return ()
	return $ return $ H.toHtml ""
