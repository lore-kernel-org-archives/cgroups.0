Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAE83438A1;
	Fri, 25 Sep 2026 06:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790319319; cv=none; b=c+nwVB/TxW2KtXzbIqeHNZZ5Yjv5S1NCBlCFxQZw7+djTQcVO3DRJPR5c7hH7OA6i2mYv4hvJ55FFXz9hkhncUUxpf9AzIRvv5iWsoDt4uMxLyHX9avDFO0vvNxNkYmIOz/ysctOL0FlZSEWKdfQXYk9yQhHoKO1ac5Nh8X5T4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790319319; c=relaxed/simple;
	bh=wQS6pdjm70n2oBuB67KhJTE08nc/AtBwYvxAW3Vuses=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+GxlKO1ZwaPpkAgOz31Mp1WG3WBHrmwLcLwY3szVBWf5JqfM9TlTooGy0b1z61t9S1E25yEKhup41D4KijKNiLcpdT5A3U6oA7D9VjHJvesAJBIh6y6SME9SW+4NGQyy9C5heT4jhysNmdmYR5d+mGF/VR6LpK7+QCD/nE34/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ne54MAPu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ne54MAPu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0h/KGKepbQbE7BW4Dl2uhb5RRiIbAMKTtfZ482lKCss=; b=ne54MAPuQmpprAPPdJWG246epv
	khzHhs+cYdD/YhrxYIrssU4PTa8OM5oF/tLvtU8AAJurOZY+j5Wem39+upmCDSWLPLKH2Lr9jIkNX
	yQ0/C4Vtr8flPutZmUTJq551ZSg00vBrjzjiLB02yq2tBPXP285Xu78nTvTprxioBdsZsuTHktHyp
	v+dRG2g6IdZXRb8nVwGMecKfzbE6R9kcxQ1YhEAfhEYsATA8XkmZUsrXMvXIqSosltoJzQQ5vg18K
	/FC9hFV6NXIGVa5KtVVWtCVeEWtNVZsMzReP/0MsSYkM7R8PSnvEPAxHbixh+LdX1bG95aKqaN/k1
	KceYlYew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9zq0-0000000Cma1-2Vei;
	Fri, 25 Sep 2026 06:55:16 +0000
Date: Thu, 24 Sep 2026 23:55:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
	jack@suse.cz, tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
Message-ID: <arYa1DbKNeAN-PLl@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-3-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925064444.3944820-3-sunjunchao@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/*
> + * No extra memcg reference is taken: this work is embedded in the memcg,
> + * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
> + */
> +struct memcg_bdev_frn {

No reason not to spell out foreign here..

> +		/* Reserve the slot: it may have become busy after the inflight check. */

Overly long line.

> +	struct address_space *mapping = folio_mapping(folio);
> +	struct inode *inode = mapping->host;
> +
> +	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {

Why do we need a NULL check for the workqueue here?

>  	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
>  	WARN_ON(!memcg_wq);
>  
> +#ifdef CONFIG_CGROUP_WRITEBACK
> +	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
> +					    WQ_UNBOUND, 0);
> +	WARN_ON(!memcg_bdev_frn_wq);
> +#endif

Instead please fail the boot.  If we can't alloc a workqueue at
boot time, we're toast anyway.

