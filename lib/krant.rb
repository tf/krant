require 'krant/engine'
require 'krant/version'

# Global settings
module Krant
  # Determines for which locales text boxes should be displayed in the
  # broadcast message edit form.
  mattr_accessor :broadcast_message_locales
  self.broadcast_message_locales = [:en, :de]

  # Unshift to Active Admin load path.
  def self.active_admin_load_path
    Dir[Krant::Engine.root.join('admin')].first
  end

  # Adds a menu item to open a news page. Displays an indicator if
  # there are unseen news items. Supports all parameters supported by
  # `ActiveAdmin::Menu#add`. Required options:
  #
  # @param menu [ActiveAdmin::Menu] The menu object yielded by
  #   `ActiveAdmin::Namespace#build_menu`.
  #
  # @param news [Krant::News] The news collection to take news item
  #   from.
  #
  # @param url [Proc|String] Url of the news page.
  def self.add_active_admin_news_menu_item_to(menu, news:, **options)
    menu.add(label: -> { I18n.t('krant.admin.news_menu_item.unseen') },
             id: 'krant_news_menu_item_unseen',
             if: -> { news.unseen_items?(for_user: current_active_admin_user) },
             html_options: { class: 'krant-news-menu-item krant-news-menu-item-unseen' },
             **options)

    menu.add(label: -> { I18n.t('krant.admin.news_menu_item.no_unseen') },
             id: 'krant_news_menu_item_no_unseen',
             if: -> { !news.unseen_items?(for_user: current_active_admin_user) },
             html_options: { class: 'krant-news-menu-item krant-news-menu-item-no-unseen' },
             **options)
  end
end
