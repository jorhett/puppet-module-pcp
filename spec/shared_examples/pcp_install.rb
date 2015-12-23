shared_examples_for 'pcp::install' do |facts|

  it { is_expected.to have_package_resource_count(1) }
  it { is_expected.to contain_package('pcp').with_ensure('present') }

  context 'when extra_packages defined' do
    let(:params) {{ :extra_packages => ['pcp-foo'] }}
    it { is_expected.to have_package_resource_count(2) }
    it { is_expected.to contain_package('pcp').with_ensure('present') }
    it { is_expected.to contain_package('pcp-foo').with_ensure('present') }
  end

end