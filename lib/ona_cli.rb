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

      help              # show this help

      ls                # short list for available servers
      show 1            # detailed info for a specific server
      show 1 2 3        # detailed info for servers 1 3 and 3

      deploy 1          # Deploy a specific server
      deploy 1 2 3      # Deploy servers with ids: 1 2 and 3

      setup 1           # Upload ssh-keys and bootstrap server
      setup 1 2 3       # Setup servers with ids: 1 2 and 3

      ssh-root 1        # Open a ssh session as root to a remote server
                        # (new window)

      ssh-root 1 2 3    # Open three ssh sessions to 1 2 and 3
                        # (new window)

      ssh-deploy 1      # Open a ssh session as deploy to a remote server
                        # (new window)

      ssh-deploy 1 2 3  # Open three ssh sessions to 1 2 and 3
                        # (new window)

      quit              # termintes the ona shell.

      "
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
