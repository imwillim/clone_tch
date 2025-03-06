# frozen_string_literal: true

class TestMailer < ApplicationMailer
  default from: 'kkan@apcs.fitus.edu.vn'

  def hello
    mail(
      # rubocop:disable Rails/I18nLocaleTexts
      subject: 'Hello from Postmark',
      # rubocop:enable Rails/I18nLocaleTexts
      to: 'kkan@apcs.fitus.edu.vn',
      from: 'kkan@apcs.fitus.edu.vn',
      html_body: '<strong>Hello</strong> this one is currently test from rails',
      track_opens: 'true',
      message_stream: 'outbound'
    )
  end
end
