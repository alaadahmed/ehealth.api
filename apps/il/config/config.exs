use Mix.Config

# General application configuration
config :il,
  env: Mix.env(),
  namespace: Il,
  ecto_repos: [Il.Repo, Il.PRMRepo],
  run_declaration_request_terminator: true,
  system_user: {:system, "EHEALTH_SYSTEM_USER", "4261eacf-8008-4e62-899f-de1e2f7065f0"}

# Configures the endpoint
config :il, Il.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AcugHtFljaEFhBY1d6opAasbdFYsvV8oydwW98qS0oZOv+N/a5TE5G7DPfTZcXm9",
  render_errors: [view: EView.Views.PhoenixError, accepts: ~w(json)]

# Configures Digital Signature API
config :il, Il.API.Signature,
  enabled: {:system, :boolean, "DIGITAL_SIGNATURE_ENABLED", true},
  endpoint: {:system, "DIGITAL_SIGNATURE_ENDPOINT"},
  hackney_options: [
    connect_timeout: {:system, :integer, "DIGITAL_SIGNATURE_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "DIGITAL_SIGNATURE_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "DIGITAL_SIGNATURE_REQUEST_TIMEOUT", 30_000}
  ]

# Configures MediaStorage API
config :il, Il.API.MediaStorage,
  endpoint: {:system, "MEDIA_STORAGE_ENDPOINT"},
  legal_entity_bucket: {:system, "MEDIA_STORAGE_LEGAL_ENTITY_BUCKET"},
  declaration_request_bucket: {:system, "MEDIA_STORAGE_DECLARATION_REQUEST_BUCKET"},
  declaration_bucket: {:system, "MEDIA_STORAGE_DECLARATION_BUCKET"},
  medication_request_request_bucket: {:system, "MEDIA_STORAGE_MEDICATION_REQUEST_REQUEST_BUCKET"},
  enabled?: {:system, :boolean, "MEDIA_STORAGE_ENABLED", false},
  hackney_options: [
    connect_timeout: {:system, :integer, "MEDIA_STORAGE_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "MEDIA_STORAGE_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "MEDIA_STORAGE_REQUEST_TIMEOUT", 30_000}
  ]

# Configures PRM API
config :il, Il.API.PRM,
  endpoint: {:system, "PRM_ENDPOINT", "http://api-svc.prm/api"},
  hackney_options: [
    connect_timeout: {:system, :integer, "PRM_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "PRM_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "PRM_REQUEST_TIMEOUT", 30_000}
  ]

# Configures Legal Entities token permission
config :il, Il.Plugs.ClientContext,
  tokens_types_personal: {:system, :list, "TOKENS_TYPES_PERSONAL", ["MSP", "PHARMACY"]},
  tokens_types_mis: {:system, :list, "TOKENS_TYPES_MIS", ["MIS"]},
  tokens_types_admin: {:system, :list, "TOKENS_TYPES_ADMIN", ["NHS ADMIN"]}

# Configures OAuth API
config :il, Il.API.Mithril,
  endpoint: {:system, "OAUTH_ENDPOINT"},
  hackney_options: [
    connect_timeout: {:system, :integer, "OAUTH_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "OAUTH_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "OAUTH_REQUEST_TIMEOUT", 30_000}
  ]

# Configures Man API
config :il, Il.API.Man,
  endpoint: {:system, "MAN_ENDPOINT"},
  hackney_options: [
    connect_timeout: {:system, :integer, "MAN_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "MAN_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "MAN_REQUEST_TIMEOUT", 30_000}
  ]

# Configures UAddress API
config :il, Il.API.UAddress,
  endpoint: {:system, "UADDRESS_ENDPOINT"},
  hackney_options: [
    connect_timeout: {:system, :integer, "UADDRESS_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "UADDRESS_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "UADDRESS_REQUEST_TIMEOUT", 30_000}
  ]

