#!/usr/bin/ruby -w
#
# Author: Joshua Kovach
# Date 29 July 2010
# Instructor: Dr. Robert Adams
# Course: CIS 675 - Compiler Construction
# Description: 
#  SAX parser for an XML DailyPlanner document.  Converts the calendar and 
#  its activities to a formatted html table to be used with 'style.css'
#
require 'rexml/document'
require 'rexml/streamlistener'

include REXML

class DailyPlannerSAXParser
  include StreamListener
  
  DAYS = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']
  
  def initialize(options = {})
    if options[:include_head]
      @html = "<html>\n<head><link rel='stylesheet' type='text/css' " +
      "href='style.css'  />\n</head>\n"
    else 
      @html = ''
    end
    
    begin
      print "Enter source file: "
      @file = File.new(gets.chomp)
    rescue Exception => e
      puts e.message
    end
    
    @am_tasks = 0
    @pm_tasks = 0
    
  end
  
  attr_reader :html, :file
  
  def tag_start(element, attributes)
    if element == 'dailyplanner'
      output "<body>\n"
      output "<table>\n<caption>Daily Planner</caption>\n"
    elsif DAYS.include? element
      output "<tr>\n<td>"
      output "#{element.capitalize}"
      if !attributes.empty?
        output "<br /><span class='time'>#{attributes['date']}</span>"
      end
      output "</td>\n"
    elsif element == 'am'
      if @am_tasks == 0
        output "<td>"
        @am_tasks += 1
      end
      output_attrs(attributes)
    elsif element == 'pm'
      if @pm_tasks == 0
        if @am_tasks == 0 
          output "<td>&nbsp;</td>"
        end
        output "</td>\n<td>"
        @pm_tasks += 1
      end
      output_attrs(attributes)
    end
  end
  
  def tag_end(element)
    if element == 'dailyplanner'
      output "</table>\n"
      output "</body>\n"
      output "</html>"
    elsif DAYS.include? element
      if @pm_tasks == 0 && @am_tasks == 0
        output "<td>&nbsp;</td><td>&nbsp;</td>"
      elsif @pm_tasks == 0
        output "<td>&nbsp;</td>"
      end
      @am_tasks = @pm_tasks = 0
    elsif element == 'am' || element == 'pm'
      output "<br />"
    end
  end
  
  def text(content)
    output content
  end
  
  def output_attrs(attributes)
    if !attributes.empty?
      output "<span class='time'>#{attributes['time']} </span>"
    else
      output "<span class='time'>"
      9.times {output "&nbsp;"}
      output "</span>"
    end
  end
  
  #
  # this method gives us a simple method of building our output string
  # which can later be printed to the output stream or saved to a file.
  #
  def output(str)
    @html += str
  end
end

#
# run the parser
#
dp_listener = DailyPlannerSAXParser.new({:include_head => true})
Document.parse_stream(dp_listener.file, dp_listener)
puts dp_listener.html

#
# output to an html file
#
op = File.new("SAXoutput.html", "w")
op.write(dp_listener.html)
op.close

  