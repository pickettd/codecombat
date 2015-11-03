async = require 'async'
config = require '../../../server_config'
require '../common'
stripe = require('stripe')(config.stripe.secretKey)
init = require '../init'

describe 'POST /db/course_instance', ->

  beforeEach (done) -> clearModels([CourseInstance, Course, User, Classroom], done)
  beforeEach (done) -> loginJoe (@joe) => done()
  beforeEach init.course()
  beforeEach init.classroom()
  
  it 'creates a CourseInstance', (done) ->
    test = @
    url = getURL('/db/course_instance')
    data = {
      name: 'Some Name'
      courseID: test.course.id
      classroomID: test.classroom.id
    }
    request.post {uri: url, json: data}, (err, res, body) ->
      expect(res.statusCode).toBe(200)
      expect(body.classroomID).toBeDefined()
      done()
      
  it 'returns 404 if the Course does not exist', (done) ->
    test = @
    url = getURL('/db/course_instance')
    data = {
      name: 'Some Name'
      courseID: '123456789012345678901234'
      classroomID: test.classroom.id
    }
    request.post {uri: url, json: data}, (err, res, body) ->
      expect(res.statusCode).toBe(404)
      done()

  it 'returns 404 if the Classroom does not exist', (done) ->
    test = @
    url = getURL('/db/course_instance')
    data = {
      name: 'Some Name'
      courseID: test.course.id
      classroomID: '123456789012345678901234'
    }
    request.post {uri: url, json: data}, (err, res, body) ->
      expect(res.statusCode).toBe(404)
      done()
      
  it 'return 403 if the logged in user does not own the Classroom', (done) ->
    test = @
    loginSam ->
      url = getURL('/db/course_instance')
      data = {
        name: 'Some Name'
        courseID: test.course.id
        classroomID: test.classroom.id
      }
      request.post {uri: url, json: data}, (err, res, body) ->
        expect(res.statusCode).toBe(403)
        done()
      
      
describe 'POST /db/course_instance/:id/members', ->
  
  beforeEach (done) -> clearModels([CourseInstance, Course, User, Classroom, Prepaid], done)
  beforeEach (done) -> loginJoe (@joe) => done()
  beforeEach init.course({free: true})
  beforeEach init.classroom()
  beforeEach init.courseInstance()
  beforeEach init.user()
  beforeEach init.prepaid()
  
  it 'adds a member to the given CourseInstance', (done) ->
    async.eachSeries([
      
      addTestUserToClassroom,
      (test, cb) ->
        url = getURL("/db/course_instance/#{test.courseInstance.id}/members")
        request.post {uri: url, json: {userID: test.user.id}}, (err, res, body) ->
          expect(res.statusCode).toBe(200)
          expect(body.members.length).toBe(1)
          expect(body.members[0]).toBe(test.user.id)
          cb()
          
    ], makeTestIterator(@), done)
      
    
  it 'return 403 if the member is not in the classroom', (done) ->
    async.eachSeries([
      
      (test, cb) ->
        url = getURL("/db/course_instance/#{test.courseInstance.id}/members")
        request.post {uri: url, json: {userID: test.user.id}}, (err, res) ->
          expect(res.statusCode).toBe(403)
          cb()
          
    ], makeTestIterator(@), done)
    
    
  it 'returns 403 if the user does not own the course instance', (done) ->
    async.eachSeries([

      addTestUserToClassroom,
      (test, cb) ->
        loginSam ->
          url = getURL("/db/course_instance/#{test.courseInstance.id}/members")
          request.post {uri: url, json: {userID: test.user.id}}, (err, res, body) ->
            expect(res.statusCode).toBe(403)
            cb()

    ], makeTestIterator(@), done)

  it 'return 402 if the course is not free and the user is not in a prepaid', (done) ->
    async.eachSeries([
      
      addTestUserToClassroom,
      makeTestCourseNotFree,
      (test, cb) ->
        url = getURL("/db/course_instance/#{test.courseInstance.id}/members")
        request.post {uri: url, json: {userID: test.user.id}}, (err, res) ->
          expect(res.statusCode).toBe(402)
          cb()
          
    ], makeTestIterator(@), done)
          
    
  it 'works if the course is not free and the user is in a prepaid', (done) ->
    async.eachSeries([
    
      addTestUserToClassroom,
      makeTestCourseNotFree,
      addTestUserToPrepaid,
      (test, cb) ->
        url = getURL("/db/course_instance/#{test.courseInstance.id}/members")
        request.post {uri: url, json: {userID: test.user.id}}, (err, res) ->
          expect(res.statusCode).toBe(200)
          cb()
          
    ], makeTestIterator(@), done)
    
    
  makeTestCourseNotFree = (test, cb) ->
    test.course.set('free', false)
    test.course.save cb
        
  addTestUserToClassroom = (test, cb) ->
    test.classroom.set('members', [test.user.get('_id')])
    test.classroom.save cb

  addTestUserToPrepaid = (test, cb) ->
    test.prepaid.set('redeemers', [{userID: test.user.get('_id')}])
    test.prepaid.save cb

makeTestIterator = (testObject) -> (func, callback) -> func(testObject, callback)
  