# 🚀 Hati Rails API

[![Gem Version](https://badge.fury.io/rb/hati-rails-api.svg)](https://badge.fury.io/rb/hati-rails-api)
[![Ruby](https://img.shields.io/badge/ruby-%E2%89%A5%203.0.0-ruby.svg)](https://www.ruby-lang.org/en/)
[![Rails](https://img.shields.io/badge/rails-API-red.svg)](https://rubyonrails.org/)
[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

> A powerful, batteries-included toolkit for rapidly scaffolding Rails APIs with sensible defaults and best practices.

## ✨ Features

**Hati Rails API** provides a comprehensive suite of tools designed to streamline Rails API development:

### 🏗️ **Core Components**

- **ApiOperation** - Structured operation patterns for business logic
- **JsonApiError** - Standardized error handling and formatting
- **ApiController helpers** - Common controller utilities and extensions

### 🔧 **Development Tools**

- **Interactor/Operation Tool** - Clean service layer abstractions
- **Service/Command Object** - Organized business logic patterns
- **Service/Command Aggregator** - Compose complex operations
- **Generators** - Rails generators for rapid scaffolding

## 📦 Installation

Add this gem to your Rails application's Gemfile:

```ruby
gem 'hati-rails-api'
```

Then execute:

```bash
bundle install
```

Or install it directly:

```bash
gem install hati-rails-api
```

## 🚀 Quick Start

```ruby
# In your Rails API controller
class Api::V1::UsersController < ApplicationController
  include HatiRailsApi::ApiController

  def create
    operation = CreateUserOperation.new(user_params)

    if operation.success?
      render json: operation.result, status: :created
    else
      render_api_error(operation.errors)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
```

## 📚 Documentation

### ApiOperation

Structure your business logic with clean, testable operations:

```ruby
class CreateUserOperation < HatiRailsApi::ApiOperation
  def call
    # Your business logic here
  end
end
```

### JsonApiError

Standardized error responses following JSON:API specification:

```ruby
# Automatically formats errors consistently
render_api_error(errors, status: :unprocessable_entity)
```

### Generators

Quickly scaffold API components:

```bash
rails generate hati_rails_api:controller Users
rails generate hati_rails_api:operation CreateUser
```

## 🛠️ Requirements

- **Ruby**: >= 3.0.0
- **Rails**: Compatible with Rails API applications

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add some amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- [**Mariya Giy**](https://github.com/mariegiy) - [send email](mailto:giy.mariya@gmail.com)
- [**Yuri Gi**](https://github.com/yurigitsu) - [send email](mailto:yurigi.pro@gmail.com)

## 🔗 Links

- [Homepage](https://github.com/hackico-ai/hati-rails-api)
- [Documentation](https://github.com/hackico-ai/hati-rails-api)
- [Issue Tracker](https://github.com/hackico-ai/hati-rails-api/issues)
- [Changelog](https://github.com/hackico-ai/hati-rails-api/blob/main/CHANGELOG.md)

---

<div align="center">
  <strong>Built with ❤️ for the Rails community</strong>
</div>
