From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: RFC: cgroups aware proc
Date: Tue, 14 Jan 2014 11:05:41 +0100
Message-ID: <20140114100541.GS7572@laptop.programming.kicks-ass.net>
References: <52D35CD0.9070602@huawei.com>
 <52D41316.5080508@yuhu.biz>
 <20140113171238.GS31570@twins.programming.kicks-ass.net>
 <52D48BA6.2080701@yuhu.biz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52D48BA6.2080701-NV7Lj0SOnH0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Cc: lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 14, 2014 at 02:58:14AM +0200, Marian Marinov wrote:
> On 01/13/2014 07:12 PM, Peter Zijlstra wrote:
> >On Mon, Jan 13, 2014 at 06:23:50PM +0200, Marian Marinov wrote:
> >>Hello Peter,
> >>
> >>I need help with the scheduler.
> >>
> >>I'm currently trying to patch the /proc/loadavg to show the load that is
> >>only related to the processes from the current cgroup.
> >>
> >>I looked trough the code and I was hoping that tsk->sched_task_group->cfs_rq
> >>struct will give me the needed information, but unfortunately for me, it did
> >>not.
> >>
> >>Can you advise me, how to approach this problem?
> >
> >Yeah, don't :-) Really, loadavg is a stupid metric.
> 
> Yes... stupid, but unfortunately everyone is looking at it :(
> 
> >
> >>I'm totally new to the scheduler code.
> >
> >Luckily you won't actually have to touch much of it. Most of the actual
> >loadavg code lives in the first ~400 lines of kernel/sched/proc.c, read
> >and weep. Its one of the best documented bits around.
> 
> I looked trough it but I don't understand how to introduce the per cgroup calculation.
> 
> I looked trough the headers and found the following, which is already implemented.
> 
>   task->sched_task_group->load_avg
>   task->sched_task_group->cfs_rq->load_avg
>   task->sched_task_group->cfs_rq->load.weight
>   task->sched_task_group->cfs_rq->runnable_load_avg
> 
> Unfortunately there is almost no documentation for these elements of the cfs_rq and task_group structs.
> 
> It seams to me that part of the per task group loadavg code is already present.

No, those are actual load metrics and completely unrelated to loadavg.

Loadavg requires per-cgroup-per-cpu variants of nr_running and
nr_uninterruptible.

Those are the only metrics used in kernel/sched/proc.c for loadavg.
