RSpec::Matchers.define :be_a_docker_success do
  match do |actual|
    if actual.is_a?(Array)
      actual[2].success?
    else
      actual == true
    end
  end

  failure_message do |actual|
    if actual.is_a?(Array)
      out_buffer = actual[0]
      out_buffer.seek(-2048, IO::SEEK_END)

      lines = out_buffer.readlines
      if lines.count > 50
        lines = lines[-50, 50]
      end

      "Container run failed (%s) last lines:\n\n%s" % [ actual[2], lines.join ]
    else
      "Container run failed"
    end
  end
end
