#!/bin/bash
# ==============================================================================
# Script Name : auto_claim.sh
# Description : Auto-retry script for provisioning OCI Ampere A1 Flex instances
#               when region capacity is full ("Out of host capacity").
# ==============================================================================

# User Configurations (Ganti dengan OCID milik Anda)
COMPARTMENT_ID=${OCI_TENANCY} # Menggunakan OCID Tenancy bawaan Cloud Shell
SUBNET_ID="YOUR_SUBNET_OCID_HERE"
IMAGE_ID="YOUR_IMAGE_OCID_HERE"
SSH_KEY_PATH="YOUR_PUBLIC_SSH_KEY_HERE"
SHAPE_CONFIG_PATH="/tmp/shape.json"

# Hardware Configuration (Default Always Free: 2 OCPU, 12GB RAM)
OCPU=1
MEMORY=6

# 1. Inject Public SSH Key
echo "YOUR_PUBLIC_SSH_KEY_HERE" > "$SSH_KEY_PATH"

# 2. Create Temporary Shape Configuration File (Avoids JSON parsing errors in Bash)
echo "{\"ocpus\": $OCPU, \"memoryInGbs\": $MEMORY}" > "$SHAPE_CONFIG_PATH"

echo "=================================================="
echo " Starting OCI Ampere VM Auto-Claim Process... "
echo " Target: $OCPU OCPU / $MEMORY GB RAM "
echo "=================================================="

# 3. Retry Loop
while true; do
  OUTPUT=$(oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --availability-domain "ap-batam-1-AD-1" \
    --shape "VM.Standard.A1.Flex" \
    --shape-config "file://$SHAPE_CONFIG_PATH" \
    --display-name "Hermes-Server" \
    --image-id "$IMAGE_ID" \
    --subnet-id "$SUBNET_ID" \
    --ssh-authorized-keys-file "$SSH_KEY_PATH" \
    --assign-public-ip true 2>&1)

  if echo "$OUTPUT" | grep -E -q "Out of host capacity|TooManyRequests|LimitExceeded|500|CannotParseRequest"; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Out of capacity. Retrying in 30 seconds..."
    sleep 30
  else
    echo "=================================================="
    echo " SUCCESS! Instance created on $(date)"
    echo "=================================================="
    echo "$OUTPUT"
    break
  fi
done
