(function($doc){
    $doc.on('portfolio.photosets.new:change', function(){
        // Handles importing photosets from Flickr
        $doc.on('click', '.photoset input[type="submit"]', function(){
            var $photoset, $inputs, $button = $(this), data;
            $photoset = $button.parents('.photoset');
            $inputs = $photoset.find('input');
            // Serializes the inputs in the fields based on the name attribute
            var serialize = function($el){
                var data = {
                    photoset: {
                        primary_photo_attributes: {}
                    }
                };
                $inputs.not('[type="submit"]').each(function(){
                    var $i = $(this);
                    var name = $i.attr('name');
                    var keys = _.filter(name.split(/[[\]]{1,2}/), function(part){
                        return part !== "" && part !== "photoset";
                    });
                    if (keys.length == 1) {
                        data.photoset[keys[0]] = $i.val();
                    } else if (keys.length == 2) {
                        data.photoset[keys[0]][keys[1]] = $i.val();
                    }
                });
                return data;
            };
            $.ajax({
                url: $(this).parents('form').attr('action'),
                method: 'post',
                dataType: 'json',
                data: serialize($photoset)
            }).success(function(data){
                var link = $('<a></a>');
                link.attr('href', '/photosets/' + data['id']);
                $doc.trigger('flash', ['notice', $photoset.find('.message.success').html()]);
                $button.remove();
                $photoset.find('.message.success').removeClass('invisible');
                $photoset.addClass('disabled');
                $photoset.wrap(link);
            }).fail(function(){
                $doc.trigger('flash', ['alert', $photoset.find('.message.failure').html()]);
            });
            return false;
        });
    });
}(jQuery(document)));