From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Fri, 28 May 2021 17:27:04 +0200
Message-ID: <CAKfTPtA6AyL2f-KqHXecZrYKmZ9r9mT=Ks6BeNLjV9dfbSZJxQ@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-3-odin@uged.al>
 <CAKfTPtCiV5LMoXBQVdSsvNq-vurFVVd4aVWW-C=8Tza8uJTCjg@mail.gmail.com> <CAFpoUr0x=tgayPWYPORR+-h8gNhiE1t12Ko2o15Y8JwOCLp=yw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OiBjppiA9FauptN85KvTMqQNccpsOQtc4MdQUyiisUU=;
        b=PrLpoLgQH2uoXy+cpWxi30XMNBXflM62zlDxEVygSH0AfIdt7LXr0IPyg2takB7LxZ
         wbT80B3Gm/NTVCarVTWzjI8vFG1NsiX18VTQxjzCpjsNWIb9l3cX3iTvcaDpFUOjWJUz
         i7WFw3zqqS2kUk4SviW7uWTrRLtn+quxOsjhBM6Y82WyRE1qrkNHTZcoJl0fWJz04+Ay
         302v/Ep7yZhWxdYTxzjkYSwHw5zYH5z46BlUY4Y+kFEsic2xIFbnBBAIPSZCpyzV8FSA
         ATB6Om4KQoEqmxxgph7e4cGgnrPcEX0RSStY7CCHKXlk/6NptQIQxKf13j3cNEf7YTTy
         hldg==
In-Reply-To: <CAFpoUr0x=tgayPWYPORR+-h8gNhiE1t12Ko2o15Y8JwOCLp=yw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, 28 May 2021 at 17:07, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org> wrote:
>
> Hi,
>
> > What would be the other condition in addition to the current one
> > :cfs_rq->nr_running >= 1 ?
>
> The condition is that if it has load, we should add it (I don't have
> 100% control on util_avg and runnable_avg tho.). Using
> "!cfs_rq_is_decayed()" is another way, but imo. that is a bit
> overkill.

normally tg_load_avg_contrib should be null when cfs_rq_is_decayed()

>
> > We need to add a cfs_rq in the list if it still contributes to the
> > tg->load_avg and the split of the share. Can't we add a condition for
> > this instead of adding a new field ?
>
> Yes, using cfs_rq->tg_load_avg_contrib as below would also work the
> same way. I still think being explicit that we insert it if we have
> removed it is cleaner in a way, as it makes it consistent with the
> other use of list_add_leaf_cfs_rq() and list_del_leaf_cfs_rq(), but

The reason of this list is to ensure that the load of all cfs_rq are
periodically updated  as it is then used to share the runtime between
groups so we should keep to use the rule whenever possible.

> that is about preference I guess. I do however think that using
> tg_load_avg_contrib will work just fine, as it should always be
> positive in case the cfs_rq has some load. I can resent v2 of this
> patch using this instead;
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ad7556f99b4a..969ae7f930f5 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4720,7 +4720,7 @@ static int tg_unthrottle_up(struct task_group
> *tg, void *data)
>                                              cfs_rq->throttled_clock_task;
>
>                 /* Add cfs_rq with already running entity in the list */
> -               if (cfs_rq->nr_running >= 1)
> +               if (cfs_rq->tg_load_avg_contrib)

we probably need to keep (cfs_rq->nr_running >= 1) as we can have case
where tg_load_avg_contrib is null but a task is enqueued

>                         list_add_leaf_cfs_rq(cfs_rq);
>         }
