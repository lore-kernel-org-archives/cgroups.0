From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v6 9/9] devcg: propagate local changes down the
 hierarchy
Date: Mon, 11 Feb 2013 17:42:59 +0000
Message-ID: <20130211174259.GA18179@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130205183646.GT17632@redhat.com>
 <20130209040402.GA31942@mail.hallyn.com>
 <20130211143241.GF30962@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130211143241.GF30962@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>

Quoting Aristeu Rozanski (aris@redhat.com):
> On Sat, Feb 09, 2013 at 04:04:02AM +0000, Serge E. Hallyn wrote:
> > Quoting Aristeu Rozanski (aris@redhat.com):
> > > devcg: propagate local changes down the hierarchy
> > > 
> > > This patch makes all changes propagate down in hierarchy respecting when
> > > possible local configurations.
> > > 
> > > Behavior changes will clean up exceptions in all the children except when the
> > > parent changes the behavior from allow to deny and the child's behavior was
> > > already deny, in which case the local exceptions will be reused. The inverse
> > > is not possible: you can't have a parent with behavior deny and a child with
> > > behavior accept.
> > > 
> > > New exceptions allowing additional access to devices won't be propagated, but
> > > it'll be possible to add an exception to access all of part of the newly
> > > allowed device(s).
> > > 
> > > New exceptions disallowing access to devices will be propagated down and the
> > > local group's exceptions will be revalidated for the new situation.
> > > Example:
> > >       A
> > >      / \
> > >         B
> > > 
> > >     group        behavior          exceptions
> > >     A            allow             "b 8:* rwm", "c 116:1 rw"
> > >     B            deny              "c 1:3 rwm", "c 116:2 rwm", "b 3:* rwm"
> > > 
> > > If a new exception is added to group A:
> > > 	# echo "c 116:* r" > A/devices.deny
> > > it'll propagate down and after revalidating B's local exceptions, the exception
> > > "c 116:2 rwm" will be removed.
> > > 
> > > In case parent behavior or exceptions change and local settings are not
> > > allowed anymore, they'll be deleted.
> > 
> > Do you have a use case which would be broken if we simply refuse to
> > allow behavior changes for any cgroup with children?
> > 
> > It seems like that would drastically simplify much of this.  We would
> > no longer need local.exceptions at all, right?  Your comment says
> > 
> >          * local set rules, saved so when a parent propagates new rules, the
> >          * local preferences can be preserved
> > 
> > but if there were no parent behavior changes, then any exception change
> > in a parent could be enforced by simply removing violating exceptions
> > in the child, and subsequently refusing the addition of new rules in the
> > child which are not allowed in the parent.  Both of which you already do.
> > 
> > Or am I thinking wrongly?
> 
> That would be an option even simpler than not keeping local settings. In
> production I doubt the sysadmin will keep playing with permissions,
> although until one gets right, it'll be annoying as hell to have to
> remove the whole hierarchy because you forgot to add a certain device to
> the list.

Note I said only forbid behavior changes - not exception changes - to
cgroups with children.

-serge
