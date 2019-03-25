require_relative '../rspec_helper'

describe Nfe::ApiResource do
  class TestClass
    include Nfe::ApiResource
  end

  before(:each) do
    Nfe.api_key('e12cmDevG5iLhSd9Y7BOpxynL86Detjd2R1D5jsP5UGXA8gwxug0Vojl3H9TIzBpbhI')
  end

  describe '#url_encode' do
    let(:array_str) { '[1,2,3]' }
    subject { TestClass.url_encode array_str }

    it { is_expected.to eq '%5B1%2C2%2C3%5D' }
  end

  describe '#encode' do
    let(:params) { { key: 'value', other_key: 'other_value' } }
    subject { TestClass.encode params }

    it { is_expected.to eq 'key=value&other_key=other_value' }
  end

  describe '#api_request' do
    let(:endpoint) { '/companies' }
    let(:method) { :get }
    let(:params) { { key: 'value' } }

    context 'execution is successful' do
      it 'uses RestClient::Request to perform request' do
        VCR.use_cassette('api_resource/successful_request') do
          result = TestClass.api_request(endpoint: endpoint, method: method, params: params)
          expect(result['companies']).to be_a Array
        end
      end
    end

    context 'execution raises RestClient::ExceptionWithResponse' do
      subject { TestClass.api_request(endpoint: endpoint, method: method) }

      it 'raises a NfeError with details' do
        VCR.use_cassette('api_resource/failed_request') do
          expect { subject }.to raise_error do |error|
            expect(error).to be_a Nfe::NfeError
            expect(error.http_status).to eq 404
            expect(error.json_message).to eq(message: 'some error')
            expect(error.http_message).to eq(message: 'some error')
            expect(error.message).to eq 'some error'
          end
        end
      end
    end
  end
end
