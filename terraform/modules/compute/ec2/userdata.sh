#!/bin/bash

exec > >(tee /var/log/userdata.log | logger -t user-data -s 2>/dev/console) 2>&1
set -xe

echo "✅ Starting ECS setup at $(date)"
# Write a simple text file
echo "Write a simple text file"
echo "This is a file created by user data" > /tmp/hello.txt

# Reinstall ECS agent only if installed; do not fail if not found
echo "Reinstall ECS agent only if installed"
if rpm -q ecs-init; then
  echo "Reinstall ECS agent only if installed"
  sleep 5
  yum remove -y ecs-init || echo "⚠️ ecs-init removal failed — continuing anyway..."
fi

sleep 5
echo "Installaing ecs-init client"
yum install -y ecs-init

sleep 5

# Write ECS cluster config
echo "⏳ ECS_CLUSTER=dev-ecs-cluster"
echo "ECS_CLUSTER=dev-ecs-cluster" > /etc/ecs/ecs.config

# Ensure Docker is running before ECS
echo "⏳ Enable docker."
sleep 3
systemctl enable docker
sleep 3
echo "⏳ Start docker."
systemctl start docker
systemctl status docker

# Enable and restart ECS agent
echo "⏳ Enable ECS agent."
systemctl enable ecs

sleep 5
echo "🔁 Restarting ECS agent in background ..."
sleep 5
(
  echo "=== ECS AGENT START ==="
  systemctl restart ecs
  systemctl status ecs
  echo "=== ECS AGENT END ==="
) >> /var/log/userdata.log 2>&1 &

sleep 10
# Optional: Wait until ECS agent metadata endpoint is ready
for i in {1..10}; do
  if curl -s http://localhost:51678/v1/metadata > /dev/null; then
    break
  fi
  echo "⏳ Waiting for ECS agent to start..."
  sleep 5
done

if ! curl -s http://localhost:51678/v1/metadata > /dev/null; then
  echo "❌ ECS agent did not start after 10 attempts" >> /var/log/userdata.log
fi

# Mount FSx if tagged
if echo "${project_tags}" | grep -q "fsx"; then
  if [ "${fsx_address}" != "none" ] && [ "${mount_point}" != "none" ]; then
    yum install -y nfs-utils
    mkdir -p ${mount_point}
    echo "${fsx_address}:/ ${mount_point} nfs4 defaults,_netdev 0 0" >> /etc/fstab
    mount -a
  fi
fi

# Install jq for formatted metadata output
echo "Install jq for formatted metadata output"
if ! command -v jq &> /dev/null; then
  yum install -y jq
fi

echo "userdata completed"

if curl -s http://localhost:51678/v1/metadata > /dev/null; then
  echo "✅ Logging ECS metadata using jq..."
  curl -s http://localhost:51678/v1/metadata | jq '.' > /var/log/ecs-metadata.json
else
  echo "❌ ECS metadata endpoint still unavailable" >> /var/log/ecs-metadata.json
fi


echo "✅ Userdata completed at $(date)"

