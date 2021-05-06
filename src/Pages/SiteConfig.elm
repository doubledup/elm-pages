module Pages.SiteConfig exposing (SiteConfig)

import ApiHandler
import DataSource exposing (DataSource)
import Head
import Pages.Manifest


type alias SiteConfig route data =
    List route
    ->
        { data : DataSource data
        , canonicalUrl : String
        , manifest : data -> Pages.Manifest.Config
        , apiRoutes : List (ApiHandler.Done ApiHandler.Response)
        , head :
            data
            -> List Head.Tag
        }
