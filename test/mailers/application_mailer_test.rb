class ApplicationMailerTest < ActionMailer::TestCase
  test "create mailer instance" do
    mailer = ApplicationMailer.new
    assert_instance_of ApplicationMailer, mailer
  end
end
