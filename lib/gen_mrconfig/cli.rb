require 'fileutils'
require 'mixlib/cli'
require 'octokit'

module GenMRConfig
  class CLI
   include Mixlib::CLI

    option :build_dir,
      short: '-b BUILD_DIR',
      long: '--build_dir BUILD_DIR',
      default: Dir.pwd,
      required: true,
      description: 'the directory the cookbook sources are in'

    option :search_query,
      short: '-s QUERY',
      long: '--search-query QUERY',
      required: true,
      description: 'Github Code search query'

    def build_dir
      config[:build_dir]
    end

    def search_query
      config[:search_query]
    end

    def run
      parse_options

      client = Octokit::Client.new(netrc: true, auto_paginate: true)

      results = client.search_code(search_query)
      repos = results[:items].map {|result| result[:repository] }

      repo_urls = repos.map do |repo|
        [ repo[:name], "git@github.com:#{repo[:full_name]}.git" ]
      end.sort.to_h

      buf = []
      buf << "# gen_mrconfig: -s #{search_query}"

      repo_urls.each do |name, url|
       buf << "[#{name}]"
       buf << "checkout = git clone #{url} #{name}"
       buf << ""
      end

      unless Dir.exist?(build_dir)
        FileUtils.mkdir_p(build_dir)
      end

      File.write(File.join(build_dir, '.mrconfig'), buf.join("\n"))
    end
  end
end
