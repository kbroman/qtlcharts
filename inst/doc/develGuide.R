## ----named_vec_to_json_hash----------------------------------------------
x <- c(a=1, b=2, c=3)
jsonlite::toJSON(x)
y <- as.list(x)
jsonlite::toJSON(y)
z <- lapply(x, jsonlite::unbox)
jsonlite::toJSON(z)

