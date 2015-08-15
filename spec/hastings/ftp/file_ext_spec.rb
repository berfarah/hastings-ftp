require "fileutils"

describe Hastings::FTP::FileExt::Core, ftp: true do
  subject { Hastings::File.new "foo" }
  let(:ftp) { Hastings::FTP::Connection.new "127.0.0.1", user: "anonymous" }
  let(:ftp_dir) { Hastings::FTP::Dir.new "my_dir", ftp }
  before do
    File.open("foo", "w") {}
    FileUtils.mkdir_p("bar")
    @ftp = Hastings::FTP::Connection.new "127.0.0.1", user: "anonymous"
    @ftp.mkdir_p("my_dir")
  end

  after do
    @ftp.rmdir("my_dir")
  end

  describe "#copy_to" do
    context "given an FTP::Dir location" do
      it "delegates copying to FTP::Dir" do
        expect_any_instance_of(Hastings::FTP::Dir).to receive(:copy_from)
        subject.copy_to ftp_dir
      end
    end

    context "given a normal Dir" do
      it "copies to directory" do
        dir = Hastings::Dir.new("bar")
        subject.copy_to dir
        expect(File.exist? "bar/foo").to be true
      end
    end
  end

  describe "#move_to" do
    context "given an FTP::Dir location" do
      it "delegates moving to FTP::Dir" do
        expect_any_instance_of(Hastings::FTP::Dir).to receive(:move_from)
        subject.move_to ftp_dir
      end
    end

    context "given a normal Dir" do
      it "moves to directory" do
        dir = Hastings::Dir.new("bar")
        subject.move_to dir
        expect(File.exist? "bar/foo").to be true
        expect(File.exist? "foo").to be false
      end
    end
  end
end
