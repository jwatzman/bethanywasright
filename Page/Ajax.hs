module Page.Ajax(render) where

import qualified Control.Monad.Trans.Error as E
import qualified Happstack.Server as S

import qualified Page.Util
import qualified Template.Ajax

render :: (a -> Page.Util.Response) -> a -> S.ServerPart S.Response
render f x = do
	-- TODO init stuff goes here, e.g., extracting javelin meta block
	r <- E.runErrorT $ f x
	S.ok $ S.toResponse $ case r of
		Right response -> Template.Ajax.render response
		Left errorStr -> Template.Ajax.renderError errorStr
