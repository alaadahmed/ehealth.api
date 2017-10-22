use Mix.Config

# Configuration for test environment


# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :il, Il.Web.Endpoint,
  http: [port: {:system, "PORT", 4000}],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console,
  format: "[$level] $message\n",
  level: :debug

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configures Legal Entities token permission
config :il, Il.Plugs.ClientContext,
  tokens_types_personal: {:system, :list, "TOKENS_TYPES_PERSONAL", ["MSP"]},
  tokens_types_mis: {:system, :list, "TOKENS_TYPES_MIS", ["MIS"]},
  tokens_types_admin: {:system, :list, "TOKENS_TYPES_ADMIN", ["NHS ADMIN"]}

config :il, :legal_entity_employee_types,
  msp: {:system, "LEGAL_ENTITY_MSP_EMPLOYEE_TYPES", ["OWNER", "HR", "DOCTOR", "ADMIN", "ACCOUNTANT"]},
  pharmacy: {:system, "LEGAL_ENTITY_PHARMACY_EMPLOYEE_TYPES", ["PHARMACY_OWNER", "PHARMACIST"]}

# Configures Digital Signature API
config :il, Il.API.Signature,
  endpoint: {:system, "DIGITAL_SIGNATURE_ENDPOINT", "http://35.187.186.145"}

# Configures OAuth API
config :il, Il.API.Mithril,
  endpoint: {:system, "OAUTH_ENDPOINT", "http://api-svc.mithril"}

# Configures Man API
config :il, Il.API.Man,
  endpoint: {:system, "MAN_ENDPOINT", "http://api-svc.man"}

# Configures UAddress API
config :il, Il.API.UAddress,
  endpoint: {:system, "UADDRESS_ENDPOINT", "http://api-svc.uaddresses"}

# Configures OTP Verification API
config :il, Il.API.OTPVerification,
  endpoint: {:system, "OTP_VERIFICATION_ENDPOINT", "http://api-svc.verification"}

# Configures MPI API
config :il, Il.API.MPI,
  endpoint: {:system, "MPI_ENDPOINT", "http://api-svc.mpi"}

# Configures OPS API
config :il, Il.API.OPS,
  endpoint: {:system, "OPS_ENDPOINT", "http://api-svc.ops"}

# Configures MediaStorage API
config :il, Il.API.MediaStorage,
  endpoint: {:system, "MEDIA_STORAGE_ENDPOINT", "http://api-svc.ael"},
  legal_entity_bucket: {:system, "MEDIA_STORAGE_LEGAL_ENTITY_BUCKET", "legal-entities-dev"},
  declaration_request_bucket: {:system, "MEDIA_STORAGE_DECLARATION_REQUEST_BUCKET", "declaration-requests-dev"},
  declaration_bucket: {:system, "MEDIA_STORAGE_DECLARATION_BUCKET", "declarations-dev"},
  medication_request_request_bucket:
    {:system, "MEDIA_STORAGE_MEDICATION_REQUEST_REQUEST_BUCKET", "medication-request-requests-dev"},
  enabled?: {:system, :boolean, "MEDIA_STORAGE_ENABLED", false}

# Configures Gandalf API
config :il, Il.API.Gandalf,
  endpoint: {:system, "GNDF_ENDPOINT", "https://api.gndf.io"},
  client_id: {:system, "GNDF_CLIENT_ID", "some_client_id"},
  client_secret: {:system, "GNDF_CLIENT_SECRET", "some_client_secret"},
  application_id: {:system, "GNDF_APPLICATION_ID", "some_gndf_application_id"},
  table_id: {:system, "GNDF_TABLE_ID", "some_gndf_table_id"}

# employee request invitation
# Configures employee request invitation template
config :il, Il.Man.Templates.EmployeeRequestInvitation,
  id: {:system, "EMPLOYEE_REQUEST_INVITATION_TEMPLATE_ID", 1}

# employee created notification
# Configures employee created notification template
config :il, Il.Man.Templates.EmployeeCreatedNotification,
  id: {:system, "EMPLOYEE_CREATED_NOTIFICATION_TEMPLATE_ID", 35}

config :il, Il.Man.Templates.DeclarationRequestPrintoutForm,
  id: {:system, "DECLARATION_REQUEST_PRINTOUT_FORM_TEMPLATE_ID", 4}

config :il, Il.Man.Templates.CredentialsRecoveryRequest,
  id: {:system, "CREDENTIALS_RECOVERY_REQUEST_INVITATION_TEMPLATE_ID", 5}

# Configure your database
config :il, Il.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ehealth",
  hostname: "localhost",
  pool_size: 10

config :il, Il.PRMRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "prm_dev",
  hostname: "localhost",
  pool_size: 10,
  types: Il.PRM.PostgresTypes