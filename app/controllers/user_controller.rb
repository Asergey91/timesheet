class UserController < ApplicationController
    before_action :check_user
    def cancel_recording
        @user=current_user
        @timer=current_user.timers.find(timer_params[:id])
        @timer.timer_status=0
        @timer.timer_paused_at=nil
        @timer.timer_started_at=nil
        @timer.timer_activity=0
        @timer.timer_elapsed_time=0
        @timer.save
        flash[:error]='Recording was canceled'
        redirect_to '/user/record_time'
    end
    def record_time
        @clients=current_user.clients.uniq
        @user=current_user
        @flag=false
        if @user.timers.count!=0
            @flag=true
        end
        #Todo
        if @flag
            @selected={:activity=>@user.timer_activity, :project=>Activity.find(@user.timer_activity).project.id, :client=>Activity.find(@user.timer_activity).client.id}
            @timer_status=@user.timer_status
            if @timer_status==1
                @elapsed_time=@user.timer_elapsed_time+(Time.now-@user.timer_started_at).seconds.round
            elsif @timer_status==2
                @elapsed_time=@user.timer_elapsed_time
            end
        end
    end
    def timer_start
        
        @timer=timer_params
        @user=current_user
        
        @user.timer_status=0
        @user.timer_paused_at=nil
        @user.timer_started_at=nil
        @user.timer_activity=0
        @user.timer_elapsed_time=0
        
        
        @user.timer_status=1#started and running
        @user.timer_started_at=Time.now
        @user.timer_activity=@timer[:timer_activity].to_i
        @user.save
        respond_to do |format|
            format.json { render json: @user }
        end
    end
    
    def timer_pause
        @timer=timer_params
        @user=current_user
        @user.timer_status=2#paused
        @user.timer_paused_at=Time.now
        @user.timer_elapsed_time=@user.timer_elapsed_time+(@user.timer_paused_at-@user.timer_started_at).seconds.round
        @user.save
        respond_to do |format|
            format.json { render json: @user }
        end
    end
    def get_params
        @timer=timer_params
        @user=current_user
        respond_to do |format|
            format.json { render json: @user }
        end
    end
    def timer_resume
        @timer=timer_params
        @user=current_user
        @user.timer_status=1#resumed and running
        @user.timer_started_at=Time.now
        @user.save
        respond_to do |format|
            format.json { render json: @user }
        end
    end
    
    def timer_stop
        @timer=timer_params
        @user=current_user
        if @user.timer_status==2 || @user.timer_status==4
            
        
        else
            @user.timer_paused_at=Time.now
            @user.timer_elapsed_time=@user.timer_elapsed_time+(@user.timer_paused_at-@user.timer_started_at).seconds.round
        end
        @user.timer_status=2#paused
        @user.save
        respond_to do |format|
            format.json { render json: @user }
        end
    end
    #landing page for users
    def new_task
        @clients=current_user.clients.uniq
    end
    
    #ajax for the main user page
    def get_projects
        @params=task_params
        @client=current_user.clients.find(@params[:client_id])
        counter=0
        @res=[]
        @client.projects.each do |c|
            if c.users.include? current_user
                @res[counter]={
                    project_id: c.id, 
                    name: c.name
                }
                counter+=1
            end
        end
        respond_to do |format|
            format.json {render json: @res.uniq}
        end
    end
    
    #ajax for the main user page
    def get_activities
        @params=task_params
        @project=current_user.projects.find(@params[:project_id])
        counter=0
        @res=[]
        @project.activities.each do |p|
            if p.users.include? current_user
                @res[counter]={
                    activity_id: p.id, 
                    name: p.name
                }
                counter+=1
            end
        end
        respond_to do |format|
            format.json {render json: @res.uniq}
        end
    end
    
    #list all tasks
    def history
        @tasks=current_user.tasks.includes(:client, :project, :activity).order(:date).reverse
    end
    
    #create a new task
    def create_task
        @p=task_params
        @user=current_user
        if @p[:is_recorded]
            @user.timer_status=0
            @user.timer_paused_at=nil
            @user.timer_started_at=nil
            @user.timer_activity=0
            @user.timer_elapsed_time=0
            @user.save
        end    
        if !@p[:activity_id] || !@p[:project_id]
            flash[:error]='Please make sure to fill out the form correctly'
            return redirect_to action:'new_task'
        end
        @activity=Activity.find(@p[:activity_id])
        @c=current_user
        if !@activity.users.include? @c
            flash[:error]='Please make sure to fill out the form correctly'
            return redirect_to action:'new_task'
        end
        @ass=@activity.assignments.find_by_user_id(@c.id)
        @ass.tasks.create(
            hours: @p[:hours],
            notes: @p[:notes],
            date: @p[:date]
        )
        flash[:notice]='Task has been submitted'
        if @p[:is_recorded]
            redirect_to '/user/record_time'
        else
            redirect_to '/user/new_entry'
        end
    end
    
    #edit user details
    def user_edit
        @user=current_user
    end
    
    def user_update
        begin
            @user=current_user
            @user.update!(user_params)
            flash[:notice]='Your details have been updated'
            redirect_to '/user/edit'
        rescue
            flash[:error]='Please make sure to fill out the form correctly'
            redirect_to '/user/edit'
        end
    end
    
    #change password
    def change_password
        begin
            @params=password_params
            @user=current_user
            if @params[:repeat]==@params[:new]
                @user.password=@params[:new]
                @user.password_verify=@params[:old]
                @user.change_password
                @user.save!
                flash[:notice]='Password changed successfully'
            else
                flash[:error]='You didnt correctly retype your new password'
            end
            redirect_to '/user/edit'
        rescue
            flash[:error]='Your old password wasn\'t correct'
            redirect_to '/user/edit'
        end
    end
    private
     # Never trust parameters from the scary internet, only allow the white list through.
        def timer_params
            params.require(:timer).permit(:id, :timer_activity)
        end
        def user_params
            params.require(:user).permit(:first_name, :last_name, :tel, :whatsapp, :email)
        end
        
        def password_params
            params.require(:pass).permit(:old, :new, :repeat)
        end
      
        def task_params
            params.require(:task).permit(:client_id, :project_id, :activity_id, :hours, :notes, :date, :is_recorded)
        end
end