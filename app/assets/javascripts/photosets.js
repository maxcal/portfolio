(function($doc){
    $doc.on('portfolio.photosets.new:change', function(){
        $('#import_photosets_form').on('click', 'input[type="submit"]', function(){
            var $photoset, $inputs, $button = $(this), data;
            $photoset = $button.parents('.photoset');
            $inputs = $photoset.find('input');

            $.ajax({
                url: $(this).parents('form').attr('action'),
                method: 'post',
                dataType: 'json',
                data: {
                    photoset: {
                        flickr_uid: $inputs.filter('.flickr_uid').val(),
                        title: $inputs.filter('.title').val(),
                        description: $inputs.filter('.description').val(),
                        user_id: $inputs.filter('.user_id').val()
                    }
                }
            }).success(function(){
                $doc.trigger('flash', ['notice', $photoset.find('.message.success').html()]);
                $button.remove();
                $photoset.addClass('disabled');
            }).fail(function(){
                $doc.trigger('flash', ['alert', $photoset.find('.message.failure').html()]);
            });
            return false;
        });
    });
}(jQuery(document)));