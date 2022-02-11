From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Thu, 10 Feb 2022 21:55:27 -0800
Message-ID: <CAM9d7cgPFLjQyopX04MwG6Leq6DwDJF2q6BxOL_Nw6J2LEZF4g@mail.gmail.com>
References: <20220208184208.79303-1-namhyung@kernel.org> <20220209090908.GK23216@worktop.programming.kicks-ass.net>
 <CAM9d7cgq+jxu6FJuKhZkprn7dO4DiG5pDjmYZzneQYTfKOM85g@mail.gmail.com> <YgTXUQ9CBoo3+A+c@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YgTXUQ9CBoo3+A+c-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, intel-gfx <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Feb 10, 2022 at 1:14 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Wed, Feb 09, 2022 at 04:32:58PM -0800, Namhyung Kim wrote:
> > On Wed, Feb 9, 2022 at 1:09 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > >
> > > On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:
> > >
> > > > Eventually I'm mostly interested in the contended locks only and I
> > > > want to reduce the overhead in the fast path.  By moving that, it'd be
> > > > easy to track contended locks with timing by using two tracepoints.
> > >
> > > So why not put in two new tracepoints and call it a day?
> > >
> > > Why muck about with all that lockdep stuff just to preserve the name
> > > (and in the process continue to blow up data structures etc..). This
> > > leaves distros in a bind, will they enable this config and provide
> > > tracepoints while bloating the data structures and destroying things
> > > like lockref (which relies on sizeof(spinlock_t)), or not provide this
> > > at all.
> >
> > If it's only lockref, is it possible to change it to use arch_spinlock_t
> > so that it can remain in 4 bytes?  It'd be really nice if we can keep
> > spin lock size, but it'd be easier to carry the name with it for
> > analysis IMHO.
>
> It's just vile and disgusting to blow up the lock size for convenience
> like this.
>
> And no, there's more of that around. A lot of effort has been spend to
> make sure spinlocks are 32bit and we're not going to give that up for
> something as daft as this.
>
> Just think harder on the analysis side. Like said; I'm thinking the
> caller IP should be good enough most of the time.

Ok, I'll go in this direction then.

So you are ok with adding two new tracepoints, even if they are
similar to what we already have in lockdep/lock_stat, right?

Thanks,
Namhyung
