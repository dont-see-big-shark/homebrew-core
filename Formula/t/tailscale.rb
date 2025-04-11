class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.82.3",
      revision: "a7b810e79c1723caf6aa4a11e5f0f2d526ef7d39"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02a95a9816847acafc62008f22d3634d2929c9a6641333fc9f42ff94f86ec6ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "607c96c9ed4f1243d91e1d09ef904ef6cad89b4d8fcb4a974a6cbc13060a3246"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "789dbbf9e6a23f46819d4afbb2e5584ebfc812163c6d9323bc0f25f258509b3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cda7560b3585f7bd6695a59563c9f7ab193046eb9e2735be8a1e9cb690b71f2"
    sha256 cellar: :any_skip_relocation, ventura:       "bef2aecba20b6cb54e8f52b082c1a9702aac943d35b9eefd01bd26a77fab57b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27622baf271208d1632fc91de086cae4dc7e1f441a3947bd9a5fa6966622090d"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", "completion")
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
