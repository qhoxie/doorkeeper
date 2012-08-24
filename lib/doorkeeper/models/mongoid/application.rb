module Doorkeeper
  class Application
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in :collection => :oauth_applications

    has_many :authorized_tokens, :class_name => "Doorkeeper::AccessToken"

    field :name, :type => String
    field :uid, :type => String
    field :secret, :type => String
    field :redirect_uri, :type => String

    index({:uid => 1}, :unique => true)
    index({:name => 1})

    def self.authorized_for(resource_owner)
      ids = AccessToken.where(:resource_owner_id => resource_owner.id, :revoked_at => nil).map(&:application_id)
      find(ids)
    end
  end
end
