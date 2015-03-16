SlpContacts::Engine.routes.draw do
  resources :users, only: [:show] do # 某个用户详情页面
    member do
      post :favorite # 收藏一个用户
      delete :unfavorite # 取消收藏一个用户
    end

    collection do
       get :query # 搜索所有用户
    end
  end

  resource :user, only: [:show] do # 当前用户详情页面
    resources :favorites, only: [:index] do # 当前用户收藏的联系人页面
      collection do
        get :query # 搜索当前用户收藏的联系人
      end
    end

    get :organizations # 当前用户所在组织
  end

  resources :organizations, only: [:show] do # 某个组织页面
    member do
      get :query # 搜索某个组织里的联系人
    end
  end

  root to: 'user#show' # 首页，当前用户详情页面

end
