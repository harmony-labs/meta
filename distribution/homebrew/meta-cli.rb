# typed: false
# frozen_string_literal: true

class MetaCli < Formula
  desc "Multi-repo management CLI with AI integration"
  homepage "https://github.com/harmony-labs/meta"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-darwin-arm64.tar.gz"
      # sha256 will be filled in by release automation
    end
    on_intel do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-darwin-x64.tar.gz"
      # sha256 will be filled in by release automation
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-linux-arm64.tar.gz"
      # sha256 will be filled in by release automation
    end
    on_intel do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-linux-x64.tar.gz"
      # sha256 will be filled in by release automation
    end
  end

  def install
    bin.install "meta"
    bin.install "meta-mcp" if File.exist?("meta-mcp")

    # Install plugins if present
    Dir["meta-*"].each do |plugin|
      next if plugin == "meta-mcp"
      bin.install plugin
    end
  end

  test do
    system "#{bin}/meta", "--version"
  end
end
