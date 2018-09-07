# Unexported utils from dplyr

# See \code{dplyr} for details.

# importFrom utils getFromNamespace
# NULL

# tbl_vars -- exported!
# common_by -- exported!

# tbl_vars returns character vector of names of columns
# tbl_vars(dplyr::band_members)
# tbl_vars(dplyr::band_instruments)

# common_by returns list with elements `x` and `y` which have the variables in each in char vector
# common_by(x = dplyr::band_members, y = dplyr::band_instruments)
# common_by(by = "name", x = dplyr::band_members, y = dplyr::band_instruments)

# common_by handles the name difference between left and right side
# common_by(by = c("name" = "artist"), x = dplyr::band_members, y = dplyr::band_instruments2)
