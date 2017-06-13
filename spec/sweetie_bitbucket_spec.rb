require 'sweetie/bitbucket'

describe Sweetie::Bitbucket do
  let(:current_dir) { File.dirname(__FILE__) }
  let(:repositories) { File.join(current_dir, 'fixtures', 'bitbucket', 'repositories.json') }
  let(:expected_repositories) { File.join(current_dir, 'fixtures', 'bitbucket', 'expected_repositories.txt') }
  let(:site_dir) { File.join(current_dir, 'fixtures', 'jekyll', 'site') }
  let(:svn_hash) { { svn: '2011-10-16' } }

  subject {Sweetie::Bitbucket.new}

  it 'parses a json file' do
    # gsub replace trailing newline at the end of the file
    changeset_expectation = File.open(expected_repositories).read.delete("\n")
    changeset = File.open(repositories).read
    changeset = subject.parse_json(changeset).to_s
    expect(changeset).to eq changeset_expectation
  end

  it 'gets the names of the repositories' do
    json_repositories = File.open(repositories).read
    expected_names = ['pmwiki-linkicons-recipe',
                      'pmwiki-dropcaps-recipe',
                      'pmwiki-headlineimage-recipe',
                      'pmwiki-syntaxlove-recipe',
                      'pmwiki-twitter-recipe',
                      'presentations',
                      'vocabularly',
                      'ruby-scripts',
                      'rails-sample-app']
    expect(subject.get_repositories_changes(json_repositories).keys).to eq expected_names
  end

  it 'get the changesets with name and date of the repositories' do
    json_repositories = File.open(repositories).read
    expected_changesets = { 'pmwiki-linkicons-recipe' => '2017-02-26',
                            'pmwiki-dropcaps-recipe' => '2017-02-24',
                            'pmwiki-headlineimage-recipe' => '2017-02-25',
                            'pmwiki-syntaxlove-recipe' => '2017-02-26',
                            'pmwiki-twitter-recipe' => '2017-02-26',
                            'presentations' => '2017-01-15',
                            'vocabularly' => '2013-01-26',
                            'ruby-scripts' => '2014-05-25',
                            'rails-sample-app' => '2013-01-26' }
    expect(subject.get_repositories_changes(json_repositories)).to eq expected_changesets
  end

  it 'parses a timestamp' do
    timestamp = '2011-04-20 11:31:39'
    expect(subject.parse_timestamp(timestamp)).to eq '2011-04-20'
  end

  it 'creates a string representation of a repository for jekyll config' do
    repository = { pmwiki: '2011-10-26' }
    expect(subject.entry_text_jekyll(repository.keys.first, repository.values.first)).to eq 'pmwiki: 2011-10-26'
  end

  it 'creates a string representation of a repository for jekyll config' do
    repository = { pmwiki: '2011-10-26' }
    expect(subject.entry_text_middleman(repository.keys.first, repository.values.first)).to eq 'set :pmwiki, 2011-10-26'
  end

  it 'writes repository changes to config file for jekyll project' do
    hash = { svn: '2011-10-26', pmwiki: '2011-10-26' }
    config = File.join(current_dir, 'fixtures', 'jekyll', '_config.yml')

    subject.config = config
    subject.write_repository_changes(hash)
    config_yml_content = File.open(config).read

    expect(config_yml_content).to include 'svn: 2011-10-26'
    expect(config_yml_content).to include 'pmwiki: 2011-10-26'

    # remove variables from the text-file
    text = config_yml_content.delete("pmwiki: 2011-10-26\n").delete("svn: 2011-10-26\n")
    config_yml_content = File.open(config, 'w')
    config_yml_content.puts text
    config_yml_content.close
  end

  it 'writes repository changes to config file for middleman project' do
    hash = { svn: '2011-10-26', pmwiki: '2011-10-26' }
    config = File.join(current_dir, 'fixtures', 'middleman', 'config.rb')

    subject.config = config
    subject.write_repository_changes(hash)
    config_yml_content = File.open(config).read

    expect(config_yml_content).to include 'set :svn, 2011-10-26'
    expect(config_yml_content).to include 'set :pmwiki, 2011-10-26'

    # remove variables from the text-file
    text = config_yml_content.delete("set :svn, 2011-10-26\n").delete("set :pmwiki, 2011-10-26\n")
    config_yml_content = File.open(config, 'w')
    config_yml_content.puts text
    config_yml_content.close
  end
end

