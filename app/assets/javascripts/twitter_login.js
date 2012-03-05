function TwitterLoginController(login_div) {

  var register_path = $(login_div).attr('data-register-path');
  var update_friends_path = $(login_div).attr('data-updatefriends-path');

  this.apply = function(){
    var controller = this;
    twttr.anywhere(function (T){
      T(login_div).connectButton({
        size: "large",
        authComplete: function(user){
          controller.registerUser(T.currentUser.data('id'), T.currentUser.data('screen_name'), T.currentUser.data('profile_image_url'));
        },
        signOut: function(){
            // this is where we need to hook in the sign-out action
        }
      });

      if (T.isConnected()) {
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
      });      
    });           
  }
}