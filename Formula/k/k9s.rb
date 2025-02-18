class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.40.4",
      revision: "e44c223e91c7fe5f6c77e3236272d1cf94bdd536"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c9a7e933da7928a8fbaedc215cdd4f5754afff29057f1753b3599ceddb264e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67d570bb7be24f32f2e251a258bff46068c909f81acb4371ed0247fd2720da8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3dc70e55e630c41770f34ee3c38608284a1128fc8f6c07b2240037a14b24b78"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a97dffb9a46acc8665136e3ce9c3958ac8171195e732c75eb4d1a3f89ffea3c"
    sha256 cellar: :any_skip_relocation, ventura:       "fc74d2b8378b9276854cb8523bce68b25a2f7f035d6a95879c094beafd15d7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cc3905723ccd8343360f0041213037c1d167479818ba373562a05652c03c90a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
