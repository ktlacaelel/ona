module Ona

  class Instructions

    def initialize instruction_matcher, target_matcher
      define_instruction_matcher instruction_matcher
      define_target_matcher target_matcher
    end

    def define_command_string command_string
      @command_string = command_string
    end

    def define_instruction_matcher matcher_regex
      @instruction_matcher = matcher_regex
    end

    def define_target_matcher matcher_regex
      @target_matcher = matcher_regex
    end

    def targets
      @command_string.scan(@target_matcher)
    end

    def instructions
      @command_string.scan(@instruction_matcher)
    end

    def group_targets_by_instruction
      group  = []
      chunks = (@command_string.split(@instruction_matcher) - [""])
      return group if chunks.size != instructions.size
      chunks.each_with_index do |instruction_targets, index|
        instruction_targets = (instruction_targets.scan(@target_matcher) - [])
        group << { instructions[index] => instruction_targets }
      end
      group
    end

  end

end
