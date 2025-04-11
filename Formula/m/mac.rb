class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1105_SDK.zip"
  version "11.05"
  sha256 "ac65d494164f0e4b5c7e759dd67503f35bfa35f324db959c3113d9e1aee9b494"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d9963e2155c7c0dc015934375a7b027633b7c8d9114b42f6f9c85ce0be82689"
    sha256 cellar: :any,                 arm64_sonoma:  "5f83f72e3b1b9a9c77d19a47e123f651bcd8e004193fea7244a3c4cb75e8ac06"
    sha256 cellar: :any,                 arm64_ventura: "73ad6281b2dddb80dd7d285a9d7cd972861562eabc1c52813179f5dc15f00d85"
    sha256 cellar: :any,                 sonoma:        "ce95e6b0c97a9cfe340e19c0050490514bc16c6adcd5364081c3a833806bcea0"
    sha256 cellar: :any,                 ventura:       "7a1cbed853a90a3cffe08324b8ceca09325b8fb11bb996c74a609f61149ab7a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fa3c369b8ab4cc420287636837bebf0fb455fa7e9d70c14e5364ae830cac590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79a72bd87a56cabc156e15d415d82f61d0c4719bf238a836b02fa42ae266fc5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end
