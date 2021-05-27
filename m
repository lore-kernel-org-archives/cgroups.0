From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] sched/fair: keep load_avg and load_sum synced
Date: Thu, 27 May 2021 15:18:35 +0200
Message-ID: <CAKfTPtAE6DJTwxZ996BJoUJF++fFHdFk-C2bpUQ8aG0NQusApA@mail.gmail.com>
References: <20210527122916.27683-1-vincent.guittot@linaro.org>
 <20210527122916.27683-2-vincent.guittot@linaro.org> <YK+ZGlfPxK3JCySS@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jfylii+y+Ojxu7E7KT+8vH0OFzsUpSqBPwQ/qgziQBk=;
        b=W3fRkD3lLeYB/4+AHVLLqJf7qv0yMm9bwfQ+wjR+/HZVP4sihm1Ai/PRMvuH//POO/
         3eEKuOhr2VmDl6z2lCWdqJ5S/mXYn/reSSul4695W8nwMpqeb9UVE5sr/VXiZ7PR+rmk
         2N/liwj7qqiWtfKyE608rYU527j3V0yQjbiaCIlvH7JbO7ZTgORZghg3HHd9JIbLutux
         1hBgoiG4wCKvY9r2iuYFvE4LJOzBHSZZM4eXK2vUhmxXhn9tFGS/HnKh3YyN/AwYiKjp
         kNf/iL+jUEWu7lCGgAAIx12TY8GQMYTavD06/kB5ULiZmHKxJ3HJ7F/168syCUtuuQkj
         NnqA==
In-Reply-To: <YK+ZGlfPxK3JCySS-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, 27 May 2021 at 15:06, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Thu, May 27, 2021 at 02:29:15PM +0200, Vincent Guittot wrote:
>
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -3509,7 +3509,8 @@ update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq
> >       se->avg.load_sum = runnable_sum;
> >       se->avg.load_avg = load_avg;
> >       add_positive(&cfs_rq->avg.load_avg, delta_avg);
> > -     add_positive(&cfs_rq->avg.load_sum, delta_sum);
> > +     cfs_rq->avg.load_sum = cfs_rq->avg.load_avg * divider;
>
> If I'm not mistaken, this makes delta_sum unused, so we can remove it
> entirely, see below.

yes, you're right

>
> > +
>
> This extra blank space, we really need that? :-)
>
> >  }
>
> ---
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 161b92aa1c79..2b99e687fe7a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3453,10 +3453,9 @@ update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cf
>  static inline void
>  update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
>  {
> -       long delta_avg, running_sum, runnable_sum = gcfs_rq->prop_runnable_sum;
> +       long running_sum, runnable_sum = gcfs_rq->prop_runnable_sum;
>         unsigned long load_avg;
>         u64 load_sum = 0;
> -       s64 delta_sum;
>         u32 divider;
>
>         if (!runnable_sum)
> @@ -3503,13 +3502,11 @@ update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq
>         load_sum = (s64)se_weight(se) * runnable_sum;
>         load_avg = div_s64(load_sum, divider);
>
> -       delta_sum = load_sum - (s64)se_weight(se) * se->avg.load_sum;
> -       delta_avg = load_avg - se->avg.load_avg;
> -
>         se->avg.load_sum = runnable_sum;
>         se->avg.load_avg = load_avg;
> -       add_positive(&cfs_rq->avg.load_avg, delta_avg);
> -       add_positive(&cfs_rq->avg.load_sum, delta_sum);
> +
> +       add_positive(&cfs_rq->avg.load_avg, (long)(load_avg - se->avg.load_avg));

you have to keep:
delta_avg = load_avg - se->avg.load_avg
or move se->avg.load_avg = load_avg after
add_positive(&cfs_rq->avg.load_avg, ..);
because otherwise (load_avg - se->avg.load_avg) == 0


> +       cfs_rq->avg.load_sum = cfs_rq->avg.load_avg * divider;
>  }
>
>  static inline void add_tg_cfs_propagate(struct cfs_rq *cfs_rq, long runnable_sum)
