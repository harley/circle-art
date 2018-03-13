require "circle/art/version"
require 'json'
require 'report_builder'

class UrlBuilder
  attr_reader :repo, :build, :token

  def initialize(repo, build, token = nil)
    @repo = repo
    @build = build
    @token = token

    raise "Missing repo" unless @repo
    raise "Missing build" unless @build


    system("mkdir -p downloads/#{build}/artifacts")
    system("mkdir -p downloads/builds")
  end

  def folder_path
    "downloads/#{build}/artifacts"
  end

  def json_path
    "downloads/#{build}.json"
  end

  def download_cmd
    "curl #{download_url}"
  end

  def download_json!
    # save json
    unless File.exist?(json_path)
      system(download_cmd + " --output #{json_path}")
    end
  end

  def url
    "https://circleci.com/gh/#{repo}/#{build}#artifacts"
  end

  def download_url
    "https://circleci.com/api/v1.1/project/github/#{repo}/#{build}/artifacts?circle-token=#{token}"
  end

  def download!(parser)
    if Dir[File.join(folder_path, "*")].length > 0
      puts "Already downloaded."
      return
    end

    parser.urls.each_with_index do |url, index|
      cmd = "curl #{url}?circle-token=#{token} --output downloads/#{build}/artifacts/#{parser.filenames[index]}"
      puts "🌐  #{cmd}"
      system(cmd)
    end
  end
end

class Parser
  attr_reader :json, :pattern

  # TODO: support path to file
  def initialize(path: nil, text: nil, pattern: '')
    if path
      text = File.read(path)
    end

    @json = JSON.parse(text)
    @pattern = pattern
  end

  def hashes
    @hashes ||= @json.select {|e| e["url"].split('/').last.match(pattern)}
  end

  def urls
    @urls ||= hashes.map{|e| e["url"]}
  end

  def filenames
    @filenames ||= urls.map.with_index do |e, index|
      "#{hashes[index]['node_index']}-" + e.split('/').last
    end
  end
end

class CukeBuilder
  attr_reader :build, :parser

  def initialize(build, parser)
    @build = build
    @parser = parser
    @download_path = "downloads/#{build}/artifacts"
    @report_path = "downloads/builds/#{build}"
  end

  def tests_files
    parser.filenames.grep(/tests\.cucumber/).map{|e| File.join(@download_path, e) }
  end

  def releases_files
    parser.filenames.grep(/release\.cucumber/).map{|e| File.join(@download_path, e)}
  end

  def build_reports!
    ReportBuilder.configure do |config|
      config.report_title = "Build #{build} Results"
      config.json_path = tests_files
      config.html_report_path = @report_path
      config.additional_info = {'browser' => 'CircleCI', 'build' => build, 'tests' => tests_files}
    end

    puts "building..."

    ReportBuilder.build_report
  end
end

module Circle
  module Art
    # Your code goes here...

  end
end
