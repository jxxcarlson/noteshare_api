require 'spec_helper'

require_relative '../../../lib/xdoc/interactors/render_asciidoc'

describe RenderAsciidoc do

  it 'can render an asciidoc string into html' do

    expected = <<END
<div class="paragraph">
<p>This <em>is</em> a test</p>
</div>
END
    result = RenderAsciidoc.new(source_text: 'This _is_ a test').call
    assert result.rendered_text.gsub(/\s/, '') == expected.gsub(/\s/, '')

  end

end