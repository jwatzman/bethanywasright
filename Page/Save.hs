module Page.Save(render) where

import Control.Monad.Trans (lift)
import qualified Control.Monad.Trans.Error as E
import qualified Data.Acid as A
import qualified Data.Acid.Advanced as AA
import qualified Data.Text.Lazy
import qualified Happstack.Server as S
import qualified Text.Blaze.Html5 as H

import qualified Model.ItemList as IL
import qualified StaticResource as SR
import qualified Template.Ajax
import qualified Template.Item

render :: A.AcidState IL.ItemList ->
	E.ErrorT String (S.ServerPartT IO) (SR.StaticResource H.Html)
render acid = do
	body <- lift $ S.lookText "body" -- TODO fail with error
	item <- AA.update' acid (IL.NewItem $ Data.Text.Lazy.toStrict body)
	return $ Template.Item.render item
