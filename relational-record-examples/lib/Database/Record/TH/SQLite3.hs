{-# LANGUAGE TemplateHaskell #-}

module Database.Record.TH.SQLite3 (
  defineTable,
  ) where

import GHC.Generics (Generic)
import Database.Relational.HDBC.TH (defineTableFromDB)
import Database.Schema.HDBC.Driver (typeMap)
import Database.Schema.HDBC.SQLite3 (driverSQLite3)
import Database.HDBC.Sqlite3 (connectSqlite3)
import Language.Haskell.TH (Q, Dec)

defineTable :: FilePath -> String -> Q [Dec]
defineTable fileName tableName =
  defineTableFromDB
    (connectSqlite3 fileName)
    (drv { typeMap = [("FLOAT", [t|Double|]), ("INTEGER", [t|Int|])] -- overwrite the default type map with yours
         })
    "main" -- schema name, ignored by SQLite
    tableName
    [''Show, ''Generic]
  where drv = driverSQLite3
