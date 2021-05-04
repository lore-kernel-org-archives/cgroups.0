From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/1] sched/fair: Fix unfairness caused by missing load decay
Date: Tue, 4 May 2021 09:14:12 +0200
Message-ID: <CAKfTPtDmYcr82o4V=Hovc3+Ht4bqhj_NNiSG2Zm+CfdpcAX9iA@mail.gmail.com>
References: <20210501141950.23622-1-odin@uged.al> <20210501141950.23622-2-odin@uged.al>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p3fJtS3ag0x38yekpEIajbjelrhY1TxoOI6xRz6q4h0=;
        b=X22FSap+30zbdRml4+tYesbBLG/84suRP4UdeSfYPFUkRa3ZYSTSQOqWGhvyXvRmSC
         VLzaPEjZHf8mG38W584jjFxx+/YHPKfcyNNvuLUuGjz6+1m+033WaKL5el5uRILdI+rK
         03R3c4XDIL330t+iSyz+dbwtEiw+KlLDbMyqJ4XcIhZFokhzlUaaaIrLmrqkPg6T3Zw3
         bZooEXZ/0jw2glT+mU1Sk+AxL8o3YaGO1L5HaQaoN8dhPAsMxs5v54riRDhwLgjosaLT
         1R7MX8jeh+D3N332K7Cmx0872bH5Uqgnvrp4SnMaRw9l88M2CphFgdXg8+qZqIOBYlLq
         WlKg==
In-Reply-To: <20210501141950.23622-2-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, 1 May 2021 at 16:22, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org> wrote:
>
> This fixes an issue where old load on a cfs_rq is not properly decayed,
> resulting in strange behavior where fairness can decrease drastically.
> Real workloads with equally weighted control groups have ended up
> getting a respective 99% and 1%(!!) of cpu time.
>
> When an idle task is attached to a cfs_rq by attaching a pid to a cgroup,
> the old load of the task is attached to the new cfs_rq and sched_entity by
> attach_entity_cfs_rq. If the task is then moved to another cpu (and
> therefore cfs_rq) before being enqueued/woken up, the load will be moved
> to cfs_rq->removed from the sched_entity. Such a move will happen when
> enforcing a cpuset on the task (eg. via a cgroup) that force it to move.
>
> The load will however not be removed from the task_group itself, making
> it look like there is a constant load on that cfs_rq. This causes the
> vruntime of tasks on other sibling cfs_rq's to increase faster than they
> are supposed to; causing severe fairness issues. If no other task is
> started on the given cfs_rq, and due to the cpuset it would not happen,
> this load would never be properly unloaded. With this patch the load
> will be properly removed inside update_blocked_averages. This also
> applies to tasks moved to the fair scheduling class and moved to another
> cpu, and this path will also fix that. For fork, the entity is queued
> right away, so this problem does not affect that.
>
> This applies to cases where the new process is the first in the cfs_rq,
> issue introduced 3d30544f0212 ("sched/fair: Apply more PELT fixes"), and
> when there has previously been load on the cgroup but the cgroup was
> removed from the leaflist due to having null PELT load, indroduced
> in 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing
> path").
>
> For a simple cgroup hierarchy (as seen below) with two equally weighted
> groups, that in theory should get 50/50 of cpu time each, it often leads
> to a load of 60/40 or 70/30.
>
> parent/
>   cg-1/
>     cpu.weight: 100
>     cpuset.cpus: 1
>   cg-2/
>     cpu.weight: 100
>     cpuset.cpus: 1
>
> If the hierarchy is deeper (as seen below), while keeping cg-1 and cg-2
> equally weighted, they should still get a 50/50 balance of cpu time.
> This however sometimes results in a balance of 10/90 or 1/99(!!) between
> the task groups.
>
> $ ps u -C stress
> USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       18568  1.1  0.0   3684   100 pts/12   R+   13:36   0:00 stress --cpu 1
> root       18580 99.3  0.0   3684   100 pts/12   R+   13:36   0:09 stress --cpu 1
>
> parent/
>   cg-1/
>     cpu.weight: 100
>     sub-group/
>       cpu.weight: 1
>       cpuset.cpus: 1
>   cg-2/
>     cpu.weight: 100
>     sub-group/
>       cpu.weight: 10000
>       cpuset.cpus: 1
>
> This can be reproduced by attaching an idle process to a cgroup and
> moving it to a given cpuset before it wakes up. The issue is evident in
> many (if not most) container runtimes, and has been reproduced
> with both crun and runc (and therefore docker and all its "derivatives"),
> and with both cgroup v1 and v2.
>
> Fixes: 3d30544f0212 ("sched/fair: Apply more PELT fixes")
> Fixes: 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing path")
> Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Reviewed-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks

> ---
>  kernel/sched/fair.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 794c2cb945f8..9e189727a457 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -10844,16 +10844,22 @@ static void propagate_entity_cfs_rq(struct sched_entity *se)
>  {
>         struct cfs_rq *cfs_rq;
>
> +       list_add_leaf_cfs_rq(cfs_rq_of(se));
> +
>         /* Start to propagate at parent */
>         se = se->parent;
>
>         for_each_sched_entity(se) {
>                 cfs_rq = cfs_rq_of(se);
>
> -               if (cfs_rq_throttled(cfs_rq))
> -                       break;
> +               if (!cfs_rq_throttled(cfs_rq)){
> +                       update_load_avg(cfs_rq, se, UPDATE_TG);
> +                       list_add_leaf_cfs_rq(cfs_rq);
> +                       continue;
> +               }
>
> -               update_load_avg(cfs_rq, se, UPDATE_TG);
> +               if (list_add_leaf_cfs_rq(cfs_rq))
> +                       break;
>         }
>  }
>  #else
> --
> 2.31.1
>
