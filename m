Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0115638B12F;
	Fri, 25 Sep 2026 06:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790319160; cv=none; b=aaCaK6+dR53NDYHTIB9j1iYnsNglpWmktkuidhXSAa2Vyjxjuv0Raw1LJ/p969Ocb67AiqZ2cbXo81gf6/4/yT6neJ49A5ztwOWKkWTAyASifCYOCkut/nsJgTbvXhykygtpkh91xXuFJX9+if8iEOxKso8aQA69bZr0WwNisk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790319160; c=relaxed/simple;
	bh=2AIv8fKcgbMSPo13H6ErlyRd1SIByl7iIGZ3siW8VNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brtMoHWe5SxwIhKvyfhPre99GzbQ3IxYWAlpCIC1CQg4R+5SCkxd18qQaT4crdz/Ubhe8vTAxXwkBSq+n4OBQgSxDSQvnG8M1HLjBiiImLkAaGWooxGRfhztXQOHLvjDq0BhfnW+jOxoZpChWQaiqWMM4d0LctL9OgpXZAGIWvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ndpbDFL5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ndpbDFL5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CoKrYiONuGciYdBdICmSxiNS+aSXQ/z1p0P2nVVf7sQ=; b=ndpbDFL5NvXtwXggjq0mHatFKi
	DkzOT+jooG7yJfqmKsJ6QZZiHHoCwGZVhpkPPL0TprtXdaI9OVDvmq06HsuIbsJzUAJF5wrclWKAm
	yat14FBHxIFEWgN5x8FDhrbiAYmmT6nKsPKg5TdZr/UQRD0VZfQMHG2mwwJybSg2xhcD27PuG59i4
	idX7xGZf1enFM25zlUkBPr82iGVeEwA+2Qqq+SYz8OPAxKjLB60kHZJHo3UAKGmd4x9b2VrhgYd0R
	EGkiZkoHe9om8IoN20EOLeYUtBz7V+cPtgGFb6M6/ijR/zxMmoUXUexLNsVRJfg56rtiD4fkK5jY2
	pjI22nig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9znN-0000000Cm6I-0Pf1;
	Fri, 25 Sep 2026 06:52:33 +0000
Date: Thu, 24 Sep 2026 23:52:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
	jack@suse.cz, tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <arYaMbJUh6unvz_t@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925064444.3944820-2-sunjunchao@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 25, 2026 at 02:44:42PM +0800, Julian Sun wrote:
> Add bdev_flush_by_dev() to submit page-cache writeback for a device
> identified by dev_t without requiring callers to hold a persistent
> device reference.

This isn't really a flush is it?  This is writeback.

> + *
> + * May sleep while submitting writeback; does not wait for I/O completion.
> + */
> +void bdev_flush_by_dev(dev_t dev)
> +{
> +	struct block_device *bdev;
> +
> +	bdev = blkdev_get_no_open(dev, false);
> +	if (!bdev)
> +		return;

Please don't add more blkdev_get_no_open.  You can get from an
bdevfs inode to the struct block_device trivially using
I_BDEV instead of doing another lookup.  Or just grab a reference
to the the inode, which would seem even easier.

