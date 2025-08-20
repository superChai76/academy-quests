class ApplicationJobTest < ActiveJob::TestCase
  test "create mailer instance" do
    job = ApplicationJob.new
    assert_instance_of ApplicationJob, job
  end
end