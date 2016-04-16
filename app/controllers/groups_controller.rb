class GroupsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_group, only: [:show]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all.collect {|g| g.to_hash}
    render json: {groups: @groups}, status: :ok
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.users = [User.where(:seq_id => params['user_id'].to_i).first]
    if @group.save
      render json: {message: "Added Successfully!"}, status: :ok
    else
      render json: {message: "Some issue!"}, status: 400
    end
  end

  def fetch_group
    if !params[:user_id].nil?
      @user_ids = User.where(seq_id: params[:user_id].to_i).pluck(:id)  
      @groups = Group.where(:user_ids.in => @user_ids).collect {|g| g.to_hash}
    elsif !params[:group_id].nil?
      @groups = Group.where(:group_id => params[:group_id]).collect {|g| g.to_hash}
    elsif !params[:group_name].nil?
      @groups = Group.where(:name => params[:group_name]).collect {|g| g.to_hash}
    elsif !params[:zip].nil?
      @groups = Group.where(:zip => params[:zip]).collect {|g| g.to_hash}
    end
    render json: {groups: @groups}, status: :ok
  end

  def allocate_user_group
    @user = User.where(seq_id: params[:user_id].to_i).first
    @group = Group.where(:group_id => params[:group_id]).first
    @group.users +=[@user]
    @group.save
    render json: {message: "Success!"}, status: :ok
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :group_id, :users, :zip, :city, :address, :state)
    end

end
