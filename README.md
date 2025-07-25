# Hati Rails API

A high-performance, scalable toolkit for building robust, domain-driven Rails APIs with migration-style code generation, clean architecture, and agentic/AI-ready patterns.

## What is Hati Rails API?

Hati Rails API is a Ruby gem that brings **migration-style, pattern-based code generation** to Rails APIs. It enables:

- **Domain-driven design** with clear context boundaries
- **Clean, SOLID architecture** for maintainable codebases
- **Fast, repeatable development** with migration files and rollback
- **Agentic/AI-ready workflows**: all code generation is explicit, declarative, and context-driven—perfect for automation and large-scale projects

## Framework Components & How They Work Together

### Context System

Centralizes domain logic, boundaries, and code generation. You define “contexts” (domains) in migration files. Each context can have operations, endpoints, models, and any number of custom layers (service, query, validation, serializer, etc.).

### Migration Engine

Provides a migration-style, repeatable, and rollbackable way to define and evolve your API structure. Migration files (class-based or DSL) describe what to generate. Running migrations creates or updates code; rollbacks revert changes.

### Generator

Orchestrates the actual file generation, tracking, and rollback. Reads migration files, generates code (models, controllers, operations, etc.), and tracks what was created for safe rollback.

### Layer System

Supports modular, extensible architecture. Built-in layers include:

- **Operation:** Business logic, step-based or simple
- **Service:** Application services, integrations
- **Query:** Data access/query objects
- **Validation:** Input/business validation
- **Serializer:** Output formatting
- **Custom:** Add your own (analytics, repository, etc.)

### ResponseHandler

Standardizes API responses and error handling. Controllers include this module to automatically handle operation results, errors, and JSON:API formatting.

### Rollback Manager

Enables safe, timestamped rollback of generated code. Tracks every file generated by a migration. Rollbacks remove files and clean up empty directories.

### Macro System

Provides reusable code patterns and metaprogramming helpers. Macros can be used in operations, layers, or anywhere in the context system to DRY up code and enforce patterns.

### Error Handling

Centralizes error types and handling logic. Custom error classes for unsupported operations, configuration issues, and more. Integrated with ResponseHandler for clean API error responses.

### Versioning

Tracks the version of the Hati Rails API gem. Ensures agents and humans know which features and patterns are available.

**How They Work Together:**

- You define your API’s structure and patterns in migration files.
- The Migration Engine and Generator read these files, using the Layer System to create all necessary code (operations, models, controllers, etc.).
- ResponseHandler ensures all endpoints behave consistently.
- Rollback Manager lets you safely undo changes, supporting rapid, iterative, and agent-driven development.
- Macros and Error Handling provide reusable patterns and robust error management.
- Versioning ensures compatibility and traceability.

The result is a highly modular, pattern-driven, and automation-friendly Rails API framework—ready for both human and AI/agentic development at scale.

## Quick Start

### 1. Install the Gem

Add to your Gemfile:

```ruby
gem 'hati-rails-api'
```

Then run:

```bash
bundle install
```

### 2. Initialize the Context System

```bash
rails generate hati_rails_api:context init
```

This creates:

- `config/contexts.rb` (global config)
- `config/contexts/` (migration files go here)
- `app/contexts/` (generated code)

### 3. Create a Migration File

Generate a migration for a domain:

```bash
rails generate hati_rails_api:context user --operations=create,update,delete
```

Edit the generated file in `config/contexts/` to define your domain, operations, and layers.

### 4. Run Migrations

Generate all code from migrations:

```bash
rails generate hati_rails_api:context run --force
```

### 5. Rollback (if needed)

```bash
rails generate hati_rails_api:context rollback --timestamp=YOUR_TIMESTAMP
```

## Basic Usage Example

A migration file (class-based, AI/agentic-ready):

```ruby
# config/contexts/20250721001327_create_user_context.rb
class CreateUserContext < HatiRailsApi::Context::Migration
  def change
    domain :user do |domain|
      domain.operation do |operation|
        operation.component [:create, :update, :delete]
      end
      domain.endpoint true
      domain.model true
      domain.validation
      domain.query
      domain.service
      domain.serializer
    end
    model [:user, :user_token]
    endpoint [:user_status]
  end
end

CreateUserContext.new.run
```

This will generate:

- Operations: `app/contexts/user/operation/create_operation.rb`, etc.
- Controller: `app/controllers/api/user_controller.rb`
- Models: `app/models/user.rb`, `app/models/user_token.rb`
- Additional layers: `app/contexts/user/validation/`, `query/`, `service/`, `serializer/`

## Advanced Usage & Patterns

### Granular/Agentic Steps

You can use granular steps to patternize operation logic based on other layers:

```ruby
domain.operation do |operation|
  operation.component [:authenticate, :authorize]
  operation.step true, granular: true # Will use all other domain layers as steps
end
```

### Custom Layers

Add any custom layer to your domain:

```ruby
domain.analytics do |analytics|
  analytics.component [:event_tracker, :report_generator]
end
```

### Explicit Steps

```ruby
domain.operation do |operation|
  operation.component [:register]
  operation.step :validate, :persist, :notify
end
```

### Full Example: Scalable, AI-Ready Context

```ruby
class CreateEcommerceContext < HatiRailsApi::Context::Migration
  def change
    domain :ecommerce do |domain|
      domain.operation do |operation|
        operation.component [:checkout, :refund]
        operation.step true, granular: true
      end
      domain.endpoint true
      domain.model true
      domain.validation { |v| v.component [:payment_validator] }
      domain.query { |q| q.component [:order_finder] }
      domain.service { |s| s.component [:payment_gateway] }
      domain.analytics { |a| a.component [:sales_reporter] }
    end
    model [:order, :payment]
    endpoint [:order_status]
  end
end

CreateEcommerceContext.new.run
```

## Library Architecture & Extensibility

- **Migration-Driven**: All code generation is declarative and repeatable
- **Layered**: Add/remove layers as your architecture evolves
- **Rollbackable**: Every generation is tracked and can be reverted
- **Composable**: Use as building blocks for agentic/AI workflows
- **Extensible**: Add new layer types, code templates, or DSL methods

## Why Hati Rails API for AI/Agentic Development?

- **Patternization**: All code is generated from explicit, context-rich patterns
- **Automation-Ready**: Migrations are just Ruby—easy to generate, modify, or analyze with AI agents
- **Scalable**: Designed for large, fast-moving teams and projects
- **Robust**: Rollback, test, and iterate safely
- **Clear Examples**: Every migration is a living, executable example

## Wrap Up

Hati Rails API brings the power of migration-driven, pattern-based, and agentic development to Rails APIs. Use it to:

- Rapidly scaffold and evolve complex API architectures
- Automate code generation with AI/agentic tools
- Maintain clean, robust, and scalable codebases

**For more examples, documentation, and advanced patterns, see the [project repo](https://github.com/hackico-ai/hati-rails-api).**
