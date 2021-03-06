// Preferences that get set when the application is loaded

// Modified by Jason for Evergreen

// These are specific to Evergreen
pref("open-ils.write_in_user_chrome_directory", true);
pref("open-ils.disable_accesskeys_on_tabs", false);
pref("toolkit.singletonWindowType", "eg_main");

// Toggles for experimental features that may later become org unit settings
pref("open-ils.enable_join_tabs", true);

// We'll use this one to help brand some build information into the client, and rely on subversion keywords
pref("open-ils.repository.headURL","$HeadURL$");
pref("open-ils.repository.author","$Author$");
pref("open-ils.repository.revision","$Revision$");
pref("open-ils.repository.date","$Date$");
pref("open-ils.repository.id","$Id$");


