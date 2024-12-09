# 电子商城系统设计报告

## 系统结构设计

### 体系结构

- 采用 MVC 设计模式
- 基于 Ruby on Rails 7.2.2 框架（全栈）
- 使用 SQLite3 作为数据库
- 前端使用 Bootstrap 工具包
- 文件存储使用 Active Storage
- 用户认证基于 authentication-zero

### 功能结构

1. 用户管理模块
    1. 用户认证（注册/登录/登出）
    2. session管理
    3. 角色管理（买家/员工/管理员）
2. 商品管理模块
    1. 商品 CRUD
    2. 分类管理（多级分类）
    3. 图片上传
3. 购物功能模块
    1. 购物车管理
    2. 地址管理
    3. 收藏夹
4. 订单管理模块
    1. 订单生成
    2. 订单状态转移
    3. 库存管理

## 数据库表设计

### 用户相关表

用户表（user）

| 属性名          | 中文名称 | 数据类型     | 备注                 |
| --------------- | -------- | ------------ | -------------------- |
| id              | 用户ID   | INT          | 主键，自增           |
| username        | 用户名   | VARCHAR(50)  | 不可为空             |
| email           | 用户邮箱 | VARCHAR(100) | 与手机二者至少有一   |
| phone           | 用户手机 | VARCHAR(100) |                      |
| password_digest | 密码     | VARCHAR(255) | 加密后的密码         |
| role            | 用户权限 | INT          | admin/worker/buyer   |
| created_at      | 注册时间 | TIMESTAMP    | 默认当前时间         |
| updated_at      | 更新时间 | TIMESTAMP    | 每次修改记录自动更新 |

会话表（session）

| 属性名     | 中文名称   | 数据类型     | 备注                         |
| ---------- | ---------- | ------------ | ---------------------------- |
| id         | 会话ID     | INT          | 主键，自增                   |
| user_id    | 用户ID     | INT          | 外键，关联用户               |
| agent      | 用户代理   | VARCHAR(255) | 用户的浏览器或客户端标识信息 |
| ip_address | 登录IP地址 | VARCHAR(255) | 用户访问时的网络地址         |
| created_at | 注册时间   | TIMESTAMP    | 默认当前时间                 |
| updated_at | 更新时间   | TIMESTAMP    | 每次修改记录自动更新         |

### 商品相关表

商品分类表（category）

| 属性名      | 中文名称 | 数据类型    | 备注             |
| ----------- | -------- | ----------- | ---------------- |
| id          | 分类ID   | INT         | 主键，自增       |
| name        | 分类名称 | VARCHAR(20) | 不可为空         |
| description | 分类描述 | TEXT        |                  |
| parent_id   | 父分类ID | INT         | 用于实现分类层级 |
| created_at  | 创建时间 | TIMESTAMP   | 默认当前时间     |
| updated_at  | 更新时间 | TIMESTAMP   | 自动更新         |

商品表（product）

| 属性名      | 中文名称 | 数据类型      | 备注           |
| ----------- | -------- | ------------- | -------------- |
| id          | 商品ID   | INT           | 主键，自增     |
| name        | 商品名称 | VARCHAR(50)   | 不可为空       |
| description | 商品描述 | TEXT          |                |
| price       | 价格     | DECIMAL(10,2) | 不小于0        |
| stock       | 库存量   | INT           | 不小于0        |
| category_id | 分类ID   | INT           | 外键，关联种类 |
| created_at  | 创建时间 | TIMESTAMP     | 默认当前时间   |
| updated_at  | 更新时间 | TIMESTAMP     | 自动更新       |

收藏夹表（favorite）

| 属性名     | 中文名称 | 数据类型  | 备注           |
| ---------- | -------- | --------- | -------------- |
| id         | 收藏ID   | INT       | 主键，自增     |
| user_id    | 用户ID   | INT       | 外键，关联用户 |
| product_id | 商品ID   | INT       | 外键，关联商品 |
| created_at | 创建时间 | TIMESTAMP | 默认当前时间   |
| updated_at | 更新时间 | TIMESTAMP | 自动更新       |

### 交易相关表

购物车表（carts）

| 属性名     | 中文名称 | 数据类型  | 备注           |
| ---------- | -------- | --------- | -------------- |
| id         | 购物车ID | INT       | 主键，自增     |
| user_id    | 用户ID   | INT       | 外键，关联用户 |
| created_at | 创建时间 | TIMESTAMP | 默认当前时间   |
| updated_at | 更新时间 | TIMESTAMP | 自动更新       |

购物车商品项表（cart_items）

