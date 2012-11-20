{-# LANGUAGE DeriveDataTypeable, GeneralizedNewtypeDeriving, RecordWildCards,
    TemplateHaskell, TypeFamilies, OverloadedStrings #-}

module Model.ItemList(
	ItemList(..),
	initialItemList,
	NewItem(..),
	ItemById(..),
	AllItems(..)
) where

import Control.Monad.Reader (ask)
import Control.Monad.State (get, put)
import qualified Data.Acid as A
import Data.Data (Data, Typeable)
import qualified Data.IxSet as IxS
import qualified Data.SafeCopy as SC
import Data.Text (Text)

import qualified Model.Item as I

data ItemList = ItemList
	{
		nextItemID :: I.ItemID,
		items :: IxS.IxSet I.Item
	}
	deriving (Typeable)
$(SC.deriveSafeCopy 0 'SC.base ''ItemList)

-- TODO remove OverloadedStrings when removing this
temporaryTestItem :: I.Item
temporaryTestItem = I.Item
	{
		itemID = I.ItemID 42,
		status = I.Visible,
		body = "hi <blink>test</blink>"
	}

initialItemList :: ItemList
initialItemList = ItemList
	{
		nextItemID = I.ItemID ((2 ^ 33) + 1),
		items = IxS.insert temporaryTestItem IxS.empty
	}

newItem :: Text -> A.Update ItemList I.Item
newItem body = do
	il@ItemList{..} <- get
	let item = I.Item
		{
			itemID = nextItemID,
			status = I.Visible,
			body = body
		}
	put $ ItemList
		{
			nextItemID = succ nextItemID,
			items = IxS.insert item items
		}
	return item

itemById :: I.ItemID -> A.Query ItemList (Maybe I.Item)
itemById id = do
	ItemList{..} <- ask
	return $ IxS.getOne $ IxS.getEQ id items

allItems :: A.Query ItemList [I.Item]
allItems = do
	ItemList{..} <- ask
	let visibleItems = IxS.getEQ I.Visible items
	return $ IxS.toAscList (IxS.Proxy :: IxS.Proxy I.ItemID) visibleItems

$(A.makeAcidic ''ItemList ['newItem, 'itemById, 'allItems])
