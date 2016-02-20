{- 下記ソースをまるっと持ってきた.
   https://hackage.haskell.org/package/yesod-auth-account-fork-2.0.3/docs/src/Yesod-Auth-Account-Message.html
-}
{-# LANGUAGE OverloadedStrings #-}
module Yesod.Auth.FreeAccount.Message(
    AccountMsg(..)
  , defaultAccountMsg
  , englishAccountMsg
) where

import qualified Data.Text as T

-- | Messages specific to yesod-auth-account.  We also use messages from "Yesod.Auth.Message".
data AccountMsg = MsgUsername
                | MsgForgotPassword
                | MsgInvalidUsername
                | MsgUsernameExists T.Text
                | MsgResendVerifyEmail
                | MsgResetPwdEmailSent
                | MsgEmailVerified
                | MsgEmailUnverified

-- | Defaults to 'englishAccountMsg'
defaultAccountMsg :: AccountMsg -> T.Text
defaultAccountMsg = englishAccountMsg

englishAccountMsg :: AccountMsg -> T.Text
englishAccountMsg MsgUsername = "Username"
englishAccountMsg MsgForgotPassword = "Forgot password?"
englishAccountMsg MsgInvalidUsername = "Invalid username"
englishAccountMsg (MsgUsernameExists u) =
    T.concat ["The username ", u, " already exists.  Please choose an alternate username."]
englishAccountMsg MsgResendVerifyEmail = "Resend verification email"
englishAccountMsg MsgResetPwdEmailSent = "A password reset email has been sent to your email address."
englishAccountMsg MsgEmailVerified = "Your email has been verified."
englishAccountMsg MsgEmailUnverified = "Your email has not yet been verified."
