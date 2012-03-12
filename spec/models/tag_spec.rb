require 'spec_helper'

describe Tag do
  context "has neoid hooks" do
    subject { Follow._save_callbacks }    
    it { subject.select { |cb| cb.kind.eql?(:after_create) }.collect(&:filter).include?(:neocreate) }
    it { subject.select { |cb| cb.kind.eql?(:after_destroy) }.collect(&:filter).include?(:neodestroy) }
  end

  describe ".create_or_update_tag" do
    subject { Tag.create_or_update_tag(tagdata) }
    let(:tagdata) { {:tag_name => 'tag_name'} }
    let(:tag) { mock_model(Tag) }

    before do
      Tag.stub_chain("where.first") { found_tag }
      tag.should_receive(:save)
    end
    
    context "when tag not previously registered" do
      before do
        Tag.stub_chain("new") { tag }
        tag.should_receive(:name=).with(tagdata[:tag_name])
      end
      let(:found_tag) { nil }
      it { expect{subject}.not_to raise_error }
    end
    
    context "when tag previously registered" do
      let(:found_tag) { tag }
      it { expect{subject}.not_to raise_error }
    end

  end  
end
