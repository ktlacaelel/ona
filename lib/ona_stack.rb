module Ona

  class Stack

    def initialize
      @list = []
      @id = 0
    end

    def append &block
      @id += 1
      server = Server.new
      server.load_block(@id, &block)
      @list << server
    end

    def find num
      @list.each do |server|
        return server if server.id == num
      end
      nil
    end

    def find_all *args
      args.map { |id| find id }.compact
    end

    def exists? num
      return false if find(num).nil?
      true
    end

    def to_a
      @list
    end

  end

end
