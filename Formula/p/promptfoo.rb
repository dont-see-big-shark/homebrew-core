class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.15.tgz"
  sha256 "d697c53c595d31731909167ff30f1c534abc496185df51d8b7485325c0484109"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff91e288caba22d016b924413501ff495e4d59bbce17fe6832596450049fc144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eb3b42d7e66c476d9a801eb96049e711cbeee60600fab848b5cab56ab3cb772"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef9aca709d4aaf813a5bc0227b53d08bbbfd3735cfe922c76d427390538764fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "c06899f2f3b0712f0072318cf976940f29c83712620cc8a63e4b360a86c5659d"
    sha256 cellar: :any_skip_relocation, ventura:       "fe8c8352ecdb06a27e4f588673b1ee7a1705768fd255cac37f314ff6820c8445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba1963377b78b402e602f5e8b961ce5fb256cb2bfbd6cc9ef62c1712e4319d09"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
