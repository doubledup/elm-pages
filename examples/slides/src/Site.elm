module Site exposing (config)

import Cloudinary
import Color
import DataSource
import Head
import MimeType
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath as PagePath
import Route exposing (Route)
import SiteConfig exposing (SiteConfig)
import Sitemap


config : SiteConfig Data
config =
    \routes ->
        { data = data
        , canonicalUrl = canonicalUrl
        , manifest = manifest
        , head = head
        , apiRoutes = []
        }


type alias Data =
    { siteName : String
    }


data : DataSource.DataSource Data
data =
    DataSource.map Data
        --(StaticFile.request "site-name.txt" StaticFile.body)
        (DataSource.succeed "site-name")


head : Data -> List Head.Tag
head static =
    [ Head.icon [ ( 32, 32 ) ] MimeType.Png (cloudinaryIcon MimeType.Png 32)
    , Head.icon [ ( 16, 16 ) ] MimeType.Png (cloudinaryIcon MimeType.Png 16)
    , Head.appleTouchIcon (Just 180) (cloudinaryIcon MimeType.Png 180)
    , Head.appleTouchIcon (Just 192) (cloudinaryIcon MimeType.Png 192)
    , Head.sitemapLink "/sitemap.xml"
    ]


canonicalUrl : String
canonicalUrl =
    "https://elm-pages.com"


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = static.siteName
        , description = "elm-pages - " ++ tagline
        , startUrl = PagePath.build []
        , icons =
            [ icon webp 192
            , icon webp 512
            , icon MimeType.Png 192
            , icon MimeType.Png 512
            ]
        }
        |> Manifest.withShortName "elm-pages"


tagline : String
tagline =
    "A statically typed site generator"


webp : MimeType.MimeImage
webp =
    MimeType.OtherImage "webp"


icon :
    MimeType.MimeImage
    -> Int
    -> Manifest.Icon
icon format width =
    { src = cloudinaryIcon format width
    , sizes = [ ( width, width ) ]
    , mimeType = format |> Just
    , purposes = [ Manifest.IconPurposeAny, Manifest.IconPurposeMaskable ]
    }


cloudinaryIcon :
    MimeType.MimeImage
    -> Int
    -> ImagePath
cloudinaryIcon mimeType width =
    Cloudinary.urlSquare "v1603234028/elm-pages/elm-pages-icon" (Just mimeType) width


siteMap :
    List (Maybe Route)
    -> { path : List String, content : String }
siteMap allRoutes =
    allRoutes
        |> List.filterMap identity
        |> List.map
            (\route ->
                { path = Route.routeToPath (Just route) |> String.join "/"
                , lastMod = Nothing
                }
            )
        |> Sitemap.build { siteUrl = "https://elm-pages.com" }
        |> (\sitemapXmlString -> { path = [ "sitemap.xml" ], content = sitemapXmlString })
