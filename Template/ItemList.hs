module Template.ItemList(render) where

import Control.Monad (mapM_)
import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import qualified Model.Item as I
import qualified StaticResource as SR

render :: [I.Item] -> SR.StaticResource H.Html
render items = return $
	H.ul $ mapM_ renderItem items

renderItem :: I.Item -> H.Html
renderItem item = H.li ! A.id (itemID item) $ H.toHtml $ I.body item

itemID :: I.Item -> H.AttributeValue
itemID item = H.toValue $ concat ["i_", show $ I.getItemID $ I.itemID item]
