From: Petr Mladek <pmladek@suse.com>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Tue, 19 Apr 2016 17:39:04 +0200
Message-ID: <20160419153904.GV30877@pathway.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415070601.GA32377@dhcp22.suse.cz>
 <20160415143815.GH12583@htj.duckdns.org>
 <20160418144023.GG6862@pathway.suse.cz>
 <20160419140120.GA4126@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160419140120.GA4126@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>, linux-kernel@vger.kernel.org

On Tue 2016-04-19 10:01:21, Michal Hocko wrote:
> On Mon 18-04-16 16:40:23, Petr Mladek wrote:
> > On Fri 2016-04-15 10:38:15, Tejun Heo wrote:
> > > > Anyway, before we go that way, can we at least consider the possibility
> > > > of removing the kworker creation dependency on the global rwsem? AFAIU
> > > > this locking was added because of the pid controller. Do we even care
> > > > about something as volatile as kworkers in the pid controller?
> > >
> > > It's not just pid controller and the global percpu locking has lower
> > > hotpath overhead.  We can try to exclude kworkers out of the locking
> > > but that can get really nasty and there are already attempts to add
> > > cgroup support to workqueue.  Will think more about it.
> > 
> > I have played with this idea on Friday. Please, find below a POC.
> > The worker detection works and the deadlock is removed. But workers
> > do not appear in the root cgroups. I am not familiar with the cgroups
> > stuff, so this part is much more difficult for me.
> > 
> > I send it because it might give you an idea when discussing it
> > on LSF. Please, let me know if I should continue on this way or
> > if it looks too crazy already now.
> > 
> > >From ca1420926f990892a914d64046ee8d273b876f30 Mon Sep 17 00:00:00 2001
> > From: Petr Mladek <pmladek@suse.com>
> > Date: Mon, 18 Apr 2016 14:17:17 +0200
> > Subject: [POC PATCH] cgroups/workqueus: Do not block forking workqueues by cgroups
> >  lock
> > 
> > This is a POC how to delay cgroups operations when forking workqueue
> > workers.
>>
> >  include/linux/kthread.h   | 14 +++++++++++++
> >  include/linux/workqueue.h |  1 +
> >  kernel/cgroup.c           | 53 +++++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/fork.c             | 36 +++++++++++++++++++++++---------
> >  kernel/kthread.c          | 14 -------------
> >  kernel/workqueue.c        |  9 ++++----
> >  6 files changed, 98 insertions(+), 29 deletions(-)
> 
> This feels too overcomplicated. Can we simply drop the locking in
> copy_process if the current == ktreadadd? Would something actually
> break?

This would affect all kthreads. But there are kthreads that might be moved
in cgroups and where it makes sense. We will need to synchronize the
delayed  cgroups initialization with the moving operation. But then we
could use the same solution for all processes.

Best Regards,
Petr
