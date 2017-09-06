module Blockchain exposing (..)

import Elchemy exposing (..)


type Encoding
    = Sha256



{- Elchemy doesn't have verify for IOData yet -}
{- flag noverify:+hash -}


hash : Encoding -> String -> String
hash =
    ffi ":crypto" "hash"


encode : String -> String
encode =
    ffi "Base" "encode16"



------------------------- Imports ------------------------


type alias Block =
    { index : Int
    , timestamp : Int
    , data : String
    , previousHash : String
    , hash : String
    }


block : Int -> Int -> String -> String -> Block
block index timestamp data previousHash =
    [ toString index, toString timestamp, data, previousHash ]
        |> List.foldl (++) ""
        |> hash Sha256
        |> encode
        |> Block index timestamp data previousHash


genesis : Int -> Block
genesis now =
    block 0 now "Genesis Block" "0"


new : Int -> String -> List Block -> List Block
new now data list =
    case list of
        [] ->
            let
                g =
                    genesis now
            in
                block (g.index + 1) now data g.hash :: [ g ]

        x :: xs ->
            block (x.index + 1) now data x.hash :: x :: xs
