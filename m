From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 5/9] sched/fair: Take into account latency priority at wakeup
Date: Tue, 21 Feb 2023 15:25:36 +0100
Message-ID: <CAKfTPtAHuVFx=5w0p5DBShx42eEPCPXJ+DLc3z3_3yFv9jJWeA@mail.gmail.com>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-6-vincent.guittot@linaro.org> <Y/S+qrschy+N+QCQ@hirez.programming.kicks-ass.net>
 <Y/TSAivRWwm2LaPh@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TQtwfob29dO020xR+nsdt79jc/m4GepwvY587uLem6Q=;
        b=Qwe+BLDHlhASfFsqXwjp1sJ8Ka1JNGxR4jj5LwZCeb2yjfO7BvpBfDcIjgM3ln+WeI
         kpKHI1DZzTnzmJLWe2O5CUhvT7nXmB7aBsEet8Tdc8gzMKdbZj1IFOzZUCIWB2XlIZux
         dg9nOb+XQYteg6LRyLscYg9Azo4dMplNRPqA28Xugg4oJ6H6EDQpgbOVXcTy1hWC3uPp
         yGffdErgwCUTq/1l0Xc68O15BgW3vIFTF/CnWJJC4SmbTlMIGefK7SBUlzkQFO41CFPY
         sDMwd9U5R5r1sA88LcQruESocHnpGHkIUPYmpb6yi5t+0OVhz6uS50ACwxuZeG9aNPD1
         rzOA==
In-Reply-To: <Y/TSAivRWwm2LaPh-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Tue, 21 Feb 2023 at 15:15, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Tue, Feb 21, 2023 at 01:52:58PM +0100, Peter Zijlstra wrote:
> > On Fri, Jan 13, 2023 at 03:12:30PM +0100, Vincent Guittot wrote:
> >
> > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > index 6c61bde49152..38decae3e156 100644
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -568,6 +568,8 @@ struct sched_entity {
> > >     /* cached value of my_q->h_nr_running */
> > >     unsigned long                   runnable_weight;
> > >  #endif
> > > +   /* preemption offset in ns */
> > > +   long                            latency_offset;
> >
> > I wonder about the type here; does it make sense to have it depend on
> > the bitness; that is if s32 is big enough on 32bit then surely it is so
> > too on 64bit, and if not, then it should be unconditionally s64.
> >
>
> The cgroup patch has this as 'int'. I'm thinking we ought to be
> consistent :-)

Yes, good point
