factories = require 'test/app/factories'
CampaignView = require 'views/play/CampaignView'
Levels = require 'collections/Levels'

describe 'CampaignView', ->

  describe 'when 4 earned levels', ->
    beforeEach ->
      @campaignView = new CampaignView()
      @campaignView.levelStatusMap = {}
      levels = new Levels(_.times(4, -> factories.makeLevel()))
      @campaignView.campaign = factories.makeCampaign({}, {levels})
      @levels = (level.toJSON() for level in levels.models)
      earned = me.get('earned') or {}
      earned.levels ?= []
      earned.levels.push(level.original) for level in @levels
      me.set('earned', earned)

    describe 'and 3rd one is practice', ->
      beforeEach ->
        @levels[2].practice = true
        @campaignView.annotateLevels(@levels)
      it 'hides next levels if there are practice levels to do', ->
        expect(@levels[2].hidden).toEqual(false)
        expect(@levels[3].hidden).toEqual(true)

    describe 'and 2nd rewards a practice a non-practice level', ->
      beforeEach ->
        @campaignView.levelStatusMap[@levels[0].slug] = 'complete'
        @campaignView.levelStatusMap[@levels[1].slug] = 'complete'
        @levels[1].rewards = [{level: @levels[2].original}, {level: @levels[3].original}]
        @levels[2].practice = true
        @campaignView.annotateLevels(@levels)
        @campaignView.determineNextLevel(@levels)
      it 'points at practice level first', ->
        expect(@levels[2].next).toEqual(true)
        expect(@levels[3].next).not.toBeDefined(true)
