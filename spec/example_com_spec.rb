require 'spec_helper'

context 'example.com ' do
  let(:config) { { nameservers: '8.8.8.8', timeouts: 10 } }

  describe "example.com" do
    it { is_expected.to have_dns.with_type('A').and_address('93.184.216.34').config(config) }
    it { is_expected.to have_dns.with_type('TXT').and_data('$Id: example.com 4415 2015-08-24 20:12:23Z davids $').config(config) }

    it {
      # two expectations in one `it` block - bad style, but testing this case
      is_expected.to have_dns.with_type('A').and_address('93.184.216.34').config(config)
      is_expected.to have_dns.with_type('TXT').and_data('$Id: example.com 4415 2015-08-24 20:12:23Z davids $').config(config)
    }
  end

  describe 'DNS tests' do
    it 'passes some tests' do
      expect('www.example.com').to have_dns.with_type('TXT').and_data('v=spf1 -all').config(config)
      expect('www.example.com').to have_dns.with_type('A').and_address('93.184.216.34').config(config)
      expect('www.example.com').to have_dns.with_type('AAAA').and_address('2606:2800:220:1:248:1893:25c8:1946').config(config)
    end

    it 'checks number of RRSIG records' do
      expect('example.com').to have_dns.with_type('RRSIG').at_least(8).config(config)
    end

    it 'checks with configuration' do
      expect('example.com').to have_dns.with_type('A').and_address('93.184.216.34').config(nameserver: '8.8.4.4')
    end
  end
end
