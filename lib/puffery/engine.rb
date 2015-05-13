module Puffery
  class Engine < ::Rails::Engine

    initializer "puffery.setup" do
      config.after_initialize do
        Puffery.load_files
      end
    end

  end
end
