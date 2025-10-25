
library(stoplight)
library(dplyr)

# The function try() is added to let the package install.
# Don't add the try() function when you use it (unless you want to).

iris |> group_by(Species) |> stoplight(n() == 50)
# Passes

iris |> group_by(Species) |> stoplight(n() != 50) |> try()
# Fails

starwars |> stoplight(n_distinct(name) == n())
# Passes

starwars |> stoplight(if_all(where(is.numeric), ~ .x > 0)) |> try()
# Fails

starwars |> stoplight(if_all(where(is.numeric), ~ .x > 0 | is.na(.x)))
# Passes
