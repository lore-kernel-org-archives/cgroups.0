From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: cgroups and SCHED_IDLE
Date: Mon, 29 Jul 2013 16:07:23 +0200
Message-ID: <20130729140723.GB22156@laptop.programming.kicks-ass.net>
References: <51CC7392.8080701@keymile.com>
 <51D139B4.8070407@keymile.com>
 <20130723155634.GD18458@mtj.dyndns.org>
 <51F65F3D.1080503@keymile.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F65F3D.1080503-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Holger Brunck <holger.brunck-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Germs, Frits (extern)" <Frits.Germs-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 29, 2013 at 02:25:33PM +0200, Holger Brunck wrote:
> On 07/23/2013 05:56 PM, Tejun Heo wrote:
> >> On 06/27/2013 07:17 PM, Holger Brunck wrote:
> >>
> >> On a single ARM CPU (kirkwood) I see the same confusing results similar to the
> >> results of the above powerpc example:
> >>
> >>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >>   232 root      20   0  1924  492  420 R 99.9  0.4   0:29.15 dd
> >>   234 root      20   0  1924  492  420 R  0.3  0.4   0:00.13 dd
> >>
> >> I doublechecked this on my local host x86_64 multicore and here it works fine
> >> even if I force both dd processes to run on the same CPU:
> >>
> >>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >> 32046 root      20   0  102m  516  432 R 49.4  0.0   0:32.49 dd
> >> 32049 root      20   0  102m  516  432 R 49.4  0.0   0:13.39 dd
> >>
> >> So either it's a problem for single CPUs or it's not allowed at all and works
> >> only by chance.
> > 
> > Can you please boot with maxcpus=1 and see whether that makes the
> > issue reproducible on x86?
> > 
> 
> I retested this with maxcpus=0 to disable SMP completely and it works, both
> processes share 50% of the CPU. But I have to admit that I currently have only a
> 3.4 setup for my x86_64 PC.
> 
> My setup for an arm kirkwood board and a board with a powerpc 8247 runs latest
> 3.10 kernel where I see the problem that one process is starving.  But the
> problem was already present in a 3.0.x kernel. So it seems to be a architecture
> dependent problem.

Does the below fix it?

---
Subject: sched: Ensure update_cfs_shares() is called for parents of continuously-running tasks
From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Date: Fri Jul 26 23:48:42 CEST 2013

We typically update a task_group's shares within the dequeue/enqueue
path.  However, continuously running tasks sharing a CPU are not
subject to these updates as they are only put/picked.  Unfortunately,
when we reverted f269ae046 (in 17bc14b7), we lost the augmenting
periodic update that was supposed to account for this; resulting in a
potential loss of fairness.

To fix this, re-introduce the explicit update in
update_cfs_rq_blocked_load() [called via entity_tick()].

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Reported-by: Max Hailperin <max-cgD0pOLU16z2fBVCVOL8/A@public.gmane.org>
Reviewed-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 kernel/sched/fair.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2032,6 +2032,7 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 	 */
 	update_entity_load_avg(curr, 1);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_cfs_shares(cfs_rq);
 
 #ifdef CONFIG_SCHED_HRTICK
 	/*
