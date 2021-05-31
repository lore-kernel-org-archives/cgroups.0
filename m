From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Mon, 31 May 2021 14:14:02 +0200
Message-ID: <CAKfTPtAwErfdVwdHFULGwbZj5D1axiB-A_AeY49R=aD9p6cezw@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-3-odin@uged.al>
 <CAKfTPtCiV5LMoXBQVdSsvNq-vurFVVd4aVWW-C=8Tza8uJTCjg@mail.gmail.com>
 <CAFpoUr0x=tgayPWYPORR+-h8gNhiE1t12Ko2o15Y8JwOCLp=yw@mail.gmail.com>
 <CAKfTPtA6AyL2f-KqHXecZrYKmZ9r9mT=Ks6BeNLjV9dfbSZJxQ@mail.gmail.com> <CAFpoUr04ziEzvNBJx0xKSuuEnapGzyABwaM-FU3TUaCZkQ4WPw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KWdRrmmQUUdShTYgF7N8YHkQMQeJcSbu2C2nHtMqGU=;
        b=rPbHFz8KHO8hT6NGvD8FDUegbYXzFW7CwBdAcvbOsVMGsFbruuLsU0t+/dIxYqnDg3
         AwU6BmbMSgVEjo10g4ffph+/MI0BxsmOoDQA0pnk5h+h9/NLd+KzdZnWBOdH3Q63JzN3
         qOjA/8KXwvqW03o+DutluDDTXhdFJrXEIY/KaLqieleaWDzq2lvmXjiriY6ta+yWbfkC
         IcfLKu4CUceHw5eiDkF4TEmXrpvgR1VPTkvVyVBOqbrPWuDOzUe32ws9zx+pBma5/mCn
         ygaMt6kRU1AOssL0eA1GxFLLmKh5mEzkxnpj6ZnaWMvBQm+NAWaBMH3lm3urLi+PRuvu
         6pJw==
In-Reply-To: <CAFpoUr04ziEzvNBJx0xKSuuEnapGzyABwaM-FU3TUaCZkQ4WPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, 29 May 2021 at 11:34, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org> wrote:
>
> Hi,
>
> > normally tg_load_avg_contrib should be null when cfs_rq_is_decayed()
>
> Yeah, I think that is an ok assumption of how it _should_ work (given
> the other patches in flight are merged).
>
> > The reason of this list is to ensure that the load of all cfs_rq are
> > periodically updated  as it is then used to share the runtime between
> > groups so we should keep to use the rule whenever possible.
>
> Yeah, right.
>
> > we probably need to keep (cfs_rq->nr_running >= 1) as we can have case
> > where tg_load_avg_contrib is null but a task is enqueued
>
> Yeah, there is probably a chance of enqueuing a task without any load,
> and then a parent gets throttled.
> So (cfs_rq->tg_load_avg_contrib || cfs_rq->nr_running) is probably the
> way to go if we want to avoid
> a new field. Will resend a patch with that instead.

Thanks

>
> In case the new field is the main issue with the original solution, we
> could also change the on_list int to have three modes like; NO, YES,
> THROTTLED/PAUSED, but that would require a bigger rewrite of the other
> logic, so probably outside the scope of this patch.
>
> Thanks
> Odin
