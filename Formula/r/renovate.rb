class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.138.0.tgz"
  sha256 "358cddeb2a512f02982b71ba04ec6db7bbaa4e7523ab0f736e8e69908109c8a7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e740b4be78a6cbee740792ec9efc5ab5f302cbb4c450909215dd48b566c583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b36b373b24efe8981744b45aae8ffc216aedeffda82b5fef699721b5c7619221"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "638e5769cfa3fa8a6c6f6d55be40a37b65b9eb4189c1bc6219ce949b9b2c9ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed394b2c97ad6ab138d1df7fdaaf8073b9ea96fa189474a15a5713534e39c096"
    sha256 cellar: :any_skip_relocation, ventura:       "866c1f62097fa4088183b34dfd99984e4029a7acad9bcb156d072c3f9e65ed55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc0003cca18f0e31fa5689b6c355458a8a088410dc89db2688beaf434fd2ae9e"
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
