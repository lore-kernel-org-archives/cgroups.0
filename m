From: Andrea Righi <andrea.righi@canonical.com>
Subject: Re: [External] Re: [PATCH v2] blk-throttle: Fix io statistics for
 cgroup v1
Date: Thu, 4 May 2023 23:13:01 +0200
Message-ID: <ZFQf3TCs7DqsSR8l@righiandr-XPS-13-7390>
References: <20230401094708.77631-1-hanjinke.666@bytedance.com>
 <ZEwY5Oo+5inO9UFf@righiandr-XPS-13-7390>
 <eb2eeb6b-07da-4e98-142c-da1e7ea35c2b@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1683234782;
        bh=8/IuvB7q0MpadpI+BtBqI9cgeVSD1cWHWWl6VaVHMkI=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=WEXQ81HvjSxQFkLOc/oIs8XXHteowDdp/+558iHFsRkT56hUEVNsl38n6j3t0ds3E
         57zl70/Z2M+AEQTDDej0C57ikM3WtAYlrSXSOztdT88yRvG7XtOGt3Mg/duA9pWIJz
         Txg0dzXPfW8MRzomRzskdHqElqZaswONkzXUqYf7wHy5GkD0LGPBW8tP+tHWyONsHW
         LoOTvBhEqXybLSgAiNjBGQ4suWfkLVOm/7HdR1+qxsiede/JfY71ihSttecGmckTcv
         TjEUwNXDcpIUDZ1v7T7nVo2oqH95m7vk3fXFzV43n33gBwhqRoPjfHxYpw107NQH0J
         GJsaH+iJMli9Q==
Content-Disposition: inline
In-Reply-To: <eb2eeb6b-07da-4e98-142c-da1e7ea35c2b@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: hanjinke <hanjinke.666@bytedance.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, May 04, 2023 at 11:08:53PM +0800, hanjinke wrote:
> Hi
> 
> Sorry for delay（Chinese Labor Day holiday).

No problem, it was also Labor Day in Italy. :)

> 
> 在 2023/4/29 上午3:05, Andrea Righi 写道:
> > On Sat, Apr 01, 2023 at 05:47:08PM +0800, Jinke Han wrote:
> > > From: Jinke Han <hanjinke.666@bytedance.com>
> > > 
> > > After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
> > > blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
> > > the only stable io stats interface of cgroup v1, and these statistics
> > > are done in the blk-throttle code. But the current code only counts the
> > > bios that are actually throttled. When the user does not add the throttle
> > > limit, the io stats for cgroup v1 has nothing. I fix it according to the
> > > statistical method of v2, and made it count all ios accurately.
> > > 
> > > Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
> > > Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
> > 
> > Thanks for fixing this!
> > 
> > The code looks correct to me, but this seems to report io statistics
> > only if at least one throttling limit is defined. IIRC with cgroup v1 it
> > was possible to see the io statistics inside a cgroup also with no
> > throttling limits configured.
> > 
> > Basically to restore the old behavior we would need to drop the
> > cgroup_subsys_on_dfl() check, something like the following (on top of
> > your patch).
> > 
> > But I'm not sure if we're breaking other behaviors in this way...
> > opinions?
> > 
> >   block/blk-cgroup.c   |  3 ---
> >   block/blk-throttle.h | 12 +++++-------
> >   2 files changed, 5 insertions(+), 10 deletions(-)
> > 
> > diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> > index 79138bfc6001..43af86db7cf3 100644
> > --- a/block/blk-cgroup.c
> > +++ b/block/blk-cgroup.c
> > @@ -2045,9 +2045,6 @@ void blk_cgroup_bio_start(struct bio *bio)
> >   	struct blkg_iostat_set *bis;
> >   	unsigned long flags;
> > -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
> > -		return;
> > -
> >   	/* Root-level stats are sourced from system-wide IO stats */
> >   	if (!cgroup_parent(blkcg->css.cgroup))
> >   		return;
> > diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> > index d1ccbfe9f797..bcb40ee2eeba 100644
> > --- a/block/blk-throttle.h
> > +++ b/block/blk-throttle.h
> > @@ -185,14 +185,12 @@ static inline bool blk_should_throtl(struct bio *bio)
> >   	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
> >   	int rw = bio_data_dir(bio);
> > -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
> > -		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
> > -			bio_set_flag(bio, BIO_CGROUP_ACCT);
> > -			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> > -					bio->bi_iter.bi_size);
> > -		}
> > -		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
> > +	if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
> > +		bio_set_flag(bio, BIO_CGROUP_ACCT);
> > +		blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> > +				bio->bi_iter.bi_size);
> >   	}
> > +	blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
> 
> It seems that statistics have been carried out in both v1 and v2，we can get
> the statistics of v2 from io.stat, is it necessary to count v2 here?
> 

I think this code is affecting (and should affect) only v1, stats for v2
are accounted via blk_cgroup_bio_start() in a different way. And the
behavior in v2 is the same as with this patch applied, that means io
stats are always reported even if we don't set any io limit.

Thanks,
-Andrea
