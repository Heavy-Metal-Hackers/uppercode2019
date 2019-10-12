<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %> <%= ", class_name: :User" if attribute.name == "create_user" || attribute.name == "update_user" %>
<% end -%>
<% if attributes.any?(&:password_digest?) -%>
  has_secure_password
<% end -%>
  include PgSearch

  def self.search(search, page)
    per_page = 20
    if page == 'all'
      per_page = 999999999
      page = 1
    end
    if search && search != ""
      paginate(:per_page => per_page, :page => page).full_search(search)
    else
      paginate(:per_page => per_page, :page => page)
    end
  end

  pg_search_scope :full_search,
    :against => [<%= (attributes.map { |a| ":#{a.name}"}).join(", ") %>],
    :using => {
      :tsearch => {:prefix => true},
      :dmetaphone => {},
      :trigram => {}
    },
    :ignoring => :accents
end
<% end -%>
