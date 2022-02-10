From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Thu, 10 Feb 2022 10:13:53 +0100
Message-ID: <YgTXUQ9CBoo3+A+c@hirez.programming.kicks-ass.net>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220209090908.GK23216@worktop.programming.kicks-ass.net>
 <CAM9d7cgq+jxu6FJuKhZkprn7dO4DiG5pDjmYZzneQYTfKOM85g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WhfsZGHRyj3BiYrePm2T7nfqolEn4234PiR7dKjI6oY=; b=q4NJZI6DxE2Kvi7IDsQkKmgYd+
        CdvNqs4GIuOeJFL07OBuo6jwtRivpLI81AjuWAK6/X5/bATwaztFCccoCMOKOgc03i6EibzJI3zex
        jiDMkf3RS+yh8mPUne5xny6D2Hs+o1qHbOe3Pv8xVEJTTnWkR82+c2sVrEy5oTt+Ov89Jtd6yla1l
        JQmlCNuH0gck2TW8MO0xMhXcUQEkiPSaCSjD/eLqgX5JiM+NGur6WVyM/z3L/l2TnzwosdxIuUC20
        3dBDXEmpxjcWUKkFe36yEwmqw0YpwEFQHpAS0mFAAPeVksb0F+hagIQzkB9qTmDOw9En54KjuiBnA
        zuhFipnw==;
Content-Disposition: inline
In-Reply-To: <CAM9d7cgq+jxu6FJuKhZkprn7dO4DiG5pDjmYZzneQYTfKOM85g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, intel-gfx <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed, Feb 09, 2022 at 04:32:58PM -0800, Namhyung Kim wrote:
> On Wed, Feb 9, 2022 at 1:09 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:
> >
> > > Eventually I'm mostly interested in the contended locks only and I
> > > want to reduce the overhead in the fast path.  By moving that, it'd be
> > > easy to track contended locks with timing by using two tracepoints.
> >
> > So why not put in two new tracepoints and call it a day?
> >
> > Why muck about with all that lockdep stuff just to preserve the name
> > (and in the process continue to blow up data structures etc..). This
> > leaves distros in a bind, will they enable this config and provide
> > tracepoints while bloating the data structures and destroying things
> > like lockref (which relies on sizeof(spinlock_t)), or not provide this
> > at all.
> 
> If it's only lockref, is it possible to change it to use arch_spinlock_t
> so that it can remain in 4 bytes?  It'd be really nice if we can keep
> spin lock size, but it'd be easier to carry the name with it for
> analysis IMHO.

It's just vile and disgusting to blow up the lock size for convenience
like this.

And no, there's more of that around. A lot of effort has been spend to
make sure spinlocks are 32bit and we're not going to give that up for
something as daft as this.

Just think harder on the analysis side. Like said; I'm thinking the
caller IP should be good enough most of the time.
