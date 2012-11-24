module Template.Ajax(render) where

import qualified Text.Blaze.Html5 as H

import qualified StaticResource as SR

render :: SR.StaticResource H.Html -> H.Html
render body = bodyMarkup
	where (bodyMarkup, _) = SR.runSR body
