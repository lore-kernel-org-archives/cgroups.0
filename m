From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Tue, 22 Aug 2023 11:06:03 +0200
Message-ID: <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-4-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692695164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PjhH5JJ/uYj/hECeKPplzMxBqTx0eSMbwEKi7pYJDLA=;
        b=m2Duffi8ECPm5ogSxiwZKOFctpoO5fB08TMKXwxMq8yjY4G+cG8jzdmMe/oms4pw/lNOlt
        5w9rj/Ky0czINnSBLoieks0aLYxh9a2faKlXMdN9+A2q7jnnzFcmLEeyigE2twSMeg+g3G
        KCx7Wi4jeTs0OyFj8UFIEZm2MZOm3kQ=
Content-Disposition: inline
In-Reply-To: <20230821205458.1764662-4-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 21-08-23 20:54:58, Yosry Ahmed wrote:
> Unified flushing allows for great concurrency for paths that attempt to
> flush the stats, at the expense of potential staleness and a single
> flusher paying the extra cost of flushing the full tree.
> 
> This tradeoff makes sense for in-kernel flushers that may observe high
> concurrency (e.g. reclaim, refault). For userspace readers, stale stats
> may be unexpected and problematic, especially when such stats are used
> for critical paths such as userspace OOM handling. Additionally, a
> userspace reader will occasionally pay the cost of flushing the entire
> hierarchy, which also causes problems in some cases [1].
> 
> Opt userspace reads out of unified flushing. This makes the cost of
> reading the stats more predictable (proportional to the size of the
> subtree), as well as the freshness of the stats. Since userspace readers
> are not expected to have similar concurrency to in-kernel flushers,
> serializing them among themselves and among in-kernel flushers should be
> okay.
> 
> This was tested on a machine with 256 cpus by running a synthetic test
> The script that creates 50 top-level cgroups, each with 5 children (250
> leaf cgroups). Each leaf cgroup has 10 processes running that allocate
> memory beyond the cgroup limit, invoking reclaim (which is an in-kernel
> unified flusher). Concurrently, one thread is spawned per-cgroup to read
> the stats every second (including root, top-level, and leaf cgroups --
> so total 251 threads). No regressions were observed in the total running
> time; which means that non-unified userspace readers are not slowing
> down in-kernel unified flushers:

I have to admit I am rather confused by cgroup_rstat_flush (and
cgroup_rstat_flush_locked). The former says it can block but the later
doesn't ever block and even if it drops the cgroup_rstat_lock it merely
cond_rescheds or busy loops. How much of a contention and yielding can
you see with this patch? What is the worst case? How bad a random user
can make the situation by going crazy and trying to flush from many
different contexts?
-- 
Michal Hocko
SUSE Labs
