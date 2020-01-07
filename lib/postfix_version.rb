if  FileTest.exists?("/etc/postfix/main.cf")
	Facter.add(:postfix_version) do
		setcode do
			%x{postconf mail_version | awk '{print $3}'}
		end
	end
end
