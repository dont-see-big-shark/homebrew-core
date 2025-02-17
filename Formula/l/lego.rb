class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.22.1.tar.gz"
  sha256 "5dc69859f5b42034acc0731d5308bc3d9eb35d323d0b6e83ec5d2ab551db43ff"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f15c0078b95028e294c8e4812f851f571ca4cbe9702eab1d9b2e3e30f498e2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f15c0078b95028e294c8e4812f851f571ca4cbe9702eab1d9b2e3e30f498e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f15c0078b95028e294c8e4812f851f571ca4cbe9702eab1d9b2e3e30f498e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d67298b522554bc42617704bcf76664ac35bbdf093633842a3372f980b4b70b"
    sha256 cellar: :any_skip_relocation, ventura:       "1d67298b522554bc42617704bcf76664ac35bbdf093633842a3372f980b4b70b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc09708660f4b244248d2a89f758422c1a2b56624c287c1c5f7cbc2e23c9034f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
