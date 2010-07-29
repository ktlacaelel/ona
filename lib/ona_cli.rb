module Ona

  class Cli

    def initialize(stack)
      @stack = stack
    end

    def selected_servers string
      @stack.find_all(*string.scan(/\d+/).map { |id| id.to_i })
    end

    def help
      puts "
      Ona -- Deployment simplified.

      deploy 1          # Deploy a specific server
      help              # show this help
      http 1            # Open the servers in default browser.
      key 1             # Uploads my public ssh-key to remote server (root)
      ls                # short list for available servers
      quit              # termintes the ona shell.
      setup 1           # Upload ssh-keys and bootstrap server
      show 1            # detailed info for a specific server
      ssh 1             # Open a ssh session as deploy to a remote server
      ssh# 1            # Open a ssh session as root to a remote server

      --

      Note: 1 is a server id, you can use many ids!

      show 1 2 3        # will display info for three servers.

      "
    end

    def http string
      selected_servers(string).each do |server|
        system server.to_http
      end
    end

    def key string
      selected_servers(string).each do |server|
        system server.setup_ssh
      end
    end


    def show string
      selected_servers(string).each do |server|
        puts server.to_s
      end
    end

    def ls
      @stack.to_a.each do |server|
        puts server.to_short_s
      end
    end

    def ssh_deploy string
      selected_servers(string).each do |server|
        system server.to_ssh 'deploy'
      end
    end

    def ssh_root string
      selected_servers(string).each do |server|
        system server.to_ssh 'root'
      end
    end

    def deploy string
      selected_servers(string).each do |server|
        puts server.to_s
        system server.say_sure_to_deploy
        puts 'Type [yes] to continue. or anything else to skip.'
        print 'What to do? :'
        line = gets
        next unless line.chomp == 'yes'
        system server.deploy
        system server.say_deployed
      end
    end

    def setup string
      install_ssh_keys string
      bootstrap string
      system server.say_finished_setup
    end

    protected

    def bootstrap string
      selected_servers(string).each do |server|
        system server.bootstrap
      end
    end

    def install_ssh_keys string
      selected_servers(string).each do |server|
        system server.setup_ssh
      end
    end

  end

end
