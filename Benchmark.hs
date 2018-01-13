-- https://making.pusher.com/latency-working-set-ghc-gc-pick-two/

module Main (main) where

import qualified System.Environment as Environment
import qualified Control.Exception as Exception
import qualified Control.Monad as Monad
import qualified Data.ByteString as ByteString
import qualified Data.Map.Strict as Map

data Msg = Msg !Int !ByteString.ByteString

type Chan = Map.Map Int ByteString.ByteString

message :: Int -> Msg
message n = Msg n (ByteString.replicate 1024 (fromIntegral n))

pushMsg :: Chan -> Msg -> IO Chan
pushMsg chan (Msg msgId msgContent) =
  Exception.evaluate $
    let
      inserted = Map.insert msgId msgContent chan
    in
      if 200000 < Map.size inserted
      then Map.deleteMin inserted
      else inserted

main :: IO ()
main = do
  args <- Environment.getArgs
  let n = case args of
            [x] -> read x
            [] -> 1000000
  Monad.foldM_ pushMsg Map.empty (map message [1..n])
