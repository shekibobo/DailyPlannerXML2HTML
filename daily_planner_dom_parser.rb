#!/usr/bin/ruby -w
#
# Author: Joshua Kovach
# Date 29 July 2010
# Instructor: Dr. Robert Adams
# Course: CIS 675 - Compiler Construction
# Description: 
#  DOM parser for an XML DailyPlanner document.  Converts the calendar and 
#  its activities to a formatted html table to be used with 'style.css'
#
class DailyPlannerDOMParser
  require 'rexml/document'
  include REXML
  #
  # prompts the user for a Daily Planner xml file and creates an xml tree
  # as well as initializing the head of the html output string.
  #
  def initialize(options={})
    begin # attempt to get a source file from the user
      print "Enter source file (xml): "
      @xmlfile = File.new(gets.chomp)
    rescue Exception => e
      puts e.message
    end
    
    # turn the file into an xml tree document
    @xmldoc = Document.new(@xmlfile)
    
    # define the root element
    @root = @xmldoc.root
    
    if options[:include_head]
      @html = "<html>\n<head><link rel='stylesheet' type='text/css' " +
        "href='style.css'  />\n</head>\n"
    else 
      @html = ""
    end
  end
  
  #
  # accessors
  #
  attr_reader :root, :xmldoc, :html
  
  #
  # this method gives us a simple method of building our output string
  # which can later be printed to the output stream or saved to a file.
  #
  def output(str)
    @html += str
  end
  
  #
  # prints tasks and their times (if the attribute is set)
  #
  def task_to_html(task)
    if task.has_attributes? 
      output "<span class='time'>#{task.attribute('time').value}</span> "
    else
      output "<span class='time'>"
      9.times {output "&nbsp;"} # proper alignment for untimed activities
      output "</span>"
    end
    output "#{task.get_text}<br />\n"
  end
  
  #
  # prints the day and its date (if the attribute is set)
  #
  def day_to_html(day)
    output "<tr>\n<td>#{day.name.capitalize}<br />"
    if day.has_attributes?
      output "<span class='time'>#{day.attribute('date').value}</span>"
    end
    output "</td>\n"
  end
  
  #
  # converts the activities of each day into a calendar table in html
  #
  def planner_to_table
    output"<table>\n"
    
    # print the title of the table
    output "<caption>#{@root.name[0,5].capitalize} " + 
      "#{@root.name[5,7].capitalize}</caption>\n"
    
    # print the header cells of the table
    output "<tr>\n<td class='label'>Day</td>\n<td class='label'>Morning</td>\n" +
      "<td class='label'>Afternoon</td>\n</tr>\n"
    @root.each_element do |day|
      day_to_html day
      output "<td>"
      day.elements.each("am") do |am_task|
        task_to_html am_task
      end
      output "&nbsp;</td>\n" # ensures table cell is not empty
      output "<td>"
      day.elements.each("pm") do |pm_task|
        task_to_html pm_task
      end
      output "&nbsp;</td>\n" # table cell is not empty (:render=>firefox)
      output "</tr>\n"
    end
    
    output "</table>"
  end
end


def main
  # creates a daily planner tree
  dpt = DailyPlannerDOMParser.new({:include_head => true})
  
  dpt.output "<body>"
  
  # converts the planner tree to an html table
  dpt.planner_to_table
  
  dpt.output "</body>\n</html>"
  
  print dpt.html
  
  # save the converted html to a file
  op = File.new("output.html", "w")
  op.write(dpt.html)
  op.close
end

main