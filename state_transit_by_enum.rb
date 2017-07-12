# -*- encoding: utf-8 -*-
require 'set'

class State
  attr_reader :name

  def initialize(name)
    @name = name
    freeze
  end

  STATE_審査中     = State.new('審査中')
  STATE_承認済     = State.new('承認済')
  STATE_実施中     = State.new('実施中')
  STATE_終了       = State.new('終了')
  STATE_差し戻し中 = State.new('差し戻し中')
  STATE_中断中     = State.new('中断中')

  STATES = [
    STATE_審査中    ,
    STATE_承認済    ,
    STATE_実施中    ,
    STATE_終了      ,
    STATE_差し戻し中,
    STATE_中断中    ,
  ]

  STATE_HASH = STATES.inject({}) { |h, state| h[state.name] = state; h }

  class << self
    def values
      STATES
    end

    def value_of(name)
      STATE_HASH[name]
    end
  end

end

class StateTransitions
  ALLOWED_HASH = {
    State::STATE_審査中     => Set.new([State::STATE_承認済, State::STATE_差し戻し中]),
    State::STATE_差し戻し中 => Set.new([State::STATE_審査中, State::STATE_終了]),
    State::STATE_承認済     => Set.new([State::STATE_実施中, State::STATE_終了]),
    State::STATE_実施中     => Set.new([State::STATE_中断中, State::STATE_終了]),
    State::STATE_中断中     => Set.new([State::STATE_実施中, State::STATE_終了]),
  }

  def can_transit(from, to)
    ALLOWED_HASH[from].include?(to)
  end
end

def main
  transition = StateTransitions.new

  print '審査中 => 承認済 : '
  puts transition.can_transit(State.value_of('審査中'), State.value_of('承認済'))
  print '審査中 => 実施中 : '
  puts transition.can_transit(State.value_of('審査中'), State.value_of('実施中'))

end

case $PROGRAM_NAME
when __FILE__
  main
end

# >> 審査中 => 承認済 : true
# >> 審査中 => 実施中 : false
