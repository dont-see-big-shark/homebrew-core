class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.174.tar.gz"
  sha256 "7774c9a27e83bc5838a3da27fa30bae97412b9496e417c9c57d4177d2d91a36e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20150336bf21bef2719f7e23be91c902752ea7fa55442de8477a456e356caad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20150336bf21bef2719f7e23be91c902752ea7fa55442de8477a456e356caad9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20150336bf21bef2719f7e23be91c902752ea7fa55442de8477a456e356caad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1a155f5f75572ec2a6f2e95eb0f38baf68a8fc286ea0c0c212dbed6d092eb7b"
    sha256 cellar: :any_skip_relocation, ventura:       "d1a155f5f75572ec2a6f2e95eb0f38baf68a8fc286ea0c0c212dbed6d092eb7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fbbb976b21f714312740eb7ffd3f5c3a7d7086abdcb673240f88f41d903dc21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
