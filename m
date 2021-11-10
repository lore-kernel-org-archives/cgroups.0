From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC] psi: Add additional PSI counters for each type of memory
 pressure
Date: Wed, 10 Nov 2021 11:44:26 -0500
Message-ID: <YYv26rKib03JnYZN@cmpxchg.org>
References: <1636558597-248294-1-git-send-email-quic_c_gdjako@quicinc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZCxppkGRFPsisss/DePYM7NyPAJRZFk6RHTjGPknvLs=;
        b=28ajj1Fad3jjq+pJTimln90y/+YAp3rK8HrgZJ21bws99je/aLNwJ1RbEpp+VOFLI5
         wziDVyxazBE/4vX294wuICHRhpFBHB277qKLsw4E7XbZCqlr79wMi6mexuoOlNCT2KUg
         +NThEa6rl1rpAb+x7b8Rg4YUzUR8AM6Ceh3SYN01pPaJ/6Lyf5BF97stdDC1tk/xfD4L
         MatKRp0x77doAxnpSTgyQIAE+RbjFZK+sFICvR5ftw0sObz/cQGUCjcW4BHDuCaT/UW7
         ZtSdZBb+RcfyxV4BMmMhvyBiL+x9D+twDGmCbtBBWkQJXPNaKFaLz1F5nl/w/CkVPb7q
         dY2g==
Content-Disposition: inline
In-Reply-To: <1636558597-248294-1-git-send-email-quic_c_gdjako-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Georgi Djakov <quic_c_gdjako-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Cc: vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, djakov-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, Nov 10, 2021 at 07:36:37AM -0800, Georgi Djakov wrote:
> From: Carlos Ramirez <carlrami-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> Calculates psi totals for memory pressure subevents:
> compaction, thrashing, direct compaction, direct reclaim, and kswapd0.
> Uses upper 16 bits of psi_flags to track memory subevents.

Oof, that's quite heavy both in terms of branches, but also in terms
of cache - which, depending on wakeup pattern and cpu topology can
really hurt those paths.

What's the usecase? Do you have automation that needs to act on one
type of stall but not the others, for example?

I find that looking at vmstat events on hosts with elevated pressure
tends to give a pretty good idea of the source. It should also be
possible to whip up a short bpftrace script to track down culprit
callstacks of psi_memstall_*.

> @@ -1053,19 +1128,56 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
> +		seq_printf(m, "%s avg10=%lu.%02lu avg60=%lu.%02lu avg300=%lu.%02lu total=%llu %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
>  			   full ? "full" : "some",
>  			   LOAD_INT(avg[0]), LOAD_FRAC(avg[0]),
>  			   LOAD_INT(avg[1]), LOAD_FRAC(avg[1]),
>  			   LOAD_INT(avg[2]), LOAD_FRAC(avg[2]),
> -			   total);
> +			   total, total_blk_cgroup_throttle, total_bio, total_compaction,
> +			   total_thrashing, total_cgroup_reclaim_high,
> +			   total_cgroup_reclaim_high_sleep, total_cgroup_try_charge,
> +			   total_direct_compaction, total_direct_reclaim, total_read_swappage,
> +			   total_kswapd);

The file format is a can of worms. I doubt we can change this at this
point without breaking parsers, so those numbers would have to live
somewhere else. But let's figure out the above questions before
worrying about this.
