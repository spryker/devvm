# Helpers
def colorize(text, color_code); "#{color_code}#{text}\033[0m"; end
def red(text); colorize(text, "\033[31m"); end
def yellow(text); colorize(text, "\033[33m"); end
def green(text); colorize(text, "\033[32m"); end
def bold(text); colorize(text, "\033[1;97m"); end
