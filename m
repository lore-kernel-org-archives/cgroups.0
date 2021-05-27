From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched/fair: Fix ascii art by relpacing tabs
Date: Thu, 27 May 2021 15:27:01 +0200
Message-ID: <CAKfTPtAi9XTyLGrCqU9A-SMoPVqd45N1Tcytqj1E6SMjb4ffxA@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-4-odin@uged.al>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bTuXJyS12cv4LuTitjmTblp9RTdGyOUhTUwwFkRbaxo=;
        b=AJ+au7Zh1JItYixxt8CVmhgXABNB1TBRD96nwd7v6HIk1hbvij2qP1pFVm9dQW94jL
         Ad4wt4EC6yIDuNF2XfRni4y26vgHLi65VqXMa4kw441X2uCb4/6NedBIi3R6UE6Dr0YQ
         i+DlbxK8dr8MslOOX4NfU1BnxVFRhhBcsgOFWiEyfygr8sK/0z+mfC5EfF0XpIUfbawa
         Y0CpFg3fi7lYBHz33pW2EHxumsJmH0cpyQXLZzzKmHR6cTE+Z0LBDAaT7eiEurMfzb9v
         lyzhV+WJ7fs0QfPh61Ug1KgIY4TYCAC++mEeYY8riXoNo20IO1NSnkT32rBzwsgu1QJO
         Y/eA==
In-Reply-To: <20210518125202.78658-4-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 18 May 2021 at 14:55, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org> wrote:
>
> When using something other than 8 spaces per tab, this ascii art
> makes not sense, and the reader might end up wondering what this
> advanced equation "is".

Documentation/process/coding-style.rst says to use 8 characters for
tab so we should not really consider other tab value

That being said the numerators and other parts of the equation use
spaces whereas denominators use tabs. so using space everywhere looks
good for me

Acked-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

>
> Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
> ---
>  kernel/sched/fair.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e7423d658389..c872e38ec32b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3142,7 +3142,7 @@ void reweight_task(struct task_struct *p, int prio)
>   *
>   *                     tg->weight * grq->load.weight
>   *   ge->load.weight = -----------------------------               (1)
> - *                       \Sum grq->load.weight
> + *                       \Sum grq->load.weight
>   *
>   * Now, because computing that sum is prohibitively expensive to compute (been
>   * there, done that) we approximate it with this average stuff. The average
> @@ -3156,7 +3156,7 @@ void reweight_task(struct task_struct *p, int prio)
>   *
>   *                     tg->weight * grq->avg.load_avg
>   *   ge->load.weight = ------------------------------              (3)
> - *                             tg->load_avg
> + *                             tg->load_avg
>   *
>   * Where: tg->load_avg ~= \Sum grq->avg.load_avg
>   *
> @@ -3172,7 +3172,7 @@ void reweight_task(struct task_struct *p, int prio)
>   *
>   *                     tg->weight * grq->load.weight
>   *   ge->load.weight = ----------------------------- = tg->weight   (4)
> - *                         grp->load.weight
> + *                         grp->load.weight
>   *
>   * That is, the sum collapses because all other CPUs are idle; the UP scenario.
>   *
> @@ -3191,7 +3191,7 @@ void reweight_task(struct task_struct *p, int prio)
>   *
>   *                     tg->weight * grq->load.weight
>   *   ge->load.weight = -----------------------------              (6)
> - *                             tg_load_avg'
> + *                             tg_load_avg'
>   *
>   * Where:
>   *
> --
> 2.31.1
>
