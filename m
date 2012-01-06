From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Date: Fri, 6 Jan 2012 10:25:35 -0800
Message-ID: <20120106182535.GJ9511@google.com>
References: <20111221034334.GD17668@somewhere>
 <20111221130848.GA19679@redhat.com>
 <20111221175632.GF17668@somewhere>
 <20111221190102.GE13529@google.com>
 <20111221190817.GI17668@somewhere>
 <20111221192413.GF13529@google.com>
 <20111221200422.GJ17668@somewhere>
 <20111222153004.GA30522@redhat.com>
 <20120104193614.GF9511@google.com>
 <20120106152356.GA23995@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        bh=QgMWI8/tjtnxESaco2yIACgenHpxUnVA5I5p1ABX1t0=;
        b=pf0/bYdqNpeBOVik/GdCoVcvv9GFn5uspqT6aX8cODod7kCt/HuCXoA7l5FjestzkC
         fIkC6PnNXZB4QxRLHZLeotlBuRVDfgzO6zxFf50iVY8kaxOsptwTdmZYwbhoYzJj2miF
         noRX6tudIN2BBDADmYM8Ss71fBRpXcYdFYmDE=
Content-Disposition: inline
In-Reply-To: <20120106152356.GA23995-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Oleg Nesterov (oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org) wrote:
> On 01/04, Mandeep Singh Baines wrote:
> >
> > Oleg Nesterov (oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org) wrote:
> > > On 12/21, Frederic Weisbecker wrote:
> > > >
> > > > On Wed, Dec 21, 2011 at 11:24:13AM -0800, Mandeep Singh Baines wrote:
> > > > >
> > > > > If you call exec from a thread other than g, g is now unlinked. So
> > > > > "t != g" will always be true. If you then pthread_create, you now
> > > > > have two threads so "t != __prev" will also always be true. So
> > > > > you now have an infinite loop.
> > > >
> > > > Oh you're right.
> > > >
> > > > But then we can't use t != t->group_leader because that assumes while_each_thread()
> > > > started on the leader.
> > >
> > > Yes, this can't work.
> > >
> > > Besides, we need more burriers to rely on the ->group_leader check.
> > >
> > > See http://marc.info/?t=127688987300002
> > >
> >
> > I went through the thread. Were there any other concerns other than
> > requiring that you start with the group_leader and the barrier?
> >
> > You could modify zap_other_threads to start with the group leader by
> > skipping p:
> >
> > if (p == t)
> >    continue;
> 
> Yes, we can but there are other while_each_thread(nonleader) users.
> Yes we can fix them too but this looks a bit ugly and we need to
> change while_each_thread() anyway. And I do not see why this change
> will be simpler if we restrict it to group_leader.
> 
> And note that zap_other_threads() is fine in any case, it is called
> under ->siglock.
> 
> > > in particular, http://marc.info/?l=linux-kernel&m=127714242731448
> > > I think this should work, but then we should do something with the
> > > users like zap_threads().
> > >
> >
> > With that patch, won't you potentially miss the exec thread if an exec
> > occurs while you're iterating over the list? Is that OK?
> 
> Of course it is not OK ;) Note the "we should do something with" above.
> 

So requirements should be something like this:

* Any task alive for the duration of the iteration MUST be visited
* No task should be visited more than once
* Any task born or exiting after starting the iteration MAY be skipped
* You can start at any task in the thread group

Would something like this work:

#define while_each_thread(g, t, o) \
	while (t->group_leader == o && (t = next_thread(t)) != g)

Where o should have the value of g->group_leader.

Regards,
Mandeep

> Oleg.
> 
