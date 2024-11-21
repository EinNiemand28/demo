module UsersHelper
  def user_avatar(user, size: '100x100')
    if user.avatar_picture.attached?
      image_tag user.avatar_picture.variant(resize: size), id: 'avatar preview'
    else
      image_tag 'default_avatar.png', size: size, id: 'avatar preview'
    end
  end
end
