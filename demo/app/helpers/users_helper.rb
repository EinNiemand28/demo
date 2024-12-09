module UsersHelper
  def user_avatar(user, size: '100x100')
    if user.avatar_picture.attached?
      image_tag user.avatar_picture.variant(resize: size), id: 'avatar preview'
    else
      image_tag 'default_avatar.png', size: size, id: 'avatar preview'
    end
  end

  def user_role(role)
    case role
    when 'admin'
      t('activerecord.enums.user.admin')
    when 'teacher'
      t('activerecord.enums.user.teacher')
    when 'student'
      t('activerecord.enums.user.student')
    end
  end
end
