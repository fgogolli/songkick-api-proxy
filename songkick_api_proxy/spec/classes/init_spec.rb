require 'spec_helper'
describe 'songkick_api_proxy' do

  context 'with defaults for all parameters' do
    it { should contain_class('songkick_api_proxy') }
  end
end
