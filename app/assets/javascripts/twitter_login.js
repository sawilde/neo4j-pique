function TwitterLoginController(login_element, vote_controller) {

  var voteController = vote_controller;
  var register_path = $(login_element).attr('data-register-path');
  var update_friends_path = $(login_element).attr('data-updatefriends-path');

  this.apply = function(){
    var controller = this;
    $(login_element + " #sign-out").hide();
    $(login_element + " #sign-out").click(function(event){
      $(this).hide();
      twttr.anywhere.signOut();
    });

    twttr.anywhere(function (T){
      T(login_element + ' #sign-in').connectButton({
        size: "large",
        authComplete: function(user){
          $(login_element + " #sign-out").show();
          controller.registerUser(T.currentUser.data('id'), T.currentUser.data('screen_name'), T.currentUser.data('profile_image_url'));
        },
        signOut: function(){
          // this is where we need to hook in the sign-out action
          voteController.clearUserId();
        }
      });

      if (T.isConnected()) {
        $(login_element + " #sign-out").show();
        controller.registerUser(T.currentUser.data('id'), T.currentUser.data('screen_name'), T.currentUser.data('profile_image_url'));
      }
    });
  }

  this.registerUser = function(twitter_id, screen_name, profile_image_url) {
    var controller = this;
    $.post(register_path, { twitter_id: twitter_id, screen_name: screen_name, profile_image_url: profile_image_url } )
      .success(function(data) {
        controller.updateFriends(twitter_id);
    });      
  }

  this.updateFriends = function(twitter_id){
    var controller = this;
    $.getJSON("http://api.twitter.com/1/friends/ids.json?user_id=" + twitter_id + "&callback=?", function(data){
      $.post(update_friends_path, { twitter_id: twitter_id, friend_ids: data.ids } )
        .success(function(data) {
          // this is where we need to hook in the sign-in complete action
          voteController.setUserId(twitter_id);
      });      
    });           
  }
}