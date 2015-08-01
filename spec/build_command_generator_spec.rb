describe Gym do
  describe Gym::BuildCommandGenerator do
    it "raises an exception when project path wasn't found" do
      expect do
        Gym.config = { project: "notExistent" }
      end.to raise_error "Could not find project at path 'notExistent'".red
    end

    it "works with the example project with no additional parameters" do
      options = { project: "./example/Example.xcodeproj" }
      Gym.config = FastlaneCore::Configuration.create(Gym::Options.available_options, options)

      result = Gym::BuildCommandGenerator.generate
      expect(result).to eq([
        "set -o pipefail && ",
        "xcodebuild",
        "-project './example/Example.xcodeproj'",
        "-configuration 'Release'",
        "-scheme 'Example'",
        "-archivePath '#{Gym::BuildCommandGenerator.archive_path}'",
        :archive,
        "| xcpretty"
      ])
    end

    it "supports additional parameters" do
      options = { project: "./example/Example.xcodeproj", sdk: "9.0" }
      Gym.config = FastlaneCore::Configuration.create(Gym::Options.available_options, options)

      result = Gym::BuildCommandGenerator.generate
      expect(result).to eq([
        "set -o pipefail && ",
        "xcodebuild",
        "-project './example/Example.xcodeproj'",
        "-configuration 'Release'",
        "-scheme 'Example'",
        "-sdk '9.0'",
        "-archivePath '#{Gym::BuildCommandGenerator.archive_path}'",
        :archive,
        "| xcpretty"
      ])
    end
  end
end
