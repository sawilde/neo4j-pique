function VoteManagerController(votes_element){

  this.timerId = 0;
  this.userId = 0;
  this.view_likes_path = $(votes_element).attr('data-view-likes-path');
  this.toggle_like_path = $(votes_element).attr('data-toggle-like-path');

  this.apply = function(){
    this.clearUserId();
    this.setController();
    this.getVoteData();
    timerId = setInterval(this.getVoteData, 10000);
  }
  
  this.setController = function(){
    var controller = this;
    $.each($(votes_element + ' .vote'), function(index, element){
      $(element)[0].controller = controller;
    });
  }

  this.setUserId = function(user_id){
    console.log(user_id);
    this.userId = user_id;
    $.each($(votes_element + ' .vote .like'), function(index, element){
      $(element).show();
    });
  }

  this.clearUserId = function(){
    this.userId = 0;
    $.each($(votes_element + ' .vote .like'), function(index, element){
      $(element).hide();
    });
  }

  this.getVoteData = function(){
    $.each($(votes_element + ' .vote'), function(index, element){
      var controller = $(element)[0].controller;
      var tag_name = $(element).attr('data-tag-name');
      //console.log(tag_name + ':' + controller.userId);
      $.post(controller.view_likes_path, { twitter_id: controller.user_id, tag_name: tag_name } )
        .success(function(data) {
          var results = ' ';
          var x = 0;
          for (f in data.friends) {
            x += 1;
            results += data.friends[f]
            if (x >= 2) break;
            results += ', ';
          }
          results += ' +' + (data.count - x) + ' others';
          $(element).find('.results').text(results);
        });
    });    
  }
}
