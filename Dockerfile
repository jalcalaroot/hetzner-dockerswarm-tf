image: jimmyadaro/gitlab-ci-cd:latest
Deploy:
 stage: deploy
 only:
 — ‘master’
 when: manual
 allow_failure: false
 before_script:
 #Create .ssh directory
 — mkdir -p ~/.ssh
 #Save the SSH private key
 — echo “$DEPLOY_KEY” > ~/.ssh/id_rsa
 — chmod 700 ~/.ssh
 — chmod 600 ~/.ssh/id_rsa
 — eval $(ssh-agent -s)
 — ssh-add ~/.ssh/id_rsa
 script:
 #Backup everything in /var/www/html/
 — ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $user@$dev “zip -q -r /var/backups/www/01-Deploy-$(date +%F_%H-%M-%S).zip /var/www/html/”
 #Deploy new files to /var/www/html
 — lftp -d -u $user, -e ‘set sftp:auto-confirm true; set sftp:connect-program “ssh -a -x -i ~/.ssh/id_rsa”; mirror -Rnev ./ /var/www/html — ignore-time — exclude-glob .git* — exclude .git/; exit’ sftp://$dev
 — rm -f ~/.ssh/id_rsa
 — ‘echo Deploy done: $(date “+%F %H:%M:%S”)’