#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views

@SLPContacts =
  Models: {}
  Collections: {}
  Views: {}
  Templates: {}
  Cache: {}
  Settings:
    per_page: 12
    prefix_link: "/namespaces/#{_global['namespace_id']}/apps/contacts"
