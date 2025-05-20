#!/bin/bash

set -e

BUCKET_NAME="homelab-terraform-state-a1b2c3"
PROJECT_ID=$(gcloud config get-value project)


echo "Creating GCS bucket: ${BUCKET_NAME}"
gsutil mb -p ${PROJECT_ID} gs://${BUCKET_NAME}

# Config Enable versioning and label on the bucket
echo "Enabling versioning on the bucket"
gsutil versioning set on gs://${BUCKET_NAME}
echo "Setting bucket labels"
gsutil label ch -l environment:homelab -l managed-by:terraform gs://${BUCKET_NAME}

echo "Backend setup complete! You can now initialize OpenTofu with:"
echo "tofu init" 
tofu init