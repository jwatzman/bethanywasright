{-# LANGUAGE DeriveDataTypeable, GeneralizedNewtypeDeriving,
    TemplateHaskell #-}

module Model.Item(ItemID(..), Status(..), Item(..)) where

import Data.Data (Data, Typeable)
import qualified Data.IxSet as IxS
import qualified Data.SafeCopy as SC
import Data.Text (Text)

newtype ItemID = ItemID { getItemID :: Integer }
	deriving (Eq, Ord, Data, Enum, Typeable, SC.SafeCopy)

data Status = Visible | Deleted
	deriving (Eq, Ord, Data, Typeable)
$(SC.deriveSafeCopy 0 'SC.base ''Status)

data Item = Item
	{
		itemID :: ItemID,
		status :: Status,
		body :: Text
	}
	deriving (Eq, Ord, Data, Typeable)
$(SC.deriveSafeCopy 0 'SC.base ''Item)

instance IxS.Indexable Item where
	empty = IxS.ixSet
		[
			IxS.ixFun $ \i -> [itemID i],
			IxS.ixFun $ \i -> [status i]
		]
