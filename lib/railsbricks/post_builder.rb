require "fileutils"
require_relative "ui_helpers"
require_relative "version"
require_relative "string_helpers"
require_relative "file_helpers"
require_relative "config_values"

module PostBuilder

  def self.build_post(app_dir, options)
    new_line(2)
    wputs "----> Generating Post resources ...", :info

    rbricks_dir = File.dirname(__FILE__)
    add_string = ""

    # Migration
    FileUtils.cp_r(rbricks_dir + "/assets/migrations/20141010133702_create_posts.rb", app_dir + "/db/migrate")
    wputs "--> Migration created."

    # Markdown helper
    FileUtils.cp_r(rbricks_dir + "/assets/lib/markdown_writer.rb", app_dir + "/lib")
    wputs "--> MarkdownWriter helper created."

    # Routes
    FileHelpers.replace_string(/BRICK_POST_ROUTES/, FileHelpers.get_file(:brick_post_routes), app_dir + "/config/routes.rb")
    FileHelpers.replace_string(/BRICK_ADMIN_POST_ROUTES/, FileHelpers.get_file(:brick_admin_post_routes), app_dir + "/config/routes.rb")
    wputs "--> Routes updated."

    # Views
    FileUtils.cp_r(rbricks_dir + "/assets/views/pages/posts.html.erb", app_dir + "/app/views/pages")
    FileUtils.cp_r(rbricks_dir + "/assets/views/pages/show_post.html.erb", app_dir + "/app/views/pages")
    wputs "--> Views created."

    # Pages controller
    FileHelpers.replace_string(/BRICK_POSTS_CONTROLLER/, FileHelpers.get_file(:brick_posts_controller), app_dir + "/app/controllers/pages_controller.rb")
    wputs "--> Pages controller updated."

    # Navigation links
    FileHelpers.replace_string(/BRICK_POSTS/, '<li><%= link_to "Posts", posts_path %></li>', app_dir + "/app/views/layouts/_navigation_links.html.erb")
    wputs "--> Navigation links updated."

    # Base controller
    FileHelpers.replace_string(/BRICK_POST_COUNT/, '@post_count = Post.count', app_dir + "/app/controllers/admin/base_controller.rb")
    wputs "--> Base controller updated."

    # Admin views
    FileHelpers.replace_string(/BRICK_POSTS_LINK/, FileHelpers.get_file(:brick_admin_posts_link), app_dir + "/app/views/admin/base/index.html.erb")
    wputs "--> Admin view updated."

    # Admin posts controller
    FileUtils.cp_r(rbricks_dir + "/assets/controllers/admin/posts_controller.rb", app_dir + "/app/controllers/admin")
    wputs "--> Admin posts controller created."

    # Admin posts views
    FileUtils.mkdir_p(app_dir + "/app/views/admin/posts")
    FileUtils.cp_r(rbricks_dir + "/assets/views/admin/posts/.", app_dir + "/app/views/admin/posts")
    wputs "--> Admin posts views created."

    # Models
    FileHelpers.replace_string(/BRICK_POSTS_RELATION/, "\n# Relations\nhas_many :posts\n", app_dir + "/app/models/user.rb")
    FileUtils.cp_r(rbricks_dir + "/assets/models/post.rb", app_dir + "/app/models")
    wputs "--> Models created and updated."

    new_line
    wputs "----> Post resources generated.", :info

  rescue
    Errors.display_error("Something went wrong and the post resources couldn't be generated. Stopping app creation.", true)
    abort

  end

  def self.clean(app_dir)
    # Routes
    FileHelpers.replace_string(/BRICK_POST_ROUTES/, '', app_dir + "/config/routes.rb")
    FileHelpers.replace_string(/BRICK_ADMIN_POST_ROUTES/, '', app_dir + "/config/routes.rb")
    # Pages controller
    FileHelpers.replace_string(/BRICK_POSTS_CONTROLLER/, '', app_dir + "/app/controllers/pages_controller.rb")
    # Navigation links
    FileHelpers.replace_string(/BRICK_POSTS/, '', app_dir + "/app/views/layouts/_navigation_links.html.erb")
    # Base controller
    FileHelpers.replace_string(/BRICK_POST_COUNT/, '', app_dir + "/app/controllers/admin/base_controller.rb")
    # Admin views
    FileHelpers.replace_string(/BRICK_POSTS_LINK/, '', app_dir + "/app/views/admin/base/index.html.erb")
    # Models
    FileHelpers.replace_string(/BRICK_POSTS_RELATION/, '', app_dir + "/app/models/user.rb")

  rescue
    Errors.display_error("Something went wrong and some clean up tasks couldn't be performed. Stopping app creation.", true)
    abort

  end

  def self.wputs(text, highlight = :none)
    StringHelpers.wputs(text, highlight)
  end

  def self.new_line(lines=1)
    StringHelpers.new_line(lines)
  end

end
