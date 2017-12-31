gcloud beta compute instances create "dl" \
--machine-type "n1-standard-2" \
--accelerator type=nvidia-tesla-k80,count=1 \
--image-family "ubuntu-1604-lts" --image-project "ubuntu-os-cloud" \
--boot-disk-size "50" --boot-disk-type "pd-ssd" \
--maintenance-policy "TERMINATE"

