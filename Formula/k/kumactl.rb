class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.8.3.tar.gz"
  sha256 "4327a2b3017dfe0648b01387b05fedcc49a2141d35b91bcc588c09cc1cbc3b11"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fda86515680067986014c9e62f4275bda8727f9ea272f7d125f5755ad967c239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a6ca3721e882c706bbd974d6ab21b8c5287f72164d8fb3381d4f577d5bbe4b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a6ca3721e882c706bbd974d6ab21b8c5287f72164d8fb3381d4f577d5bbe4b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a6ca3721e882c706bbd974d6ab21b8c5287f72164d8fb3381d4f577d5bbe4b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b544c04428257db9cf591771ad7ed63f142153eeddcff864f47ad13a10bdc0f"
    sha256 cellar: :any_skip_relocation, ventura:        "2b544c04428257db9cf591771ad7ed63f142153eeddcff864f47ad13a10bdc0f"
    sha256 cellar: :any_skip_relocation, monterey:       "2b544c04428257db9cf591771ad7ed63f142153eeddcff864f47ad13a10bdc0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03384283c7913ab17ca80b44745b37c01e25a54bdf67403b6e4289d3edf0abbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
