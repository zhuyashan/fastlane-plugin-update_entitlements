describe Fastlane::Actions::UpdateEntitlementsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The update_entitlements plugin is working!")

      Fastlane::Actions::UpdateEntitlementsAction.run(nil)
    end
  end
end
