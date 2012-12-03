module Page.Ajax(render) where

import Control.Monad.Trans (lift)
import qualified Control.Monad.Trans.Error as E
import qualified Happstack.Server as S
import qualified Text.Blaze.Html5 as H

import qualified StaticResource as SR
import qualified Template.Ajax

render ::
	(a -> E.ErrorT String (S.ServerPartT IO) (SR.StaticResource H.Html)) ->
	a ->
	S.ServerPart S.Response
render f x = do
	-- TODO init stuff goes here, e.g., extracting javelin meta block
	r <- E.runErrorT $ f x
	S.ok $ S.toResponse $ case r of
		Right response -> Template.Ajax.render response
		Left error -> Template.Ajax.renderError error
