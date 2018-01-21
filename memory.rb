require 'barr/block'

module Barr
  module Blocks
    class Memory < Block

      def update!
        @output = sys_cmd
      end

      private

      def sys_cmd
        `free -h | grep 'Mem:' | awk '{printf "%s / %s", $(NF-4), $(NF-5)}'`.chomp
      end
    end
  end
  
end
