class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.3.tgz"
  sha256 "e5f2f2bffc0ef520a6487b2cc9081c9dd9643338eff90492f3608b956f30550c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e9ad33ecfc479100820206dde952627aff5d16b2b13537aabb27763d546e461"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
