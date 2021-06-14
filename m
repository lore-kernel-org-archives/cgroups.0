From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH v5] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Mon, 14 Jun 2021 14:01:55 +0200
Message-ID: <CAKfTPtCMqZZnbwfhw0gz1Bne4j7PcG-Ma02a=gmcGbjY1bHk=g@mail.gmail.com>
References: <20210612112815.61678-1-odin@uged.al>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H+lA9naaKsakWVrnjr3YXHM+z9q5nmlt/676DWB5bB0=;
        b=BEXyZr+Mqcby06OU4xPayd0j5B1e+t+U8QVogAiv1eM8rGXa4EhjdAscNmJXLAnDH6
         fQcREIFx0bsNQqvqWU2OJ9SIRCrnbWuaNylL69JF6DvXhGuDQ732KE3ZK9nmKofx3h9t
         Ch7i0UN9fGhyInjb+Gx48+UROjgrsdvFc/R25WN6XVbKGUNWwkFxb9uDEK/+j2Q/CGON
         lesYdJSmMMA2UD75Q/Sq+GJ7ytjr7OjCMJWJB3BP9xMTsa6TvYFlnptHOWZLf/wx3o+P
         WA1FJOI0vU9hS1OBce+QAnJg5G4G+aLVRXegSxlu/hXMgk5MIgI9fGygMciMJOa4/Sis
         lCHQ==
In-Reply-To: <20210612112815.61678-1-odin@uged.al>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin@uged.al>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, 12 Jun 2021 at 13:31, Odin Ugedal <odin@uged.al> wrote:
>
> This fixes an issue where fairness is decreased since cfs_rq's can
> end up not being decayed properly. For two sibling control groups with
> the same priority, this can often lead to a load ratio of 99/1 (!!).
>
> This happen because when a cfs_rq is throttled, all the descendant cfs_rq's

s/happen/happens/

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
> Signed-off-by: Odin Ugedal <odin@uged.al>

minor typo in the commit message otherwise

Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>

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
> Changes since v4:
>  - Move cfs_rq_is_decayed again
>
>  kernel/sched/fair.c | 39 ++++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 19 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 794c2cb945f8..c48d1d409b20 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3283,6 +3283,24 @@ static inline void cfs_rq_util_change(struct cfs_rq *cfs_rq, int flags)
>
>  #ifdef CONFIG_SMP
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> +
> +static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
> +{
> +       if (cfs_rq->load.weight)
> +               return false;
> +
> +       if (cfs_rq->avg.load_sum)
> +               return false;
> +
> +       if (cfs_rq->avg.util_sum)
> +               return false;
> +
> +       if (cfs_rq->avg.runnable_sum)
> +               return false;
> +
> +       return true;
> +}
> +
>  /**
>   * update_tg_load_avg - update the tg's load avg
>   * @cfs_rq: the cfs_rq whose avg changed
> @@ -4719,8 +4737,8 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
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
> @@ -7895,23 +7913,6 @@ static bool __update_blocked_others(struct rq *rq, bool *done)
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
