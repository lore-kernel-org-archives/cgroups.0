From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 04/10] sched/core: Prevent race condition between
 cpuset and __sched_setscheduler()
Date: Wed, 14 Feb 2018 11:49:35 +0100
Message-ID: <20180214104935.GS12979@localhost.localdomain>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
 <1518553967-20656-5-git-send-email-mathieu.poirier@linaro.org>
 <20180214103639.GR12979@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214103639.GR12979-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 14/02/18 11:36, Juri Lelli wrote:
> Hi Mathieu,
> 
> On 13/02/18 13:32, Mathieu Poirier wrote:
> > No synchronisation mechanism exist between the cpuset subsystem and calls
> > to function __sched_setscheduler().  As such it is possible that new root
> > domains are created on the cpuset side while a deadline acceptance test
> > is carried out in __sched_setscheduler(), leading to a potential oversell
> > of CPU bandwidth.
> > 
> > By making available the cpuset_mutex to the core scheduler it is possible
> > to prevent situations such as the one described above from happening.
> > 
> > Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> 
> [...]
> 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index f727c3d0064c..0d8badcf1f0f 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4176,6 +4176,13 @@ static int __sched_setscheduler(struct task_struct *p,
> >  	}
> >  
> >  	/*
> > +	 * Make sure we don't race with the cpuset subsystem where root
> > +	 * domains can be rebuilt or modified while operations like DL
> > +	 * admission checks are carried out.
> > +	 */
> > +	cpuset_lock();
> > +
> > +	/*
> 
> Mmm, I'm afraid we can't do this. __sched_setscheduler might be called
> from interrupt contex by normalize_rt_tasks().

Maybe conditionally grabbing it if pi is true could do? I guess we don't
care much about domains when sysrq.
