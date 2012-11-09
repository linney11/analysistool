require 'json'

class UsersController < ApplicationController

  respond_to :html, :json

  def index
    # get all users in the table locations
    @users = User.all
    @gps_samples = GpsSample.all
    @gps_json = @gps_samples.to_json

  end

  def new
    # default: render ’new’ template (\app\views\user\new.html.haml)
  end

  def create
    # create a new instance variable called @location that holds a Location object built from the data the user submitted
    @user = User.new(params[:user])

    # if the object saves correctly to the database
    if @user.save
      # redirect the user to index
      redirect_to users_path, notice: 'User was successfully created.'
    else
      # redirect the user to the new method
      render action: 'new'
    end
  end

  def destroy
    # find only the location that has the id defined in params[:id]
    @user = User.find(params[:id])

    # delete the location object and any child objects associated with it
    @user.destroy

    # redirect the user to index
    redirect_to users_path, notice: 'Location was successfully deleted.'
  end

  def upload
    @user = User.find(params[:id])

   @gps_samples = GpsSample.find_all_by_user_id(@user)

    #obtener el numero de archivo
    if @gps_samples.length==0
      @fNum=1
    else
      @fNum= @gps_samples[@gps_samples.length-1].file.to_i+1
    end

    if !params[:file].nil?
      @file=params[:file]

      #validar que sean archivos .json
      chkNameFile=@file.original_filename.split(/\./)
      if chkNameFile[1]=="json"
        #guardar el archivo en un archivo temporar
        f = @file.tempfile.to_path

        #convertir al archivo en un arreglo de hash donde cada hash es un objeto json
        mylocJson = JSON.parse(File.read(f))

        mylocJson.each do |l1|
          @gps_samples = GpsSample.new("latitude"=>l1["latitude"],
                                       "longitude"=>l1["longitude"],
                                       "time"=>l1["timestamp"],
                                       "user_id"=>params[:id],
                                       "file"=>@fNum)
          @gps_samples.save!
        end

        #insertar en la tabla =D

        @gps_samples = GpsSample.find_all_by_user_id(params[:id])
        @gps_json = @gps_samples.to_json


      else
        redirect_to users_upload_path(@user, :id =>  params[:id]), notice: 'Just .json Files.'
      end

    end

  end

  def test

    @gps_json = GpsSample.all
    @gps_json = @gps_samples.to_json

  end


  def showAllAC

    if !params[:file].nil?
      @file=params[:file]

      #validar que sean archivos .json
      chkNameFile=@file.original_filename.split(/\./)
      if chkNameFile[1]=="json"
        #guardar el archivo en un archivo temporar
        f = @file.tempfile.to_path

        mylocJson = JSON.parse(File.read(f))
        mylocJson.each do |l1|
          @activity_count = ActivityCount.new("count"=>l1["count"],
                                              "time"=>l1["timestamp"],
                                              "user_id"=>l1["userID"])
          @activity_count.save!
          id=l1["userID"]
        end


        @activity_counts = ActivityCount.find_all_by_user_id(id)
        @counts = @activity_counts.to_json



      else
        redirect_to users_uploadAC_path(params[:id]), notice: 'Just .json Files.'
      end
    end

  end


  def showAC
    #@user = User.find(params[:id])

    @activity_counts = ActivityCount.find_all_by_user_id(params[:id])
    @x=Array.new
    @activity_counts.each do |ac|
      if ac[:count] != -1
     @x.push(ac[:count])
        end
    end
    @id=params[:id]

    respond_with(@x)

    #@graph = open_flash_chart_object(1000,300, '/users/graph_code')
  end

  def showAllAC
    @activity_counts = ActivityCount.all

    @x=Array.new
    @id = Array.new
    @activity_counts.each do |ac|
      if ac[:count] != -1
        @x.push(ac[:count])
      end
    end

    @users=User.all

    @users.each do |u|
      @id.push(u[:id])
    end

    @id = @id.to_s.gsub!("[","")
    @id = @id.to_s.gsub!("]","")


    respond_with(@x)

  end

end
