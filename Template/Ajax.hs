{-# LANGUAGE DeriveGeneric, RecordWildCards #-}

module Template.Ajax(render, renderError) where

import qualified Data.Aeson as AE
import qualified Data.ByteString.Lazy as BS
import GHC.Generics (Generic)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html.Renderer.Utf8 as R

import qualified StaticResource as SR
import qualified Template.Page

data AjaxResponse = AjaxResponse {
	-- TODO wire this up -- requires telling SR monad what the current block
	-- is though, but required for getting delete buttons to work on ajax
	-- javelin_behaviors :: [String],
	javelin_resources :: [String],
	__html :: BS.ByteString
} deriving (Generic)

data AjaxErrorResponse = AjaxErrorResponse {
	error :: String
} deriving (Generic)

instance AE.ToJSON AjaxResponse
instance AE.ToJSON AjaxErrorResponse

render :: Integer -> SR.StaticResource H.Html -> BS.ByteString
render metablock body =
	let (bodyMarkup, SR.SRResult{..}) = SR.runSR metablock body
	in AE.encode $ AjaxResponse {
		javelin_resources = map Template.Page.prependPath $ css ++ js,
		__html = R.renderHtml bodyMarkup
	}

renderError :: String -> BS.ByteString
renderError err = AE.encode $ AjaxErrorResponse { error = err }