| 属性名     | 中文名称 | 数据类型  | 备注             |
| ---------- | -------- | --------- | ---------------- |
| id         | 条目ID   | INT       | 主键，自增       |
| cart_id    | 购物车ID | INT       | 外键，关联购物车 |
| product_id | 商品ID   | INT       | 外键，关联商品   |
| quantity   | 商品数量 | INT       | 默认值1          |
| created_at | 创建时间 | TIMESTAMP | 默认当前时间     |
| updated_at | 更新时间 | TIMESTAMP | 自动更新         |

地址表（address）

| 属性名     | 中文名称   | 数据类型     | 备注           |
| ---------- | ---------- | ------------ | -------------- |
| id         | 地址ID     | INT          | 主键，自增     |
| user_id    | 用户ID     | INT          | 外键，关联用户 |
| name       | 收货人姓名 | VARCHAR(50)  | 不可为空       |
| phone      | 收货人电话 | VARCHAR(100) | 不可为空       |
| postcode   | 邮编       | VARCHAR(20)  | 不可为空       |
| content    | 详细地址   | TEXT         | 不可为空       |
| is_default | 是否默认   | BOOLEAN      | 默认false      |
| created_at | 创建时间   | TIMESTAMP    | 默认当前时间   |
| updated_at | 更新时间   | TIMESTAMP    | 自动更新       |

订单表（orders）

| 字段名       | 中文名称   | 类型          | 说明                               |
| ------------ | ---------- | ------------- | ---------------------------------- |
| id           | 订单ID     | INT           | 主键，自增                         |
| user_id      | 用户ID     | INT           | 外键，关联用户                     |
| total_amount | 订单总金额 | DECIMAL(10,2) | 不小于0                            |
| status       | 订单状态   | INT           | 待付款/已付款/已发货/已完成/已取消 |
| address_id   | 收货地址ID | INT           | 外键，关联地址                     |
| created_at   | 创建时间   | TIMESTAMP     | 默认当前时间                       |
| updated_at   | 更新时间   | TIMESTAMP     | 自动更新                           |

订单项表（order_items）

| 字段名     | 中文名称 | 类型          | 说明           |
| ---------- | -------- | ------------- | -------------- |
| id         | 订单项ID | INT           | 主键，自增     |
| order_id   | 订单ID   | INT           | 外键，关联订单 |
| product_id | 商品ID   | INT           | 外键，关联商品 |
| quantity   | 购买数量 | INT           | 大于0          |
| price      | 商品单价 | DECIMAL(10,2) | 不小于0        |
| created_at | 创建时间 | TIMESTAMP     | 默认当前时间   |
| updated_at | 更新时间 | TIMESTAMP     | 自动更新       |

## 系统重要功能实现方法

### 本地化设计与Toast消息功能

#### 本地化设计

```ruby
module Project
  class Application < Rails::Application
    # 1. 设置默认语言为中文
    config.i18n.default_locale = :'zh-CN'
    config.i18n.available_locales = [:'zh-CN']
    
    # 设置时区（存储使用utc）
    config.time_zone = 'Asia/Shanghai'
    config.active_record.default_timezone = :utc
  end
end
```

```ruby
# config/locales/zh-CN.yml
zh-CN:
  # 枚举值
  roles:
    buyer: 买家
    worker: 员工
    admin: 管理员

  statuses:
    unpaid: 未付款
    paid: 已付款
    # ...

  # 时间日期格式
  time:
    formats:
      default: "%Y-%m-%d %H:%M:%S"
      long: "%Y年%m月%d日 %H时%M分"
	  # ...
      
  # 数据验证错误信息
  activerecord:
    errors:
      models:
        user:
          attributes:
            username:
              blank: "用户名不能为空"
              # ...
              
  # 操作提示消息
  messages:
    success:
      user:
        login: "登录成功! 即将跳转到首页.."
        # ...
    error:
      unauthorized: "您没有权限执行此操作"
      # ...
```

#### Toast消息机制

```js
// app/javascript/helpers/toast_helper.js
export function showToast(options = {}) {
  const {
    message,
    type = 'success',
    delay = 2000,
    redirect = null,
    errors = null,
  } = options; // toast消息属性

  // 获取toast元素并设置样式
  const toast = document.getElementById('toast');
  toast.className = `toast align-items-center text-white bg-${type} border-0`;

  // 处理消息内容
  if (errors) {
    toast.querySelector('.toast-body').innerHTML = `
      <h6 class="mb-0">${message}</h6>
      <ul class="mb-0 small">
        ${errors.map(error => `<li>${error}</li>`).join('')}
      </ul>
    `;
  } else {
    toast.querySelector('.toast-body').textContent = message;
  }

  // 显示toast
  const bsToast = new bootstrap.Toast(toast, {
    animation: true,
    autohide: true,
    delay: delay
  });
  bsToast.show();

  // 处理跳转
  if (redirect) {
    setTimeout(() => {
      window.location.href = redirect;
    }, delay);
  }
}
```

