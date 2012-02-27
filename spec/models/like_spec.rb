require 'spec_helper'

describe Like do
  context "has neoid hooks" do
    subject { Follow._save_callbacks }    
    it { subject.select { |cb| cb.kind.eql?(:after_create) }.collect(&:filter).include?(:neocreate) }
    it { subject.select { |cb| cb.kind.eql?(:after_destroy) }.collect(&:filter).include?(:neodestroy) }
  end
end
