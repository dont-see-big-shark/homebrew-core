class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.165.0.tar.gz"
  sha256 "295c94d3d4cd55268021d2c20af6c0185b1911d3ca998f86daef7c606086c2f0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ff0a913049822bb1bec2aec3bbbbf1e92199fdf178c5b108d707a7a40c4a188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ff0a913049822bb1bec2aec3bbbbf1e92199fdf178c5b108d707a7a40c4a188"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ff0a913049822bb1bec2aec3bbbbf1e92199fdf178c5b108d707a7a40c4a188"
    sha256 cellar: :any_skip_relocation, sonoma:        "216f3757b7c1ae7701993dbf065db4f75c5e3ec83bc75d9aa26cba4c5f19afc0"
    sha256 cellar: :any_skip_relocation, ventura:       "20f1383a3bf6bf340b9cfde02e031b8a276e780905d25d1eac391fc8db4ce9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99642b80f54fc1ff2a88a754ce7e1440b81f0de3aa0cae6229ce4970ba25d58d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
