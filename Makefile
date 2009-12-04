
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/universal-darwin10.0
hdrdir = $(topdir)
VPATH = $(srcdir):$(topdir):$(hdrdir)
exec_prefix = $(prefix)
prefix = $(DESTDIR)/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr
sharedstatedir = $(prefix)/com
mandir = $(DESTDIR)/usr/share/man
psdir = $(docdir)
oldincludedir = $(DESTDIR)/usr/include
localedir = $(datarootdir)/locale
bindir = $(exec_prefix)/bin
libexecdir = $(exec_prefix)/libexec
sitedir = $(DESTDIR)/Library/Ruby/Site
htmldir = $(docdir)
vendorarchdir = $(vendorlibdir)/$(sitearch)
includedir = $(prefix)/include
infodir = $(DESTDIR)/usr/share/info
vendorlibdir = $(vendordir)/$(ruby_version)
sysconfdir = $(prefix)/etc
libdir = $(exec_prefix)/lib
sbindir = $(exec_prefix)/sbin
rubylibdir = $(libdir)/ruby/$(ruby_version)
docdir = $(datarootdir)/doc/$(PACKAGE)
dvidir = $(docdir)
vendordir = $(libdir)/ruby/vendor_ruby
datarootdir = $(prefix)/share
pdfdir = $(docdir)
archdir = $(rubylibdir)/$(arch)
sitearchdir = $(sitelibdir)/$(sitearch)
datadir = $(datarootdir)
localstatedir = $(prefix)/var
sitelibdir = $(sitedir)/$(ruby_version)

CC = gcc
LIBRUBY = $(LIBRUBY_SO)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)

RUBY_EXTCONF_H = 
CFLAGS   =  -fno-common -arch i386 -arch x86_64 -g -Os -pipe -fno-common -DENABLE_DTRACE  -fno-common  -pipe -fno-common $(cflags) 
INCFLAGS = -I. -I$(topdir) -I$(hdrdir) -I$(srcdir)
DEFS     = 
CPPFLAGS = -DHAVE_NCURSES_H  -D_XOPEN_SOURCE -D_DARWIN_C_SOURCE $(DEFS) $(cppflags)
CXXFLAGS = $(CFLAGS) 
ldflags  = -L. -arch i386 -arch x86_64 
dldflags = 
archflag = 
DLDFLAGS = $(ldflags) $(dldflags) $(archflag)
LDSHARED = cc -arch i386 -arch x86_64 -pipe -bundle -undefined dynamic_lookup
AR = ar
EXEEXT = 

RUBY_INSTALL_NAME = ruby
RUBY_SO_NAME = ruby
arch = universal-darwin10.0
sitearch = universal-darwin10.0
ruby_version = 1.8
ruby = /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby
RUBY = $(ruby)
RM = rm -f
MAKEDIRS = mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp

#### End of system configuration section. ####

preload = 

libpath = . $(libdir)
LIBPATH =  -L. -L$(libdir)
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED)  -lpthread -ldl  
SRCS = 
OBJS = 
TARGET = 
DLLIB = 
EXTSTATIC = 
STATIC_LIB = 

BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR    = $(sitelibdir)$(target_prefix)
RUBYARCHDIR   = $(sitearchdir)$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).bundle $(TARGET).il? $(TARGET).tds $(TARGET).map
CLEANOBJS     = *.o *.a *.s[ol] *.pdb *.exp *.bak

all:		Makefile
static:		$(STATIC_LIB)

clean:
		@-$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES)

distclean:	clean
		@-$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)

realclean:	distclean
install: install-so install-rb

