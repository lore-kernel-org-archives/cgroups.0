From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Thu, 3 Feb 2022 10:54:07 +0100
Message-ID: <YfumP3u1VCjKHE3b@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
 <YfFmxH1IXeegNOa9@dhcp22.suse.cz>
 <YfKHxKda7bGJmrLJ@linutronix.de>
 <YfkhsiWHzsyQSBfl@dhcp22.suse.cz>
 <Yfkjjamj09lZn4sA@linutronix.de>
 <YflR3/RuGjYuQZPH@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643882048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zdELBxlfBs+RZUwmCEVQd1bUq7O2YyUtK61hoTYBgqg=;
        b=IfJmhtbwX2obrfSDNgct9EwtFtBmqz0EJ887+lW17EFlNEbw+vhQfGZE7FhV6/SGy7QM5y
        jN8X1B1nSRWlFl2F1nl/m7JV+oHwNJN3XJPKTBiMK9GHPNck1ClVPtujVKIE4kG6nkDNc5
        iR9T1SAXjdHCJs00P4hnfqzN3HM+B8KpAcRxcvEjSUpvTiElVCMbjf+Zkeeg1VoHITV23o
        k4v+9jexPWzxbfh0stdGq5DJ08xhxlYJImY+ynQ8FqSjXXZ/JQNGDm027hjl9uvDSo6Dnc
        tNTU4mt+wi1dZhUDMPhkMbP9VoRBVmt+0iRyyXRBf8zTjWvZHzQrKkFYxjjzVw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643882048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zdELBxlfBs+RZUwmCEVQd1bUq7O2YyUtK61hoTYBgqg=;
        b=n+xCuimFf8XggWNU87WmjzdNQ0+gYt/+hK2eC85G0DeT2CAyAiati4G2XEbobv1EQ061DI
        LmAFwAbmAOjC6SAw==
Content-Disposition: inline
In-Reply-To: <YflR3/RuGjYuQZPH-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 2022-02-01 16:29:35 [+0100], Michal Hocko wrote:
> > > Sorry, I know that this all is not really related to your work but if
> > > the original optimization is solely based on artificial benchmarks then
> > > I would rather drop it and also make your RT patchset easier.
> > 
> > Do you have any real-world benchmark in mind? Like something that is
> > already used for testing/ benchmarking and would fit here?
> 
> Anything that even remotely resembles a real allocation heavy workload.

So I figured out that build the kernel as user triggers the allocation
path in_task() and in_interrupt(). I booted a PREEMPT_NONE kernel and
run "perf stat -r 5 b.sh" where b.sh unpacks a kernel and runs a
allmodconfig build on /dev/shm. The slow disk should not be a problem.

With the optimisation:
|  Performance counter stats for './b.sh' (5 runs):
| 
|       43.367.405,59 msec task-clock                #   30,901 CPUs utilized            ( +-  0,01% )
|           7.393.238      context-switches          #  170,499 /sec                     ( +-  0,13% )
|             832.364      cpu-migrations            #   19,196 /sec                     ( +-  0,15% )
|         625.235.644      page-faults               #   14,419 K/sec                    ( +-  0,00% )
| 103.822.081.026.160      cycles                    #    2,394 GHz                      ( +-  0,01% )
|  75.392.684.840.822      stalled-cycles-frontend   #   72,63% frontend cycles idle     ( +-  0,02% )
|  54.971.177.787.990      stalled-cycles-backend    #   52,95% backend cycles idle      ( +-  0,02% )
|  69.543.893.308.966      instructions              #    0,67  insn per cycle
|                                                    #    1,08  stalled cycles per insn  ( +-  0,00% )
|  14.585.269.354.314      branches                  #  336,357 M/sec                    ( +-  0,00% )
|     558.029.270.966      branch-misses             #    3,83% of all branches          ( +-  0,01% )
|  
|            1403,441 +- 0,466 seconds time elapsed  ( +-  0,03% )


With the optimisation disabled:
|  Performance counter stats for './b.sh' (5 runs):
| 
|       43.354.742,31 msec task-clock                #   30,869 CPUs utilized            ( +-  0,01% )
|           7.394.210      context-switches          #  170,601 /sec                     ( +-  0,06% )
|             842.835      cpu-migrations            #   19,446 /sec                     ( +-  0,63% )
|         625.242.341      page-faults               #   14,426 K/sec                    ( +-  0,00% )
| 103.791.714.272.978      cycles                    #    2,395 GHz                      ( +-  0,01% )
|  75.369.652.256.425      stalled-cycles-frontend   #   72,64% frontend cycles idle     ( +-  0,01% )
|  54.947.610.706.450      stalled-cycles-backend    #   52,96% backend cycles idle      ( +-  0,01% )
|  69.529.388.440.691      instructions              #    0,67  insn per cycle
|                                                    #    1,08  stalled cycles per insn  ( +-  0,01% )
|  14.584.515.016.870      branches                  #  336,497 M/sec                    ( +-  0,00% )
|     557.716.885.609      branch-misses             #    3,82% of all branches          ( +-  0,02% )
|  
|             1404,47 +- 1,05 seconds time elapsed  ( +-  0,08% )

I'm still open to a more specific test ;)

Sebastian
