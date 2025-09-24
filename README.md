# Hati Rails API

Gem Version License: MIT

Hati Rails API revolutionizes Rails API development by introducing **migration-driven architecture generation** - a paradigm that treats API structure as versioned, repeatable, and rollbackable code. Built specifically for the AI era, it transforms how developers and AI agents collaborate on building robust, scalable Rails APIs.

## The Migration-Driven API Revolution

Traditional Rails API development is ad-hoc and inconsistent. Hati Rails API changes this by introducing:

- **API as Code** – Define your entire API structure in migration files that can be versioned, shared, and automated
- **AI-Native Design** – Every pattern is explicit, declarative, and machine-readable for optimal AI collaboration
- **Instant Rollback** – Safely experiment with AI-generated APIs knowing you can revert any change
- **Pattern Consistency** – Enforce architectural patterns across your entire API surface automatically

## The Hati Rails API Architecture

Hati Rails API introduces a revolutionary approach to Rails API development through migration-driven generation:

```
─────────────────────────────────────────────────────────────────────────────────────────────────
│                           Hati Rails API - Migration-Driven Architecture                       │
├─────────────────────────────────────────────────────────────────────────────────────────────── |
│                                                                                                │
│  #Migration Files (config/contexts/)                           #Generated API Structure        │
│  ┌─────────────────────────────────────-┐                    ┌─────────────────────────────┐   │
│  │  20250121001327_ecommerce.rb         │                    │   Controllers               │   │
│  │  ┌─────────────────────────────────┐ │     ┌─────────┐    │  ├─ Api::EcommerceController│   │
│  │  │ domain :ecommerce do |domain|   │ │────▶│   Hati  │──▶ │  ├─ Api::UserController     │   │
│  │  │   domain.operation [:checkout]  │ │     │  Rails  │    │  └─ Api::OrderController    │   │
│  │  │   domain.endpoint true          │ │     │   API   │    └─────────────────────────────┘   │
│  │  │   domain.model true             │ │     │  Engine │                   │                  |
│  │  │ end                             │ │     └─────────┘    ┌──────────────────────────────┐  │
│  │  └─────────────────────────────────┘ │                    │    Operations                │  │
│  └─────────────────────────────────────-┘                    │  ├─ Ecommerce::Checkout      │  │
│                                                              │  ├─ User::Create             │  │
│  ┌──────────────────────────────────────┐                    │  └─ Order::Process           │  │
│  │     20250121001328_user.rb           │                    └──────────────────────────────┘  │
│  │  ┌─────────────────────────────────┐ │                                   │                  |
│  │  │ domain :user do |domain|        │ │                    ┌─────────────────────────────┐   │
│  │  │   domain.operation [:create]    │ │                    │    Models                   │   │
│  │  │   domain.validation             │ │                    │  ├─ User                    │   │
│  │  │   domain.service                │ │                    │  ├─ Order                   │   │
│  │  │ end                             │ │                    │  └─ Product                 │   │
│  │  └─────────────────────────────────┘ │                    └─────────────────────────────┘   │
│  └──────────────────────────────────────┘                                   │                  |
│                                                                             │                  |
│  #Rollback System                                             ┌─────────────────────────────┐  │
│  ┌─────────────────────────────────────┐                      │    Validations              │  │
│  │  Migration Tracking                 │                      │  ├─ PaymentValidator        │  │
│  │  ├─ Timestamp: 20250121001327       │                      │  ├─ UserValidator           │  │
│  │  ├─ Files Generated: 15             │                      │  └─ OrderValidator          │  │
│  │  ├─ Rollback: rails generate ...    │                      └─────────────────────────────┘  │
│  │  └─ Status: Applied                 │                                    │                  |
│  └─────────────────────────────────────┘                      ┌─────────────────────────────┐  │
│                                                               │   Services                  │  │
│                                                               │  ├─ PaymentGateway          │  │
│                                                               │  ├─ EmailNotification       │  │
│                                                               │  └─ InventoryManager        │  │
│                                                               └─────────────────────────────┘  │
│                                                                                                │
├───────────────────────────────────────────────────────────────────────────────────────────────-|
│   AI Integration Features                                                                      │
│  • Explicit Patterns for AI Understanding          • Safe Rollback for AI Experimentation      │
│  • Machine-Readable Definitions                    • Versioned API Evolution                   │
│  • Context-Aware Code Generation                   • Consistent Architecture Enforcement       │
─────────────────────────────────────────────────────────────────────────────────────────────────-
```

