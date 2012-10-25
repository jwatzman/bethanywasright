module Page.Home(render) where

import qualified Happstack.Lite as S
import qualified Text.Blaze.Html5 as H

import qualified Template.Page

render :: S.ServerPart S.Response
render =
	S.ok $ S.toResponse $
		Template.Page.render "Hello" $ return $ H.toHtml "World"
