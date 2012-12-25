module Page.All(render) where

import qualified Data.Acid as A
import qualified Data.Acid.Advanced as AA
import qualified Happstack.Lite as S

import qualified Model.ItemList as IL
import qualified Template.Home
import qualified Template.Page

render :: A.AcidState IL.ItemList -> S.ServerPart S.Response
render acid = do
	items <- AA.query' acid IL.AllItemsEvenDeleted
	S.ok $ S.toResponse $
		Template.Page.render "All Items" $ Template.Home.render items
