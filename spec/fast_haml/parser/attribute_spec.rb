require 'spec_helper'

RSpec.describe FastHaml::Parser, type: :parser do
  describe 'attribute' do
    it 'parses attributes' do
      expect(render_string('%span{class: "x"} hello')).to eq('<span class="x">hello</span>')
    end

    it 'parses attributes' do
      expect(render_string('%span{class: "x", "old" => 2} hello')).to eq('<span class="x" old="2">hello</span>')
    end

    it 'escapes' do
      expect(render_string(%q|%span{class: "x\"y'z"} hello|)).to eq('<span class="x&quot;y&#39;z">hello</span>')
    end

    it 'renders only name if value is true' do
      expect(render_string(%q|%span{foo: true, bar: 1} hello|)).to eq('<span bar="1" foo>hello</span>')
    end

    it 'renders nested attributes' do
      expect(render_string(%q|%span{data: {foo: 1, bar: 'baz'}} hello|)).to eq('<span data-bar="baz" data-foo="1">hello</span>')
    end

    it 'renders code attributes' do
      expect(render_string(<<HAML)).to eq('<span bar="2" foo="1">hello</span>')
- data = { foo: 1, bar: 2 }
%span{data} hello
HAML
    end
  end
end
