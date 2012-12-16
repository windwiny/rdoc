require 'rdoc/test_case'

class TestRDocParserRd < RDoc::TestCase

  def setup
    super

    @RP = RDoc::Parser

    @tempfile = Tempfile.new self.class.name
    filename = @tempfile.path

    @top_level = @store.add_file filename
    @fn = filename
    @options = RDoc::Options.new
    @stats = RDoc::Stats.new @store, 0
  end

  def teardown
    super

    @tempfile.close
  end

  def mu_pp obj
    s = ''
    s = PP.pp obj, s
    s = s.force_encoding Encoding.default_external if defined? Encoding
    s.chomp
  end

  def test_file
    assert_kind_of RDoc::Parser::Text, util_parser('')
  end

  def test_class_can_parse
    assert_equal @RP::RD, @RP.can_parse('foo.rd')
    assert_equal @RP::RD, @RP.can_parse('foo.rd.ja')
  end

  def test_scan
    parser = util_parser 'it ((*really*)) works'

    expected = doc(para('it <em>really</em> works'))
    expected.file = @top_level

    parser.scan

    assert_equal expected, @top_level.comment.parse
  end

  def test_scan_inline_verbatim
    parser = util_parser "(('Here's how inline ((*emphasis*)) is written'))"

    expected =
      doc(
        para("<tt>Here's how inline ((*emphasis*)) is written</tt>"))

    expected.file = @top_level

    parser.scan

    assert_equal expected, @top_level.comment.parse
  end

  def util_parser content
    RDoc::Parser::RD.new @top_level, @fn, content, @options, @stats
  end

end

