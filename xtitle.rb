require 'barr/block'

module Barr
  module Blocks
    class Xtitle < Block

      def update!
        @output = sys_cmd
      end

      private

      def sys_cmd
        `xtitle`.chomp
      end
    end
  end
  
end
