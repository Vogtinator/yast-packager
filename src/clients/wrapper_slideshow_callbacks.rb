# encoding: utf-8

# Module:		wrapper_slideshow_callbacks.ycp
#
# Authors:		Ladislav Slezak <lslezak@novell.com>
#
# Purpose:		A wrapper for SlideShowCallbacks:: module,
#			required for removing the cyclic import dependency
#			between SlideShowCallbacks.ycp and SlideShow.ycp
#
# $Id$
module Yast
  class WrapperSlideshowCallbacksClient < Client
    def main
      @func = Convert.to_string(WFM.Args(0))
      @param = []

      # get parameters if available
      if Ops.greater_or_equal(Builtins.size(WFM.Args), 2)
        @param = Convert.to_list(WFM.Args(1))
      end

      @ret = nil

      Builtins.y2milestone(
        "SlideShowCallbacks:: wrapper: func: %1, args: %2",
        @func,
        @param
      )

      Yast.import "SlideShowCallbacks"

      # call the required function
      if @func == "InstallSlideShowCallbacks"
        @ret = SlideShowCallbacks.InstallSlideShowCallbacks
      elsif @func == "RemoveSlideShowCallbacks"
        @ret = SlideShowCallbacks.RemoveSlideShowCallbacks
      else
        # the required function is not known
        Builtins.y2error("unknown function: %1", @func)
      end

      Builtins.y2milestone("SlideShowCallbacks wrapper: result: %1", @ret)

      deep_copy(@ret)
    end
  end
end

Yast::WrapperSlideshowCallbacksClient.new.main
