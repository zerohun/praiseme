module SynonymsFinderClient
  def self.find_of(str)
    result = ""
    UNIXSocket.open("#{Rails.root}/tmp/sockets/synonyms_finder_server.sock") {|c|
      c.sendmsg str
      result = c.recvmsg
    }
    return Marshal.load(result.first)
  end
end
