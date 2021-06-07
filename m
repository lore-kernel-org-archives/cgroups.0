From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Mon, 7 Jun 2021 15:29:40 +0200
Message-ID: <CAKfTPtDHrD_QGoLeUkR0ALRakWH+KOopHZk=29fyi-oonerd9g@mail.gmail.com>
References: <20210604102314.697749-1-odin@uged.al>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7pMeBbJnHe0dT56aBjX+SG8tgBkU1RFs5WrTELGr21w=;
        b=S/bfEag7I89zOTS/86dOO6jC4cob1/NUn22kCuKmb2B1z8hvctiuJzA9rY/gEG4b46
         uCDehsvTljcTN45kv7qc+PiPfHVPLL33aKkCVYW/hhbHPi2NrIb3HgmuwO+aZyB5ziJm
         vrMfArzkFmt32vDk+p2RNUzAwaFvWldu76G9Bf3//0WUXjZdOOrGYavx+pit0/8fi/PM
         12vAMOuBoy/HAMNETrGn8p//nNwKorc6LgGQxYNygMcA4kbAytF8+YXmaYqzSgKFTnKs
         NVw2ENxozeJigZymVLo63ReaHlbvhwZDm9gfh2YrzMoB/olyKutSLj7kYbGLimIy1Y6o
         90lQ==
In-Reply-To: <20210604102314.697749-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, 4 Jun 2021 at 12:26, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org> wrote:
>
> This fixes an issue where fairness is decreased since cfs_rq's can
> end up not being decayed properly. For two sibling control groups with
> the same priority, this can often lead to a load ratio of 99/1 (!!).
>
> This happen because when a cfs_rq is throttled, all the descendant cfs_rq's
> will be removed from the leaf list. When they initial cfs_rq is
> unthrottled, it will currently only re add descendant cfs_rq's if they
> have one or more entities enqueued. This is not a perfect heuristic.
>
> Instead, we insert all cfs_rq's that contain one or more enqueued
> entities, or it its load is not completely decayed.
>
> Can often lead to situations like this for equally weighted control
> groups:
>
> $ ps u -C stress
> USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       10009 88.8  0.0   3676   100 pts/1    R+   11:04   0:13 stress --cpu 1
> root       10023  3.0  0.0   3676   104 pts/1    R+   11:04   0:00 stress --cpu 1
>
> Fixes: 31bc6aeaab1d ("sched/fair: Optimize update_blocked_averages()")
> Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
> ---
> Changes since v1:
>  - Replaced cfs_rq field with using tg_load_avg_contrib
>  - Went from 3 to 1 patches; one is merged and one is replaced
>    by a new patchset.
> Changes since v2:
>  - Use !cfs_rq_is_decayed() instead of tg_load_avg_contrib
>  - Moved cfs_rq_is_decayed to above its new use
> Changes since v3:
>  - (hopefully) Fix config for !CONFIG_SMP
>  kernel/sched/fair.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 794c2cb945f8..eec32f214ff8 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -712,6 +712,25 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>         return calc_delta_fair(sched_slice(cfs_rq, se), se);
>  }
>
> +static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)

It's not the best place for this function:
- pelt.h header file is included below but cfs_rq_is_decayed() uses PELT
- CONFIG_SMP is already defined few lines below
- cfs_rq_is_decayed() is only used with CONFIG_FAIR_GROUP_SCHED and
now with CONFIG_CFS_BANDWIDTH which depends on the former

so moving cfs_rq_is_decayed() just above update_tg_load_avg() with
other functions used for propagating and updating tg load seems a
better place

> +{
> +       if (cfs_rq->load.weight)
> +               return false;
> +
> +#ifdef CONFIG_SMP
> +       if (cfs_rq->avg.load_sum)
> +               return false;
> +
> +       if (cfs_rq->avg.util_sum)
> +               return false;
> +
> +       if (cfs_rq->avg.runnable_sum)
> +               return false;
> +#endif
> +
> +       return true;
> +}
> +
>  #include "pelt.h"
>  #ifdef CONFIG_SMP
>
> @@ -4719,8 +4738,8 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
>                 cfs_rq->throttled_clock_task_time += rq_clock_task(rq) -
>                                              cfs_rq->throttled_clock_task;
>
> -               /* Add cfs_rq with already running entity in the list */
> -               if (cfs_rq->nr_running >= 1)
> +               /* Add cfs_rq with load or one or more already running entities to the list */
> +               if (!cfs_rq_is_decayed(cfs_rq) || cfs_rq->nr_running)
>                         list_add_leaf_cfs_rq(cfs_rq);
>         }
>
> @@ -7895,23 +7914,6 @@ static bool __update_blocked_others(struct rq *rq, bool *done)
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>
> -static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
> -{
> -       if (cfs_rq->load.weight)
> -               return false;
> -
> -       if (cfs_rq->avg.load_sum)
> -               return false;
> -
> -       if (cfs_rq->avg.util_sum)
> -               return false;
> -
> -       if (cfs_rq->avg.runnable_sum)
> -               return false;
> -
> -       return true;
> -}
> -
>  static bool __update_blocked_fair(struct rq *rq, bool *done)
>  {
>         struct cfs_rq *cfs_rq, *pos;
> --
> 2.31.1
>
