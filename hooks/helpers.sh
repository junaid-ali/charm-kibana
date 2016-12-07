#!/bin/bash

function flag() {
  [[ -e ../unit-data/flags/$1 ]] && return 0 || return 1
}

function flags() {
  [[ ! -d ../unit-data/flags ]] && return
  (cd ../unit-data/flags; ls "$@"*)
}

function set_flag() {
  mkdir -p ../unit-data/flags
  touch ../unit-data/flags/$1
}

function unset_flag() {
  rm -f ../unit-data/flags/$1
}

function load_dashboards_from_config() {
  if ! flag es_ready; then
    return  # ES relation not ready
  fi
  if [[ -z "$(config-get dashboards)" ]]; then
    return  # no dashboards set
  fi

  for dashboard in $(config-get dashboards); do
    if ! flag loaded_$dashboard; then
      actions/load-dashboard $dashboard
      set_flag loaded_$dashboard
    fi
  done
}
