#!/bin/sh

# Author: kwhitejr
# Copyright (c) kwhitejr.com

PLAN_FILE=planfile

# Destroy the bucket
# terraform -chdir=terraform/sync-bucket destroy

# Create the bucket
terraform -chdir=terraform/sync-bucket init
terraform -chdir=terraform/sync-bucket plan -out=$PLAN_FILE
terraform -chdir=terraform/sync-bucket apply -input=false $PLAN_FILE