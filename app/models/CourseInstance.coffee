CocoModel = require './CocoModel'
schema = require 'schemas/models/course_instance.schema'

module.exports = class CourseInstance extends CocoModel
  @className: 'CourseInstance'
  @schema: schema
  urlRoot: '/db/course_instance'

  upsertForHOC: (opts) ->
    options = {
      url: _.result(@, 'url') + '/~/create-for-hoc'
      type: 'POST'
    }
    _.extend options, opts
    @fetch(options)
    
  addMember: (userID, opts) ->
    options = {
      method: 'POST'
      url: _.result(@, 'url') + '/members'
      data: { userID: userID }
    }
    _.extend options, opts
    @fetch(options)

  removeMember: (userID, opts) ->
    options = {
      url: _.result(@, 'url') + '/members'
      type: 'DELETE'
      data: { userID: userID }
    }
    _.extend options, opts
    @fetch(options)
    
  firstLevelURL: ->
    "/play/level/dungeons-of-kithgard?course=#{@get('courseID')}&course-instance=#{@id}"
