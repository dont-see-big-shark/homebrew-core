class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "f960160510c19361f5d84771ef9372f1368c3d8edcc9714580e82fa55fa5c581"
  license "Apache-2.0"
  head "https://github.com/keploy/keploy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad45cbc18fb17001e69df35f977e35d7e32f9ca638813be570a0387b9151f9fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad45cbc18fb17001e69df35f977e35d7e32f9ca638813be570a0387b9151f9fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad45cbc18fb17001e69df35f977e35d7e32f9ca638813be570a0387b9151f9fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04178a4b93739e4b6b08960370f326920343f185011f05d8402507197f0e054"
    sha256 cellar: :any_skip_relocation, ventura:       "f04178a4b93739e4b6b08960370f326920343f185011f05d8402507197f0e054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8090b0894c5d5f65e49dfbf2fa2efe1362ebb9ba302625c08e86ac27f1514e33"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin/"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath/"keploy.yml").read

    output = shell_output("#{bin}/keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}/keploy --version")
  end
end
