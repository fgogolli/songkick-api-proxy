require 'spec_helper'
describe 'songkick-api-proxy' do

  context 'with defaults for all parameters' do
    it { should contain_class('songkick-api-proxy') }
  end
end
