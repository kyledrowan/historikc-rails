$(document).on('page:change', function() {
  if ( $('.pswp').length ) {
    $('.row').photoswipe({
      galleryPIDs: true,
      indexIndicatorSep: ' of ',
      shareButtons: [
        {id:'twitter', label:'Tweet', url:'https://twitter.com/intent/tweet?text={{text}} via @HistoriKC&url={{url}}'}
        // Facebook sharing pending Open Graph tags, see https://developers.facebook.com/docs/sharing/web
        // {id:'facebook', label:'Share on Facebook', url:'https://www.facebook.com/sharer/sharer.php?u={{url}}'}
      ],
      getTextForShare: function( shareButtonData ) {
        return $("[data-pid='" + this['index'] + "']").data('summary') || '';
      }
    });
  }
});