install-so: Makefile
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
pre-install-rb-default: $(RUBYLIBDIR)/rdesk/monkey
install-rb-default: $(RUBYLIBDIR)/rdesk/monkey/array.rb
$(RUBYLIBDIR)/rdesk/monkey/array.rb: $(srcdir)/lib/rdesk/monkey/array.rb $(RUBYLIBDIR)/rdesk/monkey
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/monkey/array.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/monkey/string.rb
$(RUBYLIBDIR)/rdesk/monkey/string.rb: $(srcdir)/lib/rdesk/monkey/string.rb $(RUBYLIBDIR)/rdesk/monkey
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/monkey/string.rb $(@D)
pre-install-rb-default: $(RUBYLIBDIR)/rdesk/project
install-rb-default: $(RUBYLIBDIR)/rdesk/project/auto_build.rb
$(RUBYLIBDIR)/rdesk/project/auto_build.rb: $(srcdir)/lib/rdesk/project/auto_build.rb $(RUBYLIBDIR)/rdesk/project
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/project/auto_build.rb $(@D)
pre-install-rb-default: $(RUBYLIBDIR)/rdesk/stage
install-rb-default: $(RUBYLIBDIR)/rdesk/stage/actor.rb
$(RUBYLIBDIR)/rdesk/stage/actor.rb: $(srcdir)/lib/rdesk/stage/actor.rb $(RUBYLIBDIR)/rdesk/stage
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/stage/actor.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/stage/message.rb
$(RUBYLIBDIR)/rdesk/stage/message.rb: $(srcdir)/lib/rdesk/stage/message.rb $(RUBYLIBDIR)/rdesk/stage
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/stage/message.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/stage/stage.rb
$(RUBYLIBDIR)/rdesk/stage/stage.rb: $(srcdir)/lib/rdesk/stage/stage.rb $(RUBYLIBDIR)/rdesk/stage
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/stage/stage.rb $(@D)
pre-install-rb-default: $(RUBYLIBDIR)/rdesk/ui
install-rb-default: $(RUBYLIBDIR)/rdesk/ui/buffer.rb
$(RUBYLIBDIR)/rdesk/ui/buffer.rb: $(srcdir)/lib/rdesk/ui/buffer.rb $(RUBYLIBDIR)/rdesk/ui
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/ui/buffer.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/ui/buffer_position.rb
$(RUBYLIBDIR)/rdesk/ui/buffer_position.rb: $(srcdir)/lib/rdesk/ui/buffer_position.rb $(RUBYLIBDIR)/rdesk/ui
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/ui/buffer_position.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/ui/buffer_region.rb
$(RUBYLIBDIR)/rdesk/ui/buffer_region.rb: $(srcdir)/lib/rdesk/ui/buffer_region.rb $(RUBYLIBDIR)/rdesk/ui
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/ui/buffer_region.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/ui/buffer_selection.rb
$(RUBYLIBDIR)/rdesk/ui/buffer_selection.rb: $(srcdir)/lib/rdesk/ui/buffer_selection.rb $(RUBYLIBDIR)/rdesk/ui
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/ui/buffer_selection.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/ui/desk.rb
$(RUBYLIBDIR)/rdesk/ui/desk.rb: $(srcdir)/lib/rdesk/ui/desk.rb $(RUBYLIBDIR)/rdesk/ui
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/ui/desk.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/ui/viewport.rb
$(RUBYLIBDIR)/rdesk/ui/viewport.rb: $(srcdir)/lib/rdesk/ui/viewport.rb $(RUBYLIBDIR)/rdesk/ui
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/ui/viewport.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/ui/viewport_selection.rb
$(RUBYLIBDIR)/rdesk/ui/viewport_selection.rb: $(srcdir)/lib/rdesk/ui/viewport_selection.rb $(RUBYLIBDIR)/rdesk/ui
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/ui/viewport_selection.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rdesk/ui/window.rb
$(RUBYLIBDIR)/rdesk/ui/window.rb: $(srcdir)/lib/rdesk/ui/window.rb $(RUBYLIBDIR)/rdesk/ui
	$(INSTALL_DATA) $(srcdir)/lib/rdesk/ui/window.rb $(@D)
pre-install-rb-default: $(RUBYLIBDIR)
install-rb-default: $(RUBYLIBDIR)/rdesk.rb
$(RUBYLIBDIR)/rdesk.rb: $(srcdir)/lib/rdesk.rb $(RUBYLIBDIR)
	$(INSTALL_DATA) $(srcdir)/lib/rdesk.rb $(@D)
$(RUBYLIBDIR)/rdesk/monkey:
	$(MAKEDIRS) $@
$(RUBYLIBDIR)/rdesk/project:
	$(MAKEDIRS) $@
$(RUBYLIBDIR)/rdesk/stage:
	$(MAKEDIRS) $@
$(RUBYLIBDIR)/rdesk/ui:
	$(MAKEDIRS) $@
$(RUBYLIBDIR):
	$(MAKEDIRS) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

