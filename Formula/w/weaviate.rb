class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.28.6.tar.gz"
  sha256 "9de35f308421e7c3fdc0f07961e6e3e24cc1f46465b999c2b08bb2273054f9e7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "593d9ed9536bd14317c3f0c7abd05c32365b96597d04101ceefb814ffe92994a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "593d9ed9536bd14317c3f0c7abd05c32365b96597d04101ceefb814ffe92994a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "593d9ed9536bd14317c3f0c7abd05c32365b96597d04101ceefb814ffe92994a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6467677bd443f76a0a2582ec547f70c2fe8d587a097ac157f3f97a65f300dc19"
    sha256 cellar: :any_skip_relocation, ventura:       "6467677bd443f76a0a2582ec547f70c2fe8d587a097ac157f3f97a65f300dc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72288c43732a0da132bfe06fb137747c2c9b11e370acf65198ed0269c446e5de"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
