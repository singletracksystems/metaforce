shared_examples 'a client' do
  describe 'when the session id expires' do
    let(:exception) { Savon::SOAPFault.new(HTTPI::Response.new(403, {}, ''), nil) }
    let(:savon1) { double('savon1') }

    before do
      allow(client).to receive(:client).and_return(savon1)
      allow(savon1).to receive(:call).and_raise(exception)
      allow(exception).to receive(:message).and_return('INVALID_SESSION_ID')
    end

    context 'and no authentication handler is present' do
      before do
        allow(client).to receive(:authentication_handler).and_return(nil)
      end

      it 'raises the exception' do
        expect { client.send(:request, :foo) }.to raise_error(exception)
      end
    end

    context 'and an authentication handler is present' do
      let(:handler) do
        proc { |client, options| { :session_id => 'foo' } }
      end
      let(:savon2) { double('savon2') }
      let(:response) do
        double('response', body: Hashie::Mash.new(foo_response: { result: '' }))
      end

      before do
        allow(client).to receive(:authentication_handler).and_return(handler)
      end

      it 'calls the authentication handler and resends the request via a fresh client' do
        allow(client).to receive(:client).and_return(savon1, savon2)
        expect(savon1).to receive(:call).with(:foo).once.and_raise(exception)
        expect(savon2).to receive(:call).with(:foo).once.and_return(response)
        expect(handler).to receive(:call).and_call_original
        client.send(:request, :foo)
      end
    end
  end
end
