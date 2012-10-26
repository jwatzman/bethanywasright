{-# LANGUAGE DeriveDataTypeable, GeneralizedNewtypeDeriving,
    TemplateHaskell #-}

module Model.ItemList(ItemList(..)) where

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
$(SC.deriveSafeCopy 0 'SC.base ''ItemList)

initialItemList :: ItemList
initialItemList = ItemList
	{
		nextItemID = I.ItemID ((2 ^ 33) + 1),
		items = IxS.empty
	}
