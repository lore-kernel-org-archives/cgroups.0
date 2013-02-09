From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 9/9] devcg: propagate local changes down the
 hierarchy
Date: Sat, 9 Feb 2013 04:04:02 +0000
Message-ID: <20130209040402.GA31942@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130205183646.GT17632@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130205183646.GT17632-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> devcg: propagate local changes down the hierarchy
> 
> This patch makes all changes propagate down in hierarchy respecting when
> possible local configurations.
> 
> Behavior changes will clean up exceptions in all the children except when the
> parent changes the behavior from allow to deny and the child's behavior was
> already deny, in which case the local exceptions will be reused. The inverse
> is not possible: you can't have a parent with behavior deny and a child with
> behavior accept.
> 
> New exceptions allowing additional access to devices won't be propagated, but
> it'll be possible to add an exception to access all of part of the newly
> allowed device(s).
> 
> New exceptions disallowing access to devices will be propagated down and the
> local group's exceptions will be revalidated for the new situation.
> Example:
>       A
>      / \
>         B
> 
>     group        behavior          exceptions
>     A            allow             "b 8:* rwm", "c 116:1 rw"
>     B            deny              "c 1:3 rwm", "c 116:2 rwm", "b 3:* rwm"
> 
> If a new exception is added to group A:
> 	# echo "c 116:* r" > A/devices.deny
> it'll propagate down and after revalidating B's local exceptions, the exception
> "c 116:2 rwm" will be removed.
> 
> In case parent behavior or exceptions change and local settings are not
> allowed anymore, they'll be deleted.

Do you have a use case which would be broken if we simply refuse to
allow behavior changes for any cgroup with children?

It seems like that would drastically simplify much of this.  We would
no longer need local.exceptions at all, right?  Your comment says

         * local set rules, saved so when a parent propagates new rules, the
         * local preferences can be preserved

but if there were no parent behavior changes, then any exception change
in a parent could be enforced by simply removing violating exceptions
in the child, and subsequently refusing the addition of new rules in the
child which are not allowed in the parent.  Both of which you already do.

Or am I thinking wrongly?

-serge
