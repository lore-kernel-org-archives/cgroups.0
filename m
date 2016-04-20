From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-4.6-fixes] memcg: remove lru_add_drain_all()
 invocation from mem_cgroup_move_charge()
Date: Wed, 20 Apr 2016 17:29:22 -0400
Message-ID: <20160420212922.GH4775@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M/tCLm3V6RxzNdzp7cC1yrHRtL8uFdU9mo62Q+TjzQs=;
        b=IEjjPdbdclhlnJ8F0fl7kmupAa2sl18mwUZow7Ewr/mVVtwk3PoECf1dxCSRkpJMMf
         zZHI+GMehp7NGr4uUblvoI6X6wtnyriVX5nzqckpi9ZYsbD6fb0H45/0SCP31jkymN11
         SP8f5/tgaVijwn5oiBL9Fsyp2tgJYhIHOGiaOPF1YddcunJlxbKzY5Az4xKFQNTIbFGY
         3Qc/PqI6GII1+INLkK2Xi5Z/WVa51OLNOhEjVY1OddcAHVP58CUYXO3pdYiH0OZghqr+
         XfoQ7n/Rfw2Tbwhgm81HBCWdrEaQPfrgbIENv1XvMpClHx2TfN0SfGac8Fp4FiyB9R/s
         QpLQ==
Content-Disposition: inline
In-Reply-To: <20160417120747.GC21757-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Michal.

On Sun, Apr 17, 2016 at 08:07:48AM -0400, Michal Hocko wrote:
> On Fri 15-04-16 15:17:19, Tejun Heo wrote:
> > mem_cgroup_move_charge() invokes lru_add_drain_all() so that the pvec
> > pages can be moved too.  lru_add_drain_all() schedules and flushes
> > work items on system_wq which depends on being able to create new
> > kworkers to make forward progress.  Since 1ed1328792ff ("sched,
> > cgroup: replace signal_struct->group_rwsem with a global
> > percpu_rwsem"), a new task can't be created while in the cgroup
> > migration path and the described lru_add_drain_all() invocation can
> > easily lead to a deadlock.
> > 
> > Charge moving is best-effort and whether the pvec pages are migrated
> > or not doesn't really matter.  Don't call it during charge moving.
> > Eventually, we want to move the actual charge moving outside the
> > migration path.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Reported-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> I guess
> Debugged-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
> Reported-by: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>

Yeah, definitely.  Sorry about missing them.

> > Suggested-by: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Fixes: 1ed1328792ff ("sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem")
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> > Hello,
> > 
> > So, this deadlock seems pretty easy to trigger.  We'll make the charge
> > moving asynchronous eventually but let's not hold off fixing an
> > immediate problem.
> 
> Although this looks rather straightforward and it fixes the immediate
> problem I am little bit nervous about it. As already pointed out in
> other email mem_cgroup_move_charge still depends on mmap_sem for
> read and we might hit an even more subtle lockup if the current holder
> of the mmap_sem for write depends on the task creation (e.g. some of the
> direct reclaim path uses WQ which is really hard to rule out and I even
> think that some shrinkers do this).
> 
> I liked your proposal when mem_cgroup_move_charge would be called from a
> context which doesn't hold the problematic rwsem much more. Would that
> be too intrusive for the stable backport?

Yeah, I'm working on the fix but let's plug this one first as it seems
really easy to trigger.  I got a couple off-list reports (in and
outside fb) of this triggering.

Thanks.

-- 
tejun
