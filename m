From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Wed, 17 Apr 2019 14:56:29 +0200
Message-ID: <CAKfTPtAFB3gSZYJN1BcjU_XoY=Pfu2xtea+2MEw7FkVc3mwTSA@mail.gmail.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
 <20190410115907.GE19434@e105550-lin.cambridge.arm.com> <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=12mqcnOOt0vufAP9KYkBeANamYksA51AvFl5IrppBvM=;
        b=pfe/NuSFFYnWmFIRCbwz4QpMLdrJfNI0taBbC3izuZfSInrQ4v1yP9XL29Eihd5UvT
         JsdCq+sHbR6vXcdUULWvUIoiDbpnNewscpug90mCJERb9SpdPG1B7ca7QAq3ry0e+up8
         urgLrbPMgbNUIVBB8FsW+1X0GoAsvFZaevqYxkNzI/1wooLzpHPQQD202eQ/wHdihbyX
         W373q8NWTR3qNPzZECNdhdAokM3IK7RyEwA6+WIO4NfyXVNYUzc3AtDRzzQNo0b6jNAA
         2eSkf585DR5oIim3ACRcvlTQ7BuQ3RYTHcbxOYza9ycMJlQSyciLgqgLom1CflxcySBE
         daLA==
In-Reply-To: <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Song Liu <songliubraving@fb.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>, Kernel Team <Kernel-team@fb.com>

On Wed, 10 Apr 2019 at 21:43, Song Liu <songliubraving@fb.com> wrote:
>
> Hi Morten,
>
> > On Apr 10, 2019, at 4:59 AM, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> >

> >
> > The bit that isn't clear to me, is _why_ adding idle cycles helps your
> > workload. I'm not convinced that adding headroom gives any latency
> > improvements beyond watering down the impact of your side jobs. AFAIK,
>
> We think the latency improvements actually come from watering down the
> impact of side jobs. It is not just statistically improving average
> latency numbers, but also reduces resource contention caused by the side
> workload. I don't know whether it is from reducing contention of ALUs,
> memory bandwidth, CPU caches, or something else, but we saw reduced
> latencies when headroom is used.
>
> > the throttling mechanism effectively removes the throttled tasks from
> > the schedule according to a specific duty cycle. When the side job is
> > not throttled the main workload is experiencing the same latency issues
> > as before, but by dynamically tuning the side job throttling you can
> > achieve a better average latency. Am I missing something?
> >
> > Have you looked at your distribution of main job latency and tried to
> > compare with when throttling is active/not active?
>
> cfs_bandwidth adjusts allowed runtime for each task_group each period
> (configurable, 100ms by default). cpu.headroom logic applies gentle
> throttling, so that the side workload gets some runtime in every period.
> Therefore, if we look at time window equal to or bigger than 100ms, we
> don't really see "throttling active time" vs. "throttling inactive time".
>
> >
> > I'm wondering if the headroom solution is really the right solution for
> > your use-case or if what you are really after is something which is
> > lower priority than just setting the weight to 1. Something that
>
> The experiments show that, cpu.weight does proper work for priority: the
> main workload gets priority to use the CPU; while the side workload only
> fill the idle CPU. However, this is not sufficient, as the side workload
> creates big enough contention to impact the main workload.
>
> > (nearly) always gets pre-empted by your main job (SCHED_BATCH and
> > SCHED_IDLE might not be enough). If your main job consist
> > of lots of relatively short wake-ups things like the min_granularity
> > could have significant latency impact.
>
> cpu.headroom gives benefits in addition to optimizations in pre-empt
> side. By maintaining some idle time, fewer pre-empt actions are
> necessary, thus the main workload will get better latency.

I agree with Morten's proposal, SCHED_IDLE should help your latency
problem because side job will be directly preempted unlike normal cfs
task even lowest priority.
In addition to min_granularity, sched_period also has an impact on the
time that a task has to wait before preempting the running task. Also,
some sched_feature like GENTLE_FAIR_SLEEPERS can also impact the
latency of a task.

It would be nice to know if the latency problem comes from contention
on cache resources or if it's mainly because you main load waits
before running on a CPU

Regards,
Vincent

>
> Thanks,
> Song
>
> >
> > Morten
>
