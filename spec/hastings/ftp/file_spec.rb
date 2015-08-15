describe Hastings::FTP::File, ftp: true do
  subject { described_class.new path, ftp }
  let(:path) { "answers/questions/people" }
  let(:ftp)  { Hastings::FTP::Connection.new("127.0.0.1", user: "anonymous") }

  before(:all) do
    @ftp = Hastings::FTP::Connection.new("127.0.0.1", user: "anonymous")
    @ftp.mkdir_p("answers")
    @ftp.mkdir_p("answers/questions")
    File.open("people", "w") {}
    @ftp.put("people", "answers/questions/people")
    File.delete("people")
  end

  after(:all) do
    # @ftp.delete("answers/questions/people")
    @ftp.rmdir("answers/questions")
    @ftp.rmdir("answers")
  end

  describe "#file?" do
    it "delegates to FTP" do
      expect_any_instance_of(Hastings::FTP::Connection).to receive(:file?)
      subject.file?("path")
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

  describe "#basename" do
    it "should equal the last bit of the file" do
      expect(subject.basename).to eq("people")
    end
  end

  describe "#dirname" do
    it "should equal the directories of the file" do
      expect(subject.dirname).to eq("answers/questions")
    end
  end

  describe "#copy_to" do
    context "given a string as a path" do
      it "assumes a local path and copies the file"
    end

    context "given a dir object" do
      it "copies the file to the directory"
    end

    context "given an ftp dir object" do
      it "copies the file to the ftp"
    end
  end

  describe "#move_to" do
    it "delegates to #copy_to" do
      args = ""
      expect(subject).to receive(:copy_to).with(args, overwrite: true)
      subject.move_to(args)
    end
  end

  describe "#mtime" do
    it "delegates to mtime" do
      expect_any_instance_of(Net::FTP).to receive(:mtime)
      subject.mtime
    end
  end

  describe "#newer_than?" do
    it "compares to mtime" do
      expect(subject).to receive(:mtime).and_return(Time.now)
      expect(subject.newer_than?(Time.now + 1)).to be false
    end
  end

  describe "#older_than?" do
    it "compares to mtime" do
      expect(subject).to receive(:mtime).and_return(Time.now)
      expect(subject.older_than?(Time.now + 1)).to be true
    end
  end
end
