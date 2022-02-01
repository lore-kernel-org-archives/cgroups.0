From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Tue, 1 Feb 2022 13:04:02 +0100
Message-ID: <YfkhsiWHzsyQSBfl@dhcp22.suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
 <YfFmxH1IXeegNOa9@dhcp22.suse.cz>
 <YfKHxKda7bGJmrLJ@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643717043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hrN9xPUO5EN6dEbkbWJxE1GMk/3AOPqzgOQALBnBLWQ=;
        b=oaBH06F3xwJLF4qBgQCvmjfMMK6tPM6NWcnZ9usdz2K1TZcbhSKMCQ8fuJp5hkqzrXGmtN
        aFjVM5efImZaoO24xax017Ow0cuV+W4i+wPJIJeP+vwnpwD1FaG/3ljfO6pYchd6D+2QKR
        yhFhjJfXgq6MIzYs5NAaVUHBIMCento=
Content-Disposition: inline
In-Reply-To: <YfKHxKda7bGJmrLJ-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu 27-01-22 12:53:40, Sebastian Andrzej Siewior wrote:
> On 2022-01-26 16:20:36 [+0100], Michal Hocko wrote:
> > I do not see any obvious problem with this patch. The code is ugly as
> > hell, though, but a large part of that is because of the weird locking
> > scheme we already have. I've had a look at 559271146efc ("mm/memcg:
> > optimize user context object stock access") and while I agree that it
> > makes sense to optimize for user context I do not really see any numbers
> > justifying the awkward locking scheme. Is this complexity really worth
> > it?
> 
> >From https://https://lkml.kernel.org/r/.kernel.org/all/YdX+INO9gQje6d0S-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org/:
> 
> |        Sandy Bridge   Haswell        Skylake         AMD-A8 7100    Zen2           ARM64
> |PREEMPT 5,123,896,822  5,215,055,226   5,077,611,590  6,012,287,874  6,234,674,489  20,000,000,100
> |IRQ     7,494,119,638  6,810,367,629  10,620,130,377  4,178,546,086  4,898,076,012  13,538,461,925
> 
> basically if PREEMPT < IRQ then preempt_disable() + enable() was cheaper
> than local_irq_save() + restore().
> 
> | Sandy Bridge
> |                  SERVER OPT   SERVER NO-OPT    PREEMPT OPT     PREEMPT NO-OPT
> | ALLOC/FREE    8,519,295,176   9,051,200,652    10,627,431,395  11,198,189,843
> | SD                5,309,768      29,253,976       129,102,317      40,681,909
> | ALLOC/FREE BH 9,996,704,330   8,927,026,031    11,680,149,900  11,139,356,465
> | SD               38,237,534      72,913,120        23,626,932     116,413,331
> 
> OPT is code as-is while "NO-OPT" is with the following patch which
> disables the optimisation (so it should be a revert of the optimisation
> commit).
> 
> ALLOC/FREE is kfree(kmalloc()).
> ALLOC/FREE BH is the same but in_interrupt() reported true.
> The numbers are are time needed in ns for 100,000,000 iterations of the
> free+alloc. SD is standard deviation.
> I also let the test run on a Zen2 box:
> 
> |                  SERVER OPT   SERVER NO-OPT   PREEMPT OPT      PREEMPT NO-OPT
> | ALLOC/FREE    8,126,735,313   8,751,307,383    9,822,927,142   10,045,105,425
> | SD              100,806,471      87,234,047       55,170,179       25,832,386
> | ALLOC/FREE BH 9,197,455,885   8,394,337,053   10,671,227,095    9,904,954,934
> | SD              155,223,919      57,800,997       47,529,496      105,260,566
> 
> Is this what you asked for?

Thanks! This gives us some picture from the microbenchmark POV. I was
more interested in some real life representative benchmarks. In other
words does the optimization from Weiman make any visible difference for
any real life workload?

Sorry, I know that this all is not really related to your work but if
the original optimization is solely based on artificial benchmarks then
I would rather drop it and also make your RT patchset easier.
-- 
Michal Hocko
SUSE Labs
