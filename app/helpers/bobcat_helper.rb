# Rails helper module for bobcat layout.
# Assumes 
#     - Rails helper function
#     - AuthPdsNyu controller methods
module BobcatHelper
  require 'institutions'

  # Title of the Applications
  def title
    "BobCat"
  end
  
  def application
    title
  end

  def suite
    title
  end
  
  # Stylesheets for the layout.
  def stylesheets
    stylesheet_link_tag "application"
  end

  # Javascripts to include.
  def javascripts
    javascript_include_tag "application"
  end

  # Login link and icon
  def login
    (current_user) ?
      content_tag(:i, nil, :class => "icons-famfamfam-lock") + 
        link_to("Log-out #{current_user.firstname}", logout_url, :class=>"logout") :
      content_tag(:i, nil, :class => "icons-famfamfam-lock_open") + 
        link_to("Login", login_url, :class=>"login")
  end

  # Breadcrumbs
  def breadcrumbs
    @breadcrumbs ||= []
    if @breadcrumbs.empty?
      breadcrumbs = views["breadcrumbs"]
      @breadcrumbs << link_to(breadcrumbs["title"], breadcrumbs["url"])
      @breadcrumbs << link_to('BobCat', "http://bobcat.library.nyu.edu/#{views["dir"]}")
    end
  end

  # Sidebar partial
  def sidebar
    render :partial => "#{current_primary_institution.views["dir"]}/sidebar" unless current_primary_institution.nil?
  end

  # Tabs
  def tabs
    @tabs ||= views["tabs"].collect{|code, values|
      values["code"] = code
      values["url"], values["klass"] = root_url, "active" if active_tab? code
      values["link"] = link_to_with_popover(values["display"], values["url"], values["tip"], "tab")
      values
    }
  end
  
  def active_tab? code
    @institution.active_tab.eql? code if @institution.respond_to? :active_tab
  end
  
  # Footer
  def footer
    javascript_include_tag "https://libraryh3lp.com/js/libraryh3lp.js?multi"
  end

  def views
    @views ||= institution.views
  end

  def institution
    @institution ||= (current_primary_institution.nil? or 
      institutions[current_primary_institution.name].nil?) ? 
        default_institution : institutions[current_primary_institution.name]
  end
  
  def default_institution
    @default_institution ||= Institutions.defaults.first
  end

  def institutions
    @institutions || Institutions.institutions
  end

  def link_to_with_popover(*args)
    klass = args.delete_at 3
    content = args.delete_at 2
    args[2] = {"title" => args[0], "data-content" => "<div class=\"#{klass}\">#{content}</div>", :rel => "popover", :class => "#{klass}"}
    link_to(*args)
  end
end