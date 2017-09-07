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
    ffi "Base" "encode32"



------------------------- Imports ------------------------


type alias Block =
    { index : Int
    , timestamp : Int
    , data : String
    , previousHash : String
    , difficulty : Int
    , nonce : Int
    , hash : String
    }


findValid : String -> String -> Int -> ( Int, String )
findValid start subblock nonce =
    subblock
        ++ toString nonce
        |> hash Sha256
        |> encode
        |> (\a ->
                if String.startsWith start a then
                    Debug.log "Found" ( nonce, a )
                else
                    findValid start subblock <| nonce + 1
           )


getHash : Int -> Int -> String -> String -> Int -> ( Int, String )
getHash index timestamp data previousHash difficulty =
    let
        start =
            String.repeat difficulty "WENDE"
                |> String.left difficulty

        subblock =
            toString index
                ++ toString timestamp
                ++ data
                ++ previousHash
    in
        findValid start subblock 0


block : Int -> Int -> String -> String -> Int -> Block
block index timestamp data previousHash difficulty =
    let
        ( nonce, validHash ) =
            getHash index timestamp data previousHash difficulty
    in
        Block index timestamp data previousHash difficulty nonce validHash


genesis : Int -> Block
genesis now =
    block 0 now "Genesis Block" "0" 1


new : Int -> String -> Int -> List Block -> List Block
new now data difficulty list =
    case list of
        [] ->
            let
                g =
                    genesis now
            in
                block (g.index + 1) now data g.hash difficulty :: [ g ]

        x :: xs ->
            block (x.index + 1) now data x.hash difficulty :: x :: xs
