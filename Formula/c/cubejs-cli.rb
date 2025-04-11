class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.34.tgz"
  sha256 "edb6ba9bb91b9b24b71698cf68d24b1d262e09f523ca0ee182c0975092a07e3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b40e927eccd25a9535161afe4868d386f00b2f02a33213b3ca30a4e3ba38d64e"
    sha256 cellar: :any,                 arm64_sonoma:  "b40e927eccd25a9535161afe4868d386f00b2f02a33213b3ca30a4e3ba38d64e"
    sha256 cellar: :any,                 arm64_ventura: "b40e927eccd25a9535161afe4868d386f00b2f02a33213b3ca30a4e3ba38d64e"
    sha256 cellar: :any,                 sonoma:        "ead070e48a7608d2b14c7e91407eed8cb415686dca386b20528a8a68122990a6"
    sha256 cellar: :any,                 ventura:       "ead070e48a7608d2b14c7e91407eed8cb415686dca386b20528a8a68122990a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "812285905ab5f1defe4cfddd501547f5fa37dee8ce8f6dc02fa47fb9e67b52b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "485367de66d7fee9490de1144719e8b51be6d5b63b536bf1fa27a3f5152ce07e"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
