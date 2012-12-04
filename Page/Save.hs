module Page.Save(render) where

import qualified Data.Acid as A
import qualified Data.Acid.Advanced as AA

import qualified Model.ItemList as IL
import qualified Template.Item
import qualified Page.Util

render :: A.AcidState IL.ItemList -> Page.Util.Response
render acid = do
	body <- Page.Util.queryParamWithError "body"
	item <- AA.update' acid (IL.NewItem body)
	return $ Template.Item.render item
