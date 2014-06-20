#!/bin/bash

prefs="$(find "${HOME}"/.thunderbird/*.default/ -type f -name prefs.js -print)"

cat << __EOT__ >> "${prefs}"

// listen to all folders for incoming email
user_pref("mail.server.default.check_all_folders_for_new", true);

// always send/receive messages in UTF-8
user_pref("mailnews.send_default_charset", "UTF-8");
user_pref("mailnews.view_default_charset", "UTF-8");
user_pref("mailnews.reply_in_default_charset", true);
__EOT__


# remove local folders
sed -i $([[ "$(uname -s)" != Linux ]] && echo "''") '/user_pref("mail.server.server2/ d' "${prefs}"
sed -i $([[ "$(uname -s)" != Linux ]] && echo "''") '/user_pref("mail.root.none/ d' "${prefs}"
sed -i $([[ "$(uname -s)" != Linux ]] && echo "''") '/user_pref("mail.account.account2.server"/ d' "${prefs}"

# user the first account as local folders
sed -i $([[ "$(uname -s)" != Linux ]] && echo "''") 's:user_pref("mail.accountmanager.localfoldersserver", "server2");:user_pref("mail.accountmanager.localfoldersserver", "server1");:' "${prefs}"

# remove the second account
sed -i $([[ "$(uname -s)" != Linux ]] && echo "''") '/user_pref("mail.accountmanager.accounts"/ s:,account2::' "${prefs}"

