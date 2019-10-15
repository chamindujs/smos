module Smos.Sync.Client.IntegrationSpec
  ( spec
  ) where

import Test.Hspec
import Test.QuickCheck
import Test.Validity

import qualified Data.Text as T

import System.Environment

import Servant.Client

import Smos.API

import Smos.Server.TestUtils

import Smos.Sync.Client
import Smos.Sync.Client.TestUtils

spec :: Spec
spec =
  serverSpec $
  describe "smos-sync-client" $ do
    it "just works (tm) with manual login" $ \cenv ->
      forAllValid $ \un ->
        forAllValid $ \pw -> do
          let t = test cenv
          t ["register", "--username", usernameString un, "--password", passwordString pw]
          t ["login", "--username", usernameString un, "--password", passwordString pw]
          t ["sync"]
    it "just works (tm) without manual login" $ \cenv ->
      forAllValid $ \un ->
        forAllValid $ \pw -> do
          let t = test cenv
          t ["register", "--username", usernameString un, "--password", passwordString pw]
          t ["sync", "--username", usernameString un, "--password", passwordString pw]

test :: ClientEnv -> [String] -> IO ()
test cenv args =
  let args' = args ++ ["--server-url", showBaseUrl $ baseUrl cenv]
   in withArgs args' smosSyncClient
