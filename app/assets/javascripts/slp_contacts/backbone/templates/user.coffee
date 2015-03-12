SLPContacts.Templates.UserGridTemplate = """
  <div class="ui statistic">
    <div class="value">
      <img src="<%= headimg %>" alt="user_pic" class="ui circular centered image">
    </div>
    <div class="label"><%= name %></div>
  </div>
"""

SLPContacts.Templates.UserListTemplate = """
  <div class="right floated compact ui <%= favorited ? 'basic' : 'secondary' %> button"><%= favorited ? '取消' : '收藏' %></div>
  <img src="<%= headimg %>" alt="user_pic" class="ui avatar image">
  <div class="content">
    <div class="header"><%= name %></div>
    <div class="description"><%= phone %></div>
  </div>
"""

