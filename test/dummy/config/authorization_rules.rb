authorization do
  role :guest do
    # add permissions for guests here, e.g.
    has_permission_on :test_models, to: :read
    has_permission_on :user_sessions, to: :manage
  end

  role :user do
    includes :guest
    has_permission_on :test_models, to: :manage do
      if_attribute user_id: is { user.id }
    end
    has_permission_on :great_test_models, to: :manage do
      if_attribute grand_test_model: { user_id: is { user.id } }
    end
  end

  # permissions on other roles, such as
  role :admin do
    includes :user
    has_permission_on :test_models, to: :manage
  end
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, includes: [:create, :read, :update, :delete]
  privilege :read, includes: [:index, :show]
  privilege :create, includes: :new
  privilege :update, includes: :edit
  privilege :delete, includes: :destroy
end
