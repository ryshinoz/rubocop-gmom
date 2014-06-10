module RuboCop
  module Cop
    module Style
      class NoSpaceInsideBlockPipes < Cop
        def on_block(node)
          _method, args, _body = *node
          left_pipe, right_pipe = args.loc.begin, args.loc.end
          first_arg, end_arg = args.children.first.loc.expression, args.children.last.loc.expression
          source_buffer = node.loc.expression.source_buffer
          # range = Parser::Source::Range.new(source_buffer, left_pipe.end_pos, right_pipe.begin_pos)

          # | a, b|
          range = Parser::Source::Range.new(source_buffer, left_pipe.end_pos, first_arg.begin_pos)
          source = range.source

          if source =~ /\s/
            offense(source_buffer, left_pipe.begin_pos, first_arg.end_pos, 'Space inside | (left) detected.')
          end

          # |a, b |
          range = Parser::Source::Range.new(source_buffer, end_arg.end_pos, right_pipe.begin_pos)
          source = range.source
          if source =~ /\s/
            offense(source_buffer, end_arg.begin_pos, right_pipe.end_pos, 'Space inside | (right) detected.')
          end
        end

        def offense(sb, begin_pos, end_pos, msg)
          range = Parser::Source::Range.new(sb, begin_pos, end_pos)
          add_offense(range, range, msg)
        end
      end
    end
  end
end
