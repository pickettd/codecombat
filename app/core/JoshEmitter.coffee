utils = require 'core/utils'

module.exports = class JoshEmitter extends SPE.Emitter
  constructor: (options) ->
    SPE.Emitter.call(@, options)
    @time = 0
    @isStatic = 0.0
    @particleCount = 2000
    @liveCount = 20
    @levelParticles = {}
    @behaviors = new Array(@particleCount)
    @nextPossiblePosition = 0
    @white = new THREE.Color('white') 

  getParticle: ->
    @behaviors[++@nextPossiblePosition] =
      alive: true

  updateWorldInfo: (data) ->
    console.log "Incoming world", data
    @levelInfo = {}
    for key, level of data
      @levelInfo[level.slug] = level

    console.log(@levelInfo)


  updateLevelInfo: (data) ->
    console.log "Incoming data", data
    #sum = Object.values(data).reduceRight ((a,b) -> a + b), 0
    #@liveCount = sum
    @counts = data

    for level, count of data
      continue unless @levelInfo[level]
      @levelParticles[level] ?= []
      for x in [0...count-1]
        p = @getParticle()
        p.position = @levelInfo[level].position
        p.level = level
        p.idx = x
        @levelParticles[level].push p

  updateEdgeInfo: (data) ->
    console.log "Got Edge Info", data
    updates = []
    for d in data
      fromInfo = @levelInfo[d.from]
      toInfo = @levelInfo[d.to]
      continue unless fromInfo? and toInfo?
      toUpdate = d.count
      for j in [0..toUpdate]
        for x in @behaviors
          continue unless x? and x.level is d.from and not x.banned
          x.banned = true
          do (x, d, toInfo, j, updates) =>
            updates.push =>
              x.level = d.to
              x.position = toInfo.position
              
              oldidx = @levelParticles[d.from].indexOf(x)
              @levelParticles[d.from].splice(oldidx, 1, null)
              @levelParticles[d.to] ?= []
              targetidx = @levelParticles[d.to].indexOf null

              if targetidx is -1
                x.idx = @levelParticles[d.to].length
              else
                x.idx = targetidx

              @levelParticles[d.to][x.idx] = x

              if d.from is 'dungeons-of-kithgard'
                p2 = @getParticle()
                p2.position = @levelInfo['dungeons-of-kithgard'].position
                p2.level = 'dungeons-of-kithgard'
                @levelParticles['dungeons-of-kithgard'].push p2
                p2.idx = @levelParticles['dungeons-of-kithgard'].length

          break

    updates =_.shuffle updates
    for u,i in updates
      setTimeout u, i * 100

      

  moveAtSpeed: (a, b, s) ->
    d = b - a
    return b if ( Math.abs(d) < s )
    if ( d > 0 )
      return a + s
    else
      return a - s


  tick: (dt) ->
    @time += dt
    #@alive = 1.0
    #@age = 3.0
    #@duration = 6.0
    #console.log "Ticking Josh", @
    #super(dt)
    
    
    speed = 20
    for i in [0..@vertices.length-1]
      wasAlive = @attributes.alive.value[i] > 0.5
      
      behavior = @behaviors[i]
      isAlive = (behavior?.alive)?

      ar = @aspectRatio
      
      #idealX = 0.1*Math.random() + Math.sin((i+time)/spots*3.1415*2)*radius + 31
      #idealY = 0.1*Math.random() + Math.cos((i+time)/spots*3.1415*2)*radius*ar + 21 * ar
      
      
      if isAlive
        behavior.banned = false
        tot = 10 + @counts[behavior.level] - 1
        radius = if tot > 30 then 5 else 2
        spots = tot / 3.5
        z = 10 + behavior.idx
        partialRadius = (z/tot)*radius
        
        idealX = 0.1*Math.random() + Math.sin(-@time + z/spots*3.1415*2)*partialRadius + behavior.position.x
        idealY = 0.1*Math.random() + Math.cos(-@time + z/spots*3.1415*2)*partialRadius*ar + behavior.position.y * ar + 1.8

        if wasAlive
          @vertices[i].x = @moveAtSpeed(@vertices[i].x, idealX, speed*dt)
          @vertices[i].y = @moveAtSpeed(@vertices[i].y, idealY, speed*dt*ar)
        else
          @attributes.colorStart.value[i] = new THREE.Color utils.hslToHex([Math.random(), Math.random(), 0.8])
          @vertices[i].x = idealX
          @vertices[i].y = idealY

      @attributes.alive.value[i] = if isAlive then 1.0 else 0.0
      @attributes.age.value[i] = 0
      @attributes.size.value[i] = new THREE.Vector3 10.0, 10.0, 10.0
      

    @
    #super(dt)