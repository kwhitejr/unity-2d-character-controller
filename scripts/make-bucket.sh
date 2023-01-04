#!/bin/sh

# Author: kwhitejr
# Copyright (c) kwhitejr.com

PLAN_FILE=planfile

# Destroy the bucket
# terraform -chdir=terraform/make-bucket destroy

# Create the bucket
terraform -chdir=terraform/make-bucket init
terraform -chdir=terraform/make-bucket plan -out=$PLAN_FILE
terraform -chdir=terraform/make-bucket apply -input=false $PLAN_FILE