class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "59cd7aad7a820adceb9d9f37a828133163f5f71e0612ec873a9c76d1291ac160"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487611578a3b9bd509649d88c41c35beb0da454f77a451eb91af4fbfc8cc1116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "487611578a3b9bd509649d88c41c35beb0da454f77a451eb91af4fbfc8cc1116"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "487611578a3b9bd509649d88c41c35beb0da454f77a451eb91af4fbfc8cc1116"
    sha256 cellar: :any_skip_relocation, sonoma:        "da5ed1f319687cb3e765bdeda8ac2be61e302e4e6446baaee9349c066fa72ca4"
    sha256 cellar: :any_skip_relocation, ventura:       "da5ed1f319687cb3e765bdeda8ac2be61e302e4e6446baaee9349c066fa72ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c861da0182dbcd8db65bbb91913f8e19f230dd3f954ea99898aeda2a4f9fc1de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
