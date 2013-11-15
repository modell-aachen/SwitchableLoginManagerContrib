# ---+ Extensions
# ---++ SwitchableLoginManagerContrib
# This contrib supplies an additional login manager that allows admins to
# temporarily assume the identity of another use to test permissions etc.
# It passes through most things to another login manager that you can choose
# here.

# **BOOLEAN**
# Whether to enable the sudo feature. With this enabled, admins can switch to
# a different user account by adding a "sudouser=" query parameter to a
# request. Setting that query parameter to an empty string returns them to
# their original account.
$Foswiki::cfg{SwitchableLoginManagerContrib}{SudoEnabled} = 0;

# **STRING M**
# When using the "sudouser=" query parameter, the "sudoauth=" parameter must
# also be given and be exactly equal to this (hopefully) secret string.
# Of course this is mostly smoke and mirrors security, so if you've got any
# sense you'll leave this sudo feature disabled pretty much always.
$Foswiki::cfg{SwitchableLoginManagerContrib}{SudoAuth} = 'changeme!';

# **SELECTCLASS Foswiki::LoginManager::*Login M**
# Choose the underlying login manager we should use.
# Please, *please* do not set this to SwitchableLoginManager. You will not
# enjoy the results.
$Foswiki::cfg{SwitchableLoginManagerContrib}{ActualLoginManager} = 'Foswiki::LoginManager::TemplateLogin';
