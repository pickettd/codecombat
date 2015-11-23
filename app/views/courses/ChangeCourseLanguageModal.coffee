ModalView = require 'views/core/ModalView'
template = require 'templates/courses/change-course-language-modal'

module.exports = class ChangeCourseLanguageModal extends ModalView
  id: 'change-course-language-modal'
  template: template

  events:
    'click .lang-choice-btn': 'onClickLanguageChoiceButton'

  onClickLanguageChoiceButton: (e) ->
    @chosenLanguage = $(e.target).data('language')
    aceConfig = _.clone(me.get('aceConfig') or {})
    aceConfig.language = @chosenLanguage
    me.set('aceConfig', aceConfig)
    res = me.patch()
    if res
      @$('#choice-area').hide()
      @$('#saving-progress').removeClass('hide')
      @listenToOnce me, 'sync', @onLanguageSettingSaved
    else
      @onLanguageSettingSaved()

  onLanguageSettingSaved: ->
    @trigger('set-language')
    @hide()
