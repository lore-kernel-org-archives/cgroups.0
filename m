From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v1 5/9] memcg: replace stats_flush_lock with an atomic
Date: Tue, 28 Mar 2023 13:53:22 -0400
Message-ID: <ZCMpklJZqwWHro0u@cmpxchg.org>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-6-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680026004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GBBAU6hZLECWp0UudInEHiiA2FkG0Dhl57EhHD71/2w=;
        b=WyJBv5Pqllid3pNI6/ikTPvxnNXwwYvm5BeSsZHlodYCQOrWeIKez1PCCxvY3x1D8c
         3+AZOlaWzwu1aKR+OAeUfaGWTxiIfflV7gGlohUIYiEqEskdjBV9QYa+PD/HDQeJZU3Y
         pFQhYKU+arSbJemfnq9SR0DQ6bDuZPsw4fp/k2p3LlpGJi35X785hbTi0EoGjexbJdKT
         /zo4sSXmA7NblVWxBBey8ZK0PCmLNdDA177py1CZsWHspE6EGmptD4//mQHui9cQkTEc
         kPDtXGZPdalt51dVpXNabobGHyskSSeC52qpMMTruKTKj6Vgxy77Pb7DYdWEsqx2UcyW
         ZVrA==
Content-Disposition: inline
In-Reply-To: <20230328061638.203420-6-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 06:16:34AM +0000, Yosry Ahmed wrote:
> As Johannes notes in [1], stats_flush_lock is currently used to:
> (a) Protect updated to stats_flush_threshold.
> (b) Protect updates to flush_next_time.
> (c) Serializes calls to cgroup_rstat_flush() based on those ratelimits.
> 
> However:
> 
> 1. stats_flush_threshold is already an atomic
> 
> 2. flush_next_time is not atomic. The writer is locked, but the reader
>    is lockless. If the reader races with a flush, you could see this:
> 
>                                         if (time_after(jiffies, flush_next_time))
>         spin_trylock()
>         flush_next_time = now + delay
>         flush()
>         spin_unlock()
>                                         spin_trylock()
>                                         flush_next_time = now + delay
>                                         flush()
>                                         spin_unlock()
> 
>    which means we already can get flushes at a higher frequency than
>    FLUSH_TIME during races. But it isn't really a problem.
> 
>    The reader could also see garbled partial updates, so it needs at
>    least READ_ONCE and WRITE_ONCE protection.
> 
> 3. Serializing cgroup_rstat_flush() calls against the ratelimit
>    factors is currently broken because of the race in 2. But the race
>    is actually harmless, all we might get is the occasional earlier
>    flush. If there is no delta, the flush won't do much. And if there
>    is, the flush is justified.
> 
> So the lock can be removed all together. However, the lock also served
> the purpose of preventing a thundering herd problem for concurrent
> flushers, see [2]. Use an atomic instead to serve the purpose of
> unifying concurrent flushers.
> 
> [1]https://lore.kernel.org/lkml/20230323172732.GE739026-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
> [2]https://lore.kernel.org/lkml/20210716212137.1391164-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

With Shakeel's suggestion:

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
