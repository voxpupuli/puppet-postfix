Facter.add(:postfix_version) do
  setcode do
    if Facter::Util::Resolution.which('postconf')
      Facter::Util::Resolution.exec('postconf mail_version').split[2]
    end
  end
end
