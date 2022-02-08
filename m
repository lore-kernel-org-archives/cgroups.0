From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Tue, 8 Feb 2022 09:58:27 -0800
Message-ID: <CALvZod7yovQ5OTWr=k_eiEBVb1LTRvPkbsY8joAtyigQnvBUww@mail.gmail.com>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de> <YfFmxH1IXeegNOa9@dhcp22.suse.cz>
 <YfKHxKda7bGJmrLJ@linutronix.de> <YfkhsiWHzsyQSBfl@dhcp22.suse.cz>
 <Yfkjjamj09lZn4sA@linutronix.de> <YflR3/RuGjYuQZPH@dhcp22.suse.cz>
 <YfumP3u1VCjKHE3b@linutronix.de> <Yfup9THPcSIPDSoH@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+CQgr5ve9zRzrNvBukJhKnL+pLaCQfJXdaqimLxBtNw=;
        b=E2UoFvQVzm+7bHzoMVzVa5ubhrCgFht99UH8rY/REMe83oGfWQbtPaijzy5V1htQAM
         BkkNX7I3Loju1qPFQ5SKiuN5gRGm//MXKuPFU/+lAiqJjC612uxlmflrzBxtp0cWwYp0
         0Kn0O12jqVtQTdqiqNJsAs/kerC4f1FDmDdBVHLKxxjOtW327uXZ7o+HvwuC70xxjlJl
         gSSvHFw3+VHuGjkG/d+Df6+eQ0ecY2ISbQ4wyFZX0Fpw5/u3TLH17KBnUcAF9XaLd/bl
         if5ThueUvsEl4EwY0MmqrEAzcqWRBNvYY6S6rsWOgW3CuGWUHJPk569Mef72P68WBent
         D8HA==
In-Reply-To: <Yfup9THPcSIPDSoH-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Feb 3, 2022 at 2:10 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 03-02-22 10:54:07, Sebastian Andrzej Siewior wrote:
> > On 2022-02-01 16:29:35 [+0100], Michal Hocko wrote:
> > > > > Sorry, I know that this all is not really related to your work but if
> > > > > the original optimization is solely based on artificial benchmarks then
> > > > > I would rather drop it and also make your RT patchset easier.
> > > >
> > > > Do you have any real-world benchmark in mind? Like something that is
> > > > already used for testing/ benchmarking and would fit here?
> > >
> > > Anything that even remotely resembles a real allocation heavy workload.
> >
> > So I figured out that build the kernel as user triggers the allocation
> > path in_task() and in_interrupt(). I booted a PREEMPT_NONE kernel and
> > run "perf stat -r 5 b.sh" where b.sh unpacks a kernel and runs a
> > allmodconfig build on /dev/shm. The slow disk should not be a problem.
> >
> > With the optimisation:
> > |  Performance counter stats for './b.sh' (5 runs):
> > |
> > |       43.367.405,59 msec task-clock                #   30,901 CPUs utilized            ( +-  0,01% )
> > |           7.393.238      context-switches          #  170,499 /sec                     ( +-  0,13% )
> > |             832.364      cpu-migrations            #   19,196 /sec                     ( +-  0,15% )
> > |         625.235.644      page-faults               #   14,419 K/sec                    ( +-  0,00% )
> > | 103.822.081.026.160      cycles                    #    2,394 GHz                      ( +-  0,01% )
> > |  75.392.684.840.822      stalled-cycles-frontend   #   72,63% frontend cycles idle     ( +-  0,02% )
> > |  54.971.177.787.990      stalled-cycles-backend    #   52,95% backend cycles idle      ( +-  0,02% )
> > |  69.543.893.308.966      instructions              #    0,67  insn per cycle
> > |                                                    #    1,08  stalled cycles per insn  ( +-  0,00% )
> > |  14.585.269.354.314      branches                  #  336,357 M/sec                    ( +-  0,00% )
> > |     558.029.270.966      branch-misses             #    3,83% of all branches          ( +-  0,01% )
> > |
> > |            1403,441 +- 0,466 seconds time elapsed  ( +-  0,03% )
> >
> >
> > With the optimisation disabled:
> > |  Performance counter stats for './b.sh' (5 runs):
> > |
> > |       43.354.742,31 msec task-clock                #   30,869 CPUs utilized            ( +-  0,01% )
> > |           7.394.210      context-switches          #  170,601 /sec                     ( +-  0,06% )
> > |             842.835      cpu-migrations            #   19,446 /sec                     ( +-  0,63% )
> > |         625.242.341      page-faults               #   14,426 K/sec                    ( +-  0,00% )
> > | 103.791.714.272.978      cycles                    #    2,395 GHz                      ( +-  0,01% )
> > |  75.369.652.256.425      stalled-cycles-frontend   #   72,64% frontend cycles idle     ( +-  0,01% )
> > |  54.947.610.706.450      stalled-cycles-backend    #   52,96% backend cycles idle      ( +-  0,01% )
> > |  69.529.388.440.691      instructions              #    0,67  insn per cycle
> > |                                                    #    1,08  stalled cycles per insn  ( +-  0,01% )
> > |  14.584.515.016.870      branches                  #  336,497 M/sec                    ( +-  0,00% )
> > |     557.716.885.609      branch-misses             #    3,82% of all branches          ( +-  0,02% )
> > |
> > |             1404,47 +- 1,05 seconds time elapsed  ( +-  0,08% )
> >
> > I'm still open to a more specific test ;)
>
> Thanks for this test. I do assume that both have been run inside a
> non-root memcg.
>
> Weiman, what was the original motivation for 559271146efc0? Because as
> this RT patch shows it makes future changes much more complex and I
> would prefer a simpler and easier to maintain code than some micro
> optimizations that do not have any visible effect on real workloads.

commit 559271146efc0 is a part of patch series "mm/memcg: Reduce
kmemcache memory accounting overhead". For perf numbers you can see
the cover letter in the commit fdbcb2a6d677 ("mm/memcg: move
mod_objcg_state() to memcontrol.c").

BTW I am onboard with preferring simpler code over complicated optimized code.
