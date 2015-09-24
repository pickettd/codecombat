Campaign = require 'models/Campaign'
CocoCollection = require 'collections/CocoCollection'
Course = require 'models/Course'
CourseInstance = require 'models/CourseInstance'
LevelSession = require 'models/LevelSession'
RootView = require 'views/core/RootView'
template = require 'templates/courses/course-details'
User = require 'models/User'
utils = require 'core/utils'

module.exports = class CourseDetailsView extends RootView
  id: 'course-details-view'
  template: template

  events:
    'change .progress-expand-checkbox': 'onCheckExpandedProgress'
    'click .btn-play-level': 'onClickPlayLevel'
    'click .btn-save-settings': 'onClickSaveSettings'
    'click .btn-select-instance': 'onClickSelectInstance'
    'click .progress-member-header': 'onClickMemberHeader'
    'click .progress-header': 'onClickProgressHeader'
    'click .progress-level-cell': 'onClickProgressLevelCell'
    'mouseenter .progress-level-cell': 'onMouseEnterPoint'
    'mouseleave .progress-level-cell': 'onMouseLeavePoint'

  constructor: (options, @courseID) ->
    super options
    @courseInstanceID = utils.getQueryVariable('ciid', false) or options.courseInstanceID
    @adminMode = me.isAdmin()
    @memberSort = 'nameAsc'
    @course = @supermodel.getModel(Course, @courseID) or new Course _id: @courseID
    @listenTo @course, 'sync', @onCourseSync
    if @course.loaded
      @onCourseSync()
    else
      @supermodel.loadModel @course, 'course'

  getRenderData: ->
    context = super()
    context.adminMode = @adminMode ? false
    context.campaign = @campaign
    context.conceptsCompleted = @conceptsCompleted ? {}
    context.course = @course if @course?.loaded
    context.courseInstance = @courseInstance if @courseInstance?.loaded
    context.courseInstances = @courseInstances?.models ? []
    context.instanceStats = @instanceStats
    context.levelConceptMap = @levelConceptMap ? {}
    context.memberSort = @memberSort
    context.memberStats = @memberStats
    context.memberUserMap = @memberUserMap ? {}
    context.noCourseInstance = @noCourseInstance
    context.noCourseInstanceSelected = @noCourseInstanceSelected
    context.showExpandedProgress = @showExpandedProgress
    context.sortedMembers = @sortedMembers ? []
    context.userConceptStateMap = @userConceptStateMap ? {}
    context.userLevelStateMap = @userLevelStateMap ? {}
    context

  onCourseSync: ->
    # console.log 'onCourseSync'
    if me.isAnonymous()
      @noCourseInstance = true
      @render?()
      return
    return if @campaign?
    campaignID = @course.get('campaignID')
    @campaign = @supermodel.getModel(Campaign, campaignID) or new Campaign _id: campaignID
    @listenTo @campaign, 'sync', @onCampaignSync
    if @campaign.loaded
      @onCampaignSync()
    else
      @supermodel.loadModel @campaign, 'campaign'
    @render?()

  onCampaignSync: ->
    # console.log 'onCampaignSync'
    if @courseInstanceID
      @loadCourseInstance(@courseInstanceID)
    else if !me.isAnonymous()
      @courseInstances = new CocoCollection([], { url: "/db/user/#{me.id}/course_instances", model: CourseInstance})
      @listenToOnce @courseInstances, 'sync', @onCourseInstancesSync
      @supermodel.loadCollection(@courseInstances, 'course_instances')
    @levelConceptMap = {}
    for levelID, level of @campaign.get('levels')
      @levelConceptMap[levelID] ?= {}
      for concept in level.concepts
        @levelConceptMap[levelID][concept] = true
    @render?()

  loadCourseInstance: (courseInstanceID) ->
    # console.log 'loadCourseInstance'
    return if @courseInstance?
    @courseInstance = @supermodel.getModel(CourseInstance, courseInstanceID) or new CourseInstance _id: courseInstanceID
    @listenTo @courseInstance, 'sync', @onCourseInstanceSync
    if @courseInstance.loaded
      @onCourseInstanceSync()
    else
      @courseInstance = @supermodel.loadModel(@courseInstance, 'course_instance').model

  onCourseInstancesSync: ->
    # console.log 'onCourseInstancesSync'
    if @courseInstances.models.length is 1
      @loadCourseInstance(@courseInstances.models[0].id)
    else
      if @courseInstances.models.length is 0
        @noCourseInstance = true
      else
        @noCourseInstanceSelected = true
      @render?()

  onCourseInstanceSync: ->
    # console.log 'onCourseInstanceSync'
    @adminMode = true if @courseInstance.get('ownerID') is me.id
    @levelSessions = new CocoCollection([], { url: "/db/course_instance/#{@courseInstance.id}/level_sessions", model: LevelSession, comparator:'_id' })
    @listenToOnce @levelSessions, 'sync', @onLevelSessionsSync
    @supermodel.loadCollection @levelSessions, 'level_sessions', cache: false
    @members = new CocoCollection([], { url: "/db/course_instance/#{@courseInstance.id}/members", model: User, comparator: 'nameLower' })
    @listenToOnce @members, 'sync', @onMembersSync
    @supermodel.loadCollection @members, 'members', cache: false
    @render?()

  onLevelSessionsSync: ->
    # console.log 'onLevelSessionsSync'
    @instanceStats = averageLevelsCompleted: 0, furthestLevelCompleted: '', totalLevelsCompleted: 0, totalPlayTime: 0
    @memberStats = {}
    @userConceptStateMap = {}
    @userLevelSessionMap = {}
    @userLevelStateMap = {}
    levelStateMap = {}
    for levelSession in @levelSessions.models
      userID = levelSession.get('creator')
      levelID = levelSession.get('level').original
      state = if levelSession.get('state')?.complete then 'complete' else 'started'
      levelStateMap[levelID] = state

      @instanceStats.totalLevelsCompleted++ if state is 'complete'
      @instanceStats.totalPlayTime += levelSession.get('playtime')

      @memberStats[userID] ?= totalLevelsCompleted: 0, totalPlayTime: 0
      @memberStats[userID].totalLevelsCompleted++ if state is 'complete'
      @memberStats[userID].totalPlayTime += levelSession.get('playtime')

      @userConceptStateMap[userID] ?= {}
      for concept of @levelConceptMap[levelID]
        @userConceptStateMap[userID][concept] = state

      @userLevelSessionMap[userID] ?= {}
      @userLevelSessionMap[userID][levelID] = levelSession

      @userLevelStateMap[userID] ?= {}
      @userLevelStateMap[userID][levelID] = state

    if @courseInstance.get('members').length > 0
      @instanceStats.averageLevelsCompleted = @instanceStats.totalLevelsCompleted / @courseInstance.get('members').length
    for levelID, level of @campaign.get('levels')
      @instanceStats.furthestLevelCompleted = level.name if levelStateMap[levelID] is 'complete'

    @conceptsCompleted = {}
    for userID, conceptStateMap of @userConceptStateMap
      for concept, state of conceptStateMap
        @conceptsCompleted[concept] ?= 0
        @conceptsCompleted[concept]++
    @render?()

  onMembersSync: ->
    # console.log 'onMembersSync'
    @memberUserMap = {}
    for user in @members.models
      @memberUserMap[user.id] = user
    @sortMembers()
    @render?()

  onCheckExpandedProgress: (e) ->
    @showExpandedProgress = $('.progress-expand-checkbox').prop('checked')
    # TODO: why does render reset the checkbox to be unchecked?
    @render?()
    $('.progress-expand-checkbox').attr('checked', @showExpandedProgress)

  onClickMemberHeader: (e) ->
    @memberSort = if @memberSort is 'nameAsc' then 'nameDesc' else 'nameAsc'
    @sortMembers()
    @render?()

  onClickProgressHeader: (e) ->
    @memberSort = if @memberSort is 'progressAsc' then 'progressDesc' else 'progressAsc'
    @sortMembers()
    @render?()

  onClickPlayLevel: (e) ->
    levelSlug = $(e.target).data('level-slug')
    Backbone.Mediator.publish 'router:navigate', {
      route: "/play/level/#{levelSlug}"
      viewClass: 'views/play/level/PlayLevelView'
      viewArgs: [{}, levelSlug]
    }

  onClickSaveSettings:  (e) ->
    return unless @courseInstance
    if name = $('.settings-name-input').val()
      @courseInstance.set('name', name)
    description = $('.settings-description-input').val()
    console.log 'onClickSaveSettings', description
    @courseInstance.set('description', description)
    @courseInstance.patch()
    $('#settingsModal').modal('hide')

  onClickSelectInstance: (e) ->
    courseInstanceID = $('.select-instance').val()
    @noCourseInstanceSelected = false
    @loadCourseInstance(courseInstanceID)

  onClickProgressLevelCell: (e) ->
    return unless @adminMode
    levelID = $(e.currentTarget).data('level-id')
    levelSlug = $(e.currentTarget).data('level-slug')
    userID = $(e.currentTarget).data('user-id')
    return unless levelID and levelSlug and userID
    route = "/play/level/#{levelSlug}"
    if @userLevelSessionMap[userID]?[levelID]
      route += "?session=#{@userLevelSessionMap[userID][levelID].id}&observing=true"
    Backbone.Mediator.publish 'router:navigate', {
      route: route
      viewClass: 'views/play/level/PlayLevelView'
      viewArgs: [{}, levelSlug]
    }

  onMouseEnterPoint: (e) ->
    $('.progress-popup-container').hide()
    container = $(e.target).find('.progress-popup-container').show()
    margin = 20
    offset = $(e.target).offset()
    scrollTop = $('#page-container').scrollTop()
    height = container.outerHeight()
    container.css('left', offset.left + e.offsetX)
    container.css('top', offset.top + scrollTop - height - margin)

  onMouseLeavePoint: (e) ->
    $(e.target).find('.progress-popup-container').hide()

  sortMembers: ->
    # Progress sort precedence: most completed concepts, most started concepts, most levels, name sort
    return unless @campaign and @courseInstance and @memberUserMap
    @sortedMembers = @courseInstance.get('members')
    switch @memberSort
      when "nameDesc"
        @sortedMembers.sort (a, b) => @memberUserMap[b]?.get('name').localeCompare(@memberUserMap[a]?.get('name'))
      when "progressAsc"
        @sortedMembers.sort (a, b) =>
          for levelID, level of @campaign.get('levels')
            if @userLevelStateMap[a][levelID] isnt 'complete' and @userLevelStateMap[b][levelID] is 'complete'
              return -1
            else if @userLevelStateMap[a][levelID] is 'complete' and @userLevelStateMap[b][levelID] isnt 'complete'
              return 1
          0
      when "progressDesc"
        @sortedMembers.sort (a, b) =>
          for levelID, level of @campaign.get('levels')
            if @userLevelStateMap[a][levelID] isnt 'complete' and @userLevelStateMap[b][levelID] is 'complete'
              return 1
            else if @userLevelStateMap[a][levelID] is 'complete' and @userLevelStateMap[b][levelID] isnt 'complete'
              return -1
          0
      else
        @sortedMembers.sort (a, b) => @memberUserMap[a]?.get('name').localeCompare(@memberUserMap[b]?.get('name'))
