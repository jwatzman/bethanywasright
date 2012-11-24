module Page.Save(render) where

import qualified Data.Acid as A
import qualified Data.Acid.Advanced as AA
import qualified Data.Text.Lazy
import qualified Happstack.Lite as S

import qualified Model.ItemList as IL
import qualified StaticResource as SR
import qualified Template.Ajax
import qualified Template.Item

render :: A.AcidState IL.ItemList -> S.ServerPart S.Response
render acid = do
	body <- S.lookText "body"
	item <- AA.update' acid (IL.NewItem $ Data.Text.Lazy.toStrict body)
	S.ok $ S.toResponse $ Template.Ajax.render $ Template.Item.render item
