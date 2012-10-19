From: Matt Helsley <matthltc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Date: Thu, 18 Oct 2012 18:29:45 -0700
Message-ID: <20121019012945.GD6223@us.ibm.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <20121017191606.GA6223@us.ibm.com>
 <20121018211434.GI13370@google.com>
 <20121018222155.GB6223@us.ibm.com>
 <20121018223517.GQ13370@google.com>
 <20121018234726.GC6223@us.ibm.com>
 <20121019000153.GZ13370@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121019000153.GZ13370-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Helsley <matthltc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, rjw-KKrjLPT3xs0@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 18, 2012 at 05:01:53PM -0700, Tejun Heo wrote:

<snip>
> I probably have chosen the wrong word.  I mean that it's a hierarchy
> management feature implemented at the wrong layer.  If we want to
> provide cgroup migration locking, it should be implemented at the
> cgroup core layer as a controller independent feature.  It's kinda
> interesting the incorrect layering here almost directly caused messy
> locking problem too.  I hope we don't need it with (the imaginary)
> proper userland arbitration but even if we do implementing it in
> cgroup proper as a separate feature would be a lot less messy.

Yeah, that would be a nice cleanup too. I guess the ultra-careful way to
remove this feature would be something like:

	Add an internal migration restriction (which may or may not be
		exported as a userspace interface in a subsequent
		patch).

	Make the cgroup freezer use it.

	Make the cgroup freezer WARN_ONCE() when the subsystem is first
		mounted. Indicates that the behavior is going to
		change.

	... time passes ...

	Remove the use of the migration "lock" from the cgroup freezer
		and the WARN_ONCE().

Which would also make the feature more obvious.

Cheers,
	-Matt
