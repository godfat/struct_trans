
require 'struct_trans/test'

describe 'from README.md' do
  readme = File.read("#{__dir__}/../README.md")
  codes  = readme.scan(/``` ruby(.+?)```/m).map(&:first)

  Context = Class.new{
    def results; @results ||= []; end
    def p res  ; results << res ; end

    def verify expects
      results.zip(expects).each do |(res, exp)|
        res.should.eq instance_eval(exp)
      end
    end
  }

  codes.each.with_index do |code, index|
    would 'pass from README.md #%02d' % index do
      context = Context.new
      context.instance_eval(code, 'README.md', 0)
      context.verify(code.scan(/# (.+)/).map(&:first))
    end
  end
end
