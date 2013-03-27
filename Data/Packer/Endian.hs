-- |
-- Module      : Data.Packer.Endian
-- License     : BSD-style
-- Maintainer  : Vincent Hanquez <vincent@snarc.org>
-- Stability   : experimental
-- Portability : unknown
--
-- Simple module to handle endianness swapping,
-- but GHC should provide (some day) primitives to call
-- into a cpu optimised version (e.g. bswap for x86)
--
{-# LANGUAGE CPP #-}
module Data.Packer.Endian
    ( le16Host
    , le32Host
    , le64Host
    , be16Host
    , be32Host
    , be64Host
    ) where

import Data.Bits
import Data.Word

#if BITS_IS_OLD
shr :: Bits a => a -> Int -> a
shr = shiftR
shl :: Bits a => a -> Int -> a
shl = shiftL
#else
shr :: Bits a => a -> Int -> a
shr = unsafeShiftR
shl :: Bits a => a -> Int -> a
shl = unsafeShiftL
#endif

-- | swap endianness on a Word64
-- 56 48 40 32 24 16  8  0
--  a  b  c  d  e  f  g  h 
--  h  g  f  e  d  c  b  a
swap64 :: Word64 -> Word64
swap64 w =
        (w `shr` 56)                  .|. (w `shl` 56)
    .|. ((w `shr` 40) .&. 0xff00)     .|. ((w .&. 0xff00) `shl` 40)
    .|. ((w `shr` 24) .&. 0xff0000)   .|. ((w .&. 0xff0000) `shl` 24)
    .|. ((w `shr` 8)  .&. 0xff000000) .|. ((w .&. 0xff000000) `shl` 8)
{-
    .|. ((w `shr` 48) .&. 0xff00)     .|. ((w .&. 0xff00) `shl` 48)
    .|. ((w `shr` 40) .&. 0xff0000)   .|. ((w .&. 0xff0000) `shl` 40)
    .|. ((w `shr` 32) .&. 0xff000000) .|. ((w .&. 0xff000000) `shl` 32)
-}

-- | swap endianness on a Word32
swap32 :: Word32 -> Word32
swap32 w =
        (w `shr` 24)             .|. (w `shl` 24)
    .|. ((w `shr` 8) .&. 0xff00) .|. ((w .&. 0xff00) `shl` 8)

-- | swap endianness on a Word16
swap16 :: Word16 -> Word16
swap16 w = (w `shr` 8) .|. (w `shl` 8)

#ifdef CPU_BIG_ENDIAN
{-# INLINE be16Host #-}
be16Host :: Word16 -> Word16
be16Host = id
{-# INLINE be32Host #-}
be32Host :: Word32 -> Word32
be32Host = id
{-# INLINE be64Host #-}
be64Host :: Word64 -> Word64
be64Host = id
le16Host :: Word16 -> Word16
le16Host w = swap16 w
le32Host :: Word32 -> Word32
le32Host w = swap32 w
le64Host :: Word64 -> Word64
le64Host w = swap64 w
#else
{-# INLINE le16Host #-}
le16Host :: Word16 -> Word16
le16Host = id
{-# INLINE le32Host #-}
le32Host :: Word32 -> Word32
le32Host = id
{-# INLINE le64Host #-}
le64Host :: Word64 -> Word64
le64Host = id
be16Host :: Word16 -> Word16
be16Host w = swap16 w
be32Host :: Word32 -> Word32
be32Host w = swap32 w
be64Host :: Word64 -> Word64
be64Host w = swap64 w
#endif