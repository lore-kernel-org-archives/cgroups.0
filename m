Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C76A399365
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 07:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785310452; cv=none; b=bu7cAInn6pHq5tx3zTfmyK2pCIsgsggm67fVEBqY+LdPtKEsV3HYLUka8r1VOQsg3LJhHKuetPmJLd/WMN2fEWBRlN2gGchw0/giHsWUMl8UIN3tAjvJufbiVq5pQVNlCwUgsFP9RXq7Z7Ubjft7kjJKv5AUZ1K44VpNkNS3MxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785310452; c=relaxed/simple;
	bh=f16qDqp4TwaG5bnsLuwm8DvQSkyiYlQgYJ8KRUJ0fIQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BdP87+H8CAl/lxXfw9+AIdsyCBix/A3vQCppt+/HmwmfbYku/fAgL2bIxf7tSOLPja5s5zY6oriam8sr4WitSJ3wKT8VsPi3MUQeEvBXILxdK8jWDbLMR+z09+yQgaGikMfuAcxfQsIZpjzbomMuZSwD7lznBB2vwXe3FR+fPw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ezTP1Hv8; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ezTP1Hv8"
Message-ID: <45ea6216-a6f6-4828-afd3-8acea8b949ab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785310443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=37LmZKKx6imgrlywMd6nb/fRt/m/R0hUT/eg6vCgpsQ=;
	b=ezTP1Hv8HlWjiVotVkFNt0FeWCJAoZHZeND7VX9um7BCVv/gPRp7466N/wcTcFHoo+7mSJ
	bDIkZ4bGuXXTAVeJ+Ikq61c9t693yqrL3mdYO8LO8nQCqjL7XUtK1aL25MsCYFLF2Mhivp
	/9gioKlJOpxhidahsl6pSs6l+XyJ8kI=
Date: Wed, 29 Jul 2026 15:33:03 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, hch@lst.de, dongsheng.yang@linux.dev,
 cengku@gmail.com, josef@toxicpanda.com, nilay@linux.ibm.com,
 ming.lei@redhat.com, yukuai@fygo.io, linux-block@vger.kernel.org,
 cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/8] bfq: avoid blkg lookup from locked cgroup
 update
To: Yu Kuai <yukuai@kernel.org>, axboe@kernel.dk, tj@kernel.org
References: <20260724123037.3004560-1-yukuai@kernel.org>
 <20260724123037.3004560-8-yukuai@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260724123037.3004560-8-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/24 20:30, Yu Kuai 写道:
> From: Yu Kuai <yukuai@fygo.io>
> 
> bfq_bio_bfqg() is called while bfqd->lock is held from the merge and
> request insertion paths.  It walks bio->bi_blkg and its parent chain to
> find the closest online BFQ group, and re-associates the bio by looking
> the chosen blkg up again through bio_associate_blkg_from_css().
> 
> Now that blkg creation runs under q->blkcg_mutex from the sleepable submit
> path, bio_associate_blkg_from_css() can sleep on a lookup miss, which BFQ
> must not do while holding bfqd->lock.  The blkg BFQ wants is already in
> hand from the ancestry walk, so update bio->bi_blkg by swapping references
> to that existing blkg directly instead of looking it up again by css.
> 

Just checking the new bfq helper that swaps a bio's blkg: it does the
blkg_put() without the NULL guard the old helper had.  Is there any path
where BFQ could see a bio that hasn't been associated yet (bi_blkg == NULL)?
The fallback branch calls it unconditionally, so if such a path exists it
would crash.  My reading is the bio is always associated before it reaches
BFQ, so it can't happen -- but wanted to ask in case I'm missing a path.

Thanks,
Tao

> Signed-off-by: Yu Kuai <yukuai@fygo.io>
> ---
>  block/bfq-cgroup.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 42614aa78cd4..8a3ff9510386 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -604,6 +604,16 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
>  	}
>  }
>  
> +static void bfq_bio_update_blkg(struct bio *bio, struct blkcg_gq *blkg)
> +{
> +	if (bio->bi_blkg == blkg)
> +		return;
> +
> +	blkg_get(blkg);
> +	blkg_put(bio->bi_blkg);
> +	bio->bi_blkg = blkg;
> +}
> +
>  struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
>  {
>  	struct blkcg_gq *blkg = bio->bi_blkg;
> @@ -616,13 +626,13 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
>  		}
>  		bfqg = blkg_to_bfqg(blkg);
>  		if (bfqg->pd.online) {
> -			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
> +			bfq_bio_update_blkg(bio, blkg);
>  			return bfqg;
>  		}
>  		blkg = blkg->parent;
>  	}
> -	bio_associate_blkg_from_css(bio,
> -				&bfqg_to_blkg(bfqd->root_group)->blkcg->css);
> +	blkg = bfqg_to_blkg(bfqd->root_group);
> +	bfq_bio_update_blkg(bio, blkg);
>  	return bfqd->root_group;
>  }
>  

