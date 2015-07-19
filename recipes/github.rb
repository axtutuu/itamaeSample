execute 'create rsa' do
  command 'ssh-keygen -t rsa -C "kawasaki8910@gmail.com" -f /home/ec2-user/.ssh/rsa_file -N ""'
  not_if 'test -e /home/ec2-user/.ssh/rsa_file'

end

execute 'chown ec2-user:ec2-user /home/ec2-user/.ssh/rsa_file.pub'
execute 'chown ec2-user:ec2-user /home/ec2-user/.ssh/rsa_file'

execute 'chmod 600 /home/ec2-user/.ssh/rsa_file.pub'
execute 'chmod 600 /home/ec2-user/.ssh/rsa_file'

execute 'cat /home/ec2-user/.ssh/rsa_file.pub'


