# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://83f56a37d80a6fdfdd13409baec4bad5@o4509152856047616.ingest.de.sentry.io/4509487937290320'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  config.send_default_pii = true
end
