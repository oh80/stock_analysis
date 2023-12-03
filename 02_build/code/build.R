#read data

Nintendo_path <- here::here("01_data","data","Nintendo.csv")
Nintendo <- read.csv(Nintendo_path)

Tokyo_denryoku_path <- here::here("01_data","data","Tokyo_denryoku.csv")
Tokyo_denryoku <- read.csv(Tokyo_denryoku_path)

Topix_path <- here::here("01_data","data","Topix.csv")
Topix <- read.csv(Topix_path)


# combine data
data <- Topix |> dplyr::select("日付け", "変化率..","終値") |> 
  dplyr::mutate("Tokyo_denryoku_rate" = Tokyo_denryoku$変化率.. ,
                "Tokyo_denryoku" = Tokyo_denryoku$終値) |> 
  dplyr::mutate("Nintendo_rate" = Nintendo$変化率.. ,
                "Nintendo" = Nintendo$終値)

#col rename
data <- data |> dplyr::rename("date" = "日付け",
                              "Topix_rate" = "変化率..",
                              "Topix" = "終値")

#change to numeric
data <- data |> dplyr::mutate("Topix_rate" = stringr::str_sub(Topix_rate, 1, -2),
                              "Nintendo_rate" = stringr::str_sub(Nintendo_rate, 1, -2),
                              "Tokyo_denryoku_rate" = stringr::str_sub(Tokyo_denryoku_rate, 1, -2)) |> 
  dplyr::mutate("Topix_rate" = as.numeric(Topix_rate),
                "Nintendo_rate" = as.numeric(Nintendo_rate),
                "Tokyo_denryoku_rate" = as.numeric(Tokyo_denryoku_rate))

data <- data |> dplyr::mutate("Topix" = sub(",", "", Topix),
                              "Nintendo" = sub(",", "", Nintendo)) |> 
  dplyr::mutate("Topix" = as.numeric(Topix),
                "Nintendo" = as.numeric(Nintendo),
                "Tokyo_denryoku" = as.numeric(Tokyo_denryoku))

#save
path <- here::here("02_build", "data", "stock.obj")
saveRDS(data, path)
