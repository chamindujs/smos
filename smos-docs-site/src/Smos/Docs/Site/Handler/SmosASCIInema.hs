{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}

module Smos.Docs.Site.Handler.SmosASCIInema
  ( getSmosASCIInemaR,
    getSmosASCIInemaSpecR,
  )
where

import Data.Text (Text)
import Options.Applicative
import Options.Applicative.Help
import Smos.ASCIInema.Commands.Record as ASCIInema
import Smos.ASCIInema.OptParse as ASCIInema
import Smos.Docs.Site.Handler.Import
import YamlParse.Applicative

getSmosASCIInemaR :: Handler Html
getSmosASCIInemaR = do
  DocPage {..} <- lookupPage "smos-asciinema"
  let argsHelpText = getHelpPageOf []
      envHelpText = "No environment variables" :: Text
      confHelpText = "No configuration" :: Text
  defaultLayout $ do
    setTitle "Smos Documentation - smos-asciinema"
    $(widgetFile "args")

getSmosASCIInemaSpecR :: Handler Html
getSmosASCIInemaSpecR = do
  let confHelpText = prettySchemaDoc @ASCIInemaSpec
  defaultLayout $ do
    setTitle "Smos Documentation - smos-asciinema spec"
    $(widgetFile "smos-asciinema/spec")

getHelpPageOf :: [String] -> String
getHelpPageOf args =
  let res = runArgumentsParser $ args ++ ["--help"]
   in case res of
        Failure fr ->
          let (ph, _, cols) = execFailure fr "smos-asciinema"
           in renderHelp cols ph
        _ -> error "Something went wrong while calling the option parser."
