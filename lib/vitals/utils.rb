module Vitals
  module Utils
    BAD_METRICS_CHARS = Regexp.compile('[\/\-:\s]').freeze
    SEPARATOR = '.'.freeze
    def self.normalize_metric(m)
      m.gsub(BAD_METRICS_CHARS, '_')
    end
    def self.hostname
      `hostname -s`.chomp
    end
    def self.sec_to_ms(sec)
      (1000.0 * sec).round
    end
    # XXX grape specific, move this away some day?
    def self.grape_path(route)
      if route.respond_to?(:version) && route.respond_to?(:path)
        version = route.version
        path    = route.path
      else
        # deprecated methods
        version = route.route_version
        path    = route.route_path
      end
      
      path = path.dup[1..-1]          # /foo/bar/baz -> foo/bar/baz
      path.sub!(/\(\..*\)$/, '')                  # (.json) -> ''
      path.sub!(":version", version) if version   # :version -> v1
      path.gsub!(/\//, self.path_sep)     # foo/bar -> foo.bar
      path
    end

    def self.path_sep
      @path_sep
    end

    def self.path_sep=(val)
      @path_sep = val
    end
  end
end
