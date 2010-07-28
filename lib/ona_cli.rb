module Ona

  class Cli

    FRINED_ACTIONS = %q{deploy setup}
    LONE_ACTIONS = %q{list ls}

    def initialize(stack)
      @stack = stack
    end

    def selected_servers string
      @stack.find_all(*string.scan(/\d+/).map { |id| id.to_i })
    end

    def unknown_command
      puts 'Unknown command.'
      help
    end

    def help
      puts "
      Ona -- Deployment simplified.

      help          # show this help

      ls            # short list for available servers
      list 1        # detailed list for a specific server
      list 1 2 3    # detailed list for servers 1 3 and 3

      deploy 1      # Deploy a specific server
      deploy 1 2 3  # Deploy servers with ids: 1 2 and 3

      setup 1       # Upload ssh-keys and bootstrap server
      setup 1 2 3   # Setup servers with ids: 1 2 and 3

      quit          # Setup servers with ids: 1 2 and 3

      "
    end

    def list string
      selected_servers(string).each do |server|
        puts server.to_s
      end
    end

    def ls
      @stack.to_a.each do |server|
        puts server.to_short_s
      end
    end

    def deploy string
      selected_servers(string).each do |server|
        system server.deploy
      end
    end

    def setup string
      install_ssh_keys string
      bootstrap string
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
