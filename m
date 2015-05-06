From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Wed, 6 May 2015 10:49:06 +0200
Message-ID: <20150506084906.GW23123@twins.programming.kicks-ass.net>
References: <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <55483EF7.7070905@huawei.com>
 <20150505141049.GN21418@twins.programming.kicks-ass.net>
 <20150505141838.GR1971@htj.duckdns.org>
 <20150505151949.GQ21418@twins.programming.kicks-ass.net>
 <20150505163112.GU1971@htj.duckdns.org>
 <20150505190057.GR23123@twins.programming.kicks-ass.net>
 <20150505190603.GZ1971@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150505190603.GZ1971-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 05, 2015 at 03:06:03PM -0400, Tejun Heo wrote:
> Hello, Peter.
> 
> On Tue, May 05, 2015 at 09:00:57PM +0200, Peter Zijlstra wrote:
> > On Tue, May 05, 2015 at 12:31:12PM -0400, Tejun Heo wrote:
> > > What I don't want to happen is controllers failing migrations
> > > willy-nilly for random reasons leaving users baffled, which we've
> > > actually been doing unfortunately.  Maybe we need to deal with this
> > > fixed resource arbitration as a separate class and allow them to fail
> > > migration w/ -EBUSY.
> > 
> > Ah, _that_ was the problem.
> > 
> > Which is something created by this co-mounting of controllers.
> 
> Yeah, partly, but also that it's an extra failure mode which isn't
> necessary for most controllers.

I can agree with reducing failure modes, but we should not do it at the
cost of functionality.

> > You could of course store the ss-id of the failing operation in
> > task_struct and have a file reporting the name of the ss-id.
> > 
> > That way, there is a simple way to find out which controller failed the
> > migrate.
> 
> Given that the resources which can fail are very limited, I don't
> think we need that right now as long as we limit and document the
> possible failure cases clearly.  Hopefully, this won't devolve into
> collection of arbitrary failures.

Right, but something like that would be fairly trivial to implement and
would give immediate resolution.

For example:

$ echo 123 > /cgroups/monkey/business/tasks
-EBUSY
$ cat /cgroups/monkey/business/errno
cpu:-EBUSY

(in fact, for a trivial implementation it doesn't matter which
cgroup/errno you cat)