# Configures OTP Verification API
config :il, Il.API.OTPVerification,
  endpoint: {:system, "OTP_VERIFICATION_ENDPOINT"},
  hackney_options: [
    connect_timeout: {:system, :integer, "OTP_VERIFICATION_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "OTP_VERIFICATION_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "OTP_VERIFICATION_REQUEST_TIMEOUT", 30_000}
  ]

# Configures MPI API
config :il, Il.API.MPI,
  endpoint: {:system, "MPI_ENDPOINT"},
  hackney_options: [
    connect_timeout: {:system, :integer, "MPI_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "MPI_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "MPI_REQUEST_TIMEOUT", 30_000}
  ]

# Configures OPS API
config :il, Il.API.OPS,
  endpoint: {:system, "OPS_ENDPOINT"},
  hackney_options: [
    connect_timeout: {:system, :integer, "OPS_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "OPS_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "OPS_REQUEST_TIMEOUT", 30_000}
  ]

# Configures Gandalf API
config :il, Il.API.Gandalf,
  endpoint: {:system, "GNDF_ENDPOINT"},
  client_id: {:system, "GNDF_CLIENT_ID"},
  client_secret: {:system, "GNDF_CLIENT_SECRET"},
  application_id: {:system, "GNDF_APPLICATION_ID"},
  table_id: {:system, "GNDF_TABLE_ID"},
  hackney_options: [
    connect_timeout: {:system, :integer, "GNDF_REQUEST_TIMEOUT", 30_000},
    recv_timeout: {:system, :integer, "GNDF_REQUEST_TIMEOUT", 30_000},
    timeout: {:system, :integer, "GNDF_REQUEST_TIMEOUT", 30_000}
  ]

# employee request invitation
# Configures employee request invitation template
config :il, Il.Man.Templates.EmployeeRequestInvitation,
  id: {:system, "EMPLOYEE_REQUEST_INVITATION_TEMPLATE_ID"},
  format: {:system, "EMPLOYEE_REQUEST_INVITATION_TEMPLATE_FORMAT", "text/html"},
  locale: {:system, "EMPLOYEE_REQUEST_INVITATION_TEMPLATE_LOCALE", "uk_UA"}

# Configures employee request invitation email
config :il, Il.Bamboo.Emails.EmployeeRequestInvitation,
  from: {:system, "BAMBOO_EMPLOYEE_REQUEST_INVITATION_FROM", ""},
  subject: {:system, "BAMBOO_EMPLOYEE_REQUEST_INVITATION_SUBJECT", ""}

# Configures chain verification failure notification
config :il, Il.Bamboo.Emails.HashChainVeriricationNotification,
  from: {:system, "CHAIN_VERIFICATION_FAILED_NOTIFICATION_FROM", ""},
  to: {:system, "CHAIN_VERIFICATION_FAILED_NOTIFICATION_TO", ""},
  subject: {:system, "CHAIN_VERIFICATION_FAILED_NOTIFICATION_SUBJECT", ""}

config :il, Il.Man.Templates.HashChainVerificationNotification,
  id: {:system, "CHAIN_VERIFICATION_FAILED_NOTIFICATION_ID", ""},
  format: {:system, "CHAIN_VERIFICATION_FAILED_NOTIFICATION_FORMAT", ""},
  locale: {:system, "CHAIN_VERIFICATION_FAILED_NOTIFICATION_LOCALE", ""}

# employee created notification
# Configures employee created notification template
config :il, Il.Man.Templates.EmployeeCreatedNotification,
  id: {:system, "EMPLOYEE_CREATED_NOTIFICATION_TEMPLATE_ID"},
  format: {:system, "EMPLOYEE_CREATED_NOTIFICATION_TEMPLATE_FORMAT", "text/html"},
  locale: {:system, "EMPLOYEE_CREATED_NOTIFICATION_TEMPLATE_LOCALE", "uk_UA"}

