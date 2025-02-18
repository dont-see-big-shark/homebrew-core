class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.90.tar.gz"
  sha256 "4b17d5c49ad80920b099b7f2c33baab08bfbb98bd6042d07811994e7a83e8a8b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "689fb9b851a06bdf0316636949d4a6d13bf1275b7b5f4f05f2b41f72d17411ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "689fb9b851a06bdf0316636949d4a6d13bf1275b7b5f4f05f2b41f72d17411ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "689fb9b851a06bdf0316636949d4a6d13bf1275b7b5f4f05f2b41f72d17411ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef043a4924f59494a41021e9096b33bbee47879c6679724d1036520667a2ad61"
    sha256 cellar: :any_skip_relocation, ventura:       "ef043a4924f59494a41021e9096b33bbee47879c6679724d1036520667a2ad61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9fc93403a00e30f9cdd9afdef53b40d1f144185c6afd6917dd5c92cbc3070d"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
