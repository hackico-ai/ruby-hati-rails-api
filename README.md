# Hati Rails API

[![Gem Version](https://badge.fury.io/rb/hati-rails-api.svg)](https://rubygems.org/gems/hati-rails-api)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](#license)

**Migration-driven Rails API development for the AI era.**

Hati Rails API revolutionizes Rails API development by treating your entire API structure as versioned, repeatable, and rollbackable code. Built specifically for AI-assisted development, it enables developers and AI agents to collaborate on building robust, scalable Rails APIs with confidence.

---

### Migration-Driven Architecture

- **API as Code** — Your entire API structure lives in versioned migration files
- **Instant Rollback** — Safely experiment knowing you can revert any change
- **Pattern Consistency** — Enforce architectural patterns across your entire API

### AI-Native Design

- **Machine-Readable** — Every pattern is explicit and declarative for optimal AI collaboration
- **Predictable Structure** — AI tools understand and generate consistent code
- **Safe Experimentation** — AI can try new patterns with instant rollback capability

### Rails-Native Integration

- **Rails Conventions** — Follows Rails patterns throughout
- **ActiveRecord Integration** — Seamless database layer integration
- **Familiar Generators** — Uses Rails generator patterns you already know

---

## Table of Contents

- [Quick Start](#quick-start)
- [Architecture Overview](#architecture-overview)
- [What Makes It Different](#what-makes-it-different)
- [Core Concepts](#core-concepts)
- [Framework Components](#framework-components)
- [Use Cases](#use-cases)
- [AI-Powered Bootstrapping](#ai-powered-bootstrapping)
- [Examples](#examples)
  - [Basic User API](#basic-user-api)
  - [E-commerce API](#e-commerce-api-with-ai-features)
  - [Advanced Patterns](#advanced-patterns)
- [AI Development Integration](#ai-development-integration)
- [Testing](#testing)
- [Architecture Benefits](#architecture-benefits)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

---

## Quick Start

### 1. Install

```ruby
# Gemfile
gem 'hati-rails-api'
```

```bash
bundle install
```

### 2. Initialize

```bash
rails generate hati_rails_api:context init
```

### 3. Create Migration

```bash
rails generate hati_rails_api:context user --operations=create,update,delete
```

### 4. Generate Code

```bash
rails generate hati_rails_api:context run --force
```

---

## Architecture Overview

Hati Rails API introduces a migration-driven approach where your entire API structure is defined in versioned migration files that generate complete, consistent code structures.

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                          Hati Rails API Architecture                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Migration Files (config/contexts/)          Generated API Structure            │
│  ┌─────────────────────────────────┐       ┌─────────────────────────────────┐  │
│  │                                 │       │                                 │  │
│  │  20250121001327_user_api.rb     │       │  Controllers                    │  │
│  │  ┌─────────────────────────────┐│       │  ├─ Api::UserController         │  │
│  │  │ domain :user do |domain|    ││  ───▶ │  ├─ Api::OrderController        │  │
│  │  │   domain.operation [...]    ││       │  └─ Api::ProductController      │  │
│  │  │   domain.endpoint true      ││       │                                 │  │
│  │  │   domain.model true         ││       │  Operations                     │  │
│  │  │ end                         ││       │  ├─ User::Create                │  │
│  │  └─────────────────────────────┘│       │  ├─ User::Update                │  │
│  │                                 │       │  └─ User::Delete                │  │
│  │  20250121001328_order_api.rb    │       │                                 │  │
│  │  ┌─────────────────────────────┐│       │  Models                         │  │
│  │  │ domain :order do |domain|   ││       │  ├─ User                        │  │
│  │  │   domain.operation [...]    ││       │  ├─ Order                       │  │
│  │  │   domain.service [...]      ││       │  └─ Product                     │  │
│  │  │ end                         ││       │                                 │  │
│  │  └─────────────────────────────┘│       │  Services                       │  │
│  └─────────────────────────────────┘       │  ├─ PaymentService              │  │
│                                            │  ├─ NotificationService         │  │
│  Rollback System                           │  └─ InventoryService            │  │
│  ┌─────────────────────────────────┐       │                                 │  │
│  │  Migration Tracking             │       │  Validations                    │  │
│  │  ├─ Timestamp: 20250121001327   │       │  ├─ UserValidator               │  │
│  │  ├─ Files Generated: 15         │       │  ├─ OrderValidator              │  │
│  │  ├─ Rollback Command Available  │       │  └─ PaymentValidator            │  │
│  │  └─ Status: Applied             │       │                                 │  │
│  └─────────────────────────────────┘       └─────────────────────────────────┘  │
│                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Key Features                                                                   │
│  • Migration-Driven Architecture    • AI-Native Design                          │
│  • Instant Rollback Capabilities    • Rails Convention Compliance               │
│  • Pattern Consistency Enforcement  • Comprehensive Test Generation             │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Core Concepts

### Migration Files

Define your API structure in timestamped migration files:

```ruby
# config/contexts/20250121001327_create_user_api.rb
class CreateUserApi < HatiRailsApi::Context::Migration
  def change
    domain :user do |domain|
      domain.operation do |operation|
        operation.component [:create, :update, :delete]
      end
      domain.endpoint true
      domain.model true
      domain.validation
      domain.service
    end
  end
end
```

### Generated Structure

This creates a complete API structure:

```
app/
├── contexts/user/
│   ├── operation/
│   │   ├── create_operation.rb
│   │   ├── update_operation.rb
│   │   └── delete_operation.rb
│   ├── validation/
│   └── service/
├── controllers/api/
│   └── user_controller.rb
└── models/
    └── user.rb
```

### Rollback System

Every migration is tracked and can be safely rolled back:

```bash
rails generate hati_rails_api:context rollback --timestamp=20250121001327
```

---

## Framework Components

<table>
<tr>
  <th width="20%">Component</th>
  <th width="25%">Purpose</th>
  <th width="35%">Key Features</th>
  <th width="20%">Benefits</th>
</tr>

<tr>
  <td><strong>Context System</strong></td>
  <td>Domain organization and structure definition</td>
  <td>
    • Domain-driven organization<br>
    • Migration-based definitions<br>
    • Custom layer support<br>
    • Extensible architecture
  </td>
  <td>
    • Centralized domain logic<br>
    • Clear boundaries<br>
    • Scalable structure<br>
    • Easy customization
  </td>
</tr>

<tr>
  <td><strong>Migration Engine</strong></td>
  <td>Version control for API structure</td>
  <td>
    • Timestamped migrations<br>
    • Class-based definitions<br>
    • Rollback support<br>
    • Change tracking
  </td>
  <td>
    • Repeatable deployments<br>
    • Safe evolution<br>
    • Version history<br>
    • Team collaboration
  </td>
</tr>

<tr>
  <td><strong>Layer System</strong></td>
  <td>Modular architecture components</td>
  <td>
    • Operations (business logic)<br>
    • Services (integrations)<br>
    • Validations (input rules)<br>
    • Queries (data retrieval)<br>
    • Serializers (formatting)
  </td>
  <td>
    • Clean separation<br>
    • Modular design<br>
    • Easy testing<br>
    • Reusable components
  </td>
</tr>

<tr>
  <td><strong>Response Handler</strong></td>
  <td>Consistent API responses</td>
  <td>
    • JSON:API compliance<br>
    • Standardized formatting<br>
    • Error handling<br>
    • Type safety
  </td>
  <td>
    • Consistent interfaces<br>
    • Clean error messages<br>
    • Predictable responses<br>
    • Better debugging
  </td>
</tr>

<tr>
  <td><strong>Rollback Manager</strong></td>
  <td>Safe change management</td>
  <td>
    • File tracking<br>
    • Safe removal<br>
    • Directory cleanup<br>
    • State management
  </td>
  <td>
    • Risk-free experimentation<br>
    • Clean rollbacks<br>
    • No orphaned files<br>
    • Reliable state
  </td>
</tr>
</table>

---

## Use Cases

<table>
<tr>
  <th width="25%" align="left">Use Case</th>
  <th width="30%" align="left">Scenario</th>
  <th width="30%" align="left">Key Benefits</th>
  <th width="15%" align="left">Ideal For</th>
</tr>

<tr>
  <td>
    <strong>✅ Enterprise API Development</strong>
  </td>
  <td>
    Large-scale applications requiring consistent API patterns across multiple teams
  </td>
  <td>
    • Enforced architectural patterns<br>
    • Version control for API structure<br>
    • Safe production rollbacks<br>
    • Consistent testing patterns
  </td>
  <td>
    <em>Fortune 500 companies, large dev teams, complex business domains</em>
  </td>
</tr>

<tr>
  <td>
    <strong>✅ Rapid Prototyping</strong>
  </td>
  <td>
    Startup teams need to quickly iterate on API designs and business logic
  </td>
  <td>
    • Generate complete APIs in minutes<br>
    • Safe architectural experimentation<br>
    • Instant rollback of failed experiments<br>
    • Focus on business logic over boilerplate
  </td>
  <td>
    <em>Startups, MVPs, proof-of-concepts, hackathons</em>
  </td>
</tr>

<tr>
  <td>
    <strong>✅ AI-Assisted Development</strong>
  </td>
  <td>
    Development teams working with AI coding assistants and autonomous agents
  </td>
  <td>
    • Machine-readable API definitions<br>
    • Safe AI experimentation environment<br>
    • Consistent patterns AI can learn<br>
    • Version control for AI changes
  </td>
  <td>
    <em>Teams using Cursor, Copilot, or custom AI agents</em>
  </td>
</tr>

<tr>
  <td>
    <strong>✅ Microservices Architecture</strong>
  </td>
  <td>
    Building multiple interconnected services with consistent patterns
  </td>
  <td>
    • Standardized service structure<br>
    • Consistent inter-service communication<br>
    • Unified testing strategies<br>
    • Easy pattern replication
  </td>
  <td>
    <em>Distributed systems, cloud-native apps, service mesh architectures</em>
  </td>
</tr>

<tr>
  <td>
    <strong>✅ Legacy System Modernization</strong>
  </td>
  <td>
    Gradually modernizing legacy systems with new API layers
  </td>
  <td>
    • Incremental migration safety<br>
    • Modern patterns alongside legacy code<br>
    • Safe architectural experimentation<br>
    • Clear old/new system separation
  </td>
  <td>
    <em>Enterprise modernization, technical debt reduction, gradual refactoring</em>
  </td>
</tr>
</table>

---

## AI-Powered Bootstrapping

### Intelligent Project Initialization

Hati Rails API enables AI agents to bootstrap entire projects based on high-level requirements:

```ruby
# AI can generate this from: "Create an e-commerce API with user management,
# product catalog, and order processing"
class BootstrapEcommerceApi < HatiRailsApi::Context::Migration
  def change
    # User management domain
    domain :user do |domain|
      domain.operation do |operation|
        operation.component [:register, :authenticate, :update_profile]
      end
      domain.endpoint true
      domain.model true
      domain.validation { |v| v.component [:email_validator, :password_validator] }
      domain.service { |s| s.component [:auth_service, :profile_service] }
    end

    # Product catalog domain
    domain :product do |domain|
      domain.operation do |operation|
        operation.component [:create, :update, :search, :categorize]
      end
      domain.endpoint true
      domain.model true
      domain.query { |q| q.component [:product_finder, :category_filter] }
      domain.service { |s| s.component [:inventory_service, :pricing_service] }
    end

    # Order processing domain
    domain :order do |domain|
      domain.operation do |operation|
        operation.component [:create, :process_payment, :fulfill, :cancel]
        operation.step true, granular: true
      end
      domain.endpoint true
      domain.model true
      domain.validation { |v| v.component [:payment_validator, :inventory_validator] }
      domain.service { |s| s.component [:payment_gateway, :shipping_service] }
    end

    # Additional models and endpoints
    model [:cart, :payment, :shipping_address, :order_item]
    endpoint [:order_status, :payment_webhook, :inventory_alert]
  end
end
```

### Context-Aware Feature Addition

AI agents can analyze existing migrations and add complementary features:

```ruby
# AI analyzes existing user and product domains, then adds:
class AddRecommendationSystem < HatiRailsApi::Context::Migration
  def change
    domain :recommendation do |domain|
      domain.operation do |operation|
        operation.component [:generate_recommendations, :track_interactions, :update_preferences]
      end
      domain.service do |service|
        service.component [:ml_engine, :preference_analyzer, :collaborative_filter]
      end
      domain.query { |q| q.component [:recommendation_finder, :interaction_tracker] }
    end

    # Extend existing domains with recommendation capabilities
    extend_domain :user do |domain|
      domain.service { |s| s.add_component :recommendation_service }
    end

    extend_domain :product do |domain|
      domain.query { |q| q.add_component :recommendation_query }
    end
  end
end
```

### Automated Testing Strategy Generation

AI can generate comprehensive testing strategies based on the migration structure:

```ruby
# AI generates test migrations alongside feature migrations
class GenerateTestingInfrastructure < HatiRailsApi::Context::Migration
  def change
    testing_domain :api_integration do |domain|
      domain.test_suite do |suite|
        suite.component [:endpoint_tests, :authentication_tests, :authorization_tests]
        suite.coverage :comprehensive
        suite.mock_external_services true
      end
    end

    testing_domain :performance do |domain|
      domain.benchmark do |benchmark|
        benchmark.component [:response_time, :throughput, :memory_usage]
        benchmark.scenarios [:normal_load, :peak_load, :stress_test]
      end
    end
  end
end
```

### Deployment Configuration Generation

AI can create deployment configurations based on the API structure:

```ruby
class GenerateDeploymentConfig < HatiRailsApi::Context::Migration
  def change
    deployment_domain :infrastructure do |domain|
      domain.container do |container|
        container.component [:api_service, :background_jobs, :database]
        container.scaling :auto
        container.health_checks true
      end

      domain.monitoring do |monitoring|
        monitoring.component [:metrics, :logging, :alerting]
        monitoring.dashboards [:api_performance, :business_metrics, :error_tracking]
      end
    end
  end
end
```

### AI Agent Tool Integration

Enable AI agents to modify and extend APIs autonomously:

```ruby
class CreateAgentToolsApi < HatiRailsApi::Context::Migration
  def change
    domain :agent_tools do |domain|
      # Safe database operations for AI agents
      domain.operation do |operation|
        operation.component [:safe_query, :safe_update, :analyze_data]
        operation.safety_checks true
        operation.audit_logging true
      end

      # AI agent capabilities
      domain.service do |service|
        service.component [:query_builder, :data_analyzer, :report_generator]
        service.rate_limiting true
        service.permission_checking true
      end

      domain.validation { |v| v.component [:query_validator, :safety_checker] }
    end

    # Audit trail for AI operations
    model [:agent_operation_log, :safety_check_result, :permission_audit]
  end
end
```

---

## Examples

### Basic User API

```ruby
class CreateUserApi < HatiRailsApi::Context::Migration
  def change
    domain :user do |domain|
      domain.operation do |operation|
        operation.component [:create, :authenticate, :update_profile]
      end
      domain.endpoint true
      domain.model true
      domain.validation
      domain.serializer
    end
  end
end
```

### E-commerce API with AI Features

```ruby
class CreateEcommerceApi < HatiRailsApi::Context::Migration
  def change
    domain :ecommerce do |domain|
      # Core business operations
      domain.operation do |operation|
        operation.component [:checkout, :refund, :inventory_check]
        operation.step true, granular: true
      end

      # AI-powered services
      domain.service do |service|
        service.component [:recommendation_engine, :fraud_detector]
      end

      domain.endpoint true
      domain.model true
      domain.validation { |v| v.component [:payment_validator] }
    end

    model [:product, :order, :payment]
    endpoint [:order_status, :payment_webhook]
  end
end
```

### Advanced Patterns

```ruby
# Custom layers
domain.analytics do |analytics|
  analytics.component [:event_tracker, :report_generator]
end

# Explicit steps
domain.operation do |operation|
  operation.component [:register]
  operation.step :validate, :persist, :notify
end

# Granular steps (uses all domain layers as steps)
domain.operation do |operation|
  operation.step true, granular: true
end
```

---

## AI Development Integration

### Enhanced AI Assistance

- **Context Awareness** — AI understands your full API structure
- **Pattern Learning** — AI learns from your existing migrations
- **Consistent Generation** — All AI-generated code follows your patterns
- **Safe Iteration** — Try AI suggestions with instant rollback

### Autonomous Development

- **Self-Modifying APIs** — AI agents can create migrations to extend functionality
- **Version Control** — Every change is tracked and reviewable
- **Pattern Enforcement** — AI agents follow your established patterns

---

## Testing

Comprehensive test suites are generated for all components:

```ruby
# Generated operation test
RSpec.describe User::Operation::Create do
  describe "#call" do
    it "creates user with valid params" do
      result = described_class.call(valid_user_params)

      expect(result).to be_success
      expect(result.value).to be_a(User)
    end
  end
end

# Generated controller test
RSpec.describe Api::UserController do
  describe "POST /api/users" do
    it "creates user and returns JSON response" do
      post "/api/users", params: valid_params

      expect(response).to have_http_status(:created)
      expect(json_response["data"]["type"]).to eq("user")
    end
  end
end
```

## Authors

- [Marie Giy](https://github.com/mariegiy)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hackico-ai/hati-command. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hackico-ai/hati-command/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HatCommand project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hackico-ai/hati-command/blob/main/CODE_OF_CONDUCT.md).
