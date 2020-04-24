module MdEmoji
  class Render < Redcarpet::Render::HTML
    def initialize(options={})
      @options = options.merge(:no_intra_emphasis => true)
      super @options
    end

    def paragraph(text)
      text.gsub!("\n", "<br>\n") if @options[:hard_wrap]

      "<p>#{replace_emoji(text)}</p>\n"
    end

    def list_item(text, list_type)
      "<li>#{replace_emoji(text)}</li>"
    end

    def header(text, header_level)
      "<h#{header_level}>#{replace_emoji(text)}</h#{header_level}>"
    end

    # Replaces valid emoji characters, ie :smile:, with img tags
    #
    # Valid emoji charaters are listed in +MdEmoji::EMOJI+
    def replace_emoji(text)
      text.gsub(/:([^\s:])+:/) do |emoji|

        emoji_code = emoji #.gsub("|", "_")
        emoji      = emoji_code.gsub(":", "")

        if MdEmoji::EMOJI.include?(emoji)
          file_name    = "#{emoji.gsub('+', 'plus')}.png"

          %{<img src="/assets/emojis/#{file_name}" class="emoji" } +
            %{title="#{emoji}" alt="#{emoji}">}
        else
          emoji_code
        end
      end
    end

    private

    # Returns +true+ if emoji are present in +text+, otherwise returns +false+
    def include_emoji?(text)
      text && text[/:\S+:/]
    end
  end
end
