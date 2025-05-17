class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://registry.npmjs.org/@openai/codex/-/codex-0.1.2505161800.tgz"
  sha256 "4cf4af6c0f52cc0865d088e1c931f19117009d527b983c676ce6a3615368a146"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e226d7dddeaa4dc898058f01614548b358a7eb50192ae139fa5e272e67c99cdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e226d7dddeaa4dc898058f01614548b358a7eb50192ae139fa5e272e67c99cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e226d7dddeaa4dc898058f01614548b358a7eb50192ae139fa5e272e67c99cdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c222b0bd287011bc637d22c0cdbf2df9dfc0a0364f07fd31eb113fac0cd17bd6"
    sha256 cellar: :any_skip_relocation, ventura:       "c222b0bd287011bc637d22c0cdbf2df9dfc0a0364f07fd31eb113fac0cd17bd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e226d7dddeaa4dc898058f01614548b358a7eb50192ae139fa5e272e67c99cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e226d7dddeaa4dc898058f01614548b358a7eb50192ae139fa5e272e67c99cdf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    libexec.glob("lib/node_modules/@openai/codex/bin/*")
           .each { |f| rm_r(f) if f.extname != ".js" }

    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    # codex is a TUI application
    assert_match version.to_s, shell_output("#{bin}/codex --version")
  end
end
