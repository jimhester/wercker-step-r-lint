#!/bin/bash

run_script () {
  temp_file=$(mktemp -t "XXXXXXXXXX.R")
  cat > "$temp_file"
  Rscript "$temp_file"
  if [[ $? -ne 0 ]]; then
    fail "Script $temp_file failed!"
  fi
}

export LINTR_ERROR_ON_LINT=true
run_script <<END
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("jimhester/lintr")
lintr::lint_package($WERCKER_R_LINT_OPTIONS)
END

success "Linting successfull!"
