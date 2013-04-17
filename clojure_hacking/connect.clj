(ns my.service.server
  (:require [monger.core :as mg])
  (:require [monger.collection :as mc])
  (:import [com.mongodb MongoOptions ServerAddress]))
(mg/connect! {:host "54.224.26.29"})
(mg/set-db! (mg/get-db "average_account"))

(mc/find "users" {:followers_count 666})

(with-collection "users"
  (find)  
  (limit 1000)
  (snapshot))