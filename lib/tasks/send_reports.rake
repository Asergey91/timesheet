
task :send_reports => :environment do
  notifier = Slack::Notifier.new "https://hooks.slack.com/services/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"
  @report='THIS IS A FLASH REPORT FOR '+Date.today.to_s
  @report=@report+"\n"
  @users=User.all
  @users.each do |user|
    @tasks=user.tasks.where(created_at: (Time.now-1.day)..Time.now)
    if @tasks.empty?
      
    else
      @report=@report+'--------------------------------------'
      @report=@report+"\n"
      @report=@report+'--------------------------------------'
      @report=@report+"\n"
      @report=@report+('*@'+user.handle+'*'+' ('+user.first_name+' '+user.last_name+') today has worked on:')
      @report=@report+"\n"
      @report=@report+'--------------------------------------'
      @report=@report+"\n"
      @tasks.each do |task|
        @report=@report+'----'
        @report=@report+'*'+task.client.name+'*'+' &gt; '+'*'+task.project.name+'*'+' &gt; '+'*'+task.activity.name+'*'
        @report=@report+"\n"
        
        @report=@report+'```'+task.notes+'```'
        @report=@report+"\n"
        
        @report=@report+"\n"
      end
    end
    notifier.ping @report
    @report=''
  end
  notifier.ping @report
end