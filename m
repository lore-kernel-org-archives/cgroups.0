From: "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Thu, 10 Feb 2022 12:10:58 -0800
Message-ID: <20220210201058.GP4285@paulmck-ThinkPad-P17-Gen-1>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220209090908.GK23216@worktop.programming.kicks-ass.net>
 <CAM9d7cgq+jxu6FJuKhZkprn7dO4DiG5pDjmYZzneQYTfKOM85g@mail.gmail.com>
 <YgTXUQ9CBoo3+A+c@hirez.programming.kicks-ass.net>
 <20220210191404.GM4285@paulmck-ThinkPad-P17-Gen-1>
 <52de2e14-33d9-bdda-4b37-3e72ae9954c7@redhat.com>
Reply-To: paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644523858;
        bh=iLVxmxOrhgeAZwTkFuG1YJotZgqgklwTkad+usc+SbM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=o56gSkY6KjsTqaNLucwpbwSfiS6lwFJGp+betDu9X8aq4l5khh7ZxFWlsuOatT/SU
         kOGdUu/H0ffGyVffjwXC/ybeD43ppXkNTvDupxItbHL7c25YO9JTjYo5liSOPlcZC2
         S1l9sx6T5hVnihTP/6rf8lhrpqqKkZFEIUwl5KM59cYjlYCu/0Yr+pjZ3xGxIECloB
         CApZ1rDMi8muJMOR27g2MNZAWOGq2UPWWAP3ejtxogM0Zp3M0cGAvHvgqTg5t4J52t
         BAlD+tYaAE1gb9pplHq+kCcw19EB/b00N+HnvtaBqE+Exhnq3oBWfkbhFmD3qaQRE5
         TDTWUZVxVnWFA==
Content-Disposition: inline
In-Reply-To: <52de2e14-33d9-bdda-4b37-3e72ae9954c7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, intel-gfx <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

On Thu, Feb 10, 2022 at 02:27:11PM -0500, Waiman Long wrote:
> On 2/10/22 14:14, Paul E. McKenney wrote:
> > On Thu, Feb 10, 2022 at 10:13:53AM +0100, Peter Zijlstra wrote:
> > > On Wed, Feb 09, 2022 at 04:32:58PM -0800, Namhyung Kim wrote:
> > > > On Wed, Feb 9, 2022 at 1:09 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > > > > On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:
> > > > > 
> > > > > > Eventually I'm mostly interested in the contended locks only and I
> > > > > > want to reduce the overhead in the fast path.  By moving that, it'd be
> > > > > > easy to track contended locks with timing by using two tracepoints.
> > > > > So why not put in two new tracepoints and call it a day?
> > > > > 
> > > > > Why muck about with all that lockdep stuff just to preserve the name
> > > > > (and in the process continue to blow up data structures etc..). This
> > > > > leaves distros in a bind, will they enable this config and provide
> > > > > tracepoints while bloating the data structures and destroying things
> > > > > like lockref (which relies on sizeof(spinlock_t)), or not provide this
> > > > > at all.
> > > > If it's only lockref, is it possible to change it to use arch_spinlock_t
> > > > so that it can remain in 4 bytes?  It'd be really nice if we can keep
> > > > spin lock size, but it'd be easier to carry the name with it for
> > > > analysis IMHO.
> > > It's just vile and disgusting to blow up the lock size for convenience
> > > like this.
> > > 
> > > And no, there's more of that around. A lot of effort has been spend to
> > > make sure spinlocks are 32bit and we're not going to give that up for
> > > something as daft as this.
> > > 
> > > Just think harder on the analysis side. Like said; I'm thinking the
> > > caller IP should be good enough most of the time.
> > 
> > Another option is to keep any additional storage in a separate data
> > structure keyed off of lock address, lockdep class, or whatever.
> > 
> > Whether or not this is a -good- option, well, who knows?  ;-)
> 
> I have suggested that too. Unfortunately, I was replying to an email with
> your wrong email address. So you might not have received it.

Plus I was too lazy to go look at lore.  ;-)

For whatever it is worth, we did something similar in DYNIX/ptx, whose
spinlocks were limited to a single byte.  But it does have its drawbacks.

							Thanx, Paul
