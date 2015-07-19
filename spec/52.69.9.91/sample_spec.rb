require 'spec_helper'

describe package('mysql-community-server') do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end

describe service('nginx') do
  it {should be_running}
end
