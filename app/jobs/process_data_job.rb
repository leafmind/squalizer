class ProcessDataJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |error|
    ap error
  end

  def perform(report)
    report.update!(state: :processing)
    report.build_statistics
    report.build_average
    report.update!(state: :ready)
  end

end