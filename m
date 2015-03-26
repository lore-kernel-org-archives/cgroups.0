From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/3] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri, 27 Mar 2015 01:38:54 +1100
Message-ID: <CAOviyahTq1K6zBRfmXfepabiQ7xU8ZoNdq0jPd3nP4Q-0H1DDQ@mail.gmail.com>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
	<1426307835-5893-3-git-send-email-cyphar@cyphar.com>
	<20150316165335.GC8353@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150316165335.GC8353-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

Here's a bit more of a follow-up on two of your points:

Since

> Do we really need a separate callback for this?  Can't we just add
> @old_css param to ss->fork() which is NULL if it didn't change since
> can_fork()?

and

> Did you explore the idea of passing an opaque pointer from can_fork to
> post_fork?  If so, why did you choose this direction instead of that
> one?

Are quite similar (they essentially both result in each other, since if you use
void pointers for state you can't check if the association changed without
doing completely separate accounting which wouldn't be used by the callbacks),
I'll respond to both in the same go:

The issue I can see with passing around an opaque pointer to fork() is that you
have a random private (void **) argument that is completely useless if you
don't use can_fork(). This is why I think we should call the reapply_fork()
callback if the association changes [we could call it something else if you
like, since reapply_fork() is a pids-specific name -- what about switch_fork(),
reassoc_fork(), re_fork() or something to show that it's a callback if the
association changes?] (the subsystem can decide if they want to ignore it / if
they don't want to touch it) and we deal with pinning / dropping the ref of the
css_set for the current task inside the cgroup_* callbacks. That way, we don't
start messing around with post-fork() callbacks that aren't related to the new
conditional stuff.

I mean, if you want to have a random, completely unused and essentially
vestigial argument to ss->fork() [if you don't use the new can_fork() callbacks
(and actually care about storing private data)] then I can just write that. It
just looks like a weird callback API imho.

In fact, it seems even more single purpose than just pinning the ref and
dealing with it for the general case of an association switching (because now
you have a single-purpose parameter to the general fork() call, as opposed to
doing some ref pinning and accounting of the current css_set for (currently)
only the pids subsystem in the cgroup core. Since we know  that pids will need
to pin the ref, then we're not doing any extra work in  doing it for the
general cgroup fork callback -- and we get to both separate "association
changed" logic from "post fork" logic in the callbacks, as well as not blindly
trusting the cgroup subsystem to properly deal with a changing association.

--
Aleksa Sarai (cyphar)
www.cyphar.com