## Getting Started with Migration-Driven APIs

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

- `config/contexts.rb` (global configuration)
- `config/contexts/` (migration files directory)
- `app/contexts/` (generated API code)

### 3. Create Your First API Migration

Generate a migration for a domain:

```bash
rails generate hati_rails_api:context user --operations=create,update,delete
```

### 4. Run Migrations

Generate all API code from migrations:

```bash
rails generate hati_rails_api:context run --force
```

### 5. Rollback (if needed)

```bash
rails generate hati_rails_api:context rollback --timestamp=YOUR_TIMESTAMP
```

## Real-World Examples

### E-commerce API with AI Integration

```ruby
# config/contexts/20250121001327_ecommerce_api.rb
class CreateEcommerceApi < HatiRailsApi::Context::Migration
  def change
    domain :ecommerce do |domain|
      # Core business operations
      domain.operation do |operation|
        operation.component [:checkout, :refund, :inventory_check]
        operation.step true, granular: true
      end

      # AI-powered features
      domain.service do |service|
        service.component [:recommendation_engine, :price_optimizer, :fraud_detector]
      end

      # Standard Rails components
      domain.endpoint true
      domain.model true
      domain.validation { |v| v.component [:payment_validator, :inventory_validator] }
      domain.query { |q| q.component [:product_finder, :order_analyzer] }
      domain.serializer { |s| s.component [:product_serializer, :order_serializer] }
    end

    # Additional models and endpoints
    model [:product, :order, :payment, :inventory]
    endpoint [:order_status, :payment_webhook, :inventory_alert]
  end
end

CreateEcommerceApi.new.run
```

### AI-Powered Content Management API

```ruby
# config/contexts/20250121001328_cms_api.rb
class CreateCmsApi < HatiRailsApi::Context::Migration
  def change
    domain :content_management do |domain|
      # AI-enhanced content operations
      domain.operation do |operation|
        operation.component [:generate_content, :optimize_seo, :translate_content]
        operation.step true, granular: true
      end

      # AI services
      domain.service do |service|
        service.component [:ai_writer, :seo_analyzer, :translation_service]
      end

      # Content validation and processing
      domain.validation { |v| v.component [:content_validator, :seo_validator] }
      domain.query { |q| q.component [:content_search, :trending_finder] }

      domain.endpoint true
      domain.model true
    end

    model [:article, :category, :tag, :seo_metadata]
    endpoint [:content_analytics, :ai_suggestions]
  end
end

CreateCmsApi.new.run
```

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

## What Makes Hati Rails API Unique

### Migration-Driven API Development

Unlike traditional Rails API development, Hati Rails API treats your entire API structure as versioned, repeatable code:

- **Versioned API Evolution** – Track every change to your API structure with timestamps and rollback capabilities
- **Consistent Architecture** – Enforce the same patterns across all your API endpoints automatically
- **AI-Friendly Definitions** – Every API structure is defined in machine-readable, declarative format
- **Instant Experimentation** – Try new API patterns knowing you can rollback instantly

### Rails-Native Integration

Built specifically for Rails, not adapted from other frameworks:

- **Rails Conventions** – Follows Rails patterns and conventions throughout
- **ActiveRecord Integration** – Seamless integration with Rails models and database layer
- **Rails Generators** – Uses familiar Rails generator patterns for consistency
- **Rails Testing** – Generated code follows Rails testing best practices

### AI Development Superpowers

Designed from the ground up for AI-assisted development:

- **Explicit Patterns** – Every API pattern is clearly defined and machine-readable
- **Predictable Structure** – AI tools can understand and generate consistent API code
- **Safe Experimentation** – Rollback any AI-generated changes instantly
- **Context Preservation** – AI tools understand the full context of your API structure

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

### AI Agent Tool Integration

