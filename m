From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] writeback, memcg: Implement foreign dirty flushing
Date: Fri, 16 Aug 2019 18:02:56 +0200
Message-ID: <20190816160256.GI3041@quack2.suse.cz>
References: <20190815195619.GA2263813@devbig004.ftw2.facebook.com>
 <20190815195930.GF2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190815195930.GF2263813@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

On Thu 15-08-19 12:59:30, Tejun Heo wrote:
> +/* issue foreign writeback flushes for recorded foreign dirtying events */
> +void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
> +	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
> +	u64 now = jiffies_64;
> +	int i;
> +
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
> +
> +		/*
> +		 * If the record is older than dirty_expire_interval,
> +		 * writeback on it has already started.  No need to kick it
> +		 * off again.  Also, don't start a new one if there's
> +		 * already one in flight.
> +		 */
> +		if (frn->at > now - intv && atomic_read(&frn->done.cnt) == 1) {
> +			frn->at = 0;
> +			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
> +					       LONG_MAX, WB_REASON_FOREIGN_FLUSH,
> +					       &frn->done);
> +		}

Hum, two concerns here still:

1) You ask to writeback LONG_MAX pages. That means that you give up any
livelock avoidance for the flusher work and you can writeback almost
forever if someone is busily dirtying pages in the wb. I think you need to
pick something like amount of dirty pages in the given wb (that would have
to be fetched after everything is looked up) or just some arbitrary
reasonably small constant like 1024 (but then I guess there's no guarantee
stuck memcg will make any progress and you've invalidated the frn entry
here).

2) When you invalidate frn entry here by writing 0 to 'at', it's likely to get
reused soon. Possibly while the writeback is still running. And then you
won't start any writeback for the new entry because of the
atomic_read(&frn->done.cnt) == 1 check. This seems like it could happen
pretty frequently?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
