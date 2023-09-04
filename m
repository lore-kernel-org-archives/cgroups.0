From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v4 3/4] mm: memcg: let non-unified root stats flushes
 help unified flushes
Date: Mon, 4 Sep 2023 16:50:15 +0200
Message-ID: <ZPXupwjewuLgksAI@dhcp22.suse.cz>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-4-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693839015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Rqxt2fKuHu+fMkXB1ABsmiC5CJA+FwEMGNI3T54CYQ=;
        b=YK/bkj5FbjjMVmedwWleIXDzouuBOnGEzArXL+4TxwuX2/8ac/VoPq5zgf84SuAIqqSIVe
        Un1PE1PblYMz3htUnajK+Ea30KZjpx8e7xaHcbzI13bEsasUkZFAru6LqpVxubJBlSNPsz
        ExMcCBemZIczMo64i+MOBBV7+loOwRU=
Content-Disposition: inline
In-Reply-To: <20230831165611.2610118-4-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 31-08-23 16:56:10, Yosry Ahmed wrote:
> Unified flushing of memcg stats keeps track of the magnitude of pending
> updates, and only allows a flush if that magnitude exceeds a threshold.
> It also keeps track of the time at which ratelimited flushing should be
> allowed as flush_next_time.
>=20
> A non-unified flush on the root memcg has the same effect as a unified
> flush, so let it help unified flushing by resetting pending updates and
> kicking flush_next_time forward. Move the logic into the common
> do_stats_flush() helper, and do it for all root flushes, unified or
> not.

I have hard time to follow why we really want/need this. Does this cause
any observable changes to the behavior?

>=20
> There is a subtle change here, we reset stats_flush_threshold before a
> flush rather than after a flush. This probably okay because:
>=20
> (a) For flushers: only unified flushers check stats_flush_threshold, and
> those flushers skip anyway if there is another unified flush ongoing.
> Having them also skip if there is an ongoing non-unified root flush is
> actually more consistent.
>=20
> (b) For updaters: Resetting stats_flush_threshold early may lead to more
> atomic updates of stats_flush_threshold, as we start updating it
> earlier. This should not be significant in practice because we stop
> updating stats_flush_threshold when it reaches the threshold anyway. If
> we start early and stop early, the number of atomic updates remain the
> same. The only difference is the scenario where we reset
> stats_flush_threshold early, start doing atomic updates early, and then
> the periodic flusher kicks in before we reach the threshold. In this
> case, we will have done more atomic updates. However, since the
> threshold wasn't reached, then we did not do a lot of updates anyway.
>=20
> Suggested-by: Michal Koutn=FD <mkoutny@suse.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  mm/memcontrol.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8c046feeaae7..94d5a6751a9e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -647,6 +647,11 @@ static inline void memcg_rstat_updated(struct mem_cg=
roup *memcg, int val)
>   */
>  static void do_stats_flush(struct mem_cgroup *memcg)
>  {
> +	/* for unified flushing, root non-unified flushing can help as well */
> +	if (mem_cgroup_is_root(memcg)) {
> +		WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
> +		atomic_set(&stats_flush_threshold, 0);
> +	}
>  	cgroup_rstat_flush(memcg->css.cgroup);
>  }
> =20
> @@ -665,11 +670,8 @@ static void do_unified_stats_flush(void)
>  	    atomic_xchg(&stats_unified_flush_ongoing, 1))
>  		return;
> =20
> -	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
> -
>  	do_stats_flush(root_mem_cgroup);
> =20
> -	atomic_set(&stats_flush_threshold, 0);
>  	atomic_set(&stats_unified_flush_ongoing, 0);
>  }
> =20
> --=20
> 2.42.0.rc2.253.gd59a3bf2b4-goog

--=20
Michal Hocko
SUSE Labs
