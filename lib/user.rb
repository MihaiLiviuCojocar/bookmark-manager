require 'bcrypt'

class User

  attr_reader :password
  attr_accessor :password_confirmation


  include DataMapper::Resource


  property :id,              Serial
  property :email,           String, :unique => true, :message => "This email is already taken"
  property :password_digest, Text

  validates_confirmation_of :password, :message => "Your passwords don't match"


  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    # that's the user who is trying to sign in
    user = first(:email => email)
    # if this user exists and the password provided matches
    # the one we have password_digest for, everything's fine
    #
    # The Password.new returns an object that overrodes the == method
    # Instead of comparing two passwords directly
    # which is impossible because we have only one-way hash
    # the == method calculates the candidate password_digest from
    # the password givven and compares it to the password_digest
    # it was initialised with.
    # So, to recap : THIS IS NOT A STRING COMPARISON
    if user && BCrypt::Password.new(user.password_digest) == password
      # return this user
      user
    else
      nil
    end
  end


end
