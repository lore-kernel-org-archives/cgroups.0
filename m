Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E13D367F41;
	Tue, 15 Sep 2026 06:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454999; cv=none; b=su9L5/oIBEKZ81ZbmVcgDJeTQPARnWjVF1q+vjDjeD7131G+MvAOQJjhCVXks4jnxh9lvyQGOmboThe6cXb87qy4iZtPPAIsngANDH2xiYjF6BL14B0TrBK1tQUhriOPnDXTSNFIBo1a9zCk7Cz/kyHTnYkK4nMyclt74Mmx8X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454999; c=relaxed/simple;
	bh=s1i3seGVTsVpKoGeCYiSmRwSO5Mr/3c/9nV9mUMLiUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H5A5LO56tnlhzbG8NDaRkZ3KUaXGEe5Miqlxa6OQOGX3MtnjGs2fFuhBcKSE4SUrlqxFD9IeTZmKhJAf7zwK0prL7Qjfuz5Z7oTzQ5BAGvCmqy9EtmHkL3czWHuZXN/RSqysWtkG0imQ6wEGAGm1KsNEL3iPgJZKHJbSfeeHiBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB37468C4E; Tue, 15 Sep 2026 08:49:50 +0200 (CEST)
Date: Tue, 15 Sep 2026 08:49:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-ID: <20260915064950.GA13417@lst.de>
References: <cover.1789237876.git.yukuai@fygo.io> <ef547fdb7a6c8e39a25a1b9473c444f24a0f03be.1789237876.git.yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef547fdb7a6c8e39a25a1b9473c444f24a0f03be.1789237876.git.yukuai@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Sep 13, 2026 at 02:54:39PM +0800, Yu Kuai wrote:
> @@ -6243,10 +6245,17 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  	bool idle_timer_disabled = false;
>  	blk_opf_t cmd_flags;
>  	LIST_HEAD(free);
>  
>  #ifdef CONFIG_BFQ_GROUP_IOSCHED
> +	/*
> +	 * Pin the blkg used to look up bfqg.  If this is the first IO for
> +	 * the blkcg on this queue, create the bfqg before holding bfqd->lock.
> +	 */
> +	if (rq->bio && !bio_flagged(rq->bio, BIO_BLKG_REF))
> +		bio_blkg(rq->bio);

Can rq->bio be NULL here?  flush or empty passthrough request should
never enter the scheuler.

>  	if (!cgroup_subsys_on_dfl(io_cgrp_subsys) && rq->bio)
>  		bfqg_stats_update_legacy_io(q, rq);

But I guess given that the code below checks it, we should at least
be consistent, so I guess it is better to keep it for now.

>  
>  static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
>  {
>  	bd->bi_bdev = bio->bi_bdev;
> -	bd->bi_flags = bio->bi_flags;
> +	/* Restoring an ownership bit cannot recreate the associated reference. */
> +	bd->bi_flags = bio->bi_flags & ~(1U << BIO_BLKG_REF);

I have a bit of a hard time parsing this, the line also is overly
long.

