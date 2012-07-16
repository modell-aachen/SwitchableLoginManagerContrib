# Module of Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2012 Jan Krueger, Modell Aachen GmbH
# http://modell-aachen.de/
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
package Foswiki::LoginManager::SwitchableLogin;

=begin TML

---+ Foswiki::LoginManager::SwitchableLogin

This is a simple login manager that adds the ability for admins to switch to
an an arbitrary user (for testing permissions etc.) on top of a real login
manager.

=cut

use strict;
use Assert ();
use Foswiki::LoginManager ();
use Foswiki::Sandbox ();

our @ISA;

=begin TML

---++ ClassMethod new($session)

Construct the <nop>SwitchableLogin object

=cut

sub new {
    my ($class, $session) = @_;

    my $base = $Foswiki::cfg{SwitchableLoginManagerContrib}{ActualLoginManager};
    # Prevent infinite recursion
    $base = 'Foswiki::LoginManager' if !$base || $base eq 'Foswiki::LoginManager::SwitchableLogin';

    # Magically make the desired actual login manager our base class
    eval "require $base";
    die $@ if $@;
    @ISA = ($base);

    bless( $class->SUPER::new($session), $class );
}

=begin TML

---++ ObjectMethod userLoggedIn()

Initializes the logged in user. In this login manager, overwrite the logged in
user with our own (determined from sudouser query param) for admins.

=cut

sub userLoggedIn {
    my ($this, $authUser) = @_;
    my $session = $this->{session};

    unless ($this->{_cgisession} &&
        $Foswiki::cfg{SwitchableLoginManagerContrib}{SudoEnabled} &&
        $Foswiki::cfg{SwitchableLoginManagerContrib}{SudoAuth} ne 'changeme!'
    ) {
        return $this->SUPER::userLoggedIn($authUser);
    }

    # We store our sudo target in an extra session variable so that we can be
    # sure that it hasn't been overwritten by the regular login manager or
    # anything else.
    my $sessionUser = Foswiki::Sandbox::untaintUnchecked(
        $this->{_cgisession}->param('SUDOTOAUTHUSER') ) || $authUser;

    my $sudo = $session->{request}->param('sudouser');
    # "Authentication" as legitimate sudo request
    my $sudoauth = $session->{request}->param('sudoauth');
    my $orig = $this->{_cgisession}->param('SUDOFROMAUTHUSER') || $sessionUser;
    if (defined $sudo && Foswiki::Func::isAnAdmin($orig) && (!$sudo || $sudoauth eq $Foswiki::cfg{SwitchableLoginManagerContrib}{SudoAuth})) {
        # Un-sudo 'em
        if (!$sudo) {
            $this->{_cgisession}->param('AUTHUSER', $orig);
            $this->{_cgisession}->clear(['SUDOFROMAUTHUSER', 'SUDOTOAUTHUSER']);
            $authUser = $orig;
            Foswiki::Func::writeDebug("unsudo: $authUser <- $sessionUser");
        }
        else {
            $this->{_cgisession}->param('SUDOFROMAUTHUSER', $orig);
            $this->{_cgisession}->param('SUDOTOAUTHUSER', $sudo);
            $authUser = $sudo;
            Foswiki::Func::writeDebug("sudo: $sessionUser -> $authUser");
        }
        $session->{request}->delete('sudouser');
        $session->{request}->delete('sudoauth');
        $this->{_cgisession}->flush;
        $session->redirect($session->{request}->self_url);
    }

    return $this->SUPER::userLoggedIn($authUser);
}

1;
