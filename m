From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Wed, 15 May 2019 12:18:37 +0200
Message-ID: <CAKfTPtDxhjh0LsjgTwKhMMtFqhyDW6qtU-=9K1p-fCR6YLjxCQ@mail.gmail.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
 <20190410115907.GE19434@e105550-lin.cambridge.arm.com> <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
 <CAKfTPtAFB3gSZYJN1BcjU_XoY=Pfu2xtea+2MEw7FkVc3mwTSA@mail.gmail.com>
 <E97E73F4-CE8C-4CD7-B6B6-5F63A4E881B1@fb.com> <F0A127DD-F9B6-4FBE-B9AD-8E8B00A7D676@fb.com>
 <CAKfTPtA_ouYCes9LnYn0quAKm273mi3vP-++GTBtYcQn07xc6Q@mail.gmail.com>
 <A62E5068-4A1E-44E3-99BB-02E98229C1E2@fb.com> <CAKfTPtAG3v=37wyLjzkNNK_6HdoMK6WO7AMYfa+G24rq2iyAfg@mail.gmail.com>
 <19AF6556-A2A2-435B-9358-CD22CF7BFD9F@fb.com> <2E7A1CDA-0384-474E-9011-5B209A1A58DF@fb.com>
 <0C1325C9-DE18-42C6-854D-64433ABD6FC3@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KFvZDl23y035feTSM2upuZ1LCAcrX8ykiQojg4IcAkQ=;
        b=Hkf6YYNNErzxvv5/SAw6jPm1nxRGPXBx754mOPzdNOiyOQtDOOhR/b5ZIKJPxxuFLC
         atqV38GudEL/shOEA7TbbpYUTd26wB3pnWTXAeqnSTxsgZXcBKo9I6rzgYNTbiGB5R6e
         v84ceroUvmWprEM6kcSAhw3vUXWV+fWFbxvbOQxRczzeZsKVzDjSROUMJtI0KaUkeW7w
         /LSmvZfRWIrs/vjBpnAiCFpikTqAP0lVUV97xoXaa/Jgi8A7KZGby9FV0Xs3Rf/oh593
         J94cwao/g2KFbLoPwOcq9gOe2K6UJgiTmLzWuYi/ajn3a+ufG080Vo2mnFa59dmQVZMU
         BQoQ==
In-Reply-To: <0C1325C9-DE18-42C6-854D-64433ABD6FC3@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Song Liu <songliubraving@fb.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>, Kernel Team <Kernel-team@fb.com>, viresh kumar <viresh.kumar@linaro.org>

Hi Song,

On Tue, 14 May 2019 at 22:58, Song Liu <songliubraving@fb.com> wrote:
>
> Hi Vincent,
>

[snip]

> >
> > Here are some more results with both Viresh's patch and the cpu.headroom
> > set. In these tests, the side job runs with SCHED_IDLE, so we get benefit
> > of Viresh's patch.
> >
> > We collected another metric here, average "cpu time" used by the requests.
> > We also presented "wall time" and "wall - cpu" time. "wall time" is the
> > same as "latency" in previous results. Basically, "wall time" includes cpu
> > time, scheduling latency, and time spent waiting for data (from data base,
> > memcache, etc.). We don't have good data that separates scheduling latency
> > and time spent waiting for data, so we present "wall - cpu" time, which is
> > the sum of the two. Time spent waiting for data should not change in these
> > tests, so changes in "wall - cpu" mostly comes from scheduling latency.
> > All the latency numbers are normalized based on the "wall time" of the
> > first row.
> >
> > side job | cpu.headroom |  cpu-idle | wall time | cpu time | wall - cpu
> > ------------------------------------------------------------------------
> > none    |     n/a      |    42.4%  |   1.00    |   0.31   |   0.69
> > ffmpeg   |       0      |    10.8%  |   1.17    |   0.38   |   0.79
> > ffmpeg   |     25%      |    22.8%  |   1.08    |   0.35   |   0.73
> >
> > From these results, we can see that Viresh's patch reduces the latency
> > overhead of the side job, from 42% (in previous results) to 17%. And
> > a 25% cpu.headroom further reduces the latency overhead to 8%.
> > cpu.headroom reduces time spent in "cpu time" and "wall - cpu" time,
> > which means cpu.headroom yields better IPC and lower scheduling latency.
> >
> > I think these data demonstrate that
> >
> >  1. Viresh's work is helpful in reducing scheduling latency introduced
> >     by SCHED_IDLE side jobs.
> >  2. cpu.headroom work provides mechanism to further reduce scheduling
> >     latency on top of Viresh's work.
> >
> > Therefore, the combination of the two work would give us mechanisms to
> > control the latency overhead of side workloads.
> >
> > @Vincent, do these data and analysis make sense from your point of view?
>
> Do you have further questions/concerns with this set?

Viresh's patchset takes into account CPU running only sched_idle task
only for the fast wakeup path. But nothing special is (yet) done for
the slow path or during idle load balance.
The histogram that you provided for "Fallback to sched-idle CPU for
better performance", shows that even if we have significantly reduced
the long wakeup latency, there are still some wakeup latency evenly
distributed in the range [16us-2msec]. Such values are most probably
because of sched_other task doesn't always preempt sched_idle task and
sometime waits for the next tick. This means that there are still
margin for improving the results with sched_idle without adding a new
knob.
The headroom knob forces cpus to be idle from time to time and the
scheduler fallbacks to the normal scheduling policy that tries to fill
idle CPU in this case. I'm still not convinced that most of the
increase of the latency increase is linked to contention when
accessing shared resources.

>
> As the data shown, scheduling latency is not the only resource of high
> latency here. In fact, with hyper threading and other shared system
> resources (cache, memory, etc.), side workload would always negatively
> impact the latency of the main workload. It is impossible to eliminate
> these impacts with scheduler optimizations. On the other hand,
> cpu.headroom provides mechanism to limit such impact.
>
> Optimization and protection are two sides of the problem. While we
> spend a lot of time optimizing the workload (so Viresh's work is really
> interesting for us), cpu.headroom works on the protection side. There
> are multiple reasons behind the high latencies. cpu.headroom provides
> universal protection against all these.
>
> With the protection of cpu.headroom, we can actually do optimizations
> more efficiently, as we can safely start with a high headroom, and
> then try to lower it.
>
> Please let me know your thoughts on this.
>
> Thanks,
> Song
>
>
>