### 用户认证系统实现

#### 基础认证机制

```ruby
class ApplicationController < ActionController::Base
  before_action :set_current_request_details
  before_action :authenticate

  protected
    def set_current_request_details
      # 获取用户代理和IP
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
	  
      # 从cookie中获取会话令牌并验证
      if session_token = (Rails.env.test? ? cookies[:session_token] : cookies.permanent.signed[:session_token])
        Current.session = Session.find_by_id(session_token)
        Current.user = Current.session&.user
      end
    end
end
```

#### 用户会话管理

```ruby
class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]
  before_action :set_session, only: [:destroy], if: -> { params[:id].present? }
  
  def create
    if user = User.find_by_login(params[:login])
      if user.authenticate(params[:password])
        # 创建新会话
        @session = user.sessions.create!
        # 设置加密cookie
        cookies.signed.permanent[:session_token] = @session.id
       	# 返回json响应
        render json: {
          success: true,
          message: t('messages.success.user.login'),
          redirect_url: root_path
        }
      else
        # ...
      end
    else
      # ...
  end
  def destroy
    # 获取当前会话对象
    current_session = Current.session
    if params[:id]
      @session = Current.user.sessions.find(params[:id])
      @session.destroy
    else
      current_session.destroy if current_session
    end
    # 删除浏览器中保存的会话令牌cookie
    cookies.delete(:session_token)
    # 重置Current对象中的所有信息(清除用户状态)
    Current.reset
    # ...
  end
```

#### 用户权限控制

```ruby
class UsersController < ApplicationController
  before_action :authenticate
  before_action :set_user, except: [:index]
  before_action :require_admin, except: [:show, :edit, :update]
  before_action :authorize, only: [:show, :edit, :update]
    
  def update_role
    # 仅管理员可操作且管理员权限不可改
    if Current.user.admin? && !@user.admin?
      if @user.update(role: params[:role])
        render json: {
          success: true,
          message: t('messages.success.user.role_update'),
          redirect_url: users_path
        }
      end
    end
  end
```

### 用户注册机制

#### 数据验证

```ruby
class User < ApplicationRecord
  has_secure_password # 密码加密存储
    
  # 字段验证
  validates :username, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A1[3-9]\d{9}\z/ }
  validates :password, length: { minimum: 6 }
  # 邮箱与手机号至少有一个
  validate :email_or_phone_present
```

#### 注册逻辑

```ruby
class RegistrationsController < ApplicationController
  skip_before_action :authenticate
    
  def create
    @user = User.new(user_params)
    @user.verified = true # 跳过邮箱认证
    if @user.save
      # 创建会话并设置登录状态
      @session = @user.sessions.create!
      cookies.signed.permanent[:session_token] = @session.id
      render json: {
        success: true,
        message: t('messages.success.user.signup'),
        redirect_url: root_path
      }
    end
  end
```

### 安全特性

#### 密码管理

```ruby
class PasswordsController < ApplicationController
  before_action :authenticate
  before_action :set_user
    
  def update
    if @user.admin? # 管理员信息暂定无法修改
      # render json
    else
      # 验证当前密码
      if @user.authenticate(user_params[:password_challenge])
        # 更新密码
        if @user.update(user_params)
          # render json
        end
      end
    end
  end
```

#### 访问控制

```ruby
private
  def authorize
    unless (Current.user == @user || Current.user.admin?)
      respond_to do |format|
        format.json { render json: { success: false }, status: :unauthorized }
        format.html { redirect_to root_path }
      end
    end
  end
```

### 商品管理

```ruby
class ProductsController < ApplicationController
  before_action :require_admin_or_woker, except: [:index, :show]  # 权限控制
  
  def create
    @product = Product.new(product_params)
    if @product.save
      # render json
    end
  end

  private
  def product_params
    # 支持图片上传
    params.require(:product).permit(:name, :description, :price, :stock, :category_id, :image)
  end
end
```

### 分类管理

```ruby
class CategoriesController < ApplicationController
  def edit
    # 排除自身，防止循环引用
    @categories = Category.where.not(id: @category.id)
  end

  private
  def category_params
    # 支持父分类设置
    params.require(:category).permit(:name, :description, :parent_id)
  end
end
```

