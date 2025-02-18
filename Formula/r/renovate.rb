class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.174.0.tgz"
  sha256 "aac90525f1967e61c29d6ed09add82932251575ec43d436ddc79f795dc3d81e2"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e210dac9b76dad5c236cc59813175a55b071ffeaec425e4534f157a279465a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "520d59939eb31a9565b454b44d01b15df458910aed9fe04fd557ec668c15bc01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c78811a26b7d7e994a845420dbce0d4d84ccce261229a7be1a059feb77594481"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5a70bd48cfbb95543a6046ad2718f464fff2eae4f8b212d5b1e7bbf5c20bdb"
    sha256 cellar: :any_skip_relocation, ventura:       "92b99f3442805b33c36e037085083e7acbe4432886b32e433f31ae00ff0e688a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f61dca3ecbc183d319b14402e4eea27d2e036cd136c3e4f4f3a23c6cc9fc87c"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
