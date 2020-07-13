#' @export
vctrs::vec_cast

#' @inherit vctrs::vec_cast title description params
#' @seealso [vctrs::vec_cast()]
#' @method vec_cast term
#' @export
#' @export vec_cast.term
#' @examples
#' vec_cast(new_term(c("a[1]", "a[2]")), character())
#' vec_cast(c("a[1]", "a[2]"), new_term())
vec_cast.term <- function(x, to, ...) UseMethod("vec_cast.term")

#' @method vec_cast.term default
#' @export
vec_cast.term.default <- function(x, to, ...) {
  vec_default_cast(x, to)
}

#' @method vec_cast.term term
#' @export
vec_cast.term.term <- function(x, to, ...) x

#' @method vec_cast.term character
#' @export
vec_cast.term.character <- function(x, to, ...) new_term(x)

#' @method vec_cast.term term_rcrd
#' @export
vec_cast.term.term_rcrd <- function(x, to, normalize = TRUE, ...) {
  chk_flag(normalize)
  term <- paste0(x$par, "[", vapply(x$dim, paste, collapse = ",", FUN.VALUE = "", USE.NAMES = FALSE), "]")
  term[is.na(x$par) | is.na(x$dim)] <- NA_character_
  if(normalize)
    term <- normalize_terms_impl(term)
  new_term(term)
}