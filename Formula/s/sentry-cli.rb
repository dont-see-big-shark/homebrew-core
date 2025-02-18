class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.42.0.tar.gz"
  sha256 "bda459b68b4ac6b595fde1f81d775967c23099ec4b2939f1531e0a26275e6a5d"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51504fd88a9e5cbf25f2d86a1cf641d68445001bbf27806974ae2fe1ec21dc51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd527355b987156f37c537668d78ccc3fbd03c0aec29f091bd52598502a937f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bf83f59b481bd427f70b7b6fe13cfd57d728b50143aa60d9b59fd212fedc1d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cc4c41ce79bb006f5d08ff749efc61f8cb6cb2914043223196a001c019bf7a2"
    sha256 cellar: :any_skip_relocation, ventura:       "36d33820a7921be1db22c18edfe65d24b5632da3cb4b5771f6e1362ba4bf186c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "585e62228fd3761b8ce0dffd8739a88fe9133a56f72871aba7d10276a2600d0c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
