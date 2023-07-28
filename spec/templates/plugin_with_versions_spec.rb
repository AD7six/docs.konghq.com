RSpec.describe 'Plugin page with multiple versions' do
  let(:page) { find_page_by_url(page_url) }
  let(:html) { Capybara::Node::Simple.new(page.output) }

  before do
    generate_site!
    render_page(page: page)
  end

  context 'versions with a specific file - _2.6.x' do
    let(:page_url) { '/hub/kong-inc/jwt-signer/2.6.x/' }

    it 'renders the content' do
      expect(html).to have_css('h2', text: '_2.6.x Description')
      expect(html).to have_css('p', text: 'content: Verify and (re-)sign one or two tokens in a request')
    end

    it 'renders metadata in the header' do
      expect(html).to have_css('.page-header--info-icon')
      expect(html).to have_css('h1#main', text: 'Kong JWT Signer')
      expect(html).to have_css('.badge.plus')
      expect(html).to have_css('.badge.enterprise')
      expect(html).to have_css('.old-version-banner')
    end
  end

  context 'versions using _index' do
    let(:page_url) { '/hub/kong-inc/jwt-signer/' }

    it 'renders the content' do
      expect(html).to have_css('h2', text: 'Manage key signing')
      expect(html).to have_css('p', text: 'If you specify')
    end

    it 'renders metadata in the header' do
      expect(html).to have_css('.page-header--info-icon')
      expect(html).to have_css('h1#main', text: 'Kong JWT Signer')
      expect(html).to have_css('.badge.plus')
      expect(html).to have_css('.badge.enterprise')
      expect(html).not_to have_css('.old-version-banner')
    end

    it 'renders the sidenav' do
      expect(html).to have_css('.docs-sidebar .accordion-item:nth-of-type(2)', text: 'Overview')
      expect(html).to have_css('.docs-sidebar .accordion-item:nth-of-type(3)', text: 'Configuration reference')
      expect(html).to have_css('.docs-sidebar .accordion-item:nth-of-type(4)', text: 'Using the plugin')
      expect(html).to have_css('.docs-sidebar .accordion-item:nth-of-type(5)', text: 'Changelog')

      how_tos = html.find('.docs-sidebar .accordion-item:nth-of-type(4)', text: 'Using the plugin')
      expect(how_tos).to have_css('.accordion-item:nth-of-type(1)', text: 'Basic config examples')
      expect(how_tos).to have_css('.accordion-item:nth-of-type(2)', text: 'Manage key signing')
      expect(how_tos).to have_css('.accordion-item:nth-of-type(3)', text: 'Nested')

      nested_how_to = how_tos.find('.accordion-item:nth-of-type(3)')
      expect(nested_how_to).to have_css('.accordion-item', text: 'Nested Tutorial Nav title')
    end
  end
end
