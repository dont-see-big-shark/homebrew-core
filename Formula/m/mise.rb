class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.2.5.tar.gz"
  sha256 "39a6383fd765686c021b8ccfd295ceb7c2e1edd99e6c44f1b8a9fafff86e4295"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca2543701b61079275c50c63d74a49ff806522b24799031589d05f75ee5a5b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47affd3d20534bb332dffaa81f640f559580f57bc5302dec7f6c60e45efb52c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bae98b9411dfcedf07778311cc12342c1c88eb1b02f81f954a57e93cc131820"
    sha256 cellar: :any_skip_relocation, sonoma:        "315d430e16d4dd2fde568b4c4f540e9c37a918556d0b274e1d90c7c62c67371e"
    sha256 cellar: :any_skip_relocation, ventura:       "e15ff2afe635174da408f6d173213a5c18dc95d0cff274859db24549cd693bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7780d116d1e3a6dde23bf39da5c647f95de212f9bf7edfaa9a2cdd7ab4076855"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
