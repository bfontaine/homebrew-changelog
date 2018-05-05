# -*- coding: UTF-8 -*-

require_relative "./changelog"

def compute_coverage
  klasses = {}

  Formula.each do |f|
    chg = Changelog.for_formula(f)
    chg_name = if chg.nil?
                 "(none)"
               else
                 chg.class.name
               end

    klasses[chg_name] ||= 0
    klasses[chg_name] += 1
  end

  klasses
end
