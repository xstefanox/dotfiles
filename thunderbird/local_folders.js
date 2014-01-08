// remove
user_pref("mail.server.server2.directory", "...");
user_pref("mail.server.server2.directory-rel", "...");
user_pref("mail.server.server2.hostname", "...");
user_pref("mail.server.server2.name", "...");
user_pref("mail.server.server2.storeContractID", "...");
user_pref("mail.server.server2.type", "...");
user_pref("mail.server.server2.userName", "...");
user_pref("mail.root.none", "...");
user_pref("mail.account.account2.server", "server2");

// change to server1
user_pref("mail.accountmanager.localfoldersserver", "server2");

// automatic configuration (copy-paste into a shell)
sed -i '' '/user_pref("mail.server.server2/ d' prefs.js
sed -i '' '/user_pref("mail.root.none/ d' prefs.js
sed -i '' '/user_pref("mail.account.account2.server"/ d' prefs.js
sed -i '' 's:user_pref("mail.accountmanager.localfoldersserver", "server2");:user_pref("mail.accountmanager.localfoldersserver", "server1");:' prefs.js
sed -i '' '/user_pref("mail.accountmanager.accounts"/ s:,account2::' prefs.js