```ruby
class Category < ApplicationRecord
  # 防止循环引用导致错误
  def all_parent_ids
    return [] unless parent
    [parent_id] + parent.all_parent_ids
  end
    
  private
  def no_circular_reference
    if parent_id.present?
      if parent_id == id
        errors.add(:parent_id, "不能选择自己作为父分类")
      elsif all_parent_ids.include?(id)
        errors.add(:parent_id, "不能形成循环引用")
      end
    end
  end
end
```

### 购物车

```ruby
class CartItemsController < ApplicationController
  before_action :require_buyer # 仅买家可用
  
  def create
    @product = Product.find(params[:product_id])
    @cart_item = @cart.cart_items.find_by(product: @product)
    
    # 已存在则增加数量
    if @cart_item
      @cart_item.quantity += 1
    else
      @cart_item = @cart.cart_items.build(product: @product)
    end
    
    if @cart_item.save
      # render json
    end
  end
  
  private
  def require_buyer
    unless Current.user.buyer?
      respond_to do |format|
        format.html {
          redirect_to root_path, alert: t('messages.error.unauthorized')
        }
        format.json {
          render json: {
            success: false,
            message: t('messages.error.unauthorized')
          }, status: :unauthorized
        }
      end
    end
  end
end
```

### 收藏夹

```ruby
class FavoritesController < ApplicationController
  before_action :require_buyer  # 仅买家可用
    
  def index
    @favorites = Current.user.favorites.includes(:product)
  end
    
  def create
    @favorite = Current.user.favorites.build(product: @product)
    if @favorite.save
      render json: {
        success: true,
        message: t('messages.success.favorite.create')
      }
    end
  end
end
```

### 订单系统

#### 订单状态转移

```ruby
class Order < ApplicationRecord
  # 状态定义
  enum :status, { :unpaid => 0, :paid => 1, :shipped => 2, :completed => 3, :canceled => 4 }
  
  after_initialize :set_default_status, if: :new_record?
  # 状态改变验证
  validate :valid_status_transition, if: :status_changed?

  def valid_status_transition
    case status_was.to_sym
    when :unpaid
      unless [:paid, :canceled].include?(status.to_sym)
        errors.add(:status, "未支付订单只能转为已支付或已取消")
      end
    when :paid
      unless [:shipped, :canceled].include?(status.to_sym)
        errors.add(:status, "已支付订单只能转为已发货或已取消")
      end
    when :shipped
      unless status.to_sym == :completed
        errors.add(:status, "已发货订单只能转为已完成")
      end
    when :completed, :canceled
      errors.add(:status, "订单已完成或已取消")
    end
  end
```

#### 订单创建流程

```ruby
class OrdersController < ApplicationController
  # 由购物车结算下单功能触发
  def create
    # 保证操作原子性和数据一致性
    # 出现错误自动回滚
    ActiveRecord::Base.transaction do
      # 创建订单
      @order = Current.user.orders.build(
        address_id: params[:address_id],
        total_amount: @cart.total_price,
        status: :unpaid
      )

      if @order.save
        # 依次创建订单项
        @cart.cart_items.each do |item|
          @order.order_items.create(
            product_id: item.product_id,
            quantity: item.quantity,
            price: item.product.price
          )
        end
        # 清空购物车
        @cart.cart_items.delete_all
        # render json
      end
    end
  rescue ActiveRecord::RecordInvalid
    # 如果任何一步失败，所有操作都会回滚
  end
end
```

#### 库存管理机制

```ruby
class Order < ApplicationRecord
  def can_ship?
    # 检查所有商品库存是否充足
    order_items.all? { |item| item.quantity <= item.product.stock }
  end

  def update_product_stock!
    # 发货时扣减库存
    order_items.each do |item|
      item.product.decrement!(:stock, item.quantity)
    end
  end
end

class OrdersController < ApplicationController
  def update_status
    if params[:status] == 'shipped'
      # 检查库存
      return unless @order.can_ship?
      
      # 更新状态并扣减库存
      ActiveRecord::Base.transaction do
        @order.update!(status: params[:status])
        @order.update_product_stock!
      end
    end
  end
end
```



## 备注：bootstrap 环境准备

```shell
# 添加 NodeSource 仓库
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
# 安装 Node.js
apt install -y nodejs
# 设置淘宝镜像源
npm config set registry https://registry.npmmirror.com
# 安装 yarn
npm install -g yarn
# 设置镜像源
yarn config set registry https://registry.npmmirror.com
# 清除缓存
yarn cache clean
（下载仍超时，记得删除Lock文件重新进行下载）

# 创建项目
rails new project -G -M --css=bootstrap
cd project
# js打包支持
bundle add jsbundling-rails
rails javascript:install:esbuild
#（需要处理importmap冲突的地方）

# 安装依赖并进行构建
yarn install
yarn build
```