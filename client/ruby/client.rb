require "openssl"
require "typhoeus"
require "uri"

PROJECT_ROOT = File.join('..','..')

cert_file = File.join(PROJECT_ROOT, 'client', 'client1-crt.pem')
key_file = File.join(PROJECT_ROOT, 'client', 'client1-key.pem')
ca_file = File.join(PROJECT_ROOT, 'ca-crt.pem')

# puts " #{cert_file}  #{key_file}  #{ca_file}"

cert = File.read(cert_file)
key = File.read(key_file)

ctx       = OpenSSL::SSL::SSLContext.new
ctx.cert  = OpenSSL::X509::Certificate.new(cert)
ctx.key   = OpenSSL::PKey::RSA.new(key)

content_type = "text/xml"

options = {
  :headers => { "Content-Type" => "#{content_type}; charset=UTF-8"},
  :ssl_verifypeer => true,
  :ssl_verifyhost => 2,
  :timeout => 30,
  :cainfo => ca_file,
  :sslkey => key_file,
  :sslcert => cert_file
}

uri = URI.parse("server.localhost:8000")


request = Typhoeus::Request.new(
  "https://server.localhost:8000",
  options
)

request.on_complete do |response|
  if response.success?
    puts "success"
  else
    puts "failed #{response.return_message}"
  end
end

request.run
