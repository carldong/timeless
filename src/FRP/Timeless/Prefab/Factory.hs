-- |
-- Module:     FRP.Timeless.Prefab.Factory
-- Copyright:  (c) 2015 Rongcui Dong
-- License:    BSD3
-- Maintainer: Rongcui Dong <karl_1702@188.com>

module FRP.Timeless.Prefab.Factory
    where

import Control.Arrow
import Control.Applicative
import Data.Monoid 
import Control.Monad
import Control.Monad.IO.Class

import FRP.Timeless.Signal



-- | Make a pure stateful wire from given transition function
mkPW :: (Monoid s) => (s -> a -> (b, Signal s m a b)) -> Signal s m a b
mkPW f = mkPure (\ds -> lstrict . first (Just) . (f ds)) 
-- first (Just) has type (a, b) -> (Maybe a, b)

-- | Make a pure stateful wire from given time independant transition function
mkPWN :: (a -> (b, Signal s m a b)) -> Signal s m a b
mkPWN f = mkPureN $ lstrict . first (Just) . f

-- | Make a pure stateless wire from given function
mkPW_ :: (a -> b) -> Signal s m a b
mkPW_ = SArr . fmap

-- | Make a stateful wire from chained state transition function
mkSW_ :: b -> (b -> a -> b) -> Signal s m a b
mkSW_ b0 f = mkPWN $ g b0
    where
      g b0 x = let b1 = f b0 x in
               (b1, mkSW_ b1 f)

-- | Make a signal that inhibits forever
mkEmpty :: Signal s m a b
mkEmpty = SConst Nothing

-- | The Identity Signal
mkId :: Signal s m a a 
mkId = SId

-- | Make a constant Signal
mkConst :: Maybe b -> Signal s m a b
mkConst = SConst 

-- | Make a pure stateful signal from given transition function
mkPure :: (Monoid s) => (s -> a -> (Maybe b, Signal s m a b)) -> Signal s m a b
mkPure f = go mempty
    where
      go t0 = SPure $ \ds mx ->
          let t = t0 <> ds in 
          t `seq` 
            case mx of
              Just x -> lstrict (f t x)
              Nothing -> (Nothing, go t)

-- | Make a pure stateful signal from given time independant transition function
mkPureN :: (a -> (Maybe b, Signal s m a b)) -> Signal s m a b
mkPureN f = go 
    where
      go = SPure $ \_ mx ->
           case mx of
             Just x -> lstrict (f x)
             Nothing -> (Nothing, go)

-- | Make a pure stateless signal from given function
mkPure_ :: (a -> (Maybe b)) -> Signal s m a b
mkPure_ f = go 
    where
      go = SPure $ \_ mx ->
           case mx of
             Just x -> lstrict (f x, go)
                 -- ^ From (m (Maybe b)) to (m (Maybe b, Signal s m a b))
             Nothing -> (Nothing, go)

-- | Make a stateful signal from given (Monadic) transition function
mkGen :: (Monad m, Monoid s) => (s -> a -> m (Maybe b, Signal s m a b)) -> Signal s m a b
mkGen f = go mempty
    where
      go s0 = SGen $ \ds mx ->
          let s = s0 <> ds in 
          s `seq` 
            case mx of
              Just x -> liftM lstrict (f s x)
              Nothing -> return (Nothing, go s)

-- | Make a stateful signal from given (Monadic) time independant transition function
mkGenN :: (Monad m) => (a -> m (Maybe b, Signal s m a b)) -> Signal s m a b
mkGenN f = go 
    where
      go = SGen $ \_ mx ->
           case mx of
             Just x -> liftM lstrict (f x)
             Nothing -> return (Nothing, go)

-- | Make a stateless signal from given function
mkGen_ :: (Monad m) => (a -> m (Maybe b)) -> Signal s m a b
mkGen_ f = go 
    where
      go = SGen $ \_ mx ->
           case mx of
             Just x -> 
                 let mmx' = f x in
                 liftM (lstrict . (, go)) mmx'
                 -- ^ From (m (Maybe b)) to (m (Maybe b, Signal s m a b))
             Nothing ->
                 return (Nothing, go)

-- | Make a stateless signal from Kleisli function
mkKleisli_ :: (Monad m) => (a -> m b) -> Signal s m a b
mkKleisli_ f =  mkGen_ $ \x -> fmap Just (f x)

-- | Make a monadic constant wire
mkConstM :: (Monad m) => m b -> Signal s m a b
mkConstM b = mkKleisli_ $ \_ -> b
