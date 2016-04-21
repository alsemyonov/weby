require 'weby'

class Weby
  module Helpers
    # @param [String] text
    def title(text)
      content_for(:title) { text }
      text
    end

    # @param [String] text
    # @return [String, nil]
    def head_title(text = nil)
      yield_content(:title).presence || current_resource.data['title'].presence || data.site['title'] || text
    end

    # Inspect +object+
    # @param [Object] object object to inspect
    # @param [Object] condition true in development, false elsewhere
    # @return [String] Inspect +object+ wrapped in `<code name="ruby">` using standard Ruby inspection
    def inspect(object, condition = environment.development?)
      content_tag(:code, escape_html(object.inspect), class: 'ruby') if condition
    end

    # Debug +object+
    # @param [Object] object object to inspect
    # @param [Object] condition true in development, false elsewhere
    # @return [String] YAML representation of +object+ wrapped in `<pre><code class="yaml">`
    def debug(object, condition = environment.development?)
      content_tag(:pre, content_tag(:code, YAML.dump(object), class: 'yaml')) if condition
    end

    def frontmatter(resource = current_resource, condition = environment.development?)
      content_tag(:pre, content_tag(:code, YAML.dump(resource.data) << '---', class: 'yaml')) if condition
    end

    # Wraps Middleman::Application#environment into `StringInquirer`
    # @return [#development?, #production?]
    def environment
      @environment ||= ActiveSupport::StringInquirer.new(app.environment.to_s)
    end

    def mail_attrs(email, mail_options = {})
      html_options = mail_options.slice!(:cc, :bcc, :subject, :body)
      mail_query = Rack::Utils.build_query(mail_options).gsub(/\+/, '%20').gsub('%40', '@')
      mail_href = "mailto:#{email}"; mail_href << "?#{mail_query}" if mail_query.present?
      html_options.merge(href: mail_href)
    end
  end
end
