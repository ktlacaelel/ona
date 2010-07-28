module Ona

  class Server

    attr_accessor :id, :role, :ip, :pass, :desc, :dna

    def load_block id, &block
      @id = id
      yield(self)
    end

    def setup_ssh
      "rake upload_ssh_key server=root@#{ip} pass=#{pass} key=#{local_key}"
    end

    def say_deployed
      "say #{desc} deployed"
    end

    def say_finished_setup
      "say #{desc} setup terminated"
    end

    def bootstrap
      "rake bootstrap server=root@#{ip}"
    end

    def deploy
      "rake cook server=root@#{ip} dna=#{dna} instance_role=#{role}"
    end

    def to_ssh user
"osascript 2>/dev/null <<EOF
    tell application \"Terminal\"
        activate
        do script with command \"ssh #{user}@#{ip}\"
    end tell
EOF"
    end

    def to_short_s
      "#{id}".ljust(5) + "#{desc}"
    end

    def to_s
      "
  #{id} - #{desc}

      Id           #{id}
      Ip           #{ip}
      Dna          #{dna}
      Role         #{role}
      Password     #{pass}

      ssh root@#{ip}
      "
    end

    def local_key
      File.join(ENV['HOME'], '.ssh/id_rsa.pub')
    end

  end

end
