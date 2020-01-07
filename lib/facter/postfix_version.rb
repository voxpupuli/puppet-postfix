if  FileTest.exists?("/etc/postfix/main.cf")
	Facter.add(:postfix_version) do
		setcode do
			Facter::Core::Execution.execute('postconf mail_version').split[4]
		end
	end
end
