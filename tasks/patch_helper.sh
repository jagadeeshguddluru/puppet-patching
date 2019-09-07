#!/bin/bash

# when doing a `bolt task run` without a script argument the PT_script variable is not set
# when doing a run_task('patching::pre_patch', script => undef) PT_script is set to "null"
if [[ -z "$PT_script" || "$PT_script" == "null" ]]; then
  # set our default script, if one wasn't passed in, based on the calling task
  if [[ "$PT__task" == "patching::pre_patch" ]]; then
    PT_script='/etc/puppetlabs/patching/pre_patch.sh'
  elif [[ "$PT__task" == "patching::post_patch" ]]; then
    PT_script='/etc/puppetlabs/patching/post_patch.sh'
  else 
    echo "ERROR - 'script' wasn't specified and we were called with an unknown task: ${PT__task}" >&2
    exit 2
  fi
fi

if [[ -x "$PT_script" ]]; then
  "$PT_script"
  exit $?
else
  echo "WARNING: Script doesn't exist or isn't executable: ${PT_script}"
  exit 0
fi