#!/bin/bash

PATH_ROOT="/data/sites/web/buildsoftwebsite/sites/buildsoft.eu/dev";
PATH_WEB="$PATH_ROOT/web"

function _drupal_execute_sync() {
  local site_name="$1"
  # Cache rebuild.
  drush -l ${site_name} cr -y
  # Database updates
  drush -l ${site_name} updb --entity-updates -y
  # Cache rebuild.
  drush -l ${site_name} cr -y
  # Sync config
  drush -l ${site_name} cim -y
  # Sync config (do it twice to make sure)
  drush -l ${site_name} cim -y
  # Cache rebuild.
  drush -l ${site_name} cr -y
  # Node access rebuild (disabled)
  # drush -l ${site_name} php-eval 'node_access_rebuild()'
}

cd $PATH_ROOT
# Composer install
composer install --no-suggest

cd $PATH_WEB

# Sync all subsites.
_drupal_execute_sync "default"

