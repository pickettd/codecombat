_ = require 'lodash'
utils = require '../lib/utils'
errors = require '../commons/errors'
wrap = require 'co-express'
Promise = require 'bluebird'
database = require '../commons/database'
mongoose = require 'mongoose'
Classroom = require '../models/Classroom'
parse = require '../commons/parse'
LevelSession = require '../models/LevelSession'
User = require '../models/User'

module.exports =
  getByOwner: wrap (req, res, next) ->
    options = req.query
    ownerID = options.ownerID
    return next() unless ownerID
    throw new errors.UnprocessableEntity('Bad ownerID') unless utils.isID ownerID
    throw new errors.Unauthorized() unless req.user
    throw new errors.Forbidden('"ownerID" must be yourself') unless req.user.isAdmin() or ownerID is req.user.id
    sanitizedOptions = {}
    unless _.isUndefined(options.archived)
      # Handles when .archived is true, vs false-or-null
      sanitizedOptions.archived = { $ne: not (options.archived is 'true') }
    dbq = Classroom.find _.merge sanitizedOptions, { ownerID: mongoose.Types.ObjectId(ownerID) }
    dbq.select(parse.getProjectFromReq(req))
    classrooms = yield dbq
    classrooms = (classroom.toObject({req: req}) for classroom in classrooms)
    res.status(200).send(classrooms)

  fetchMemberSessions: wrap (req, res, next) ->
    throw new errors.Unauthorized() unless req.user
    memberLimit = parse.getLimitFromReq(req, {default: 10, max: 100, param: 'memberLimit'})
    memberSkip = parse.getSkipFromReq(req, {param: 'memberSkip'})
    classroom = yield database.getDocFromHandle(req, Classroom)
    throw new errors.NotFound('Classroom not found.') if not classroom
    throw new errors.Forbidden('You do not own this classroom.') unless req.user.isAdmin() or classroom.get('ownerID').equals(req.user._id)
    members = classroom.get('members') or []
    members = members.slice(memberSkip, memberSkip + memberLimit)
    dbqs = []
    select = 'state.complete level creator playtime'
    for member in members
      dbqs.push(LevelSession.find({creator: member.toHexString()}).select(select).exec())
    results = yield dbqs
    sessions = _.flatten(results)
    res.status(200).send(sessions)
    
  fetchMembers: wrap (req, res, next) ->
    throw new errors.Unauthorized() unless req.user
    memberLimit = parse.getLimitFromReq(req, {default: 10, max: 100, param: 'memberLimit'})
    memberSkip = parse.getSkipFromReq(req, {param: 'memberSkip'})
    classroom = yield database.getDocFromHandle(req, Classroom)
    throw new errors.NotFound('Classroom not found.') if not classroom
    isOwner = classroom.get('ownerID').equals(req.user._id)
    isMember = req.user.id in (m.toString() for m in classroom.get('members'))
    unless req.user.isAdmin() or isOwner or isMember
      throw new errors.Forbidden('You do not own this classroom.')
    memberIDs = classroom.get('members') or []
    memberIDs = memberIDs.slice(memberSkip, memberSkip + memberLimit)
    
    members = yield User.find({ _id: { $in: memberIDs }}).select(parse.getProjectFromReq(req))
    memberObjects = (member.toObject({ req: req, includedPrivates: ["name", "email"] }) for member in members)
    
    res.status(200).send(memberObjects)

  post: wrap (req, res) ->
    throw new errors.Unauthorized() unless req.user and not req.user.isAnonymous()
    throw new errors.Forbidden() unless req.user?.isTeacher()
    classroom = database.initDoc(req, Classroom)
    classroom.set 'ownerID', req.user._id
    classroom.set 'members', []
    database.assignBody(req, classroom)
    database.validateDoc(classroom)
    classroom = yield classroom.save()
    res.status(201).send(classroom.toObject({req: req}))