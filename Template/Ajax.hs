{-# LANGUAGE DeriveGeneric, RecordWildCards #-}

module Template.Ajax(render, renderError) where

import qualified Data.Aeson as AE
import qualified Data.ByteString.Lazy as BS
import GHC.Generics (Generic)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html.Renderer.Utf8 as R

import qualified StaticResource as SR
import qualified Template.Page

data AjaxPayloadHtml = AjaxPayloadHtml {
	__html :: BS.ByteString
} deriving (Generic)
instance AE.ToJSON AjaxPayloadHtml

data AjaxPayload = AjaxPayload {
	html :: AjaxPayloadHtml
} deriving (Generic)
instance AE.ToJSON AjaxPayload

data AjaxResponse = AjaxResponse {
	javelin_metadata :: [String],
	javelin_resources :: [String],
	payload :: AjaxPayload
} deriving (Generic)
instance AE.ToJSON AjaxResponse

data AjaxErrorResponse = AjaxErrorResponse {
	error :: String
} deriving (Generic)
instance AE.ToJSON AjaxErrorResponse

render :: Integer -> SR.StaticResource H.Html -> BS.ByteString
render metablock body =
	let (bodyMarkup, SR.SRResult{..}) = SR.runSR metablock body
	in AE.encode $ AjaxResponse {
		javelin_resources = map Template.Page.prependPath $ css ++ js,
		javelin_metadata = meta,
		payload = AjaxPayload {
			html = AjaxPayloadHtml {
				__html = R.renderHtml bodyMarkup
			}
		}
	}

renderError :: String -> BS.ByteString
renderError err = AE.encode $ AjaxErrorResponse { error = err }
