# 🚀 Hati Rails API

[![Gem Version](https://badge.fury.io/rb/hati-rails-api.svg)](https://badge.fury.io/rb/hati-rails-api)
[![Ruby](https://img.shields.io/badge/ruby-%E2%89%A5%203.0.0-ruby.svg)](https://www.ruby-lang.org/en/)
[![Rails](https://img.shields.io/badge/rails-API-red.svg)](https://rubyonrails.org/)
[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

> A lightweight, opinionated toolkit for building robust Rails APIs with structured operation patterns and consistent error handling.

## ✨ Features

**Hati Rails API** provides essential building blocks for Rails API development:

### 🎯 **Core Components**

- **ResponseHandler** - Unified response handling for operations with automatic success/error formatting
- **Operation Integration** - Seamless integration with HatiOperation-based business logic
- **JSON:API Error Support** - Standardized error responses via HatiJsonapiError integration
- **Flexible Parameters** - Smart parameter handling for different Rails environments

### 🔧 **What it Does**

- Executes operations and automatically renders appropriate JSON responses
- Handles both success and error scenarios with consistent formatting
- Integrates with the Hati ecosystem (HatiOperation, HatiJsonapiError, HatiCommand)
- Provides clean controller abstractions for API endpoints

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

### Basic Usage

Include the `ResponseHandler` in your API controllers:

```ruby
class Api::V1::UsersController < ApplicationController
  include HatiRailsApi::ResponseHandler

  def create
    run_and_render CreateUserOperation
  end

  def update
    run_and_render UpdateUserOperation
  end
end
```

### Operation Example

Your operations should follow the HatiOperation pattern:

```ruby
class CreateUserOperation < HatiOperation::Base
  def call(params:)
    user = User.create!(params[:user])
    HatiCommand::Result.success(user)
  rescue ActiveRecord::RecordInvalid => e
    HatiCommand::Result.failure(e.message)
  end
end
```

### Advanced Usage with Block

You can also pass a block to customize the operation execution:

```ruby
def create
  run_and_render CreateUserOperation do
    # Custom logic here
    # The block will be passed to the operation
  end
end
```

## 📚 API Reference

### ResponseHandler Module

When included in a controller, provides:

#### `run_and_render(operation, &block)`

Executes an operation and renders the appropriate response:

- **Success**: Renders `{ data: result }` with HTTP 200 (or custom status)
- **Failure**: Renders error using HatiJsonapiError formatting

**Parameters:**

- `operation`: A HatiOperation class or HatiCommand::Result instance
- `&block`: Optional block passed to the operation

**Example:**

```ruby
# Simple operation call
run_and_render MyOperation

# With block
run_and_render MyOperation do
  # Custom logic
end

# With status override in operation result
# Your operation can return: HatiCommand::Result.success(data, status: 201)
```

### Error Handling

The gem automatically configures HatiJsonapiError with sensible defaults:

```ruby
HatiJsonapiError::Config.configure do |config|
  config.load_errors!
  config.use_unexpected = HatiJsonapiError::InternalServerError
end
```

Custom errors are defined in `HatiRailsApi::Errors` namespace.

## 🛠️ Requirements

- **Ruby**: >= 3.0.0
- **Rails**: API-compatible applications
- **Dependencies**:
  - `hati-jsonapi-error` - For structured error handling
  - `hati-operation` - For operation patterns (optional)
  - `hati-command` - For result objects (optional)

## 🔧 Configuration

Currently, the gem uses sensible defaults. Configuration options will be expanded in future versions.

## 🏗️ Development Status

This gem is currently in **beta** (v0.1.0.beta1). The API is stable but may evolve based on community feedback.

### Roadmap

- [ ] Enhanced configuration options
- [ ] Additional response macros (204, 206, 207)
- [ ] Custom error mapping
- [ ] Performance optimizations
- [ ] Comprehensive documentation

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Write tests** for your changes
4. **Commit** your changes (`git commit -m 'Add some amazing feature'`)
5. **Push** to the branch (`git push origin feature/amazing-feature`)
6. **Open** a Pull Request

### Development Setup

```bash
git clone https://github.com/hackico-ai/hati-rails-api.git
cd hati-rails-api
bundle install
bundle exec rspec
```

## 🧪 Testing

Run the test suite:

```bash
bundle exec rspec
```

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- [**Mariya Giy**](https://github.com/mariya-giy-github) - [giy.mariya@gmail.com](mailto:giy.mariya@gmail.com)
- [**Yuri Gi**](https://github.com/yuriygiy) - [yurigi.pro@gmail.com](mailto:yurigi.pro@gmail.com)

## 🔗 Related Projects

- [**hati-jsonapi-error**](https://github.com/hackico-ai/hati-jsonapi-error) - JSON:API compliant error handling
- [**hati-operation**](https://github.com/hackico-ai/hati-operation) - Structured operation patterns
- [**hati-command**](https://github.com/hackico-ai/hati-command) - Command/result objects

## 🔗 Links

- [Homepage](https://github.com/hackico-ai/hati-rails-api)
- [Documentation](https://github.com/hackico-ai/hati-rails-api)
- [Issue Tracker](https://github.com/hackico-ai/hati-rails-api/issues)
- [Changelog](https://github.com/hackico-ai/hati-rails-api/blob/main/CHANGELOG.md)

---

<div align="center">
  <strong>Built with ❤️ for the Rails community</strong>
</div>
