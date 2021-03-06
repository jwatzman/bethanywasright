module Page.Ajax(render) where

import qualified Control.Monad.Trans.Error as E
import qualified Happstack.Server as S

import qualified Page.Util
import qualified Template.Ajax

render :: (a -> Page.Util.Response) -> a -> S.ServerPart S.Response
render f x = do
	-- iOS loves to cache things it shouldn't, unless we EXPLICITLY say not
	-- to: http://stackoverflow.com/a/12516555
	S.addHeaderM "Cache-Control" "no-cache"
	errResult <- E.runErrorT $ do
		Page.Util.queryParamWithError "__ajax__"
		metablockText <- Page.Util.queryParamWithError "__metablock__"
		metablock <- Page.Util.textToDecimalWithError metablockText
		r <- f x
		return $ (metablock, r)
	S.ok $ S.toResponse $ case errResult of
		Right (metablock, response) -> Template.Ajax.render metablock response
		Left errorStr -> Template.Ajax.renderError errorStr
