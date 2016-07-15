CocoView = require 'views/core/CocoView'
State = require 'models/State'
template = require 'templates/play/level/web-surface-view'

module.exports = class WebSurfaceView extends CocoView
  id: 'web-surface-view'
  template: template

  subscriptions:
    'tome:html-updated': 'onHTMLUpdated'

  initialize: (options) ->
    @state = new State
      blah: 'blah'
    super(options)

  afterRender: ->
    super()
    @iframe = @$('iframe')[0]
    $(@iframe).on 'load', (e) =>
      @iframe.contentWindow.postMessage {type: 'log', text: 'Player HTML iframe is ready.'}, "*" 
      @iframeLoaded = true
      @onIframeLoaded?()
      @onIframeLoaded = null
        
  onHTMLUpdated: (e) ->
    unless @iframeLoaded
      return @onIframeLoaded = => @onHTMLUpdated e unless @destroyed
    dom = htmlparser2.parseDOM e.html, {}
    body = _.find(dom, name: 'body') ? {name: 'body', attribs: null, children: dom}
    html = _.find(dom, name: 'html') ? {name: 'html', attribs: null, children: [body]}
    # TODO: pull out the actual scripts, styles, and body/elements they are doing so we can merge them with our initial structure on the other side
    virtualDOM = @dekuify html
    messageType = if @virtualDOM then 'update' else 'create'
    @iframe.contentWindow.postMessage {type: messageType, dom: virtualDOM}, '*'

  dekuify: (elem) ->
    return elem.data if elem.type is 'text'
    return null if elem.type is 'comment'  # TODO: figure out how to make a comment in virtual dom
    unless elem.name
      console.log("Failed to dekuify", elem)
      return elem.type
    deku.element(elem.name, elem.attribs, (@dekuify(c) for c in elem.children ? []))