```ruby
class Agent::Context::DatabaseApi < HatiRailsApi::Context::Migration
  def change
    domain :agent_tools do |domain|
      # Register tool capabilities for AI agents
      domain.operation do |operation|
        operation.component [:query_database, :update_records, :analyze_data]
        operation.step true, granular: true
      end
      domain.endpoint true
      domain.model true
      domain.validation { |v| v.component [:query_validator, :safety_checker] }
      domain.service { |s| s.component [:safe_executor, :audit_logger] }
    end
    model [:query_log, :audit_trail]
    endpoint [:tool_status, :execution_metrics]
  end
end
```

### AI Assistant Integration

```ruby
class Assistant::Context::CodeReviewApi < HatiRailsApi::Context::Migration
  def change
    domain :code_review do |domain|
      # Structured for AI assistant comprehension
      domain.operation do |operation|
        operation.component [:analyze_code, :generate_review, :format_feedback]
        operation.step true, granular: true
      end
      domain.endpoint true
      domain.model true
      domain.validation { |v| v.component [:code_validator] }
      domain.service { |s| s.component [:code_analyzer, :review_generator] }
    end
    model [:code_snippet, :review_comment]
    endpoint [:review_status]
  end
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

## AI Development Workflow Integration

### Cursor IDE Integration

Hati Rails API's migration-driven approach creates the perfect environment for Cursor:

- **Context-Aware Suggestions** – Cursor understands your entire API structure through migration files
- **Pattern Recognition** – AI can suggest consistent patterns based on your existing migrations
- **Safe Code Generation** – Generate new API endpoints knowing you can rollback if needed
- **Intelligent Refactoring** – AI can suggest and implement API structure improvements

### GitHub Copilot Enhancement

Copilot becomes significantly more effective with Hati Rails API:

- **Predictable Code Patterns** – Copilot learns your API patterns from migration files
- **Consistent Suggestions** – All generated code follows your established patterns
- **Migration-Aware Completions** – Copilot understands the relationship between migrations and generated code
- **Test Generation** – Copilot can generate tests that match your API structure

### Autonomous Agent Development

Perfect for building AI agents that can modify and extend APIs:

- **Self-Modifying APIs** – Agents can create new migrations to extend API functionality
- **Safe Experimentation** – Agents can try new patterns with instant rollback capability
- **Pattern Learning** – Agents can learn from existing migrations to generate consistent code
- **Version Control** – Every agent modification is tracked and can be reviewed

## Testing Your Migration-Driven APIs

Hati Rails API generates comprehensive test suites for all your API components:

```ruby
# Generated test for ecommerce operations
RSpec.describe Ecommerce::Operation::Checkout do
  describe "#call" do
    it "processes checkout with payment validation" do
      result = described_class.call(
        user_id: user.id,
        items: [product1, product2],
        payment_method: "credit_card"
      )

      expect(result).to be_success
      expect(result.value).to be_a(Order)
    end

    it "handles inventory validation failures" do
      allow(InventoryValidator).to receive(:call).and_return(Failure("Out of stock"))

      result = described_class.call(invalid_params)

      expect(result).to be_failure
      expect(result.error).to include("Out of stock")
    end
  end
end

# Generated controller test
RSpec.describe Api::EcommerceController do
  describe "POST /api/ecommerce/checkout" do
    it "creates order and returns JSON response" do
      post "/api/ecommerce/checkout", params: valid_checkout_params

      expect(response).to have_http_status(:created)
      expect(json_response["data"]["type"]).to eq("order")
    end
  end
end
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

## Contributing

We welcome contributions! Please:

1. Fork the project
2. Create your feature branch
3. Add tests for new features
4. Ensure all tests pass
5. Submit a PR with clear description

## License

Hati Rails API is available under the MIT License.

## About

Hati Rails API brings the power of migration-driven, pattern-based, and agentic development to Rails APIs. Use it to:

- Rapidly scaffold and evolve complex API architectures
- Automate code generation with AI/agentic tools
- Maintain clean, robust, and scalable codebases
- Build AI-powered APIs and autonomous agent systems

### Topics

ruby rails-api service-objects code-organization business-logic-frameworks ai-development agentic-programming

### Resources

Readme

### License

MIT license

**For more examples, documentation, and advanced patterns, see the [project repo](https://github.com/hackico-ai/hati-rails-api).**
