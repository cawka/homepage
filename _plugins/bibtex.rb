require 'jekyll/scholar'

module Jekyll
  class Scholar

    module Utilities
      def bibtex_files
        @bibtex_files ||= config['bibliography']
      end
    end

    class Details < Page
      include Scholar::Utilities

      def initialize(site, base, dir, entry)
        @site, @base, @dir = site, base, dir

        @config = Scholar.defaults.merge(site.config['scholar'] || {})

        @name = entry.key.to_s.gsub(/[:\s]+/, '_')
        @name << '.html'

        process(@name)
        read_yaml(File.join(base, '_layouts'), config['details_layout'])

        data.merge!(reference_data(entry))
        data['title'] = data['entry']['title'] if data['entry'].has_key?('title')
      end

    end

    class DetailsGenerator < Generator
      include Scholar::Utilities

      safe true
      priority :high

      attr_reader :config

      def generate(site)
        @site, @config = site, Scholar.defaults.merge(site.config['scholar'] || {})

        if generate_details?
          entries.each do |entry|
            to_remove = entry.field_names.select{ |name| name.to_s =~ /bdsk-.*/ }
            to_remove.each{ |field| entry.delete(field) }
            
            details = Details.new(site, site.source, File.join('', details_path), entry)
            details.render(site.layouts, site.site_payload)
            details.write(site.dest)

            site.pages << details

            site.regenerator.add_dependency(
              site.in_source_dir(details.path),
              bibtex_path
            )
          end

        end
      end

    end
    
  end
end
