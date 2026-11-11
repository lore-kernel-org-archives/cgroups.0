Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794414796;
	b=Bx02My43tRRs8Xcl9FBSIDI5mL7G+l//vPv6qIGRFh1j0t6dHLyxZSFYMgf3WmnBKKG+
	 peXns6R/somw2H6DEJp/HRI1csVYfpNHvBtue8HbhU8IDniV32PIEwNg0TZeXJIQXD58W
	 kIi0UZbqC8RAym5ViLToVGhYBpGLKGrnjpaWDOuTeeXsZO8ecfg62DICW9ZEJWUalMIRc
	 Ps2jwm2zzb/nHQrNc5ytcYRfd1hOkOX5EAc52tx/Pzi53hHcJ8rKfERIK4fsuSkbSjin0
	 wOXNV5XmB0gS78bcEZUfHTy5rN2ck6k5/wBtWAVWwXIMFJMfmDApgi0PHWLkbDXJulA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794414796;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=LH6X8w/nRCanGXnIzr1Nnjdalussa4hxV2AIO7iP3vg=;
	b=TfLDy6av2N1cXCtXQedI72T0u/um42jYlHACOJ2GHLxl6j2E1U1kVup8hn/qzS7Wn0lG
	 mTyBsvgSbVf3DXm+Hjj0Cg8LDNXpXGrD+bbQU7/W1RQZB3BkzQWh0FTlvPA157ys3KlxF
	 K8AITGWmVpUyLf3SDXQSgIrMYEcbwd9mCMryeKkP7ML0Glvoozjslhx3mvXs2FIgRNeQB
	 OFWh6Jve0pU4bRqh1cy37UZlZ6Rm8wz9XU5UMTDZed83s7oLuR9wM/cE7i0PJ+MdP15kN
	 DxKNehSKx45rwYW1/6VyHiYK6Jg4GouTI36q25C2I0kbhn5IRirlkstqbkDRsc0EzsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD92606A324;
	Wed, 11 Nov 2026 16:33:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDD92606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6E23768D1F; Wed, 11 Nov 2026 17:33:07 +0100 (CET)
Date: Wed, 11 Nov 2026 17:33:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, axboe@kernel.dk, josef@toxicpanda.com,
	oliver.sang@intel.com, nilay@linux.ibm.com, hch@lst.de,
	yukuai@fygo.io, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn, sashiko-bot@kernel.org
Subject: Re: [PATCH] blk-iocost: fix the lock order in
 ioc_cost_model_write()
Message-ID: <20261111163306.GA17267@lst.de>
References: <20261111162137.295523-1-cui.tao@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111162137.295523-1-cui.tao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 12, 2026 at 12:21:37AM +0800, Tao Cui wrote:
> ioc_cost_model_write() holds rq_qos_mutex, which is acquired by
> blkg_conf_open_bdev(), across blk_mq_freeze_queue(). ioc_qos_write()
> freezes the queue before taking the mutex instead.
> 
> The inversion cannot currently deadlock because blk_mq_freeze_queue()
> is in a noio scope since 1e1a9cecfa ("block: force noio scope in
> blk_mq_freeze_queue"), so a caller freezing a queue cannot recurse
> into the frozen queue through reclaim. Holding the mutex across
> the freeze needlessly serializes config writers behind it and
> leaves two different orderings in the same file. Release the mutex
> around the freeze to match ioc_qos_write(), mirroring the fix there
> in 9730763f4756 ("block: correct locking order for protecting
> blk-wbt parameters").
> 
> Reported-by: sashiko-bot@kernel.org
> Link: https://sashiko.dev/#/patchset/20261103132613.1952975-1-cui.tao@linux.dev?part=1
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  block/blk-iocost.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 1c1025157d8e..7fe0a6fa146e 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -3605,7 +3605,14 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
>  		ioc = q_to_ioc(q);
>  	}
>  
> +	/*
> +	 * Nothing in the cost model is protected yet; release rq_qos_mutex
> +	 * around the freeze to match ioc_qos_write().
> +	 */
> +	mutex_unlock(&q->rq_qos_mutex);
>  	memflags = blk_mq_freeze_queue(q);
> +	mutex_lock(&q->rq_qos_mutex);

blkg_conf_open_bdev takes rq_qos_mutex aronud the disk_live
call.  So you'll have to redo it here.  Or maybe we should just move
that check and the locking into the callers of blkg_conf_open_bdev
in general to better support the need for freezing and other
potentially nested locking?

