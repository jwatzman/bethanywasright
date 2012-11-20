module Page.Home(render) where

import qualified Data.Acid as A
import qualified Data.Acid.Advanced as AA
import qualified Happstack.Lite as S
import qualified Text.Blaze.Html5 as H

import qualified Model.ItemList as IL
import qualified Template.ItemList
import qualified Template.Page

render :: A.AcidState IL.ItemList -> S.ServerPart S.Response
render acid = do
	items <- AA.query' acid IL.AllItems
	S.ok $ S.toResponse $
		Template.Page.render "Home" $ Template.ItemList.render items
