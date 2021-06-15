From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] memcg: periodically flush the memcg stats
Date: Tue, 15 Jun 2021 15:29:55 -0400
Message-ID: <YMj/s26uF+cQOB2D@cmpxchg.org>
References: <20210615174435.4174364-1-shakeelb@google.com>
 <20210615174435.4174364-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b1NdNJmbQ9vufxbdq46R0yQ5rOWLcgcQTrxTuRLsRs4=;
        b=kZmQdCqtAe6i6mcTzPE2G1TnxW5S3b3u7NHWwpD/z6z+rVhlqxQofe38Zav7pYflCb
         6TjmJhRoa0BXLTlDnKddSVw7zM/k74Plwu1Q4dNQn5RRpBWMyBbKtApXtgOUdOW+PsP2
         i3+fbThoD6+KVR8g8QPHi6Rkizkxw2FQpC0R7pXdyz7mIH5K5spJvHcPMeVOQv8JENu0
         tYtQFQ9eyCT9WqDme2JdoLd9kwKp2xnWipBrKHag4G8AY6i7Cz/mf2UVWkvHpmHgVEtg
         bgGU4fEzFlzDrN8NXje4+5ygkO87UjYU+B58pIvX82JJ5I3InE44LSHwHZfL9L+L8YdK
         bNBg==
Content-Disposition: inline
In-Reply-To: <20210615174435.4174364-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey Shakeel,

On Tue, Jun 15, 2021 at 10:44:35AM -0700, Shakeel Butt wrote:
> At the moment memcg stats are read in four contexts:
> 
> 1. memcg stat user interfaces
> 2. dirty throttling
> 3. page fault
> 4. memory reclaim
> 
> Currently the kernel flushes the stats for first two cases. Flushing the
> stats for remaining two casese may have performance impact. Always
> flushing the memcg stats on the page fault code path may negatively
> impacts the performance of the applications. In addition flushing in the
> memory reclaim code path, though treated as slowpath, can become the
> source of contention for the global lock taken for stat flushing because
> when system or memcg is under memory pressure, many tasks may enter the
> reclaim path.
> 
> Instead of synchronously flushing the stats, this patch adds support of
> asynchronous periodic flushing of the memcg stats. For now the flushing
> period is hardcoded to 2*HZ but that can be changed later through maybe
> sysctl if need arise.

I'm concerned that quite a lot can happen in terms of reclaim and page
faults in 2 seconds. It's conceivable that the error of a fixed 2s
flush can actually exceed the error of a fixed percpu batch size.

The way the global vmstat implementation manages error is doing both:
ratelimiting and timelimiting. It uses percpu batching to limit the
error when it gets busy, and periodic flushing to limit the length of
time consumers of those stats could be stuck trying to reach a state
that the batching would otherwise prevent from being reflected.

Maybe we can use a combination of ratelimiting and timelimiting too?

We shouldn't flush on every fault, but what about a percpu ratelimit
that would at least bound the error to NR_CPU instead of nr_cgroups?

For thundering herds during reclaim: as long as they all tried to
flush from the root, only one of them would actually need to do the
work, and we could use trylock. If the lock is already taken, you can
move on knowing that somebody is already doing the shared flush work.
