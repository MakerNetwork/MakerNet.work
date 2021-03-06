class NotificationsMailer < NotifyWith::NotificationsMailer
  default :from => ENV['DEFAULT_MAIL_FROM']
  layout 'notifications_mailer'

  helper :application

  def send_mail_by(notification)
    @notification = notification
    @recipient = notification.receiver
    @attached_object = notification.attached_object
    @fablab_name = Setting.find_by(name: 'fablab_name').value

    if !respond_to?(notification.notification_type)
      class_eval %Q{
        def #{notification.notification_type}
          mail to: @recipient.email,
               subject: t('notifications_mailer.#{notification.notification_type}.subject', {FABLAB: @fablab_name}),
               template_name: '#{notification.notification_type}',
               content_type: 'text/html'
        end
      }
    end

    send(notification.notification_type)
  end

  def helpers
    ActionController::Base.helpers
  end

  def notify_user_when_invoice_ready
    attachments[@attached_object.filename] = File.read(@attached_object.file)
    @fablab_name = Setting.find_by(name: 'fablab_name').value
    mail(
      to: @recipient.email,
      subject: t('notifications_mailer.notify_member_invoice_ready.subject', {FABLAB: @fablab_name}),
      template_name: 'notify_member_invoice_ready'
    )
  end

  def notify_user_when_avoir_ready
    attachments[@attached_object.filename] = File.read(@attached_object.file)
    @fablab_name = Setting.find_by(name: 'fablab_name').value
    mail(
      to: @recipient.email,
      subject: t('notifications_mailer.notify_member_avoir_ready.subject', {FABLAB: @fablab_name}),
      template_name: 'notify_member_avoir_ready'
    )
  end
end
