module Ona

  class Cli

    TRANSLATION = {
      'show'   => { :method => :show,      :id_required => true   },
      'setup'  => { :method => :setup,     :id_required => true   },
      'deploy' => { :method => :deploy,    :id_required => true   },
      'ssh#'   => { :method => :ssh_root,  :id_required => true   },
      'ssh'    => { :method => :ssh_deploy,:id_required => true   },
      'go'     => { :method => :go_deploy, :id_required => true   },
      'go#'    => { :method => :go_root,   :id_required => true   },
      'http'   => { :method => :http,      :id_required => true   },
      'key'    => { :method => :key,       :id_required => true   },
      'keys'   => { :method => :keys,      :id_required => true   },
      'rake'   => { :method => :rake,      :id_required => true   },
      'ls'     => { :method => :ls,        :id_required => false  },
      'help'   => { :method => :help,      :id_required => false  },
    }

    def initialize(stack)
      @stack        = stack
      @instructions = Ona::Instructions.new(/[a-z]+[#]*/, /\d+/)
    end

    def parse command_string
      # Handle this separately for now.
      return run_instruction('ls', 0)   if command_string == 'ls'
      return run_instruction('help', 0) if command_string == 'help'

      @instructions.define_command_string(command_string)
      group = @instructions.group_targets_by_instruction
      copy  = group.dup
      copy.pop

      # Only last group has ids?
      if copy.all? { |x| x.values == [[]] }
        @instructions.instructions.each do |instruction|
          @instructions.targets.each do |target|
            run_instruction instruction, target
          end
        end
        return
      end

      # Run by group.
      group.each do |hash|
        instruction, targets = hash.to_a[0][0], hash.to_a[0][1]
        targets.each do |target|
          run_instruction instruction, target
        end
      end
    end

    def run_instruction instruction, target
      return unless TRANSLATION.keys.include?(instruction)
      hash = TRANSLATION[instruction]
      cmd  = "#{TRANSLATION[instruction][:method]}"
      if (hash[:id_required])
        cmd << "(#{target.to_i})"
      end
      eval cmd
    end

    def help
      puts "
      Ona -- Deployment simplified.

      deploy 1          # Deploy a specific server
      exit              # Same as *quit*
      go                # Go to server without opening a new window.
      go#               # Same as go but do it as root.
      help              # Show this help
      http 1            # Open the server in default browser.
      key 1             # Uploads my public ssh-key to remote server (root)
      keys              # Uploads my public ssh-key to all servers (root)
      ls                # Short list for available servers
      quit              # Termintes the ona shell.
      rake              # Shows rake tasks.
      setup 1           # Upload ssh-keys and bootstrap server
      show 1            # Detailed info for a specific server
      ssh 1             # Open a ssh session as *deploy* on remote server (new window)
      ssh# 1            # Open a ssh session as *root* to a remote server (new window)

      --

      Note: 1 is a server id, you can use many ids!

      show 1 2 3        # Will display info for three servers.

      "
    end

    def http server_id
      @stack.find_all(server_id).each do |server|
        system server.to_http
      end
    end

    def key server_id
      @stack.find_all(server_id).each do |server|
        puts 'Setting up key for root'
        system server.setup_ssh
      end
    end

    def show server_id
      @stack.find_all(server_id).each do |server|
        puts server.to_s
      end
    end

    def ls
      @stack.to_a.each do |server|
        puts server.to_short_s
      end
    end

    def ssh_deploy server_id
      @stack.find_all(server_id).each do |server|
        system server.to_ssh 'deploy'
      end
    end

    def ssh_root server_id
      @stack.find_all(server_id).each do |server|
        system server.to_ssh 'root'
      end
    end

    def go_deploy server_id
      @stack.find_all(server_id).each do |server|
        system server.to_go 'deploy'
      end
    end

    def go_root server_id
      @stack.find_all(server_id).each do |server|
        system server.to_go 'deploy'
      end
    end

    def deploy server_id
      @stack.find_all(server_id).each do |server|
        prompt_for_continuation server
        system server.say_sure_to_deploy
        line = gets
        next unless line.chomp == 'yes'
        system server.deploy
        system server.say_deployed
      end
    end

    def setup server_id
      key server_id
      @stack.find_all(server_id).each do |server|
        prompt_for_continuation server
        system server.say_sure_to_setup
        line = gets
        next unless line.chomp == 'yes'
        system server.bootstrap
        system server.say_finished_setup
      end
    end

    def rake server_id
      @stack.find_all(server_id).each do |server|
        server.to_s
        server.rake.each do |task|
          puts task
        end
      end
    end

    def keys
      @stack.to_a.each do |server|
        puts 'Setting up key for root'
        system server.setup_ssh
      end
    end

    protected

    def prompt_for_continuation server
      puts server.to_s
      puts 'Type [yes] to continue. or anything else to skip.'
      print 'What to do? >'
    end

  end

end
