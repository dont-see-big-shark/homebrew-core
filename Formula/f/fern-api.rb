class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.7.tgz"
  sha256 "4d25ecce98e13a0c1ee91a89dc806c4f86a0605a8ccf12eed9bea323e7842aae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2522f4921e705d2b25ac4f337492c1b2b542491bc50b0b195e5664638d858b37"
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
