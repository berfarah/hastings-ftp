describe Hastings::FTP::Dir do
  subject { described_class.new "baz", ftp }
  let(:ftp)  { Hastings::FTP::Connection.new("127.0.0.1", user: "anonymous") }

  before(:all) do
    @ftp = Hastings::FTP::Connection.new("127.0.0.1", user: "anonymous")
    @ftp.mkdir_p("baz")
  end

  after(:all) do
    @ftp.delete("baz/foo")
    @ftp.rmdir("baz")
    @ftp.close
  end

  describe "#exist?" do
    it "delegates to FTP" do
      expect_any_instance_of(Hastings::FTP::Connection).to receive(:dir?)
      subject.exist?("path")
    end
  end

  describe "#path" do
    subject { super().path }
    it { is_expected.to be_a String }
  end

  describe "#ftp" do
    subject { super().ftp }
    it { is_expected.to be_a Hastings::FTP::Connection }
  end

  describe "#copy_from" do
    before(:all) { @file = File.open("foo", "w") {} }
    after(:all)  do
      File.exist?("foo") && File.delete("foo")
    end

    it "copies the file" do
      (s = subject).copy_from("foo")
      expect(s.ftp.exist?("baz/foo")).to be true
    end

    it "retains the local copy" do
      expect(File.exist? "foo").to be true
    end
  end

  describe "#move_from" do
    before(:all) { @file = File.open("foo", "w") {} }

    it "copies the file" do
      (s = subject).move_from("foo")
      expect(s.ftp.exist?("baz/foo")).to be true
    end

    it "removes the local copy" do
      expect(File.exist? "foo").to be false
    end
  end
end
