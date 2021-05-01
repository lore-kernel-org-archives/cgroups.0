From: Odin Ugedal <odin-lVFEcm3hDZTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] sched/fair: Fix unfairness caused by missing load decay
Date: Sat, 1 May 2021 16:33:49 +0200
Message-ID: <CAFpoUr1D5URSODXKaOOHaBbmkNiNNbsCL1WCcEAWrdhJ8gXs8w@mail.gmail.com>
References: <20210425080902.11854-1-odin@uged.al> <20210425080902.11854-2-odin@uged.al>
 <20210427142611.GA22056@vingu-book> <CAFpoUr1KOvLSUoUac8MMTD+TREDWmDpeku950U=_p-oBDE4Avw@mail.gmail.com>
 <CAKfTPtCtt9V69AvkJTuMDRPJXGPboFsnSmwLM5RExnU2h5stSw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35m+0g71EHp5JplTjNeuJu6NM0nqBbYx65WIaAvO81I=;
        b=Td0Qom2EuAirsDIjUOJ5NTSXMc6m+HoFdvNW0EXDUhwC96V38cn6E5O/bRpDdyBQnm
         uiWzjyJZoMTN5y1XpAumatFyMlf7QmF72mHuNAmk/HIh5ZmlSpeje2HpMJGXRvjt4OML
         3bCPXB3bH4JnS70m0uLbFi6wI2vjBPOvcWx7de8Yc93nEhFkZ5IlskiqazIkNCPEwtOt
         5PLVCbJhez74FqLCbWYhISCvuSpEtTFSJ0VznD7pRztIrVh/AVHnh1X7sqfPsRsO1IVG
         w8Q/muGzvFG1YpIFxJZbB4ekUm+LTxM4o4z+glwtB+o5YhYtxqbane1csM1IRJ2tB7Sf
         lwTg==
In-Reply-To: <CAKfTPtCtt9V69AvkJTuMDRPJXGPboFsnSmwLM5RExnU2h5stSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

ons. 28. apr. 2021 kl. 17:36 skrev Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>:
> You can keep both fixes tags

ACK

> If the cfs_rq is already in the list list_add_leaf_cfs_rq() will exit
> early but if it's not, we don't have to make sure that the whole
> branch in the list

Yeah, thats right. Calling list_add_leaf_cfs_rq once "too much" doesnt
hurt after all.

> In fact, we can break as soon as list_add_leaf_cfs_rq() and
> cfs_rq_throttled() return true

ACK, that makes sense.

> When a cfs_rq is throttled, it is not accounted in its parent anymore
> so we don't have to update and propagate the load down.

Okay. Still need to wrap my head around this a bit more I guess. I
have looked a bit around, and there
is actually a similar issue as "this one" for the case when a
throttled cgroup is "moved" via cpuset. It is however waaay
harder to reproduce, but it is doable, and it _will_ happen in real
life systems if the timing is "correct". I will dig deeper
and finish the patch for that case some time next week (hopefully). I
think that however deserve a separate patchset,
so I will come back with that later.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 33b1ee31ae0f..18441ce7316c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -11026,10 +11026,10 @@ static void propagate_entity_cfs_rq(struct sched_entity *se)
>         for_each_sched_entity(se) {
>                 cfs_rq = cfs_rq_of(se);
>
> -               if (cfs_rq_throttled(cfs_rq))
> -                       break;
> +               if (!cfs_rq_throttled(cfs_rq))
> +                       update_load_avg(cfs_rq, se, UPDATE_TG);
>
> -               update_load_avg(cfs_rq, se, UPDATE_TG);
> +               list_add_leaf_cfs_rq(cfs_rq);
>         }
> }

Sent a v2 with something like this now; that exit if
(list_add_leaf_cfs_rq(cfs_rq) && throttled). Since this loop start at
the parent of
the cfs_rq of the supplied se, I added a list_add_leaf_cfs_rq to the
top in order to insert the leaf cfs_rq as well.

Thanks
Odin
