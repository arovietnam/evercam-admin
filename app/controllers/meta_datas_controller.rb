class MetaDatasController < ApplicationController
  def index
    @meta_datas = MetaData.all
  end
end