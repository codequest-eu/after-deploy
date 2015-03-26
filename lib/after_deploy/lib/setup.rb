module Deployment
  class Setup

    attr_reader :config, :tasks

    def self.call(config=Deployment.configuration)
      self.new(config).tap { |instance| instance.call }
    end

    def initialize(config)
      @config = config
      migration_task = Task.new('db:migrate')
      @tasks = [*config.before_migrations, migration_task, *config.after_migrations]
    end

    def call
      tasks.each(&:call)
      config.notifiers.each { |notifier| notifier.call(self) }
    end

  end
end