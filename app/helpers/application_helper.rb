# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def action_link(action, path, options = {})
    case action
      when "delete", :delete
        link_to( 
          image_tag(
            "gnome/gnome-delete.png",
            :class => 'links',
            :alt => 'Delete',
            :title => 'Delete'
          ) + "#{options[:text]}",
        path, :class => options[:class] ? options[:class] : "action_link", :confirm => "Are you sure?", :method => :delete )
      when "edit", :edit
        link_to( 
          image_tag(
            "gnome/gnome-edit.png",
            :class => 'links',
            :alt => 'Edit',
            :title => 'Edit'
          ) + "#{options[:text]}",
        path, :class => options[:class] ? options[:class] : "action_link" )
      when "help", :help
        link_to(
          image_tag(
            "gnome/gnome-dialog-question.png",
            :class => 'links',
            :alt => 'Help',
            :title => 'Help'
          ) + "#{options[:text]}",
        path, :class => options[:class] ? options[:class] : "action_link", :popup => true )
      when "new", :new
        link_to( 
          image_tag(
            "gnome/gnome-document-new.png",
            :class => 'links',
            :alt => 'New',
            :title => 'New'
          ) + "#{options[:text]}",
        path, :class => options[:class] ? options[:class] : "action_link" )
      when "show", :show
        link_to( 
          image_tag(
            "gnome/gnome-view.png",
            :class => 'links',
            :alt => 'Show',
            :title => 'Show'
          ) + "#{options[:text]}",
        path, :class => options[:class] ? options[:class] : "action_link" )
      when "submit", :submit
        link_to( 
          image_tag(
            "gnome/gnome-document-save.png",
            :class => 'links',
            :alt => 'Submit',
            :title => 'Submit'
          ) + "#{options[:text]}",
        "javascript:document.forms.#{path}.submit();", :class => options[:class] ? options[:class] : "action_link" )
      when "remote_submit", :remote_submit
        link_to_remote(
          image_tag(
            "gnome/gnome-document-save.png",
            :class => options[:class] ? options[:class] : 'links',
            :alt => 'Submit',
            :title => 'Submit'
          ) + "#{options[:text]}",
        :url => path, :update => options[:update], :submit => options[:submit], :complete => "$('#{options[:submit]}').reset();")
      when "remote_delete", :remote_delete
        link_to_remote(
          image_tag(
            "gnome/gnome-delete.png",
            :class => options[:class] ? options[:class] : 'links',
            :alt => 'Delete',
            :title => 'Delete'
          ) + "#{options[:text]}",
        :url => path, :update => options[:update], :confirm => "Are you sure?", :method => :delete ) 
      else
      link_to action, path, :class => options[:class] ? options[:class] : "action_link"
    end # case action
  end # def action_link

  def back_img_link(options = {})
    raw "<span class='delete_img_link' >" + link_to(
      image_tag(
        "gnome/gnome-emblem-back.png",
        :class => 'links',
        :alt => "Back",
        :title => "Back") + "#{options[:text]}",
      "#",
      :onclick => "parent.history.back(); return false;"
    ) + "</span>"
  end # back_img_link

  # sort_field is used to make a field sortable (ASC, DESC). This does not include
  #  the associated database sorting logic, as this just creates links to the current
  #  page (using GET), passing the params ":sort" and ":order_by".
  def sort_field(options = {})
    output = ""
    if !options[:text]
      options[:text] = options[:column].titleize
    end
    if params[:order_by] == options[:column]
      if !params[:sort] or params[:sort] == "ASC"
        sort = ["ASC", "DESC"]
      else
        sort = ["DESC", "ASC"]
      end
      output += "<a href='?order_by=#{options[:column]}&amp;sort=#{sort[1]}"
      params.each do |key,value|
        output += "&amp;#{key}=#{value}" if !["order_by", "sort", "controller", "action", "authenticity_token"].include?(key)
      end
      output += "' title='sort'>" + options[:text]
      output += image_tag("sort_#{sort[0].downcase}.png", :alt => "sorted #{sort[0].downcase}", :class => "sorted_#{sort[0].downcase}")
    else
      output += "<a href='?order_by=#{options[:column]}&amp;sort=ASC"
      params.each do |key,value|
        output += "&amp;#{key}=#{value}" if !["order_by", "sort", "controller", "action", "authenticity_token"].include?(key)
      end
      output += "' title='sort'>" + options[:text]
    end
    output += "</a>"
    return output
  end # sort field

# This makes a spinner image appear within a div
  def spinner_tag(options = {})
    id = options[:id] ? options[:id] : "spinner"
    output = "#{options[:text]}"
    output += image_tag(
      "spinner.gif",
      :class => "spinner_image",
      :alt => "spinner",
      :id => id,
      :height => options[:height] ? options[:height] : "16",
      :style => 'display: none;',
      :title => "spinner"
    )
    return output
  end

  def logout_link
    output = ""
    if session['user_id']
      output = link_to("Log Out", :controller => :users, :action => :logout)
    else
      output = link_to("Log In", :controller => :users, :action => :login)
    end
    return output
  end

  def member_of?(group_name)
    member = false
    if session['user_id']
      group = Group.find_by_cn(group_name)
      if group.valid?
        member = group.member?(session['user_id'])
      end
    end
    return member
  end
  
  def admin?
    admin = false
    if session['user_id']
      user = User.find_by_uid(session['user_id'])
      if user.valid?
        admin = user.admin?
      end
    end
    return admin
  end

  def filter_box(options = {})
    output = "<span id=\"#{options[:item]}_filter_span\">"
    output += label_tag( "#{options[:item]}_filter",
      image_tag(
        "gnome/gnome-system-query.png",
        :class => 'links',
        :alt => "Query",
        :title => "Filter"
      ) +'Filter: ')
    output += text_field_tag( "#{options[:item]}_filter", (params[:filter] ? params[:filter] : nil))
    output += "</span>"
    output += observe_field( "#{options[:item]}_filter", :url => { :action => "find_#{options[:item].pluralize}" },
      :frequency => 0.25,
      :update => "#{options[:item]}_div",
      :with => "'filter=' + escape($('#{options[:item]}_filter').value) + '&order_by=' + escape('#{params[:order_by]}') + '&sort=' + escape('#{params[:sort]}')")
    return output
  end
end
