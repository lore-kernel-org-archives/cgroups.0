From: Josh Don <joshdon@google.com>
Subject: Re: [PATCH 1/2] cgroup: add cpu.stat_percpu
Date: Tue, 11 Jan 2022 15:38:20 -0800
Message-ID: <CABk29NuGs_9uxgbv678W=BGGinZNiUHO5T57FHGbOG+HP-FT2g@mail.gmail.com>
References: <20220107234138.1765668-1-joshdon@google.com> <Yd189wHB2LJcK1Pv@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=95SGhqOm0RccSxJd03GJ+P09jT1muY8YMjYut8pvtqA=;
        b=oh8SsVjgy0iZTdFo6YzyNVUqT1q/qdQHbxYWVkHGO7CG64yrC1aFcOfJBL7xrSAlY+
         RVtvIjA/p2bWEp6apmi/M0sDnT83FLIUvq78MpV8sZy9vtQVY5tqeJrpJDEedtQvx9OZ
         MPw4nuikifUlivgQBD+7FjtvuZo7nc2CwEX8orNj2/Slu0GJ9e+69x01Jxsz2wlPaobq
         U/dF8X2zhedHCjjLSMl/qZhQ3HFa55fhGCf8qofKVe0BQLTWNijS9GIv/O/GHgBhOrHJ
         SgzyS93ujsrXUWxfD97cq7se0IRa35hwt980hfCuYJyr39pl1Jc8wlvTcVIIk5iE4kLR
         eGCg==
In-Reply-To: <Yd189wHB2LJcK1Pv@hirez.programming.kicks-ass.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, cgroups@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Jan 11, 2022 at 4:50 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Jan 07, 2022 at 03:41:37PM -0800, Josh Don wrote:
>
> > +     seq_puts(seq, "usage_usec");
> > +     for_each_possible_cpu(cpu) {
> > +             cached_bstat = per_cpu_ptr(&cached_percpu_stats, cpu);
> > +             val = cached_bstat->cputime.sum_exec_runtime;
> > +             do_div(val, NSEC_PER_USEC);
> > +             seq_printf(seq, " %llu", val);
> > +     }
> > +     seq_puts(seq, "\n");
> > +
> > +     seq_puts(seq, "user_usec");
> > +     for_each_possible_cpu(cpu) {
> > +             cached_bstat = per_cpu_ptr(&cached_percpu_stats, cpu);
> > +             val = cached_bstat->cputime.utime;
> > +             do_div(val, NSEC_PER_USEC);
> > +             seq_printf(seq, " %llu", val);
> > +     }
> > +     seq_puts(seq, "\n");
> > +
> > +     seq_puts(seq, "system_usec");
> > +     for_each_possible_cpu(cpu) {
> > +             cached_bstat = per_cpu_ptr(&cached_percpu_stats, cpu);
> > +             val = cached_bstat->cputime.stime;
> > +             do_div(val, NSEC_PER_USEC);
> > +             seq_printf(seq, " %llu", val);
> > +     }
> > +     seq_puts(seq, "\n");
>
> This is an anti-pattern; given enough CPUs (easy) this will trivially
> overflow the 1 page seq buffer.
>
> People are already struggling to fix existing ABI, lets not make the
> problem worse.

Is the concern there just the extra overhead from making multiple
trips into this handler and re-allocating the buffer until it is large
enough to take all the output? In that case, we could pre-allocate
with a size of the right order of magnitude, similar to /proc/stat.

Lack of per-cpu stats is a gap between cgroup v1 and v2, for which v2
can easily support this interface given that it already tracks the
stats percpu internally. I opted to dump them all in a single file
here, to match the consolidation that occurred from cpuacct->cpu.stat.
