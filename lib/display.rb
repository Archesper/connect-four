# frozen_string_literal: true

module Display
  EMPTY_CELL = "\u25CB"
  YELLOW_DISC = "\e[93m\u25CF\e[m"
  RED_DISC = "\e[31m\u25CF\e[m"
  TOP_BOX_FRAME = " \u250C#{"\u2500" * 16}\u2510\n"
  BOTTOM_BOX_FRAME = " \u2514#{"\u2500" * 16}\u2518\n"
  VERTICAL_LINE = "\u2502"
end