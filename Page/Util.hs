module Page.Util(ResponseM, Response, queryParamWithError) where

import Control.Monad.Trans (lift)
import qualified Control.Monad.Trans.Error as E
import qualified Data.Text
import qualified Data.Text.Lazy
import qualified Happstack.Server as S
import qualified Happstack.Server.RqData as RQ
import qualified Text.Blaze.Html5 as H

import qualified StaticResource as SR

type ResponseM t = E.ErrorT String (S.ServerPartT IO) t
type Response = ResponseM (SR.StaticResource H.Html)

queryParamWithError :: String -> ResponseM Data.Text.Text
queryParamWithError param = do
	paramOrError <- lift $ RQ.getDataFn $ S.lookText param
	paramText <- case paramOrError of
		Left err -> E.throwError $ concat err
		Right paramText -> return paramText
	return $ Data.Text.Lazy.toStrict paramText
