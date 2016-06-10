
class MainView

    resize: =>
        width = @$tiles.width()
        @$tiles.css
            height: width

    onGet: (result) =>
        nodes = jQuery.parseHTML(result)
        $div = $(_.find(nodes, ((el) ->
            el.nodeName == 'DIV')))

        $portfolioPiece = $div.find('[data-js-portfolio-piece]')
        $portfolioPiece.attr('data-js-portfolio-piece-in-modal', true)
        @$modalContent.fadeOut(100, =>
            @$modalContent.html($portfolioPiece)
            @$modalContent.fadeIn(100)
        )
        @$modal.show()
        @$modalContent.scrollTop(0)
        _.defer =>
            @$modal.attr('data-js-modal-is-visible', true)

        prevHref = $div.find('[data-js-modal-prev]').attr('href')
        nextHref = $div.find('[data-js-modal-next]').attr('href')
        $('[data-js-modal-prev] a').attr('href', prevHref)
        $('[data-js-modal-next] a').attr('href', nextHref)

    onTileClick: (e) =>
        href = $(e.target).closest('a').attr('href')
        if href?
            @loadPage(href)
            e.preventDefault()
            return false
        else
            return true

    loadPage: (href) =>
        jQuery.get(href, {}, @onGet, 'html')

    onModalCloseClick: (e) =>
        @$modal.attr('data-js-modal-is-visible', false)
        _.delay (=> @$modal.hide()), 250

    constructor: ->
        @$tiles = $('[data-js-tile]')
        @$modal = $('[data-js-modal]')
        @$modalContent = @$modal.find('[data-js-modal-content]')
        @$modalClose = @$modal.find('[data-js-modal-close]')

        @resize()
        $(window).on 'resize', _.throttle(@resize, 50)

        @$tiles.click @onTileClick
        $('[data-js-modal-prev] a').click @onTileClick
        $('[data-js-modal-next] a').click @onTileClick
        @$modalClose.click @onModalCloseClick

$ -> window.mainView = new MainView()
