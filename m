From: Andrea Righi <andrea.righi@canonical.com>
Subject: Re: [External] Re: [PATCH v2] blk-throttle: Fix io statistics for
 cgroup v1
Date: Sat, 6 May 2023 13:44:33 +0200
Message-ID: <ZFY9ocCi2EPU3Cu3@righiandr-XPS-13-7390>
References: <20230401094708.77631-1-hanjinke.666@bytedance.com>
 <ZEwY5Oo+5inO9UFf@righiandr-XPS-13-7390>
 <eb2eeb6b-07da-4e98-142c-da1e7ea35c2b@bytedance.com>
 <ZFQf3TCs7DqsSR8l@righiandr-XPS-13-7390>
 <6696100e-e838-d96a-2894-bbca9783d2a3@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1683373476;
        bh=LHpyysAD0KT29d8ObzyF//DXpS+COhpwRCE79w2kL7U=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=qQKY/TVz6NbLNXDX1WAg0MuJP6K37kRnAsMAb1lUYLoUwrOodJDM50s2EpKrbN9LF
         cL1sNDwhvA40upc7fVVuph/xdcdM/yp14UpxsiZcKiJT/w9ZZ1qUZeAydvb3EN7s8+
         WAOdYD1VCHHhPKSJOS+zPRaYJz11TGiEsNwrk70QPc0cYGNTBBjbaAyuq4VnP6eZSG
         7s2+v+X4Wt0ccbWfirKhsREpaV6OC1+TLNEnYZRStz8CVnRt13dfAT+ZZoz8rXXBL4
         kJivIi36fVuCJisSWwlK6rjjNL12LU5wYr9kU68lfxRFMxn2GpFvHej9pnfJE1+Ai1
         76/rpEbL/NbXg==
Content-Disposition: inline
In-Reply-To: <6696100e-e838-d96a-2894-bbca9783d2a3@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: hanjinke <hanjinke.666@bytedance.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, May 05, 2023 at 09:35:21PM +0800, hanjinke wrote:
> 
> 
> 在 2023/5/5 上午5:13, Andrea Righi 写道:
> > On Thu, May 04, 2023 at 11:08:53PM +0800, hanjinke wrote:
> > > Hi
> > > 
> > > Sorry for delay（Chinese Labor Day holiday).
> > 
> > No problem, it was also Labor Day in Italy. :)
> > 
> > > 
> > > 在 2023/4/29 上午3:05, Andrea Righi 写道:
> > > > On Sat, Apr 01, 2023 at 05:47:08PM +0800, Jinke Han wrote:
> > > > > From: Jinke Han <hanjinke.666@bytedance.com>
> > > > > 
> > > > > After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
> > > > > blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
> > > > > the only stable io stats interface of cgroup v1, and these statistics
> > > > > are done in the blk-throttle code. But the current code only counts the
> > > > > bios that are actually throttled. When the user does not add the throttle
> > > > > limit, the io stats for cgroup v1 has nothing. I fix it according to the
> > > > > statistical method of v2, and made it count all ios accurately.
> > > > > 
> > > > > Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
> > > > > Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
> > > > 
> > > > Thanks for fixing this!
> > > > 
> > > > The code looks correct to me, but this seems to report io statistics
> > > > only if at least one throttling limit is defined. IIRC with cgroup v1 it
> > > > was possible to see the io statistics inside a cgroup also with no
> > > > throttling limits configured.
> > > > 
> > > > Basically to restore the old behavior we would need to drop the
> > > > cgroup_subsys_on_dfl() check, something like the following (on top of
> > > > your patch).
> > > > 
> > > > But I'm not sure if we're breaking other behaviors in this way...
> > > > opinions?
> > > > 
> > > >    block/blk-cgroup.c   |  3 ---
> > > >    block/blk-throttle.h | 12 +++++-------
> > > >    2 files changed, 5 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> > > > index 79138bfc6001..43af86db7cf3 100644
> > > > --- a/block/blk-cgroup.c
> > > > +++ b/block/blk-cgroup.c
> > > > @@ -2045,9 +2045,6 @@ void blk_cgroup_bio_start(struct bio *bio)
> > > >    	struct blkg_iostat_set *bis;
> > > >    	unsigned long flags;
> > > > -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
> > > > -		return;
> > > > -
> > > >    	/* Root-level stats are sourced from system-wide IO stats */
> > > >    	if (!cgroup_parent(blkcg->css.cgroup))
> > > >    		return;
> > > > diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> > > > index d1ccbfe9f797..bcb40ee2eeba 100644
> > > > --- a/block/blk-throttle.h
> > > > +++ b/block/blk-throttle.h
> > > > @@ -185,14 +185,12 @@ static inline bool blk_should_throtl(struct bio *bio)
> > > >    	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
> > > >    	int rw = bio_data_dir(bio);
> > > > -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
> > > > -		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
> > > > -			bio_set_flag(bio, BIO_CGROUP_ACCT);
> > > > -			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> > > > -					bio->bi_iter.bi_size);
> > > > -		}
> > > > -		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
> > > > +	if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
> > > > +		bio_set_flag(bio, BIO_CGROUP_ACCT);
> > > > +		blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> > > > +				bio->bi_iter.bi_size);
> > > >    	}
> > > > +	blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
> > > 
> 
> I checked the code again. If we remove cgroup_subsys_on_dfl check here, io
> statistics will still be performed in the case of v2, which I think is
> unnecessary, and this information will be counted to
> io_service_bytes/io_serviced, these two files are not visible in v2. Am I
> missing something?

You are absolutely right. Sorry, I have just re-tested your fix and it
seems to handle the cgroup v1 case correctly, you can add my:

Tested-by: Andrea Righi <andrea.righi@canonical.com>

And we definitely need the cgroup_subsys_on_dfl() check, otherwise we'd
account extra IO in the v2 case that is not really needed.

Thanks,
-Andrea
