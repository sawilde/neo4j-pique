function VoteManagerController(votes_element){

  this.timerId = 0;
  this.userId = 0;
  this.view_likes_path = $(votes_element).attr('data-view-likes-path');
  this.toggle_like_path = $(votes_element).attr('data-toggle-like-path');

  this.apply = function(){
    this.setController();
    this.clearUserId();
  }

  this.resetTimer = function(){
    if (this.timerId != 0) clearInterval(timerId);
    this.getVoteData();
    timerId = setInterval(this.getVoteData, 10000);    
  }
  
  this.setController = function(){
    var controller = this;
    $.each($(votes_element + ' .vote'), function(index, element){
      var tag_name = $(element).attr('data-tag-name');
      $(element)[0].controller = controller;
      $(element).find('.like').click(function(event){
        $.post(controller.toggle_like_path, { twitter_id: controller.userId, tag_name: tag_name } )
          .success(function(data) {
            controller.updateVoteData(element, data);
          });
      });
    });
  }

  this.setUserId = function(user_id){
    this.userId = user_id;
    $.each($(votes_element + ' .vote .like'), function(index, element){
      $(element).show();
    });
    this.resetTimer();
  }

  this.clearUserId = function(){
    this.userId = 0;
    $.each($(votes_element + ' .vote .like'), function(index, element){
      $(element).hide();
    });
    this.resetTimer();
  }

  this.updateVoteData = function(element, data){
    var results = ' ';
    var x1 = 0;
    var x2 = 0;
    if (data.you){
      results += 'you';
      x1 += 1;
    }
    for (f in data.friends) {
      if (x1 > 0){
        results += ', ';
      }
      x1 += 1;
      x2 += 1;
      results += data.friends[f]
      if (x2 >= 2) break;
    }
    results += ' +' + (data.count - x1) + ' others';
    $(element).find('.results').text(results);
    $(element).find('.like').text( data.you? 'Unlike' : 'Like');
  }

  this.getVoteData = function(){
    $.each($(votes_element + ' .vote'), function(index, element){
      var controller = $(element)[0].controller;
      var tag_name = $(element).attr('data-tag-name');
      $.getJSON(controller.view_likes_path, { twitter_id: controller.userId, tag_name: tag_name } )
        .success(function(data) {
          controller.updateVoteData(element, data);
        });
    });    
  }
}
