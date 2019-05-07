#!/bin/bash
# Use this script to deploy master of all sub sites.

#export PATH="$HOME/.config/composer/vendor/bin:$PATH"

PATH_ROOT="/data/sites/web/buildsoftwebsite/sites/buildsoft.eu/master";
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

  # Uninstall dev modules
  #drush -l ${site_name} pm-uninstall kint -y
  #drush -l ${site_name} pm-uninstall devel -y
  #drush -l ${site_name} pm-uninstall webprofiler -y
  # Disable maintenance mode.
  drush -l ${site_name} sset system.maintenance_mode FALSE
  # Cache rebuild.
  drush -l ${site_name} cr -y
}

cd $PATH_WEB
# Set site in maintenance mode.
drush -l default sset system.maintenance_mode TRUE

cd $PATH_ROOT
# Composer install
composer install --no-suggest

cd $PATH_WEB
# Execute sync.
_drupal_execute_sync "default"

# EXAMPLE HOW TO EDIT robots.txt ON DEPLOY.
#grep -qF -- "# Custom added paths" "robots.txt" || echo "# Custom added paths" >> "robots.txt"
#grep -qF -- "Disallow: /calculate/*" "robots.txt" || echo "Disallow: /calculate/*" >> "robots.txt"
