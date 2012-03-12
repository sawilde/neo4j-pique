require 'spec_helper'

describe User do
  context "has neoid hooks" do
    subject { Follow._save_callbacks }    
    it { subject.select { |cb| cb.kind.eql?(:after_create) }.collect(&:filter).include?(:neocreate) }
    it { subject.select { |cb| cb.kind.eql?(:after_destroy) }.collect(&:filter).include?(:neodestroy) }
  end

  describe ".create_or_update_user" do
    subject { User.create_or_update_user(userdata) }
    let(:userdata) { {:twitter_id => 1234, :screen_name => 'superman', :profile_image_url => 'http://an_image_url'} }
    let(:user) { mock_model(User) }

    before do
      User.stub_chain("where.first") { found_user }
      user.should_receive(:save)
      user.should_receive(:screen_name=).with(userdata[:screen_name])
      user.should_receive(:profile_image_url=).with(userdata[:profile_image_url])
    end
    
    context "when user not previously registered" do
      before do
        User.should_receive("new").with({:twitter_id => userdata[:twitter_id]}).and_return(user)
      end
      let(:found_user) { nil }
      it { expect{subject}.not_to raise_error }
    end
    
    context "when user previously registered" do
      let(:found_user) { user }
      it { expect{subject}.not_to raise_error }
    end

  end  
  
  describe ".refresh_friends" do
    subject { User.refresh_friends(twitter_id, friend_ids) }
    let(:twitter_id) { 1 }
    let(:friend_ids) { ["2", "3"] }

    before do
      User.stub!('where').with(:twitter_id => 1).and_return([ found_user ])
    end
    
    context "when user is not known" do
      let(:user) { mock_model(User, {:twitter_id => 1}) }
      let(:found_user) { nil }
      it { expect{subject}.not_to raise_error }
    end

    describe "when user is known" do
      before do
        user.should_receive(:save)
        User.stub!('where').with(:twitter_id => 2).and_return([ ])
        User.stub!('where').with(:twitter_id => 3).and_return([ ])
      end
      
      context "and is not friends with any known users" do
        before do
          user.stub(:friends).and_return( [] )
          user.should_receive(:friends=).with([])
        end
        let(:user) { mock_model(User, {:twitter_id => 1}) }
        let(:found_user) { user }
        it { expect{subject}.not_to raise_error }
      end

      context "and stays friends with known users" do
        before do
          user.stub(:friends).and_return( [new_friend1, new_friend2] )
          user.should_receive(:friends=).with([new_friend1, new_friend2])
        end
        let(:user) { stub_model(User, {:twitter_id => 1}) }
        let(:new_friend1) { mock_model(User, {:twitter_id => 2}) }
        let(:new_friend2) { mock_model(User, {:twitter_id => 3}) }
        let(:found_user) { user }
        it { expect{subject}.not_to raise_error }
      end
      
      context "and is a new friend of known user" do
        before do
          user.should_receive(:friends=).with([ new_friend ])
          User.should_receive('where').with(:twitter_id => 2).and_return([ new_friend ])
        end
        let(:user) { stub_model(User, {:twitter_id => 1}) }
        let(:new_friend) { mock_model(User, {:twitter_id => 2}) }
        let(:found_user) { user }
        it { expect{subject}.not_to raise_error }
      end

      context "and is no longer a friend of known user" do
        before do
          user.stub(:friends).and_return( [old_friend] )
          user.stub(:follows).and_return( [ old_follow_users ] )
          User.should_receive('where').with(:twitter_id => 4).and_return([ old_friend ])
          user.follows.should_receive('where').with({:friend_id => old_friend.id, :user_id => found_user.id}).and_return( old_follow_users )
          old_follow_users.should_receive('destroy_all')
        end
        let(:user) { stub_model(User, {:twitter_id => 1}) }
        let(:old_friend) { mock_model(User, {:twitter_id => 4}) }
        let(:old_follow_users) { [mock_model(Follow)] }
        let(:found_user) { user }
        it { expect{subject}.not_to raise_error }
      end

    end
    
  end
  
end
