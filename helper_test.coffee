chai      = require('chai')
expect    = chai.expect
should    = chai.should()
sinon     = require('sinon')
sinonChai = require('sinon-chai')

chai.use(sinonChai)

helper = require './helper'

describe "buildBinaryExpression", ->
  beforeEach (done) ->
    @leftExpression =
      type: Literal
      value: 1
      raw: "1"

    @rightExpressions =
      [
        {
          type: Literal
          value: 2
          raw: "2"
        }
        {
          type: Literal
          value: 3
          raw: "3"
        }
      ]

    @output = helper.buildBinaryExpression
      left: @leftExpression
      right: @rightExpressions
      operator: "+"

    done()

  it "should be done successfull", ->
    expect(@foo).to.be.a "string"
    expect(@foo).to.equal "bar"
    expect(@foo).to.have.length 3
    expect(@beverages).to.have.property("tea").with.length 3