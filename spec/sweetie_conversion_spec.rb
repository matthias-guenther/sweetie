require 'sweetie/conversion'

describe Sweetie::Conversion do
  let(:current_dir) { File.dirname(__FILE__) }
  let(:about_page) { File.join(current_dir, 'fixtures', 'site', 'about.html') }
  let(:site_dir) { File.join(current_dir, 'fixtures', 'site') }
  let(:sweetie) { Sweetie::Conversion }

  it 'should count links of about.html page' do
    expect(sweetie.count_link_of_one_page(about_page)).to eq(11)
  end

  it 'should count images of about.html page' do
    expect(sweetie.count_images_of_one_page(about_page)).to eq 1
  end

  it 'should count all html pages' do
    expect(sweetie.count_all_html_pages(site_dir)).to eq 8
  end

  it 'should count all links of all pages' do
    expect(sweetie.count_all_links(site_dir)).to eq 54
  end

  it 'should count all images' do
    expect(sweetie.count_all_images(site_dir)).to eq 1
  end

  it 'creates the correct build-time' do
    time = Time.now
    expected_time = "#{time.month}-#{time.day}-#{time.year}"
    allow(time).to receive(:now).and_return(time)
    expect(sweetie.build_time).to eq expected_time
  end
end

