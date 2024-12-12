class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "b502777581357add91c8ba37c95f955470c11e2df68675e7bd88c68317e5fd0a"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9aade0ce945e0dc14ad54dfa1e5e241c2789a8f7a078cc795d1c1ce8fa778a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19109930d33f1631afd05604192b93af40b4cee357bcdc645a3489d4ff9fe630"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b86d05a7e7e91e93e9512a7fad42a47c8d2ce1767e3475e9923ab7620295141"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcbedaba3e87c68a234b445140f31599e9ac2d8147ebea3cba89ce05fdacce97"
    sha256 cellar: :any_skip_relocation, ventura:       "1c185e820c53521cd7464523171cceb247c411d9d459ca961d917171c3f6a33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a991274a4b14099b981a8e3c036192cb54459bd1747cac47a6005d6bad8283a9"
  end

  depends_on "rust" => :build
  depends_on "bat"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
