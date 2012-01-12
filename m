From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Date: Thu, 12 Jan 2012 09:57:25 -0800
Message-ID: <20120112175725.GD9511@google.com>
References: <20111221190817.GI17668@somewhere>
 <20111221192413.GF13529@google.com>
 <20111221200422.GJ17668@somewhere>
 <20111222153004.GA30522@redhat.com>
 <20120104193614.GF9511@google.com>
 <20120106152356.GA23995@redhat.com>
 <20120106182535.GJ9511@google.com>
 <20120111160730.GA24556@redhat.com>
 <20120112003102.GB9511@google.com>
 <20120112170728.GA25717@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        bh=+aZfVDc4Mp6U6gCOqxYYRx1yid95xfpLn2omPcflszY=;
        b=PqQsvSbGUcB6IogqtRUjaKLDfHcvFQFtHdW6e+jBnnlBr2QfUnz2ujf2CiksTwgN80
         /+r4attjf4CwDGW8BrDUJx6NHy2FV+ZQjjd9Oi9Aj5FtRq30iVcEfAL3C8BKl4PgAIOj
         Bhb6nXxzkb/bcZhJQiXRBP5j/dVknFFa1sa50=
Content-Disposition: inline
In-Reply-To: <20120112170728.GA25717-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Hi Oleg,

Oleg Nesterov (oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org) wrote:
> Hi Mandeep,
> 
> On 01/11, Mandeep Singh Baines wrote:
> > > >
> > > > #define while_each_thread(g, t, o) \
> > > > 	while (t->group_leader == o && (t = next_thread(t)) != g)
> > > >
> > > > Where o should have the value of g->group_leader.
> > >
> > > I don't understand how this helps... and how this can work even
> > > ignoring the barriers.
> > >
> > > OK, we have the main thream M and the sub-thread T, we are doing
> > >
> > > 	do {
> > > 		do_something(t);
> > > 	} while_each_thread(M, t, M);
> > >
> > > why we can't miss T if it does exec?
> > >
> >
> > So for:
> >
> > struct task *M; /* assuming this is passed in to us */
> > struct task *L = M->group_leader;
> 
> L == M
> 
> > do {
> > 	do_something(T);
> > } while_each_thread(M, T, L);
> >
> > Here is my thinking.
> >
> > If some thread K does exec, you won't miss it because:
> >
> > 1) Ignoring the group_leader check, you'll visit K just by following
> >    next_thread(). That's the case today and is what you except
> >    when iterating over an rcu_list.
> > 2) (t->group_leader == o) will fail iff t is the exec thread.
> >    Since we test t->group_leader before re-assigning it (t=next_thread()),
> >    the test will fail only after visiting the exec thread. So you'll
> >    visit the exec thread and then terminate the loop.
> 
> Still can't understand... Lets look at this trivial example again.
> 
> We start from the main thread M, it is ->group_leader. There is
> another thread T in this thread group. We are doing
> 
> 	OLD = M;
> 
> 	t = M;
> 	do {
> 		do_smth(t);
> 	}
> 	while (t->group_leader == OLD && ((t = next_thread(t)) != M);
> 
> The first iteration does do_smth(M).
> 
> T calls de_thread() and, in particular, it does M->group_leader = T
> (see "leader->group_leader = tsk" in de_thread).
> 
> after that t->group_leader == OLD fails. t == M, its group_leader == T.
> do_smth(T) won't be called.
> 
> No?
> 

I think we can handle this by removing the assignment. So in de_thread():

-		leader->group_leader = tsk;

		tsk->exit_signal = SIGCHLD;
		leader->exit_signal = -1;

		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
		leader->exit_state = EXIT_DEAD;

In the current d_thread(), four statements after reassigning
leader->group_leader, we mark the old leader as EXIT_DEAD. So what if
we leave leader->group_leader = leader. Since its EXIT_DEAD a few
statements later, I don't think anything should break.

What do you think?

Regards,
Mandeep

> Oleg.
> 
