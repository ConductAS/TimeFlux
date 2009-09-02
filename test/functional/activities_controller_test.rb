require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase

  context "User logged in: " do

    setup { login_as(:bob) }
    
    context "GET to :index without search criteria" do

      setup { get :index }

      should_respond_with :success
      should_assign_to :activities

    end

    context "GET to :new" do
      
      setup { get :new }
      
      should_respond_with :success
      should_assign_to :activity
      
    end
    
    context "GET to :edit" do
      
      setup do
        @id = activities(:timeflux_development).id 
        get :edit, :id => @id
      end
      
      should_respond_with :success
      
      should "find activity 'TimeFlux Development'" do
         assert_equal(@id, assigns(:activity).id)
      end
      
    end
    
    context "successful POST to :create" do
      
      setup do
        post :create, "activity"=>{"name"=>"Foobar", "default_activity"=>"0", "description"=>"Put the foo in the bar", "active"=>"1", "tag_ids" => "#{tags(:timeflux).id}"}
      end
       
      should_change "Activity.count", :by => 1            
      should_redirect_to(":index") { activities_url }
            
    end
    
    context "unsuccessful POST to :create" do
      
      setup do
        @original_activity_count = Activity.count
        post :create, "activity"=>{} # The activities table has a not null constraint on :name
      end
      
      should_assign_to :activity      
      should_render_template :new
      should_not_change "Activity.count"      
      
    end
    
    context "PUT to :update" do
    
      setup do
        @activity = Activity.find_by_id(activities(:timeflux_development).id)
      end
    
      context "successful path" do
      
        setup do
          put :update, "id"=>@activity.id,
          "activity"=>{"name"=>"TimeFlux Admin", "default_activity"=>"1", "description"=>"Administration of TimeFlux in production", "active"=>"0"}        
        end
      
        should_assign_to :activity
        should_set_the_flash_to 'Activity was successfully updated.'      
        should_redirect_to(":index") { activities_url }
      
      end
    
      context "unsuccessful path" do
      
        setup do
          put :update, "id"=>@activity.id,
          "activity"=>{"name"=>"", "default_activity"=>"1", "description"=>"Administration of TimeFlux in production", "active"=>"0"}        
        end
      
        should_assign_to :activity
        should_render_template :edit
        should_not_change "@activity.name"
      
      end
    
    end
    
    context "successful DELETE to :destroy" do
      
      setup do
        @id = activities(:timeflux_administration).id
        delete :destroy, "id"=>@id
      end
      
      should_change "Activity.count", :by => -1
      should_set_the_flash_to "Activity successfully removed"      
      should_redirect_to(":index") { activities_url }
           
    end
        
    context "unsuccessful DELETE to :destroy for activity with no time entries" do
           
      setup do
        @id = activities(:timeflux_administration).id.to_s
        activity = Activity.find_by_id @id
        activity.stubs(:destroy).returns(false)
        Activity.expects(:find_by_id).at_least_once.with(equals(@id)).returns(activity)
        delete :destroy, "id"=>@id
      end
      
      should_not_change "Activity.count"      
      should_render_template :edit
      should_assign_to :activity
      
    end
    
    context "unsuccessful DELETE to :destroy for activity with time entries" do
      
      setup do
        @id = activities(:timeflux_development).id.to_s
        delete :destroy, "id"=>@id
      end
      
      should_not_change "Activity.count"           
      should_render_template :edit
      should_assign_to :activity
      
    end
            
  end

  context "User logged out: " do

    should "be redirected to login page on GET to :index" do
      get :index
      assert_redirected_to new_user_session_url
    end

    should "be redirected to login page on GET to :destroy" do
      get :destroy
      assert_redirected_to new_user_session_url
    end

    should "be redirected to login page on POST to :create" do
      post :create
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on POST to :filter_by_tag_type" do
      post :filter_by_tag_type
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on POST to :filter_by_tag" do
      post :filter_by_tag
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on GET to :edit" do
      get :edit
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on GET to :new" do
      get :new
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on PUT to :update" do
      put :update
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on POST to :add_tag" do
      post :add_tag
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on POST to :add_user" do
      post :add_user
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on GET to :remove_tag" do
      get :remove_tag
      assert_redirected_to new_user_session_url
    end
    
    should "be redirected to login page on GET to :remove_user" do
      get :remove_user
      assert_redirected_to new_user_session_url
    end

  end

end