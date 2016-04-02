# jabara-yesod-auth-freeaccount

Yesodの認証プラグラインです。
メールアドレスを利用してユーザー登録を自動化する処理シーケンスを提供します。

元ネタはこちら。  
[yesod-auth-account](https://hackage.haskell.org/package/yesod-auth-account-1.4.1/docs/Yesod-Auth-Account.html)

```models
User
    name Text
    password ByteString
    emailAddress Text
    verified Bool
    verifyKey Text
    resetPasswordKey Text
    UniqueUser name
    deriving Typeable
```

```Foundation.hs
import           Jabara.Yesod.Auth.FreeAccount (YesodAuthFreeAccount(..), AccountSendEmail(..)
                 , AccountPersistDB, runAccountPersistDB
                 , authFreeAccountPlugin
                 , verifyPassword
                 , PersistUserCredentials(..))

instance YesodAuthFreeAccount (AccountPersistDB App User) App where
    runAccountDB = runAccountPersistDB

instance PersistUserCredentials User where
    userUsernameF = UserName
    userPasswordHashF = UserPassword
    userEmailF = UserEmailAddress
    userEmailVerifiedF = UserVerified
    userEmailVerifyKeyF = UserVerifyKey
    userResetPwdKeyF = UserResetPasswordKey
    uniqueUsername = UniqueUser
    userCreate name email key pwd = User name pwd email False key ""

instance AccountSendEmail App where
    -- sendVerifyEmail :: Username
    --                 -> Text -- ^ email address
    --                 -> Text -- ^ verification URL
    --                 -> HandlerT master IO ()
    sendVerifyEmail uname email url = do
        msg <- return $ concat [ "Verification email for "
                              , uname
                              , " (", email, "): "
                              , url
                              ]
        $(logDebug) msg
        result <- liftIO $ sendSimpleMail SimpleMailData {
                    simpleMailDataFrom = address "Admin" "admin@example.com"
                  , simpleMailDataTo = address uname email
                  , simpleMailDataSubject = "Verify emai address."
                  , simpleMailDataBody = "Please accept this URL for email verification.\n" ++ url
                  }
        case result of
            Left err -> $(logDebug) (pack err)
            Right _  -> return ()

    -- sendNewPasswordEmail :: Username
    --                      -> Text -- ^ email address
    --                      -> Text -- ^ new password URL
    --                      -> HandlerT master IO ()
    sendNewPasswordEmail uname email url = do
        msg <- return $ concat [ "Reset password email for "
                              , uname
                              , " (", email, "): "
                              , url
                              ]
        $(logDebug) msg
        result <- liftIO $ sendSimpleMail SimpleMailData {
                    simpleMailDataFrom = address "Admin" "admin@example.com"
                  , simpleMailDataTo = address uname email
                  , simpleMailDataSubject = "New password page"
                  , simpleMailDataBody = "Please accept this URL for new password.\n" ++ url
                  }
        case result of
            Left err -> $(logDebug) (pack err)
            Right _  -> return ()
```

```Foundation.hs
    authPlugins _ = [authFreeAccountPlugin]
```
