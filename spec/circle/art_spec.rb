require 'circle/art'

RSpec.describe Circle::Art do
  let(:repo) { 'TINYhr/tinypulse' }
  let(:build) { 71855 }
  let(:token) { 'bd04c8e73d188fd1be5d8061d33d14e2c5ea749b' }

  it 'has a version number' do
    expect(Circle::Art::VERSION).not_to be nil
  end

  it 'generate circle path' do
    url = UrlBuilder.new(repo, build).url
    output = 'https://circleci.com/gh/TINYhr/tinypulse/71855#artifacts'
    expect(url).to eq(output)
  end

  it 'artifacts path' do
    url = "https://circleci.com/api/v1.1/project/github/TINYhr/tinypulse/71855/artifacts?circle-token=#{token}"
    builder = UrlBuilder.new(repo, build, token)
    expect(builder.download_url).to eq url
    expect(builder.download_cmd).to eq "curl #{url}"
  end

  describe Parser do
    let(:json_text) { File.read("spec/samples/#{build}.json") }
    let(:parser) { Parser.new(text: json_text) }

    it "parses" do
      expect(parser.json[0].keys).to match_array %w[node_index path pretty_path url]
      expect(parser.urls).to include(
        "https://71855-5513444-gh.circle-artifacts.com/3/home/circleci/tinypulse/tmp/test-results/cucumber/tests/release.cucumber"
      )
    end

    it "extracts filenames" do
      expect(parser.filenames).to include("3-release.cucumber")
    end
  end

  describe CukeBuilder do
  end
end