config :il, Il.Man.Templates.DeclarationRequestPrintoutForm,
  id: {:system, "DECLARATION_REQUEST_PRINTOUT_FORM_TEMPLATE_ID"},
  format: {:system, "DECLARATION_REQUEST_PRINTOUT_FORM_TEMPLATE_FORMAT", "text/html"},
  locale: {:system, "DECLARATION_REQUEST_PRINTOUT_FORM_TEMPLATE_LOCALE", "uk_UA"}

# Configures employee created notification email
config :il, Il.Bamboo.Emails.EmployeeCreatedNotification,
  from: {:system, "BAMBOO_EMPLOYEE_CREATED_NOTIFICATION_FROM", ""},
  subject: {:system, "BAMBOO_EMPLOYEE_CREATED_NOTIFICATION_SUBJECT", ""}

# Template and setting for credentials recovery requests
config :il, :credentials_recovery_request_ttl,
  {:system, :integer, "CREDENTIALS_RECOVERY_REQUEST_TTL", 1_500}

config :il, Il.Bamboo.Emails.CredentialsRecoveryRequest,
  from: {:system, "BAMBOO_CREDENTIALS_RECOVERY_REQUEST_INVITATION_FROM", ""},
  subject: {:system, "BAMBOO_CREDENTIALS_RECOVERY_REQUEST_INVITATION_SUBJECT", ""}

config :il, Il.Man.Templates.CredentialsRecoveryRequest,
  id: {:system, "CREDENTIALS_RECOVERY_REQUEST_INVITATION_TEMPLATE_ID"},
  format: {:system, "CREDENTIALS_RECOVERY_REQUEST_INVITATION_TEMPLATE_FORMAT", "text/html"},
  locale: {:system, "CREDENTIALS_RECOVERY_REQUEST_INVITATION_TEMPLATE_LOCALE", "uk_UA"}

config :il, :legal_entity_employee_types,
  msp: {:system, "LEGAL_ENTITY_MSP_EMPLOYEE_TYPES", ["OWNER", "HR", "DOCTOR", "ADMIN"]},
  pharmacy: {:system, "LEGAL_ENTITY_PHARMACY_EMPLOYEE_TYPES", ["PHARMACY_OWNER", "PHARMACIST", "HR"]}

config :il, :legal_entity_division_types,
  msp: {:system, "LEGAL_ENTITY_MSP_DIVISION_TYPES", ["CLINIC", "AMBULANT_CLINIC", "FAP"]},
  pharmacy: {:system, "LEGAL_ENTITY_PHARMACIST_DIVISION_TYPES", ["DRUGSTORE", "DRUGSTORE_POINT"]}

config :il, :medication_request_request,
  expire_in_minutes: {:system, "MEDICATION_REQUEST_REQUEST_EXPIRATION", 30},
  otp_code_length: {:system, "MEDICATION_REQUEST_REQUEST_OTP_CODE_LENGTH", 4}

# Configures bamboo
config :il, Il.Bamboo.Mailer,
  adapter: Il.Bamboo.PostmarkAdapter,
  api_key: {:system, "POSTMARK_API_KEY", ""}

# Configures address merger
config :il, Il.Utils.AddressMerger,
  no_suffix_areas: {:system, "NO_SUFFIX_AREAS", ["М.КИЇВ", "М.СЕВАСТОПОЛЬ"]}

# Configures birth date validator
config :il, Il.Validators.BirthDate,
  min_age: {:system, "MIN_AGE", 0},
  max_age: {:system, "MAX_AGE", 150}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure JSON Logger back-end
config :logger_json, :backend,
  load_from_system_env: true,
  json_encoder: Poison,
  metadata: :all

# Configures declaration request terminator
config :il, Il.DeclarationRequest.Terminator,
  frequency: 24 * 60 * 60 * 1000,
  utc_interval: {0, 4}

# Configures employee request terminator
config :il, Il.EmployeeRequest.Terminator,
  frequency: 24 * 60 * 60 * 1000,
  utc_interval: {0, 4}

import_config "#{Mix.env}.exs"