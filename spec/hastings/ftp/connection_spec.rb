# This testing is done with FTP software independent from Ruby
# which can be enabled on OSX via launchctl.
# http://igerry.com/desktop/apple-os/enabling-ftp-server-os-x-mavericks.html
# http://www.linickx.com/os-x-anonymous-ftp-directory-on-mountain-lion
describe Hastings::FTP::Connection, ftp: true do
  subject do
    described_class.new "127.0.0.1", port: 21, user: "anonymous"
  end

  before :all do
    @klass = described_class.new "127.0.0.1", port: 21, user: "anonymous"
    File.open("foo", "w") {}
    @klass.mkdir_p "bar"
    @klass.put "foo"
    FileUtils.rm("foo")
  end

  after :all do
    @klass.rmdir "bar"
    @klass.delete("foo")
    @klass.close
  end

  [:login, :close, :closed?,
   :get, :put, :delete, :rename,
   :chdir, :mkdir, :rmdir, :nlst, :pwd,
   :mtime, :size].each { |m| it { is_expected.to respond_to m } }

  describe "#dir?" do
    it "is false for files" do
      expect(subject.dir? "foo").to be false
    end
    it "is true for directories" do
      expect(subject.dir? "bar").to be true
    end
    it "is false if not found" do
      expect(subject.dir? "not_exist").to be false
    end
  end

  describe "#exist?" do
    it "is true for files" do
      expect(subject.exist? "foo").to be true
    end
    it "is true for directories" do
      expect(subject.exist? "bar").to be true
    end
    it "is false if not found" do
      expect(subject.exist? "not_exist").to be false
    end
  end

  describe "#file?" do
    it "is true for files" do
      expect(subject.file? "foo").to be true
    end
    it "is false for directories" do
      expect(subject.file? "bar").to be false
    end
    it "is false if not found" do
      expect(subject.file? "not_exist").to be false
    end
  end
end
