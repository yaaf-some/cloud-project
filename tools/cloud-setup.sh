#!/usr/bin/env bash
# Setup script for the Cloud-Project environment (Claude cloud sessions).
# Paste this file into the environment's setup script. Keep both copies identical.
# Every download is pinned and checked against a SHA256 recorded here.
# To bump a tool: change its version and hash in the same commit.
set -euo pipefail

BIN=/usr/local/bin
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
GH=https://github.com

# name|version|url|sha256|path inside archive ("-" = raw binary)
TOOLS=(
  "tofu|1.13.9|$GH/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_linux_amd64.tar.gz|b34b327cc1ef07178207b6f2cd1f5276537d3e5b7be316500f6dac50d4c0a857|tofu"
  "tflint|0.66.0|$GH/terraform-linters/tflint/releases/download/v0.66.0/tflint_linux_amd64.zip|22be11cadc25cd02401e94c0ccc91aa63467debb8485c2a755d98f4c0a9d1e2e|tflint"
  "kubectl|1.37.2|https://dl.k8s.io/release/v1.37.2/bin/linux/amd64/kubectl|c04487523e7aa7d1493f7808174c899db93d7a9cf57531420cd76b9bd415f8f4|-"
  "helm|4.3.2|https://get.helm.sh/helm-v4.3.2-linux-amd64.tar.gz|d1c0278d46beab79582d7e50f5b3dc206944ba8e577cde618513fd07daa53983|linux-amd64/helm"
  "kind|0.33.0|$GH/kubernetes-sigs/kind/releases/download/v0.33.0/kind-linux-amd64|aee6151561422756b764a4ae28e7f44cda5af5a9eead3cc9985112b1de8d8e0d|-"
  "k6|2.4.0|$GH/grafana/k6/releases/download/v2.4.0/k6-v2.4.0-linux-amd64.tar.gz|5a5ecf23529ccf93135bc7e5b0c1cd5126ecf5f2672e22eed1556a0ab74abb87|k6-v2.4.0-linux-amd64/k6"
  "cosign|3.1.4|$GH/sigstore/cosign/releases/download/v3.1.4/cosign-linux-amd64|424e2c97d0b45fd7a6b608a87f090f35633f4c23ece5f092d48bba11aaf4bbfa|-"
  "syft|1.57.1|$GH/anchore/syft/releases/download/v1.57.1/syft_1.57.1_linux_amd64.tar.gz|bf52519eb57f675d47c07d43213cb6dff6449f3d6d1147ff6701ed91f44eef0c|syft"
  "actionlint|1.7.12|$GH/rhysd/actionlint/releases/download/v1.7.12/actionlint_1.7.12_linux_amd64.tar.gz|8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8|actionlint"
  # checkov publishes no checksum file; hash taken from the release zip on 2026-11-13.
  "checkov|3.4.5|$GH/bridgecrewio/checkov/releases/download/3.4.5/checkov_linux_X86_64.zip|8b088b4b7c0ffffa47c5c463978057187c457b62ccdcc2137697d5b3be3de79e|dist/checkov"
)

install_one() {
  local name ver url sha inner f
  IFS='|' read -r name ver url sha inner <<<"$1"
  if [ -x "$BIN/$name" ] && [ -f "$BIN/.$name.$ver" ]; then echo "= $name $ver"; return; fi
  mkdir -p "$WORK/$name" && f="$WORK/$name/${url##*/}"
  curl -fsSL --retry 3 -o "$f" "$url"
  echo "$sha  $f" | sha256sum -c --quiet -
  case "$f" in
    *.tar.gz) tar -xzf "$f" -C "$WORK/$name" "$inner"; f="$WORK/$name/$inner" ;;
    *.zip) unzip -q -o "$f" "$inner" -d "$WORK/$name"; f="$WORK/$name/$inner" ;;
  esac
  install -m 0755 "$f" "$BIN/$name"
  rm -f "$BIN/.$name."* && touch "$BIN/.$name.$ver"
  echo "+ $name $ver"
}

pids=()
for t in "${TOOLS[@]}"; do install_one "$t" & pids+=($!); done
for p in "${pids[@]}"; do wait "$p"; done   # set -e: any failed check stops the script

# zizmor: single wheel with no dependencies, pinned by hash.
cat >"$WORK/zizmor.txt" <<'EOF'
zizmor==1.32.0 --hash=sha256:84a6acb975accc13408786a2bd274b572537ca19c933ebbc13e78f3988562071
EOF
python3 -m pip install -q --root-user-action=ignore --no-deps --require-hashes --only-binary=:all: -r "$WORK/zizmor.txt"

mkdir -p /root/.terraform.d/plugin-cache   # TF_PLUGIN_CACHE_DIR
echo "cloud-setup: done"
