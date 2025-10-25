
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stoplight: lightweight assertive programming for dplyr

The goal of stoplight is to provide a tidy alternative to the
`stopifnot` function. It’s equivalent to filtering by a condition and
making sure you didn’t lose any rows. If no rows are lost, the data
pipeline continues, if any row doesn’t match the condition, the function
returns an error.

If there’s something wrong with your code, it’s better to raise an error
than miss it!

## Installation

You can install stoplight like so:

``` r
remotes::install_github("AnthonyEbert/stoplight")
```

## Example

Some examples of stoplight verifying correct statements, and making
errors for false statements.

Note: The function `try()` is only added to let the package install.
Don’t add the `try()` function when you use it (unless you want to).

``` r
library(stoplight)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

# The function try() is added to let the package install.
# Don't add the try() function when you use it (unless you want to).

iris |> group_by(Species) |> stoplight(n() == 50) # Passes
#> # A tibble: 150 × 5
#> # Groups:   Species [3]
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # ℹ 140 more rows

iris |> group_by(Species) |> stoplight(n() != 50) |> try() # This is supposed to error
#> Error in dplyr::mutate(.data, stopifnot(!!!statements)) : 
#>   ℹ In argument: `stopifnot(n() != 50)`.
#> ℹ In group 1: `Species = setosa`.
#> Caused by error in `stopifnot()`:
#> ! ~n() != 50 is not TRUE

starwars |> stoplight(n_distinct(name) == n()) # Passes
#> # A tibble: 87 × 14
#>    name     height  mass hair_color skin_color eye_color birth_year sex   gender
#>    <chr>     <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr> 
#>  1 Luke Sk…    172    77 blond      fair       blue            19   male  mascu…
#>  2 C-3PO       167    75 <NA>       gold       yellow         112   none  mascu…
#>  3 R2-D2        96    32 <NA>       white, bl… red             33   none  mascu…
#>  4 Darth V…    202   136 none       white      yellow          41.9 male  mascu…
#>  5 Leia Or…    150    49 brown      light      brown           19   fema… femin…
#>  6 Owen La…    178   120 brown, gr… light      blue            52   male  mascu…
#>  7 Beru Wh…    165    75 brown      light      blue            47   fema… femin…
#>  8 R5-D4        97    32 <NA>       white, red red             NA   none  mascu…
#>  9 Biggs D…    183    84 black      light      brown           24   male  mascu…
#> 10 Obi-Wan…    182    77 auburn, w… fair       blue-gray       57   male  mascu…
#> # ℹ 77 more rows
#> # ℹ 5 more variables: homeworld <chr>, species <chr>, films <list>,
#> #   vehicles <list>, starships <list>

starwars |> stoplight(if_all(where(is.numeric), ~ .x > 0)) |> try() # This is supposed to error
#> Error in dplyr::mutate(.data, stopifnot(!!!statements)) : 
#>   ℹ In argument: `stopifnot(if_all(where(is.numeric), ~.x > 0))`.
#> Caused by error in `stopifnot()`:
#> ! ~if_all(where(is.numeric), ~.x > 0) are not all TRUE

starwars |> stoplight(if_all(where(is.numeric), ~ .x > 0 | is.na(.x))) # Passes
#> # A tibble: 87 × 14
#>    name     height  mass hair_color skin_color eye_color birth_year sex   gender
#>    <chr>     <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr> 
#>  1 Luke Sk…    172    77 blond      fair       blue            19   male  mascu…
#>  2 C-3PO       167    75 <NA>       gold       yellow         112   none  mascu…
#>  3 R2-D2        96    32 <NA>       white, bl… red             33   none  mascu…
#>  4 Darth V…    202   136 none       white      yellow          41.9 male  mascu…
#>  5 Leia Or…    150    49 brown      light      brown           19   fema… femin…
#>  6 Owen La…    178   120 brown, gr… light      blue            52   male  mascu…
#>  7 Beru Wh…    165    75 brown      light      blue            47   fema… femin…
#>  8 R5-D4        97    32 <NA>       white, red red             NA   none  mascu…
#>  9 Biggs D…    183    84 black      light      brown           24   male  mascu…
#> 10 Obi-Wan…    182    77 auburn, w… fair       blue-gray       57   male  mascu…
#> # ℹ 77 more rows
#> # ℹ 5 more variables: homeworld <chr>, species <chr>, films <list>,
#> #   vehicles <list>, starships <list>
```
