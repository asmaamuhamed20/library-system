# frozen_string_literal: true

require 'rails_helper'
require 'rswag/api'
require 'rswag/ui'
require 'rswag/specs'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: Ensure that rswag-api is configured to serve Swagger from this folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Library System API',
        version: 'v1',
        description: 'API documentation for the Library System'
      },
      paths: {
        '/api/v1/register' => {
          post: {
            summary: 'Register a new user',
            description: 'Create a new user with the provided information.',
            requestBody: {
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                    properties: {
                      username: { type: 'string' },
                      email: { type: 'string' },
                      password: { type: 'string' }
                    },
                    required: ['username', 'email', 'password']
                  }
                }
              },
              required: true
            },
            responses: {
              '201': {
                description: 'User created successfully',
                content: {
                  'application/json': {
                    schema: {
                      type: 'object',
                      properties: {
                        message: { type: 'string' }
                      }
                    }
                  }
                }
              },
              '422': {
                description: 'Validation errors',
                content: {
                  'application/json': {
                    schema: {
                      type: 'object',
                      properties: {
                        errors: { type: 'array', items: { type: 'string' } }
                      }
                    }
                  }
                }
              }
            }
          }
        },
        '/api/v1/login' => {
          post: {
            summary: 'Log in a user',
            description: 'Authenticate a user and return a JWT token.',
            requestBody: {
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                    properties: {
                      email: { type: 'string' },
                      password: { type: 'string' }
                    },
                    required: ['email', 'password']
                  }
                }
              },
              required: true
            },
            responses: {
              '200': {
                description: 'Login successful',
                content: {
                  'application/json': {
                    schema: {
                      type: 'object',
                      properties: {
                        token: { type: 'string' }
                      }
                    }
                  }
                }
              },
              '401': {
                description: 'Invalid credentials',
                content: {
                  'application/json': {
                    schema: {
                      type: 'object',
                      properties: {
                        error: { type: 'string' }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Local server'
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'
  config.openapi_format = :yaml
end
