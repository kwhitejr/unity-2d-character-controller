#!/bin/sh

# Author: kwhitejr
# Copyright (c) kwhitejr.com

PLAN_FILE=planfile

# NOTE: If the Terraform deploy (init, plan, apply) goes awry,
# it can be helpful to simply tear everything down (destroy) and start fresh.
# Below, find scripts to either create or destroy the various AWS S3 static site resources.
# I generally just toggle which lines are commented.

# Destroy the bucket
# terraform -chdir=terraform/make-bucket destroy
###### END destroy

# Create the bucket
terraform -chdir=terraform/make-bucket init
terraform -chdir=terraform/make-bucket plan -out=$PLAN_FILE
terraform -chdir=terraform/make-bucket apply -input=false $PLAN_FILE
###### END create