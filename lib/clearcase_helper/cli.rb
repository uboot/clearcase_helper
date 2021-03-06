require 'thor'

module ClearcaseHelper
  class CLI < Thor
    class_option :verbose, :default => false, :type => :boolean, :desc => "Show executed cleartool commands and its results on stdout."
    class_option :noop,    :default => false, :type => :boolean, :desc => "Do nothing to the clearcase view. cleartool is not executed."
    class_option :nostdout,:default => false, :type => :boolean, :desc => "Do not show the cleartool output when verbose is on."

    desc "status [PATH]", "Shows files in this view prefixed with its short status (CO: checkedout, HI: hijacked, ~: loaded but missing, ?: only in view)."
    method_option :long, :default => false, :aliases => ['-l'], :desc => 'Show all files, including those that have no special state.'
    def all_files(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.all_files_with_status(false, options)
    end
    map ['st'] => :all_files

    desc "view_only_files [PATH]", "Shows all files that are not added to this view (unversioned files)."
    def view_only_files(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.view_only_files(false, options)
    end
    map 'vof' => :view_only_files

    desc "hijacked_files [PATH]", "Shows all files that are hijacked."
    def hijacked_files(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.hijacked_files(false, options)
    end
    map 'hif' => :hijacked_files

    desc "checkedout_files [PATH]", "Shows all files that are checked out."
    def checkedout_files(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.checkedout_files(false, options)
    end
    map 'cof' => :checkedout_files

    desc "missing_files [PATH]", "Shows all files that are loaded but missing in view."
    def missing_files(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.missing_files(false, options)
    end
    map 'mf' => :missing_files

    desc "checkout_highjacked [PATH]", "Checks out all highjacked files."
    def checkout_highjacked(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.checkout_highjacked!(options)
    end
    map 'cohi' => :checkout_highjacked

    desc "checkin [PATH]", "Checks in all checked out files."
    method_option :comment, :default => '', :aliases => ['-c', '-m'], :desc => 'use <comment> as commit message'
    def checkin_checkedout(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.checkin_checkedout!(options)
    end
    map ['ci', 'checkin'] => :checkin_checkedout

    desc "checkin_hijacked [PATH]", "Checks hijacked files out and in again."
    method_option :comment, :default => '', :aliases => ['-c', '-m'], :desc => 'use <comment> as commit message'
    def checkin_hijacked(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.checkin_hijacked!(options)
    end
    map 'cihi' => :checkin_hijacked

    desc "add_view_only_files [PATH]", "Recursively adds and checks in files that are not yet versioned."
    def add_view_only_files(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.add_view_only_files!(options)
    end
    map ['avo', 'add'] => :add_view_only_files

    desc "remove_missing_files [PATH]", "Removes files (rmname) that are loaded but deleted from view."
    def remove_missing_files(path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.remove_missing_files!(options)
    end

    desc "create_and_add_label label [PATH]", "Creates a label type and adds it recursively to all files in current view path."
    method_option :comment, :default => '', :aliases => ['-c', '-m'], :desc => 'use <comment> as commit message'
    def create_and_add_label(label, path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.make_label_type(label)
      puts view.make_label(label)
    end

    desc "add_label label [PATH]", "Adds an existing label recursively to all files in current view path."
    method_option :comment, :default => '', :aliases => ['-c', '-m'], :desc => 'use <comment> as commit message'
    def add_label(label, path='.')
      view = ClearcaseHelper::View.new(path)
      puts view.make_label(label)
    end

    desc "heaven", "Show real help."
    def heaven
      $stderr.puts 'NO HEAVEN HERE - use a proper VCS!'
    end

    desc "version", "Show the version"
    def version
      puts VERSION
    end
  end
end