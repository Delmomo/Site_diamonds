
library(usethis)

usethis::use_git_config(
  scope = "user",
  user.name = "Drain Delphine", 
  user.email = "delphinedrain@hotmail.fr",
  credential.helper = "store",
  init.defaultBranch = "main"
)

gitcreds::gitcreds_set()
