From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Fri, 24 Mar 2023 15:54:50 -1000
Message-ID: <ZB5UalkjGngcBDEJ@slm.duckdns.org>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com>
 <ZBz/V5a7/6PZeM7S@slm.duckdns.org>
 <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679709292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rZD4yeAZYRZA0h6Sa2287K8z27FVJ3yK8JKUr0lQOXE=;
        b=mC2DwxizegktL3ml5ZkgW4iCveIfhyJtMgfrimZIa1j1Y8YW2I4IZ0tdvhZc1A2gBf
         bPpL453iMfkKE7Q2iWa4l856pfAiURxN5/VWU5iRKWYdb8bkZ3t7oIn4Ot9AMCUHitJ1
         fCBSfv9sMBPT7l1ZZx+O8DWyTvwkVSxYlGe9lG/wtPJtTqKF+eHZphHY8fK58NNu/2RP
         gJ6z0onrbm2DECMNfgl9WtEt3NFf22+/uIlkkjpNvmM6Bun+RuVdmYM0bG3VPR8NAMhS
         fy/MyqxnmIPai73OJB0s480cJGQXc7QfJTxlb9Gf6+IA3XpIVl5ws2XDBcGAJ5Rj3nhv
         6k6A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Mar 24, 2023 at 12:22:09AM -0700, Yosry Ahmed wrote:
> I think a problem with this approach is that we risk having to contend
> for the global lock at every CPU boundary in atomic contexts. Right
> now we contend for the global lock once, and once we have it we go
> through all CPUs to flush, only having to contend with updates taking
> the percpu locks at this point. If we unconditionally release &
> reacquire the global lock at every CPU boundary then we may contend
> for it much more frequently with concurrent flushers.
> 
> On the memory controller side, concurrent flushers are already held
> back to avoid a thundering herd problem on the global rstat lock, but
> flushers from outside the memory controller can still compete together
> or with a flusher from the memory controller. In this case, we risk
> contending the global lock more and concurrent flushers taking a
> longer period of time, which may end up causing multi-CPU stalls
> anyway, right? Also, if we keep _irq when spinning for the lock, then
> concurrent flushers still need to spin with irq disabled -- another
> problem that this series tries to fix.
> 
> This is particularly a problem for flushers in atomic contexts. There
> is a flusher in mem_cgroup_wb_stats() that flushes while holding
> another spinlock, and a flusher in mem_cgroup_usage() that flushes
> with irqs disabled. If flushing takes a longer period of time due to
> repeated lock contention, it affects such atomic context negatively.
> 
> I am not sure how all of this matters in practice, it depends heavily
> on the workloads and the configuration like you mentioned. I am just
> pointing out the potential disadvantages of reacquiring the lock at
> every CPU boundary in atomic contexts.

So, I'm not too convinced by the arguments for a couple reasons:

* It's not very difficult to create conditions where a contented non-irq
  protected spinlock is held unnecessarily long due to heavy IRQ irq load on
  the holding CPU. This can easily extend the amount of time the lock is
  held by multiple times if not orders of magnitude. That is likely a
  significantly worse problem than the contention on the lock cacheline
  which will lead to a lot more gradual degradation.

* If concurrent flushing is an actual problem, we need and can implement a
  better solution. There's quite a bit of maneuvering room here given that
  the flushing operations are mostly idempotent in close time proximity and
  there's no real atomicity requirement across different segments of
  flushing operations.

Thanks.

-- 
tejun
