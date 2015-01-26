# Documentation for RedCarpet: https://github.com/vmg/redcarpet
class MarkdownWriter

  def self.to_html(markdown)
    renderer = Redcarpet::Render::HTML.new(filter_html: false,
    no_styles: true,
    no_images: false,
    with_toc_data: false,
    link_attributes: {:target => "_blank"}
    )
    converter = Redcarpet::Markdown.new(renderer)
    output = converter.render(markdown)
  end

  def self.update_html(obj)
    obj.content_html = MarkdownWriter.to_html(obj.content_md)
  end

end
